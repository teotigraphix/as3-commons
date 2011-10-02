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
	import org.as3commons.metadata.process.impl.AbstractMetadataProcessorTest;
	import org.as3commons.metadata.registry.impl.AS3ReflectMetadataProcessorRegistryTest;
	import org.as3commons.metadata.registry.impl.AbstractMetadataProcessorRegistry;
	import org.as3commons.metadata.registry.impl.BytecodeMetadataProcessorRegistryTest;
	import org.as3commons.metadata.registry.impl.SpiceLibMetadataProcessorRegistryTest;

	[Suite]
	[RunWith("org.flexunit.runners.Suite")]
	public class MetadataTestSuite {
		public var test1:AS3ReflectMetadataProcessorRegistryTest;
		public var test2:SpiceLibMetadataProcessorRegistryTest;
		public var test3:AbstractMetadataProcessorRegistry;
		public var test4:AbstractMetadataProcessorTest;
		public var test5:BytecodeMetadataProcessorRegistryTest;
	}
}
