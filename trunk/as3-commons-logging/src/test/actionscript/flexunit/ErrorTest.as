package flexunit {
	import flexunit.framework.TestCase;

	/**
	 * @author mh
	 */
	public class ErrorTest extends TestCase {
		public function testException():void {
			throw new Error("HI!");
		}
		public function testFailure():void {
			assertEquals(1, 2);
		}
	}
}
