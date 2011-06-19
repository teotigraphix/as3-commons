package org.as3commons.reflect {

	import flexunit.framework.TestCase;

	/**
	 * Class description
	 *
	 * @author Christophe Herreman
	 * @since 13-jan-2009
	 */
	public class MetadataArgumentTest extends TestCase {

		/**
		 * Creates a new MetadataArgumentTest object.
		 */
		public function MetadataArgumentTest(methodName:String = null) {
			super(methodName);
		}

		public function testNew():void {
			var a:MetadataArgument = new MetadataArgument("key", "value");
			assertEquals("key", a.key);
			assertEquals("value", a.value);
		}

		public function testEqualsPass():void {
			var a:MetadataArgument = new MetadataArgument("key", "value");
			assertTrue(a.equals(new MetadataArgument("key", "value")));
		}

		public function testEqualsFail():void {
			var a:MetadataArgument = new MetadataArgument("key", "value");
			assertFalse(a.equals(new MetadataArgument("key", "value2")));
		}

		public function testNewInstanceWithoutSameArguments():void {
			var mda1:MetadataArgument = MetadataArgument.newInstance("type", "propertyChanged");
			var mda2:MetadataArgument = MetadataArgument.newInstance("type", "propertyChanged");
			var mda3:MetadataArgument = MetadataArgument.newInstance("type", "propertyChanged");
			assertStrictlyEquals(mda1, mda2);
			assertStrictlyEquals(mda1, mda3);
		}

		public function testNewInstanceWithoutSameKeyButDifferentValue():void {
			var mda1:MetadataArgument = MetadataArgument.newInstance("type", "propertyChanged");
			var mda2:MetadataArgument = MetadataArgument.newInstance("type", "propertyChanged2");
			assertFalse(mda1 === mda2);
		}

		public function testNewInstanceWithoutDifferentKeyButSameValue():void {
			var mda1:MetadataArgument = MetadataArgument.newInstance("type", "propertyChanged");
			var mda2:MetadataArgument = MetadataArgument.newInstance("type2", "propertyChanged");
			assertFalse(mda1 === mda2);
		}

	}
}
