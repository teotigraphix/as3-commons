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
	import flash.errors.IllegalOperationError;
	import org.as3commons.metadata.process.IMetadataProcessor;

	/**
	 * Abstract base class for <code>IMetadataProcessor</code> implementations.
	 * @author Roland Zwaga
	 */
	public class AbstractMetadataProcessor implements IMetadataProcessor {

		/**
		 * Creates a new <code>AbstractMetadataProcessor</code> instance.
		 */
		public function AbstractMetadataProcessor() {
			super();
		}

		private var _metadataNames:Vector.<String>;

		/**
		 * @inheritDoc
		 */
		public function get metadataNames():Vector.<String> {
			return _metadataNames ||= new Vector.<String>();
		}

		/**
		 * Returns <code>true</code> if the specified metadata name is found in the metadataNames <code>Vector</code>.
		 * @param metadataName
		 * @return
		 */
		public function canProcess(metadataName:String):Boolean {
			return (metadataNames.indexOf(metadataName) > -1);
		}

		/**
		 * This method needs to be implemented by subclasses of <code>AbstractMetadataProcessor</code>.
		 * @throws flash.errors.IllegalOperationError
		 */
		public function process(target:Object, metadataName:String, info:*=null):* {
			throw new IllegalOperationError("Not implmented in abstract base class");
		}
	}
}
