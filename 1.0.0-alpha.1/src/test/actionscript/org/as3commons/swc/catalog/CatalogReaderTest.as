package org.as3commons.swc.catalog {
	import org.as3commons.swc.SWC;
	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.assertNotNull;
	import org.flexunit.asserts.assertTrue;

	/**
	 * Note: test catalog.xml files should NOT have an xml declaration in them.
	 */
	public class CatalogReaderTest {

		[Embed(source="testfiles/catalog-as3commons-lang.xml")]
		private static const as3commonsLangCatalog:Class;

		[Embed(source="testfiles/catalog-spring-actionscript.xml")]
		private static const springActionScriptCatalog:Class;

		[Embed(source="testfiles/catalog-flash.xml")]
		private static const flashCatalog:Class;

		public function CatalogReaderTest() {
		}

		[Test]
		public function testRead():void {
			var swc:SWC = new SWC();
			var xml:XML = as3commonsLangCatalog.data as XML;
			var reader:CatalogReader = new CatalogReader(swc, xml.toXMLString());
			reader.read();
			assertEquals("1.2", swc.libVersion);
			assertEquals("4.5.1", swc.flexVersion);
			assertEquals("3.0.0", swc.flexMinimumSupportedVersion);
			assertEquals("21328", swc.flexBuild);
		}

		[Test]
		public function testRead_springActionScriptCatalog():void {
			var swc:SWC = new SWC();
			var xml:XML = springActionScriptCatalog.data as XML;
			var reader:CatalogReader = new CatalogReader(swc, xml.toXMLString());
			reader.read();
			assertEquals("1.2", swc.libVersion);
			assertEquals("4.5.1", swc.flexVersion);
			assertEquals("3.0.0", swc.flexMinimumSupportedVersion);
			assertEquals("21328", swc.flexBuild);
			assertTrue(swc.numComponents > 0);
			assertNotNull(swc.components);
			assertTrue(swc.components.length > 0);
		}

		[Test]
		public function testRead_flashCatalog():void {
			var swc:SWC = new SWC();
			var xml:XML = flashCatalog.data as XML;
			var reader:CatalogReader = new CatalogReader(swc, xml.toXMLString());
			reader.read();
			assertEquals("1.2", swc.libVersion);
			assertEquals("", swc.flexVersion);
			assertEquals("", swc.flexMinimumSupportedVersion);
			assertEquals("", swc.flexBuild);
			assertEquals("11.5", swc.flashVersion);
			assertEquals("d325", swc.flashBuild);
			assertEquals("WIN", swc.flashPlatform);
		}
	}
}
