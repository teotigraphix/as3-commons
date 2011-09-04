package org.as3commons.lang {
	import org.as3commons.lang.testclasses.AbstractClass;
	import org.as3commons.lang.testclasses.PublicClass;
	import org.flexunit.asserts.assertTrue;
	import org.flexunit.asserts.fail;

	public class AssertTest {

		public function AssertTest() {
		}

		[Test]
		public function testNotAbstract_Fail():void {
			try {
				Assert.notAbstract(new AbstractClass(), AbstractClass);
			} catch(e:Error) {
				assertTrue(e is IllegalArgumentError);
			}
		}

		[Test]
		public function testNotAbstract_Pass():void {
			try {
				Assert.notAbstract(new PublicClass(), AbstractClass);
			} catch(e:IllegalArgumentError) {
				fail(e.message);
			}
		}
	}
}