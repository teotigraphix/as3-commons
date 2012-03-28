package org.as3commons.bytecode.emit.util {

	import flash.errors.IllegalOperationError;
	import flash.utils.Dictionary;

	import org.as3commons.bytecode.abc.enum.ConstantKind;
	import org.flexunit.asserts.assertStrictlyEquals;
	import org.flexunit.asserts.assertTrue;
	import org.flexunit.asserts.fail;

	public class BuildUtilTest {

		public function BuildUtilTest() {
			super();
		}

		[Test]
		public function testToConstantKindInt():void {
			var c:ConstantKind = BuildUtil.defaultValueToConstantKind(-1);
			assertStrictlyEquals(ConstantKind.INT, c);
		}

		[Test]
		public function testToConstantKindUInt():void {
			var c:ConstantKind = BuildUtil.defaultValueToConstantKind(uint(1));
			assertStrictlyEquals(ConstantKind.UINT, c);
		}

		[Test]
		public function testToConstantKindNumber():void {
			var c:ConstantKind = BuildUtil.defaultValueToConstantKind(Number(1.3));
			assertStrictlyEquals(ConstantKind.DOUBLE, c);
		}

		[Test]
		public function testToConstantKindString():void {
			var c:ConstantKind = BuildUtil.defaultValueToConstantKind("Test");
			assertStrictlyEquals(ConstantKind.UTF8, c);
		}

		[Test]
		public function testToConstantKindFalse():void {
			var c:ConstantKind = BuildUtil.defaultValueToConstantKind(false);
			assertStrictlyEquals(ConstantKind.FALSE, c);
		}

		[Test]
		public function testToConstantKindTrue():void {
			var c:ConstantKind = BuildUtil.defaultValueToConstantKind(true);
			assertStrictlyEquals(ConstantKind.TRUE, c);
		}

		[Test]
		public function testToConstantKindNull():void {
			var c:ConstantKind = BuildUtil.defaultValueToConstantKind(null);
			assertStrictlyEquals(ConstantKind.NULL, c);
		}

		[Test]
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