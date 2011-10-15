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
package org.as3commons.metadata.test {

	[MetadataProcessor]
	/**
	 *
	 * @author Roland Zwaga
	 */
	public class AnonMetadataProcessorWithArgumentsInDifferentOrderAndDifferentProcessName {

		private var _processArgsValues:Array;

		/**
		 * Creates a new <code>AnonMetadataProcessorWithAllArgumentsAndDifferentProcessName</code> instance.
		 */
		public function AnonMetadataProcessorWithArgumentsInDifferentOrderAndDifferentProcessName() {
			super();
		}

		public function get processArgsValues():Array {
			return _processArgsValues;
		}

		[Ignore]
		[Test]
		public function process(metadataName:String, info:*, target:Object):void {
			_processArgsValues = [];
			_processArgsValues[_processArgsValues.length] = target;
			_processArgsValues[_processArgsValues.length] = metadataName;
			_processArgsValues[_processArgsValues.length] = info;
		}

	}
}
