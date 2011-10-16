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
	import org.as3commons.metadata.process.IMetadataProcessor;
	import org.as3commons.reflect.IMetadataContainer;
	import org.as3commons.reflect.Type;

	/**
	 * An <code>IMetadataProcessorRegistry</code> implementation that uses the as3commons-reflect library internally
	 * to retrieve the metadata information for the specified instances passed into its <code>process()</code> method.
	 * @author Roland Zwaga
	 */
	public class AS3ReflectMetadataProcessorRegistry extends AbstractMetadataProcessorRegistry {

		/**
		 * Creates a new <code>AS3ReflectMetadataProcessorRegistry</code> instance.
		 */
		public function AS3ReflectMetadataProcessorRegistry() {
			super();
		}

		/**
		 * Adds the processor with all of its metadata names forced to lower case.
		 * @param processor
		 */
		override public function addProcessor(processor:IMetadataProcessor):void {
			for each (var metadataName:String in processor.metadataNames) {
				internalAddProcessor(processor, metadataName.toLowerCase());
			}
		}

		/**
		 * Forces the specified metadataName to lowercase and returns the associated <code>Vector.&lt;IMetadataProcessor&gt;</code> if it exists.
		 * @return The <code>Vector.&lt;IMetadataProcessor&gt;</code> that may be associated with the specified metadata name, otherwise <code>null</code> is returned.
		 */
		override public function getProcessorsForMetadata(metadataName:String):Vector.<IMetadataProcessor> {
			return metadataLookup[metadataName.toLowerCase()];
		}

		/**
		 * Retrieves the reflection information for the specified target instance and continues to let this instance be
		 * processed by the registered <code>IMetadataProcessors</code>.
		 * @param target
		 * @return
		 */
		override public function process(target:Object, params:Array=null):* {
			var type:Type = Type.forInstance(target, applicationDomain);
			return processType(type, target, params);
		}

		/**
		 * Removes the processor with all of its metadata names forced to lower case.
		 * @param processor
		 */
		override public function removeProcessor(processor:IMetadataProcessor):void {
			for each (var metadataName:String in processor.metadataNames) {
				internalRemoveProcessor(processor, metadataName.toLowerCase());
			}
		}

		/**
		 * Calls every <code>IMetadataProcessor</code> that has been registered with the metadata that is reported
		 * by the specified <code>Type</code> object. The <code>IMetadataContainer</code> describing the member that
		 * is annotated with the specified metadata will be passed to the <code>IMetadataProcessors</code> as the <code>info</code> argument.
		 * The <code>info</code> parameter will be put into an <code>Array</code> together with the <code>IMetadataContainer</code> instance.
		 * (First the <code>IMetadataContainer</code> instance then the <code>info</code> parameter.)
		 * @param type
		 * @param target
		 * @returns
		 */
		protected function processType(type:Type, target:Object, params:Array):* {
			for (var name:String in metadataLookup) {
				var processors:Vector.<IMetadataProcessor> = metadataLookup[name] as Vector.<IMetadataProcessor>;
				var containers:Array = (type.hasMetadata(name)) ? [type] : [];
				var memberContainers:Array = type.getMetadataContainers(name);
				if (memberContainers != null) {
					containers = containers.concat(memberContainers);
				}

				for each (var container:IMetadataContainer in containers) {
					for each (var processor:IMetadataProcessor in processors) {
						params = (params != null) ? [container].concat(params) : [container];
						var result:* = processor.process(target, name, params);
						if (result != null) {
							target = result;
						}
					}
				}
			}
			return target;
		}
	}
}
