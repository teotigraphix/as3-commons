package org.as3commons.collections.testhelpers {

	/**
	 * @author jes 19.03.2010
	 */
	public class AbstractSpecialIteratorUnitTest extends AbstractIteratorUnitTest {

		public function AbstractSpecialIteratorUnitTest(test : AbstractIteratorTest) {
			super(test);
		}
		
		protected function get _specialIteratorTest() : AbstractSpecialIteratorTest {
			return _test as AbstractSpecialIteratorTest;
		}

	}
}
