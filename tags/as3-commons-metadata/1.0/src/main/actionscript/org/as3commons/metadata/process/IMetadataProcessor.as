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
package org.as3commons.metadata.process {

	/**
	 * Describes an object that can process an instance that is annotated with specific metadata.
	 * @author Roland Zwaga
	 */
	public interface IMetadataProcessor {

		/**
		 * The names of the metadata annotations that the current <code>IMetadataProcessor</code> is abe to process.
		 */
		function get metadataNames():Vector.<String>;

		/**
		 * Returns <code>true</code> if the specified metadataName is able to be processed by the current <code>IMetadataProcessor</code>.
		 * @param metadataName
		 * @return
		 */
		function canProcess(metadataName:String):Boolean;

		/**
		 * Processes the specified <code>Object</code>. This method return a new instance to replace the passed in object instance.
		 * @param instance The specified <code>Object</code>.
		 * @param metadataName The metadata name that triggered this invocation.
		 * @param params Optional <code>Array</code> of parameters that contains implementation specific data.
		 */
		function process(target:Object, metadataName:String, params:Array=null):*;

	}
}
