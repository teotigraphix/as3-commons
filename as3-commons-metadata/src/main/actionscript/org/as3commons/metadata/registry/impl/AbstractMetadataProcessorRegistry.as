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
package org.as3commons.metadata.registry.impl {

	import flash.errors.IllegalOperationError;
	import flash.system.ApplicationDomain;

	import org.as3commons.metadata.process.IMetadataProcessor;
	import org.as3commons.metadata.registry.IMetadataProcessorRegistry;

	/**
	 *
	 * @author Roland Zwaga
	 */
	public class AbstractMetadataProcessorRegistry implements IMetadataProcessorRegistry {

		private var _applicationDomain:ApplicationDomain;
		protected var metadataLookup:Object = {};

		/**
		 *
		 */
		public function get applicationDomain():ApplicationDomain {
			return _applicationDomain;
		}

		/**
		 * @inheritDoc
		 */
		public function set applicationDomain(value:ApplicationDomain):void {
			_applicationDomain = value;
		}


		/**
		 * Creates a new <code>AbstractMetadataProcessorRegistry</code> instance.
		 */
		public function AbstractMetadataProcessorRegistry() {
			super();
		}

		public function getProcessorsForMetadata(metadataName:String):Vector.<IMetadataProcessor> {
			return metadataLookup[metadataName.toLowerCase()] as Vector.<IMetadataProcessor>;
		}

		public function process(target:Object):* {
			throw new IllegalOperationError("Not implemented in abstract base class");
		}

		public function addProcessor(processor:IMetadataProcessor):void {
			for each (var metadataName:String in processor.metadataNames) {
				var processors:Vector.<IMetadataProcessor> = metadataLookup[metadataName.toLowerCase()] ||= new Vector.<IMetadataProcessor>();
				if (processors.indexOf(processor) < 0) {
					processors[processors.length] = processor;
				}
			}
		}

		/**
		 *
		 * @param processor
		 */
		public function removeProcessor(processor:IMetadataProcessor):void {
			for each (var metadataName:String in processor.metadataNames) {
				var processors:Vector.<IMetadataProcessor> = metadataLookup[metadataName.toLowerCase()];
				if (processors != null) {
					var idx:int = processors.indexOf(processor);
					if (idx > -1) {
						processors.splice(idx, 1);
					}
				}
			}
		}
	}
}
