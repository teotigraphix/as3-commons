/*
* Copyright 2007-2012 the original author or authors.
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
package org.as3commons.swc.catalog.reader.impl {
	import org.as3commons.swc.catalog.SWCCatalog;
	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.assertNotNull;
	import org.flexunit.asserts.assertTrue;

	/**
	 * Note: test catalog.xml files should NOT have an xml declaration in them.
	 */
	public class XMLCatalogReaderTest {

		[Embed(source="testfiles/catalog-as3commons-lang.xml")]
		private static const as3commonsLangCatalog:Class;

		[Embed(source="testfiles/catalog-spring-actionscript.xml")]
		private static const springActionScriptCatalog:Class;

		[Embed(source="testfiles/catalog-flash.xml")]
		private static const flashCatalog:Class;

		public function XMLCatalogReaderTest() {
		}

		[Test]
		public function testRead():void {
			var xml:XML = as3commonsLangCatalog.data as XML;
			var reader:XMLCatalogReader = new XMLCatalogReader(xml.toXMLString());
			var catalog:SWCCatalog = reader.read();
			assertEquals("1.2", catalog.versions.libVersion);
			assertEquals("4.5.1", catalog.versions.flexVersion);
			assertEquals("3.0.0", catalog.versions.flexMinimumSupportedVersion);
			assertEquals("21328", catalog.versions.flexBuild);
		}

		[Test]
		public function testRead_springActionScriptCatalog():void {
			var xml:XML = springActionScriptCatalog.data as XML;
			var reader:XMLCatalogReader = new XMLCatalogReader(xml.toXMLString());
			var catalog:SWCCatalog = reader.read();
			assertEquals("1.2", catalog.versions.libVersion);
			assertEquals("4.5.1", catalog.versions.flexVersion);
			assertEquals("3.0.0", catalog.versions.flexMinimumSupportedVersion);
			assertEquals("21328", catalog.versions.flexBuild);
			assertNotNull(catalog.components);
			assertTrue(catalog.components.length > 0);
			assertNotNull(catalog.libraries);
			assertEquals(1, catalog.libraries.length);
			assertEquals("library.swf", catalog.libraries[0].path);
			assertNotNull(catalog.libraries[0].scripts);
			assertTrue(catalog.libraries[0].scripts.length > 0);
			assertNotNull(catalog.libraries[0].metadata);
			assertTrue(catalog.libraries[0].metadata.length > 0);
			assertNotNull(catalog.files);
			assertEquals(3, catalog.files.length);
		}

		[Test]
		public function testRead_flashCatalog():void {
			var xml:XML = flashCatalog.data as XML;
			var reader:XMLCatalogReader = new XMLCatalogReader(xml.toXMLString());
			var catalog:SWCCatalog = reader.read();
			assertEquals("1.2", catalog.versions.libVersion);
			assertEquals("", catalog.versions.flexVersion);
			assertEquals("", catalog.versions.flexMinimumSupportedVersion);
			assertEquals("", catalog.versions.flexBuild);
			assertEquals("11.5", catalog.versions.flashVersion);
			assertEquals("d325", catalog.versions.flashBuild);
			assertEquals("WIN", catalog.versions.flashPlatform);
		}
	}
}
