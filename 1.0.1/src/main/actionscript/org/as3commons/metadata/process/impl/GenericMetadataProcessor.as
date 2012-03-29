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
package org.as3commons.metadata.process.impl {
	import flash.system.ApplicationDomain;

	import org.as3commons.reflect.Method;
	import org.as3commons.reflect.MethodInvoker;
	import org.as3commons.reflect.Parameter;
	import org.as3commons.reflect.Type;

	/**
	 * <code>IMetadatProcessor</code> implementation that acts as a wrapper for metadata processors that don't implement the <code>IMetadataProcessor</code> interface.<br/>
	 * By default it uses a method with the name "process" as the processing method. If specified this is overriden by the <code>[MetadataProcessor(processMethod="customProcess")]</code>
	 * metadata argument. The metadata names that the wrapped object will be invoked for are specified by the <code>[MetadataProcessor(metadataNames="metadataName1,metadataName1")]</code> argument.
	 * @author Roland Zwaga
	 */
	public class GenericMetadataProcessor extends AbstractMetadataProcessor {
		private static const OBJECT_CLASSNAME:String = "Object";
		private static const STRING_CLASSNAME:String = "String";
		private static const ARRAY_CLASSNAME:String = "Array";

		private var _methodInvoker:MethodInvoker;
		private var _objectParamIndex:int = -1;
		private var _metadataNameIndex:int = -1;
		private var _arrayIndex:int = -1;
		private var _paramCount:int = 0;

		/**
		 * Creates a new <code>GenericMetadataProcessor</code> instance.
		 */
		public function GenericMetadataProcessor(wrappedMetadataProcessor:Object, methodName:String="process", applicationDomain:ApplicationDomain=null, namespaceURI:String=null) {
			applicationDomain ||= Type.currentApplicationDomain;
			super();
			_methodInvoker = new MethodInvoker();
			_methodInvoker.namespaceURI = namespaceURI;
			_methodInvoker.target = wrappedMetadataProcessor;
			_methodInvoker.method = methodName;
			var cls:Class = wrappedMetadataProcessor.constructor;
			var type:Type = Type.forClass(cls, applicationDomain);
			var method:Method = type.getMethod(methodName, namespaceURI);
			var len:int = method.parameters.length;
			for (var i:int = 0; i < len; ++i) {
				var param:Parameter = method.parameters[int(i)];
				switch (param.type.name) {
					case OBJECT_CLASSNAME:
						_objectParamIndex = i;
						_paramCount++;
						break;
					case STRING_CLASSNAME:
						_metadataNameIndex = i;
						_paramCount++;
						break;
					case ARRAY_CLASSNAME:
						_arrayIndex = i;
						_paramCount++;
						break;
				}
			}
		}

		override public function process(target:Object, metadataName:String, params:Array=null):* {
			var args:Array = [];
			if (_objectParamIndex > -1) {
				args[_objectParamIndex] = target;
			}
			if (_metadataNameIndex > -1) {
				args[_metadataNameIndex] = metadataName;
			}
			if (_arrayIndex > -1) {
				args[_arrayIndex] = params;
			}
			_methodInvoker.arguments = args;
			return _methodInvoker.invoke();
		}
	}
}
