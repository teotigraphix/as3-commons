package org.as3commons.bytecode.abc.enum {
	import org.flexunit.asserts.assertTrue;

	public class MethodFlagsTest {

		public function MethodFlagsTest() {
			MethodFlag;
		}

		[Test]
		public function testAddFlag():void {
			var testFlags:uint = 0;
			testFlags = MethodFlag.addFlag(testFlags, MethodFlag.HAS_OPTIONAL);
			assertTrue(MethodFlag.flagPresent(testFlags, MethodFlag.HAS_OPTIONAL));

			testFlags = MethodFlag.addFlag(testFlags, MethodFlag.HAS_PARAM_NAMES);
			assertTrue(MethodFlag.flagPresent(testFlags, MethodFlag.HAS_PARAM_NAMES));

			testFlags = MethodFlag.addFlag(testFlags, MethodFlag.IGNORE_REST);
			assertTrue(MethodFlag.flagPresent(testFlags, MethodFlag.IGNORE_REST));

			testFlags = MethodFlag.addFlag(testFlags, MethodFlag.NATIVE);
			assertTrue(MethodFlag.flagPresent(testFlags, MethodFlag.NATIVE));

			testFlags = MethodFlag.addFlag(testFlags, MethodFlag.NEED_ACTIVATION);
			assertTrue(MethodFlag.flagPresent(testFlags, MethodFlag.NEED_ACTIVATION));

			testFlags = MethodFlag.addFlag(testFlags, MethodFlag.NEED_ARGUMENTS);
			assertTrue(MethodFlag.flagPresent(testFlags, MethodFlag.NEED_ARGUMENTS));

			testFlags = MethodFlag.addFlag(testFlags, MethodFlag.NEED_REST);
			assertTrue(MethodFlag.flagPresent(testFlags, MethodFlag.NEED_REST));

			testFlags = MethodFlag.addFlag(testFlags, MethodFlag.SET_DXNS);
			assertTrue(MethodFlag.flagPresent(testFlags, MethodFlag.SET_DXNS));
		}
	}
}