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
	import flash.utils.describeType;

	import org.as3commons.metadata.process.IMetadataProcessor;

	/**
	 *
	 * @author Roland Zwaga
	 */
	public class DescribeTypeMetadataProcessorRegistry extends AbstractMetadataProcessorRegistry {

		/**
		 * Creates a new <code>DescribeTypeMetadataProcessorRegistry</code> instance.
		 */
		public function DescribeTypeMetadataProcessorRegistry() {
			super();
		}

		override public function process(target:Object):* {
			var clazz:Class = Object(target).constructor as Class;
			var type:XML = describeType(clazz);
			for (var name:String in metadataLookup) {
				var processors:Vector.<IMetadataProcessor> = metadataLookup[name] as Vector.<IMetadataProcessor>;
				var containers:Array = findContainersInXML(name, type);

				for each (var container:XML in containers) {
					for each (var processor:IMetadataProcessor in processors) {
						processor.process(target, name, container);
					}
				}
			}
		}

		protected function findContainersInXML(metadataName:String, type:XML):Array {
			var result:Array = [];
			var xmlList:XMLList = type..metadata.(@name == metadataName);
			for each (var xml:XML in xmlList) {
				result[result.length] = xml.parent();
			}
			return result;
		}

	}
}
