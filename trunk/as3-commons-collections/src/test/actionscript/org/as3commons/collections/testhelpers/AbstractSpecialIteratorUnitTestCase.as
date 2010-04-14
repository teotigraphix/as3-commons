package org.as3commons.collections.testhelpers {

	/**
	 * @author jes 19.03.2010
	 */
	public class AbstractSpecialIteratorUnitTestCase extends AbstractIteratorUnitTestCase {

		public function AbstractSpecialIteratorUnitTestCase(test : AbstractIteratorTestCase) {
			super(test);
		}
		
		protected function get _specialIteratorTest() : AbstractSpecialIteratorTestCase {
			return _test as AbstractSpecialIteratorTestCase;
		}

	}
}
