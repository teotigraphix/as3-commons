package org.as3commons.bytecode.emit.util {

	import flexunit.framework.TestCase;

	import org.as3commons.bytecode.abc.enum.ConstantKind;

	public class BuildUtilTest extends TestCase {

		public function BuildUtilTest() {
			super();
		}

		public function toConstantKindIntTest():void {
			var c:ConstantKind = BuildUtil.toConstantKind(-1);
			assertStrictlyEquals(ConstantKind.INT, c);
		}

		public function toConstantKindUIntTest():void {
			var c:ConstantKind = BuildUtil.toConstantKind(uint(1));
			assertStrictlyEquals(ConstantKind.UINT, c);
		}

		public function toConstantKindNumberTest():void {
			var c:ConstantKind = BuildUtil.toConstantKind(Number(1.3));
			assertStrictlyEquals(ConstantKind.DOUBLE, c);
		}

		public function toConstantKindStringTest():void {
			var c:ConstantKind = BuildUtil.toConstantKind("Test");
			assertStrictlyEquals(ConstantKind.UTF8, c);
		}

		public function toConstantKindFalseTest():void {
			var c:ConstantKind = BuildUtil.toConstantKind(false);
			assertStrictlyEquals(ConstantKind.FALSE, c);
		}

		public function toConstantKindTrueTest():void {
			var c:ConstantKind = BuildUtil.toConstantKind(true);
			assertStrictlyEquals(ConstantKind.TRUE, c);
		}

		public function toConstantKindNullTest():void {
			var c:ConstantKind = BuildUtil.toConstantKind(null);
			assertStrictlyEquals(ConstantKind.NULL, c);
		}

	}
}