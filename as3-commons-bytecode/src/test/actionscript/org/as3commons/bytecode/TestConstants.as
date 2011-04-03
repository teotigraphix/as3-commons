/**
 * Copyright 2009 Maxim Cassian Porges
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package org.as3commons.bytecode {
	import flash.utils.ByteArray;
	import flash.utils.Endian;

	public class TestConstants {

		[Embed(source="../../../../../test/resources/assets/SWFWeaverTest-debug.swf", mimeType="application/octet-stream")]
		private static var debugbuildswfweavertest:Class;
		
		public static function getDebugBuildSWFWeaverTest():ByteArray {
			return new debugbuildswfweavertest() as ByteArray;
		}
		
		[Embed(source="../../../../../test/resources/assets/SWFWeaverTest-release.swf", mimeType="application/octet-stream")]
		private static var releasebuildswfweavertest:Class;

		public static function getReleaseBuildSWFWeaverTest():ByteArray {
			return new releasebuildswfweavertest() as ByteArray;
		}

		[Embed(source="../../../../../test/resources/assets/BytecodeDeserializeTest-release.swf", mimeType="application/octet-stream")]
		private static var releasebuildtest:Class;

		public static function getReleaseBuildTest():ByteArray {
			return new releasebuildtest() as ByteArray;
		}

		[Embed(source="../../../../../test/resources/assets/BytecodeDeserializeTest-debug.swf", mimeType="application/octet-stream")]
		private static var debugbuildtest:Class;

		public static function getDebugBuildTest():ByteArray {
			return new debugbuildtest() as ByteArray;
		}

		[Embed(source="../../../../../test/resources/assets/framework_4.0.0.14159.swf", mimeType="application/octet-stream")]
		private static var framework4:Class;

		public static function getFramework4():ByteArray {
			return new framework4() as ByteArray;
		}

		[Embed(source="../../../../../test/resources/assets/framework_4.1.0.16076.swf", mimeType="application/octet-stream")]
		private static var framework41:Class;

		public static function getFramework41():ByteArray {
			return new framework41() as ByteArray;
		}

		[Embed(source="../../../../../test/resources/assets/metadatalookuptest.swf", mimeType="application/octet-stream")]
		private static var metadataLookupTest:Class;

		public static function getMetadataLookupTest():ByteArray {
			return new metadataLookupTest() as ByteArray;
		}

		[Embed(source="../../../../../test/resources/assets/template/SubClassOfSubClassOfSubClass.abc", mimeType="application/octet-stream")]
		private static var subClassOfsubClassOfSubClassTemplate:Class;

		public static function getSubClassOfSubClassOfSubClassTemplate():ByteArray {
			return new subClassOfsubClassOfSubClassTemplate() as ByteArray;
		}

		[Embed(source="../../../../../test/resources/assets/template/BaseClass.abc", mimeType="application/octet-stream")]
		private static var baseClassTemplateTemplate:Class;

		public static function getBaseClassTemplate():ByteArray {
			return new baseClassTemplateTemplate() as ByteArray;
		}

		[Embed(source="../../../../../test/resources/assets/template/MethodInvocation.abc", mimeType="application/octet-stream")]
		private static var methodInvocation:Class;

		public static function getMethodInvocation():ByteArray {
			return new methodInvocation() as ByteArray;
		}

		[Embed(source="../../../../../test/resources/assets/template/DynamicSubClass.abc", mimeType="application/octet-stream")]
		private static var proxyTemplate:Class;

		public static function getProxyTemplate():ByteArray {
			return new proxyTemplate() as ByteArray;
		}

		[Embed(source="../../../../../test/resources/assets/abc/FCDSubClass.abc", mimeType="application/octet-stream")]
		private static var fullClassDefinitionSubClassBytes:Class;

		public static function getFullClassDefinitionSubClassByteCode():ByteArray {
			return new fullClassDefinitionSubClassBytes() as ByteArray;
		}

		[Embed(source="../../../../../test/resources/assets/abc/FullClassDefinition.abc", mimeType="application/octet-stream")]
		private static var fullClassDefinitionBytes:Class;

		public static function getFullClassDefinitionByteCode():ByteArray {
			return new fullClassDefinitionBytes() as ByteArray;
		}

		[Embed(source="../../../../../test/resources/assets/abc/Interface.abc", mimeType="application/octet-stream")]
		private static var interfaceBytes:Class;

		public static function getInterfaceDefinitionByteCode():ByteArray {
			return new interfaceBytes() as ByteArray;
		}
	}
}