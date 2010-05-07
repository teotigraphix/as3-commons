/*
* Copyright 2009-2010 the original author or authors.
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
package org.as3commons.emit {
import flash.display.Loader;
import flash.errors.IllegalOperationError;
import flash.events.ErrorEvent;
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.IEventDispatcher;
import flash.events.IOErrorEvent;
import flash.system.ApplicationDomain;
import flash.utils.Dictionary;

import mx.controls.SWFLoader;

import org.as3commons.emit.bytecode.ByteCodeLayoutBuilder;
import org.as3commons.emit.bytecode.DynamicClass;
import org.as3commons.emit.bytecode.IByteCodeLayout;
import org.as3commons.emit.bytecode.IByteCodeLayoutBuilder;
import org.as3commons.emit.bytecode.QualifiedName;
import org.as3commons.emit.reflect.EmitReflectionUtils;
import org.as3commons.emit.reflect.EmitType;
import org.as3commons.emit.util.newInstance;
import org.as3commons.lang.ClassUtils;
import org.as3commons.lang.IllegalArgumentError;

/**
 * 
 * @author Andrew Lewisohn
 */
public class ClassRepository {
	
	private var classCache:ClassCache;
	
	public function ClassRepository(classGenerator:IClassGenerator=null) {
		classCache = new ClassCache();
		_classGenerator = classGenerator;
	}
	
	private var _classGenerator:IClassGenerator;
	
	public function get classGenerator():IClassGenerator {
		return _classGenerator;
	}
	
	public function set classGenerator(value:IClassGenerator):void {
		_classGenerator = value;
	}
	
	public function contains(cls:Class):Boolean {
		return classCache.contains(cls);	
	}
	
	public function create(cls:Class, args:Array=null):Object {
		args = args || [];
		
		var newClass:Class = classCache.get(cls);
		if(newClass == null) {
			throw new IllegalArgumentError("A class definition for " 
				+ ClassUtils.getFullyQualifiedName(cls) + " has not been prepared yet"); 
		}
		
		var constructorArgCount:int = EmitType.forClass(newClass).constructorMethod.parameters.length;
		var constructorRequiredArgCount:int = EmitReflectionUtils.getRequiredArgumentCount(EmitType.forClass(newClass).constructorMethod);
		
		if(args.length < constructorRequiredArgCount) {
			throw new IllegalArgumentError("Incorrect number of constructor arguments supplied.");
		}
			
		return newInstance(newClass, args);
	}
	
	public function prepare(classes:Array, applicationDomain:ApplicationDomain=null):IEventDispatcher {
		applicationDomain = applicationDomain || ApplicationDomain.currentDomain;
		classes = classes.filter(
			function(cls:Class, index:int, array:Array):Boolean {
				return !classCache.contains(cls);
			}
		);
		
		if(classes.length == 0) {
			return new CompleteEventDispatcher();
		}
		
		var dynamicClasses:Array = [];
		var layoutBuilder:IByteCodeLayoutBuilder = new ByteCodeLayoutBuilder();
		var generatedNames:Dictionary = new Dictionary();
		
		for each(var cls:Class in classes) {
			
			if(ClassUtils.isPrivateClass(cls)) {
				throw new IllegalOperationError("Private classes are not supported.");
			}
			
			var type:EmitType = EmitType.forClass(cls, applicationDomain);
			
			if(type.isGeneric || type.isGenericTypeDefinition) {
				throw new IllegalOperationError("Generic types (Vector) are not supported.");
			}
			
			var dynamicClass:DynamicClass = _classGenerator.createClass(type);
			generatedNames[cls] = dynamicClass.qname;
			layoutBuilder.registerType(dynamicClass);
		}
		
		var layout:IByteCodeLayout = layoutBuilder.createLayout();
		var loader:SWFLoader = new SWFLoader(); 
		loader.contentLoaderInfo.addEventListener(Event.COMPLETE, classesLoaded);
		loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, errorHandler);
		loader.contentLoaderInfo.addEventListener(ErrorEvent.ERROR, errorHandler);
		loader.loadClasses(layout, applicationDomain);
		
		function classesLoaded(event:Event):void {
			for each(var cls:Class in classes) {
				var qname:QualifiedName = generatedNames[cls];
				var fullName:String = qname.ns.name.concat("::", qname.name);
				var generatedClass:Class = loader.contentLoaderInfo.applicationDomain.getDefinition(fullName) as Class;
				EmitType.forClass(generatedClass);
				classCache.put(cls, generatedClass);
			}
			
			dispatcher.dispatchEvent(new Event(Event.COMPLETE));	
		}
		
		function errorHandler(event:ErrorEvent):void {
			dispatcher.dispatchEvent(event);
		}
		
		var dispatcher:EventDispatcher = new EventDispatcher();
		return dispatcher;
	}
}
}

import flash.display.Loader;
import flash.events.ErrorEvent;
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.system.ApplicationDomain;
import flash.system.LoaderContext;
import flash.utils.ByteArray;

import org.as3commons.emit.SWFHeader;
import org.as3commons.emit.SWFWriter;
import org.as3commons.emit.bytecode.IByteCodeLayout;
import org.as3commons.emit.tags.DoABCTag;
import org.as3commons.emit.tags.EndTag;
import org.as3commons.emit.tags.FileAttributesTag;
import org.as3commons.emit.tags.FrameLabelTag;
import org.as3commons.emit.tags.ScriptLimitsTag;
import org.as3commons.emit.tags.SetBackgroundColorTag;
import org.as3commons.emit.tags.ShowFrameTag;

class CompleteEventDispatcher extends EventDispatcher {
	
	public override function addEventListener(type:String, listener:Function, useCapture:Boolean=false, priority:int=0, useWeakReference:Boolean=false):void {
		super.addEventListener(type, listener, useCapture, priority, useWeakReference);
		
		if(type == Event.COMPLETE) {
			dispatchEvent(new Event(Event.COMPLETE));
			super.removeEventListener(type, listener, useCapture);
		}
	}
}

class SWFLoader extends Loader {
	
	public function SWFLoader() {	
	}
	
	public function loadClasses(layout:IByteCodeLayout, applicationDomain:ApplicationDomain):void {
		var header:SWFHeader = new SWFHeader(10);
		var tags:Array = [
			FileAttributesTag.create(false, false, false, true, true),
			new ScriptLimitsTag(),
			new SetBackgroundColorTag(0xFF, 0x0, 0x0),
			new FrameLabelTag("AS3CommonsEmitFrameLabel"),
			new DoABCTag(false, "AS3CommonsEmit", layout),
			new ShowFrameTag(),
			new EndTag()
		];
		
		var buffer:ByteArray = new ByteArray();
		var writer:SWFWriter = new SWFWriter();
		
		writer.write(buffer, header, tags);
		buffer.position = 0;
		
		var loaderContext:LoaderContext = new LoaderContext(false, applicationDomain);
		if(loaderContext.hasOwnProperty("allowLoadBytesCodeExecution")) {
			loaderContext["allowLoadBytesCodeExecution"] = true;
		}
		
		loadBytes(buffer, loaderContext);
	}
}