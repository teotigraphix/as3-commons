package org.as3commons.collections.testhelpers {
	import org.as3commons.collections.ArrayList;
	import org.as3commons.collections.framework.IIterator;
	import org.as3commons.collections.framework.IOrderedList;
	import org.as3commons.collections.framework.IRecursiveIterator;

	/**
	 * @author jes 19.03.2010
	 */
	public class AbstractSpecialIteratorTestCase extends AbstractIteratorTestCase {

		/*
		 * Test neutralisation
		 */
		
		override public function setUp() : void {
			TestItems.init();
			collection = new ArrayList();
		}

		override public function tearDown() : void {
			TestItems.cleanUp();
		}

		/*
		 * Test public interface
		 */

		override public function fillCollection(items : Array) : void {
			IOrderedList(collection).array = items;
		}

		public function add(item : *) : void {
			IOrderedList(collection).add(item);
		}

		override public function toArray() : Array {
			return IOrderedList(collection).toArray();
		}

		public function getFilterIterator() : IIterator {
			return null;
		}

		public function getRecursiveIterator() : IRecursiveIterator {
			return null;
		}

		public function filter(item : *) : Boolean {
			return item["index"] % 2 == 0; 
		}

	}

}
