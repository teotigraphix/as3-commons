/*
* Copyright 2007-2011 the original author or authors.
*
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
*      http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
*/
package org.as3commons.bytecode.swf {
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.system.ApplicationDomain;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;

	import org.as3commons.bytecode.abc.AbcFile;
	import org.as3commons.bytecode.emit.IAbcBuilder;
	import org.as3commons.bytecode.emit.IClassBuilder;
	import org.as3commons.bytecode.emit.IInterfaceBuilder;
	import org.as3commons.bytecode.emit.impl.AbcBuilder;
	import org.as3commons.bytecode.io.AbcDeserializer;
	import org.as3commons.bytecode.io.MethodBodyExtractionKind;
	import org.as3commons.bytecode.swf.event.SWFFileIOEvent;
	import org.as3commons.bytecode.tags.DoABCTag;
	import org.as3commons.bytecode.tags.serialization.DoABCSerializer;
	import org.as3commons.bytecode.tags.serialization.ITagSerializer;
	import org.as3commons.bytecode.util.AbcSpec;

	/**
	 * Dispatched when the class loader has finished loading the SWF/ABC bytecode in the Flash Player/AVM.
	 * @eventType flash.events.Event.COMPLETE
	 */
	[Event(name="complete", type="flash.events.Event")]
	/**
	 * Dispatched when the class loader has encountered an IO related error.
	 * @eventType flash.events.IOErrorEvent.IO_ERROR
	 */
	[Event(name="ioError", type="flash.events.IOErrorEvent")]
	/**
	 * Dispatched when the class loader has encountered a SWF verification error.
	 * @eventType flash.events.IOErrorEvent.VERIFY_ERROR
	 */
	[Event(name="verifyError", type="flash.events.IOErrorEvent")]
	/**
	 * <code>ISWFWeaver</code> implementation used to manipulate existing classes in a <code>SWF</code> file.
	 * @author Roland Zwaga
	 */
	public class SWFWeaver extends EventDispatcher implements ISWFWeaver {

		private var _loader:AbcClassLoader;
		private var _SWFFileIO:SWFFileIO;
		private var _swfFile:SWFFile;
		private var _builders:Dictionary;
		private var _newClasses:IAbcBuilder;

		/**
		 * Creates a new <code>SWFWeaver</code> instance.
		 */
		public function SWFWeaver() {
			super();
			initSWFWeaver();
		}

		/**
		 * Internal <code>AbcClassLoader</code> instance used by the <code>buildAndLoad()</code> method.
		 */
		protected function get loader():AbcClassLoader {
			if (_loader == null) {
				_loader = new AbcClassLoader();
				_loader.addEventListener(Event.COMPLETE, redispatch);
				_loader.addEventListener(IOErrorEvent.IO_ERROR, redispatch);
				_loader.addEventListener(IOErrorEvent.VERIFY_ERROR, redispatch);
			}
			return _loader;
		}

		/**
		 * Redispatches the specified <code>AbcClassLoader</code> <code>Event</code>.
		 * @param event The specified <code>AbcClassLoader</code> <code>Event</code>.
		 */
		protected function redispatch(event:Event):void {
			dispatchEvent(event);
		}

		/**
		 *
		 * @return
		 */
		protected function get newClasses():IAbcBuilder {
			if (_newClasses == null) {
				_newClasses = new AbcBuilder();
			}
			return _newClasses;
		}

		/**
		 * Initializes the current <code>SWFWeaver</code>.
		 */
		protected function initSWFWeaver():void {
			_SWFFileIO = new SWFFileIO();
			_SWFFileIO.addEventListener(SWFFileIOEvent.TAG_SERIALIZER_CREATED, onTagSerializerCreated);
			_builders = new Dictionary();
		}

		/**
		 *
		 * @param event
		 */
		protected function onTagSerializerCreated(event:SWFFileIOEvent):void {
			if (event.tagSerializer is DoABCSerializer) {
				DoABCSerializer(event.tagSerializer).deserializer = new AbcDeserializer();
				DoABCSerializer(event.tagSerializer).deserializer.methodBodyExtractionMethod = MethodBodyExtractionKind.BYTEARRAY;
			}
		}

		/**
		 *
		 * @param byteArray
		 */
		public function initialize(byteArray:ByteArray):void {
			_swfFile = _SWFFileIO.read(byteArray);
		}

		/**
		 *
		 * @param fullyQualifiedName
		 * @return
		 */
		protected function getBuilderForFullName(fullyQualifiedName:String):AbcBuilder {
			if (_builders[fullyQualifiedName] == null) {
				var abcFile:AbcFile = _swfFile.getAbcFileForClassName(fullyQualifiedName);
				_builders[fullyQualifiedName] = new AbcBuilder(abcFile);
			}
			return AbcBuilder(_builders[fullyQualifiedName]);
		}

		/**
		 *
		 * @param className
		 * @return
		 */
		public function getClassBuilder(className:String):IClassBuilder {
			var builder:AbcBuilder = getBuilderForFullName(className);
			return builder.defineClass(className);
		}

		/**
		 *
		 * @param interfaceName
		 * @return
		 */
		public function getInterfaceBuilder(interfaceName:String):IInterfaceBuilder {
			var builder:AbcBuilder = getBuilderForFullName(interfaceName);
			return builder.defineInterface(interfaceName);
		}

		/**
		 *
		 * @return
		 */
		public function build():Array {
			var result:Array;
			if (_swfFile != null) {
				result = [];
				var i:int = 0;
				var serializer:DoABCSerializer = DoABCSerializer(_SWFFileIO.createTagSerializer(DoABCTag.TAG_ID));
				for each (var tag:ITagSerializer in _swfFile.tags) {
					if (tag is DoABCTag) {
						result[result.length] = serializer.serializer.serializeAbcFile(DoABCTag(tag).abcFile);
					}
				}
			}
			return result;
		}

		/**
		 *
		 *
		 */
		public function buildAndLoad(applicationDomain:ApplicationDomain = null):Boolean {
			applicationDomain ||= ApplicationDomain.currentDomain;
			var binaryAbcFiles:Array = build();
			if ((binaryAbcFiles != null) && (binaryAbcFiles.length > 0)) {
				_loader.loadClassDefinitionsFromBytecode(binaryAbcFiles, applicationDomain);
				return true;
			}
			return false;
		}
	}
}