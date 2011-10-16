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

	import org.as3commons.lang.StringUtils;
	import org.as3commons.metadata.registry.IMetadataProcessorRegistry;
	import org.as3commons.reflect.Metadata;
	import org.as3commons.reflect.Type;

	/**
	 * <code>IMetadataProcessor</code> implementation that wraps instances annotated with the <code>[MetadataProcessor]</code> in a <code>GenericMetadataProcessor</code>
	 * instance and registers this with the specified <code>IMetadataProcessorRegistry</code>.
	 * @author Roland Zwaga
	 */
	public class MetadataMetadataProcessor extends AbstractMetadataProcessor {
		private static const METADATA_PROCESSOR_METADATA_NAME:String = "MetadataProcessor";
		private static const PROCESS_METHOD_ARG:String = "processMethod";
		private static const METADATA_NAMES_ARG:String = "metadataNames";
		private static const COMMA:String = ",";

		private var _metadataProcessorRegistry:IMetadataProcessorRegistry;
		private var _applicationDomain:ApplicationDomain;

		/**
		 * Creates a new <code>MetadataMetadataProcessor</code> instance.
		 */
		public function MetadataMetadataProcessor(registry:IMetadataProcessorRegistry, applicationDomain:ApplicationDomain=null) {
			super();
			metadataNames[metadataNames.length] = METADATA_PROCESSOR_METADATA_NAME;
			_metadataProcessorRegistry = registry;
			_applicationDomain = applicationDomain ||= Type.currentApplicationDomain;
		}

		override public function process(target:Object, metadataName:String, params:Array=null):* {
			var type:Type = Type.forInstance(target, _applicationDomain);
			var methodName:String = "process";
			var metadata:Metadata = type.getMetadata(METADATA_PROCESSOR_METADATA_NAME)[0];
			if (metadata.hasArgumentWithKey(PROCESS_METHOD_ARG)) {
				methodName = metadata.getArgument(PROCESS_METHOD_ARG).value;
			}
			var processor:GenericMetadataProcessor = new GenericMetadataProcessor(target, methodName, _applicationDomain);
			addMetadaNames(metadata, processor.metadataNames);
			_metadataProcessorRegistry.addProcessor(processor);
		}

		protected function addMetadaNames(metadata:Metadata, names:Vector.<String>):void {
			if (metadata.hasArgumentWithKey(METADATA_NAMES_ARG)) {
				var argString:String = metadata.getArgument(METADATA_NAMES_ARG).value;
				var args:Array = argString.split(COMMA);
				for each (var arg:String in args) {
					names[names.length] = StringUtils.trim(arg);
				}
			}
		}

	}
}
