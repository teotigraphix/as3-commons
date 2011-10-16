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
package org.as3commons.metadata.registry {
	import org.as3commons.metadata.process.IMetadataProcessor;

	/**
	 * Describes an object that acts as a registry for a collection of <code>IMetadataProcessors</code>. It can be used to invoke one or more <code>IMetadataProcessors</code>
	 * on object instances that are annotated with the exact metadata that these <code>IMetadataProcessors</code> have been associated with.
	 * @author Roland Zwaga
	 */
	public interface IMetadataProcessorRegistry {

		/**
		 * Registers the specified <code>IMetadataProcessor</code> with the current <code>IMetadataProcessorRegistry</code>.
		 * @param processor
		 */
		function addProcessor(processor:IMetadataProcessor):void;
		/**
		 * Returns a <code>Vector</code> of <code>IMetadataProcessors</code> that have been associated with the specified metadata name.<br/>
		 * This should return <code>null</code> if no processors were found.
		 * @param metadataName
		 * @return A <code>Vector</code> of <code>IMetadataProcessors</code>
		 */
		function getProcessorsForMetadata(metadataName:String):Vector.<IMetadataProcessor>;

		/**
		 * Examines the specified target instance for the existence of any metadata names that have been registered. If these are found the appropriate
		 * <code>IMetadataProcessors</code> are invoked.
		 * @param target The specified target object that will be processed by the appropriate <code>IMetadataProcessors</code>.
		 * @param params An optional <code>Array</code> of implementation specific data that will be passed to the <code>process()</code> method of each invoked <code>IMetadataProcessor</code>.
		 * @return
		 */
		function process(target:Object, params:Array=null):*;

		/**
		 * Removes the specified <code>IMetadataProcessor</code> from the current <code>IMetadataProcessorRegistry</code>.
		 * @param processor
		 */
		function removeProcessor(processor:IMetadataProcessor):void;
	}
}
