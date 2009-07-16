package org.as3commons.lang {
	
	import flexunit.framework.TestCase;
	
	import org.as3commons.lang.testclasses.EqualsImplementation;
	
	/**
	 * @author Christophe Herreman
	 */
	public class ArrayUtilsTest extends TestCase {
		
		public function ArrayUtilsTest(methodName:String = null) {
			super(methodName);
		}
		
		public function testIndexOfEquals():void {
			assertEquals(-1, ArrayUtils.indexOfEquals(null, null));
			assertEquals(-1, ArrayUtils.indexOfEquals(null, new EqualsImplementation()));
			assertEquals(-1, ArrayUtils.indexOfEquals([], null));
			assertEquals(-1, ArrayUtils.indexOfEquals([new EqualsImplementation("a")], new EqualsImplementation("b")));
			assertEquals(0, ArrayUtils.indexOfEquals([new EqualsImplementation("a")], new EqualsImplementation("a")));
			assertEquals(1, ArrayUtils.indexOfEquals([new EqualsImplementation("a"), new EqualsImplementation("b")], new EqualsImplementation("b")));
		}
	}
}