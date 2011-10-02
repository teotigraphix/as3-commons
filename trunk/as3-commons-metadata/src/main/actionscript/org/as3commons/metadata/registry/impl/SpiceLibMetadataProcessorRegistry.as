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

	import flash.system.ApplicationDomain;

	import org.as3commons.metadata.process.IMetadataProcessor;
	import org.as3commons.metadata.registry.IMetadataProcessorRegistry;
	import org.spicefactory.lib.reflect.ClassInfo;
	import org.spicefactory.lib.reflect.Member;
	import org.spicefactory.lib.reflect.Method;

	/**
	 * An <code>IMetadataProcessorRegistry</code> implementation that uses the Spicelib Reflect library internally
	 * to retrieve the metadata information for the specified instances passed into its <code>process()</code> method.
	 * @author Roland Zwaga
	 */
	public class SpiceLibMetadataProcessorRegistry extends AbstractMetadataProcessorRegistry {

		/**
		 * Creates a new <code>SpiceLibMetadataProcessorRegistry</code> instance.
		 */
		public function SpiceLibMetadataProcessorRegistry() {
			super();
		}

		override public function process(target:Object):* {
			var type:ClassInfo = ClassInfo.forInstance(target, applicationDomain);
			for (var name:String in metadataLookup) {
				var processors:Vector.<IMetadataProcessor> = metadataLookup[name] as Vector.<IMetadataProcessor>;
				var containers:Array = (type.hasMetadata(name)) ? [type] : [];
				var memberContainers:Array = getMembersWithMetadata(type, name);
				containers = containers.concat(memberContainers);

				for each (var container:Object in containers) {
					for each (var processor:IMetadataProcessor in processors) {
						processor.process(target, name, container);
					}
				}
			}
		}

		protected function getMembersWithMetadata(type:ClassInfo, name:String):Array {
			var result:Array = [];
			var members:Array = type.getMethods().concat(type.getStaticMethods()).concat(type.getProperties()).concat(type.getStaticProperties());
			for each (var m:Member in members) {
				if (m.hasMetadata(name)) {
					result[result.length] = m;
				}
			}
			return result;
		}
	}
}
