package org.as3commons.reflect {

	import flexunit.framework.TestCase;

	/**
	 * @author Christophe Herreman
	 * @since 13-jan-2009
	 */
	public class MetaDataTest extends TestCase {

		public function MetaDataTest(methodName:String = null) {
			super(methodName);
		}

		public function testNew():void {
			var metaData:MetaData = new MetaData("key", [new MetaDataArgument("key", "value")]);
			assertEquals("key", metaData.name);
			assertNotNull(metaData.arguments);
			assertEquals(1, metaData.arguments.length);
		}

		public function testNew_shouldHaveEmptyArgumentsArrayIfNullArgumentsAreGiven():void {
			var metaData:MetaData = new MetaData("key", null);
			assertEquals("key", metaData.name);
			assertNotNull(metaData.arguments);
			assertEquals(0, metaData.arguments.length);
		}

		public function testEqualsPass():void {
			var a:MetaData = new MetaData("testMetaData");
			a.arguments.push(new MetaDataArgument("key", "value"));

			var a2:MetaData = new MetaData("testMetaData");
			a2.arguments.push(new MetaDataArgument("key", "value"));

			assertTrue(a.equals(a2));
		}

		public function testEqualsFail():void {
			var a:MetaData = new MetaData("testMetaData");
			a.arguments.push(new MetaDataArgument("key", "value"));

			var a2:MetaData = new MetaData("testMetaData");
			a2.arguments.push(new MetaDataArgument("key", "value2"));

			assertFalse(a.equals(a2));

			a = new MetaData("testMetaData");
			a.arguments.push(new MetaDataArgument("key", "value"));

			a2 = new MetaData("testMetaData");
			a2.arguments.push(new MetaDataArgument("key", "value"));
			a2.arguments.push(new MetaDataArgument("key2", "value2"));

			assertFalse(a.equals(a2));

		}


	}
}