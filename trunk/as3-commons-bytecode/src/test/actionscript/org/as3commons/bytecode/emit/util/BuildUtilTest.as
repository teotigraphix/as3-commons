package org.as3commons.bytecode.emit.util {

	import flash.errors.IllegalOperationError;
	import flash.utils.Dictionary;

	import flexunit.framework.TestCase;

	import org.as3commons.bytecode.abc.enum.ConstantKind;

	public class BuildUtilTest extends TestCase {

		public function BuildUtilTest() {
			super();
		}

		public function testToConstantKindInt():void {
			var c:ConstantKind = BuildUtil.defaultValueToConstantKind(-1);
			assertStrictlyEquals(ConstantKind.INT, c);
		}

		public function testToConstantKindUInt():void {
			var c:ConstantKind = BuildUtil.defaultValueToConstantKind(uint(1));
			assertStrictlyEquals(ConstantKind.UINT, c);
		}

		public function testToConstantKindNumber():void {
			var c:ConstantKind = BuildUtil.defaultValueToConstantKind(Number(1.3));
			assertStrictlyEquals(ConstantKind.DOUBLE, c);
		}

		public function testToConstantKindString():void {
			var c:ConstantKind = BuildUtil.defaultValueToConstantKind("Test");
			assertStrictlyEquals(ConstantKind.UTF8, c);
		}

		public function testToConstantKindFalse():void {
			var c:ConstantKind = BuildUtil.defaultValueToConstantKind(false);
			assertStrictlyEquals(ConstantKind.FALSE, c);
		}

		public function testToConstantKindTrue():void {
			var c:ConstantKind = BuildUtil.defaultValueToConstantKind(true);
			assertStrictlyEquals(ConstantKind.TRUE, c);
		}

		public function testToConstantKindNull():void {
			var c:ConstantKind = BuildUtil.defaultValueToConstantKind(null);
			assertStrictlyEquals(ConstantKind.NULL, c);
		}

		public function testToConstantKindIllegalValue():void {
			try {
				BuildUtil.defaultValueToConstantKind(new Dictionary());
				fail("IllegalOperationError needs to be thrown");
			} catch (e:IllegalOperationError) {
				assertTrue(true);
			}
		}

	}
}