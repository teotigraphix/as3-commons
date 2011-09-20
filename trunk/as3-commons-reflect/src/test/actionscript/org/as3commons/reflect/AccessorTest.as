package org.as3commons.reflect {

	import flash.system.ApplicationDomain;

	import flexunit.framework.TestCase;

	import org.as3commons.lang.HashArray;

	/**
	 * @author Christophe Herreman
	 */
	public class AccessorTest extends TestCase {

		public var appDomain:ApplicationDomain = ApplicationDomain.currentDomain;

		public function AccessorTest(methodName:String = null) {
			super(methodName);
		}

		override public function setUp():void {
			super.setUp();
		}

		override public function tearDown():void {
			super.tearDown();
		}

		// --------------------------------------------------------------------
		//
		// readable
		//
		// --------------------------------------------------------------------

		public function testReadable_shouldReturnTrueForReadOnlyAccess():void {
			assertTrue(newAccessor(AccessorAccess.READ_ONLY).readable);
		}

		public function testReadable_shouldReturnTrueForReadWriteAccess():void {
			assertTrue(newAccessor(AccessorAccess.READ_WRITE).readable);
		}

		public function testReadable_shouldReturnFalseForWriteOnlyAccess():void {
			assertFalse(newAccessor(AccessorAccess.WRITE_ONLY).readable);
		}

		// --------------------------------------------------------------------
		//
		// writeable
		//
		// --------------------------------------------------------------------

		public function testWriteable_shouldReturnTrueForWriteOnlyAccess():void {
			assertTrue(newAccessor(AccessorAccess.WRITE_ONLY).writeable);
		}

		public function testWriteable_shouldReturnTrueForReadWriteAccess():void {
			assertTrue(newAccessor(AccessorAccess.READ_WRITE).writeable);
		}

		public function testWriteable_shouldReturnFalseForReadOnlyAccess():void {
			assertFalse(newAccessor(AccessorAccess.READ_ONLY).writeable);
		}

		// --------------------------------------------------------------------
		//
		// isReadable()
		//
		// --------------------------------------------------------------------

		public function testIsReadable_shouldReturnTrueForReadOnlyAccess():void {
			assertTrue(newAccessor(AccessorAccess.READ_ONLY).isReadable());
		}

		public function testIsReadable_shouldReturnTrueForReadWriteAccess():void {
			assertTrue(newAccessor(AccessorAccess.READ_WRITE).isReadable());
		}

		public function testIsReadable_shouldReturnFalseForWriteOnlyAccess():void {
			assertFalse(newAccessor(AccessorAccess.WRITE_ONLY).isReadable());
		}

		// --------------------------------------------------------------------
		//
		// isWriteable()
		//
		// --------------------------------------------------------------------

		public function testIsWriteable_shouldReturnTrueForWriteOnlyAccess():void {
			assertTrue(newAccessor(AccessorAccess.WRITE_ONLY).isWriteable());
		}

		public function testIsWriteable_shouldReturnTrueForReadWriteAccess():void {
			assertTrue(newAccessor(AccessorAccess.READ_WRITE).isWriteable());
		}

		public function testIsWriteable_shouldReturnFalseForReadOnlyAccess():void {
			assertFalse(newAccessor(AccessorAccess.READ_ONLY).isWriteable());
		}

		// --------------------------------------------------------------------
		//
		// as3commons_reflect
		//
		// --------------------------------------------------------------------

		public function testSetProperties():void {
			var accessor:Accessor = newAccessor(AccessorAccess.READ_ONLY);
			assertFalse(accessor.isWriteable());
			accessor.as3commons_reflect::setAccess(AccessorAccess.READ_WRITE);
			assertTrue(accessor.isWriteable());
		}

		// --------------------------------------------------------------------
		//
		// Private Methods
		//
		// --------------------------------------------------------------------

		private function newAccessor(access:AccessorAccess):Accessor {
			return new Accessor("test", access, "test", "test", false, appDomain);
		}

		public function testNewInstanceWithCacheAndEqualParams():void {
			var acc1:Accessor = Accessor.newInstance("test", AccessorAccess.READ_ONLY, "test", "test", false, appDomain);
			var acc2:Accessor = Accessor.newInstance("test", AccessorAccess.READ_ONLY, "test", "test", false, appDomain);
			assertStrictlyEquals(acc1, acc2);
		}

		public function testNewInstanceWithCacheAndDifferentParams():void {
			var acc1:Accessor = Accessor.newInstance("test", AccessorAccess.READ_ONLY, "test", "test", false, appDomain);
			var acc2:Accessor = Accessor.newInstance("test", AccessorAccess.READ_WRITE, "test", "test", false, appDomain);
			assertFalse(acc1 === acc2);
		}

		public function testNewInstanceWithCacheAndEqualParamsAndDifferentMetadata():void {
			var md:HashArray = new HashArray("name", false, [Metadata.newInstance("Bindable")]);
			var acc1:Accessor = Accessor.newInstance("test", AccessorAccess.READ_ONLY, "test", "test", false, appDomain, md);
			var acc2:Accessor = Accessor.newInstance("test", AccessorAccess.READ_ONLY, "test", "test", false, appDomain);
			assertFalse(acc1 === acc2);
		}

		public function testNewInstanceWithIllegalName():void {
			var acc1:Accessor = Accessor.newInstance("hasOwnProperty", AccessorAccess.READ_ONLY, "test", "test", false, appDomain);
			var acc2:Accessor = Accessor.newInstance("hasOwnProperty", AccessorAccess.READ_ONLY, "test", "test", false, appDomain);
			var acc3:Accessor = Accessor.newInstance("hasOwnProperty", AccessorAccess.READ_ONLY, "test", "test", false, appDomain);
			assertStrictlyEquals(acc1, acc2);
			assertStrictlyEquals(acc1, acc3);
		}

		/*public function testNewInstance_speed():void {
			for (var i:int = 0; i<1000; i++) {
				testNewInstanceWithCacheAndEqualParams();
				testNewInstanceWithCacheAndDifferentParams();
				testNewInstanceWithCacheAndEqualParamsAndDifferentMetadata();
				testNewInstanceWithIllegalName();
			}
		}*/

	}
}
