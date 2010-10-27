package org.as3commons.bytecode.emit.util {

	import flash.errors.IllegalOperationError;
	import flash.utils.Dictionary;

	import flexunit.framework.TestCase;

	import org.as3commons.bytecode.abc.enum.ConstantKind;

	public class BuildUtilTest extends TestCase {

		public function BuildUtilTest() {
			super();
		}

		public function toConstantKindIntTest():void {
			var c:ConstantKind = BuildUtil.defaultValueToConstantKind(-1);
			assertStrictlyEquals(ConstantKind.INT, c);
		}

		public function toConstantKindUIntTest():void {
			var c:ConstantKind = BuildUtil.defaultValueToConstantKind(uint(1));
			assertStrictlyEquals(ConstantKind.UINT, c);
		}

		public function toConstantKindNumberTest():void {
			var c:ConstantKind = BuildUtil.defaultValueToConstantKind(Number(1.3));
			assertStrictlyEquals(ConstantKind.DOUBLE, c);
		}

		public function toConstantKindStringTest():void {
			var c:ConstantKind = BuildUtil.defaultValueToConstantKind("Test");
			assertStrictlyEquals(ConstantKind.UTF8, c);
		}

		public function toConstantKindFalseTest():void {
			var c:ConstantKind = BuildUtil.defaultValueToConstantKind(false);
			assertStrictlyEquals(ConstantKind.FALSE, c);
		}

		public function toConstantKindTrueTest():void {
			var c:ConstantKind = BuildUtil.defaultValueToConstantKind(true);
			assertStrictlyEquals(ConstantKind.TRUE, c);
		}

		public function toConstantKindNullTest():void {
			var c:ConstantKind = BuildUtil.defaultValueToConstantKind(null);
			assertStrictlyEquals(ConstantKind.NULL, c);
		}

		public function toConstantKindIllegalValueTest():void {
			try {
				BuildUtil.defaultValueToConstantKind(new Dictionary());
				fail("IllegalOperationError needs to be thrown");
			} catch (e:IllegalOperationError) {
				assertTrue(true);
			}
		}

	}
}