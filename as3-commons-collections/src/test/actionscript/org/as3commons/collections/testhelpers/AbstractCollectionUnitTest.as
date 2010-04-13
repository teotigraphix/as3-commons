package org.as3commons.collections.testhelpers {
	import flexunit.framework.TestCase;

	import flash.utils.describeType;

	/**
	 * @author jes 24.02.2010
	 */
	public class AbstractCollectionUnitTest extends TestCase {
		
		protected var _test : AbstractCollectionTest;
		
		public function AbstractCollectionUnitTest(test : AbstractCollectionTest) {
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
					setUp();

					this[method.toString()]();
//					trace (collectionTest + "::" + unitTest + "::" + method + "()");
//					trace (collectionTest + "::" + method + "()");

					tearDown();
					_test.tearDown();

				}
			}
		}
		
	}
}
