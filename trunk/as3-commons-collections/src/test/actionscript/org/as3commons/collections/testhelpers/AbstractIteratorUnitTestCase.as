package org.as3commons.collections.testhelpers {
	import flexunit.framework.TestCase;

	import flash.utils.describeType;

	/**
	 * @author jes 18.03.2010
	 */
	public class AbstractIteratorUnitTestCase extends TestCase {
		protected var _test : AbstractIteratorTestCase;
		
		public function AbstractIteratorUnitTestCase(test : AbstractIteratorTestCase) {
			_test = test;
		}
		
		public function runAllTests() : void {
//			var unitTest : String = "[" + getQualifiedClassName(this).replace(/^.*::/, "") + "]";
//			var collectionTest : String = "[" + getQualifiedClassName(_test).replace(/^.*::/, "") + "]";
			var description:XML = describeType(this);
			
			var list : XMLList = description..method.@name;
			for each (var method : String in list) {
				if (method.toString().indexOf("test") == 0) {

					_test.setUp();

					this[method.toString()]();
//					trace (collectionTest + "::" + unitTest + "::" + method + "()");
//					trace (collectionTest + "::" + method + "()");

					_test.tearDown();

				}
			}
		}

	}
}
