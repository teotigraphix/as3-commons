package org.as3commons.reflect {

	import flexunit.framework.TestCase;

	/**
	 * @author Christophe Herreman
	 * @since 13-jan-2009
	 */
	public class MetadataTest extends TestCase {

		public function MetadataTest(methodName:String = null) {
			super(methodName);
		}

		public function testNew():void {
			var metadata:Metadata = new Metadata("key", [new MetadataArgument("key", "value")]);
			assertEquals("key", metadata.name);
			assertNotNull(metadata.arguments);
			assertEquals(1, metadata.arguments.length);
		}

		public function testNew_shouldHaveEmptyArgumentsArrayIfNullArgumentsAreGiven():void {
			var metadata:Metadata = new Metadata("key", null);
			assertEquals("key", metadata.name);
			assertNotNull(metadata.arguments);
			assertEquals(0, metadata.arguments.length);
		}

		public function testEqualsPass():void {
			var a:Metadata = new Metadata("testMetadata");
			a.arguments.push(new MetadataArgument("key", "value"));

			var a2:Metadata = new Metadata("testMetadata");
			a2.arguments.push(new MetadataArgument("key", "value"));

			assertTrue(a.equals(a2));
		}

		public function testEqualsFail():void {
			var a:Metadata = new Metadata("testMetadata");
			a.arguments.push(new MetadataArgument("key", "value"));

			var a2:Metadata = new Metadata("testMetadata");
			a2.arguments.push(new MetadataArgument("key", "value2"));

			assertFalse(a.equals(a2));

			a = new Metadata("testMetadata");
			a.arguments.push(new MetadataArgument("key", "value"));

			a2 = new Metadata("testMetadata");
			a2.arguments.push(new MetadataArgument("key", "value"));
			a2.arguments.push(new MetadataArgument("key2", "value2"));

			assertFalse(a.equals(a2));

		}


	}
}