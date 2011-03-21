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

	import flash.events.IEventDispatcher;
	import flash.system.ApplicationDomain;
	import flash.utils.ByteArray;

	import org.as3commons.bytecode.emit.IClassBuilder;
	import org.as3commons.bytecode.emit.IInterfaceBuilder;

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
	 *
	 * @author Roland Zwaga
	 */
	public interface ISWFWeaver extends IEventDispatcher {

		/**
		 *
		 * @param byteArray
		 */
		function initialize(byteArray:ByteArray):void;

		/**
		 *
		 * @param className
		 * @return
		 */
		function getClassBuilder(className:String):IClassBuilder;

		/**
		 *
		 * @param interfaceName
		 * @return
		 */
		function getInterfaceBuilder(interfaceName:String):IInterfaceBuilder;

		/**
		 *
		 * @return
		 */
		function build():Array;

		/**
		 *
		 */
		function buildAndLoad(applicationDomain:ApplicationDomain = null):Boolean;
	}
}