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
	 * Abstract base class for <code>IMetadataProcessorRegistry</code> implementations. Provides only logic for associating <code>IMetadataProcessors</code>
	 * with metdata names. The actual processoing logic needs to be implemented by subclasses.
	 * @author Roland Zwaga
	 */
	public class AbstractMetadataProcessorRegistry implements IMetadataProcessorRegistry {

		/**
		 * Creates a new <code>AbstractMetadataProcessorRegistry</code> instance.
		 */
		public function AbstractMetadataProcessorRegistry() {
			super();
		}

		protected var metadataLookup:Object = {};

		private var _applicationDomain:ApplicationDomain;

		/**
		 * The <code>ApplicationDomain</code> that will be used to retrieve the class information for the instances passed into
		 * the <code>process()</code> method.
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
		 * @inheritDoc
		 */
		public function addProcessor(processor:IMetadataProcessor):void {
			for each (var metadataName:String in processor.metadataNames) {
				internalAddProcessor(processor, metadataName);
			}
		}

		/**
		 * @inheritDoc
		 */
		public function getProcessorsForMetadata(metadataName:String):Vector.<IMetadataProcessor> {
			return metadataLookup[metadataName];
		}

		/**
		 * This methoid needs to be overriden and implemented in subclasses of <code>AbstractMetadataProcessorRegistry</code>.
		 * @throws flash.errors.IllegalOperationError
		 */
		public function process(target:Object, params:Array=null):* {
			throw new IllegalOperationError("Not implemented in abstract base class");
		}

		/**
		 * @inheritDoc
		 */
		public function removeProcessor(processor:IMetadataProcessor):void {
			for each (var metadataName:String in processor.metadataNames) {
				internalRemoveProcessor(processor, metadataName);
			}
		}

		/**
		 * Retrieves or creates the <code>Vector</code> that contains all the <code>IMetadataProcessors</code> associated with the specified metadata name.<br/>
		 * If the <code>Vector</code> doesn't already contain the specified <code>IMetadataProcessor</code> it is added.
		 * @param processor
		 * @param metadataName
		 */
		protected function internalAddProcessor(processor:IMetadataProcessor, metadataName:String):void {
			var processors:Vector.<IMetadataProcessor> = metadataLookup[metadataName] ||= new Vector.<IMetadataProcessor>();
			if (processors.indexOf(processor) < 0) {
				processors[processors.length] = processor;
			}
		}

		/**
		 * Retrieves the <code>Vector</code> that contains all the <code>IMetadataProcessors</code> associated
		 * with the specified metadata name. If it is found the specified <code>IMetadataProcessor</code> is removed from
		 * it. If after removal the <code>Vector</code> is empty, the metadata name and its associated <code>Vector</code> is
		 * removed from the metadata-&gt;<code>Vector</code> lookup.
		 * @param processor
		 * @param metadataName
		 */
		protected function internalRemoveProcessor(processor:IMetadataProcessor, metadataName:String):void {
			var processors:Vector.<IMetadataProcessor> = metadataLookup[metadataName];
			if (processors != null) {
				var idx:int = processors.indexOf(processor);
				if (idx > -1) {
					processors.splice(idx, 1);
					if (processors.length == 0) {
						delete metadataLookup[metadataName];
					}
				}
			}

		}
	}
}
