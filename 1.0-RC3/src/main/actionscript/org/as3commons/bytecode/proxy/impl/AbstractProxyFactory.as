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
package org.as3commons.bytecode.proxy.impl {
	import flash.events.EventDispatcher;

	import org.as3commons.bytecode.emit.IMetadataContainer;
	import org.as3commons.bytecode.emit.impl.MetadataArgument;
	import org.as3commons.reflect.Metadata;

	public class AbstractProxyFactory extends EventDispatcher {

		public function AbstractProxyFactory() {
			super();
		}

		/**
		 * Adds the metadata from the specified <code>Array</code> of <code>Metadata</code> instances
		 * to the specified <code>IMetadataContainer</code> instance.
		 * @param metadaContainer The specified <code>IMetadataContainer</code> instance.
		 * @param metadatas The specified <code>Array</code> of <code>Metadata</code> instances
		 */
		protected function addMetadata(metadaContainer:IMetadataContainer, metadatas:Array):void {
			for each (var metadata:Metadata in metadatas) {
				var args:Array = [];
				for each (var arg:org.as3commons.reflect.MetadataArgument in metadata.arguments) {
					args[args.length] = new org.as3commons.bytecode.emit.impl.MetadataArgument(arg.key, arg.value);
					metadaContainer.defineMetadata(metadata.name, args);
				}
			}
		}

	}
}