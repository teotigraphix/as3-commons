package {
	import flexunit.framework.TestSuite;

	import org.as3commons.collections.ArrayListTest;
	import org.as3commons.collections.LinkedListTest;
	import org.as3commons.collections.LinkedMapKeyIteratorTest;
	import org.as3commons.collections.LinkedMapTest;
	import org.as3commons.collections.LinkedSetTest;
	import org.as3commons.collections.MapKeyIteratorTest;
	import org.as3commons.collections.MapTest;
	import org.as3commons.collections.SetTest;
	import org.as3commons.collections.SortedListTest;
	import org.as3commons.collections.SortedMapKeyIteratorTest;
	import org.as3commons.collections.SortedMapTest;
	import org.as3commons.collections.SortedSetTest;
	import org.as3commons.collections.TreapTest;
	import org.as3commons.collections.framework.core.ArrayListIteratorTest;
	import org.as3commons.collections.framework.core.LinkedListIteratorTest;
	import org.as3commons.collections.framework.core.LinkedMapIteratorTest;
	import org.as3commons.collections.framework.core.LinkedSetIteratorTest;
	import org.as3commons.collections.framework.core.MapIteratorTest;
	import org.as3commons.collections.framework.core.SetIteratorTest;
	import org.as3commons.collections.framework.core.SortedListIteratorTest;
	import org.as3commons.collections.framework.core.SortedMapIteratorTest;
	import org.as3commons.collections.framework.core.SortedSetIteratorTest;
	import org.as3commons.collections.framework.core.TreapIteratorTest;
	import org.as3commons.collections.fx.ArrayListFxTest;
	import org.as3commons.collections.fx.LinkedMapFxTest;
	import org.as3commons.collections.fx.LinkedSetFxTest;
	import org.as3commons.collections.fx.MapFxTest;
	import org.as3commons.collections.fx.SetFxTest;
	import org.as3commons.collections.fx.SortedListFxTest;
	import org.as3commons.collections.fx.SortedMapFxTest;
	import org.as3commons.collections.fx.SortedSetFxTest;
	import org.as3commons.collections.iterators.ArrayIteratorTest;
	import org.as3commons.collections.iterators.CollectionFilterIteratorTest;
	import org.as3commons.collections.iterators.FilterIteratorTest;
	import org.as3commons.collections.iterators.RecursiveFilterIteratorTest;
	import org.as3commons.collections.iterators.RecursiveIteratorTest;
	import org.as3commons.collections.utils.StringComparatorTest;

	/**
	 * @author jes 19.02.2010
	 */
	public class AllTests extends TestSuite {

		public function AllTests() {

			// lists

			addTestSuite(ArrayListTest);
			addTestSuite(ArrayListFxTest);
			addTestSuite(ArrayListIteratorTest);
			
			addTestSuite(SortedListTest);
			addTestSuite(SortedListFxTest);
			addTestSuite(SortedListIteratorTest);

			// sets

			addTestSuite(SetTest);
			addTestSuite(SetFxTest);
			addTestSuite(SetIteratorTest);

			addTestSuite(LinkedSetTest);
			addTestSuite(LinkedSetFxTest);
			addTestSuite(LinkedSetIteratorTest);
			
			addTestSuite(SortedSetTest);
			addTestSuite(SortedSetFxTest);
			addTestSuite(SortedSetIteratorTest);

			// maps

			addTestSuite(MapTest);
			addTestSuite(MapFxTest);
			addTestSuite(MapIteratorTest);
			addTestSuite(MapKeyIteratorTest);
			
			addTestSuite(LinkedMapTest);
			addTestSuite(LinkedMapFxTest);
			addTestSuite(LinkedMapIteratorTest);
			addTestSuite(LinkedMapKeyIteratorTest);

			addTestSuite(SortedMapTest);
			addTestSuite(SortedMapFxTest);
			addTestSuite(SortedMapIteratorTest);
			addTestSuite(SortedMapKeyIteratorTest);
			
			// sequential collections

			addTestSuite(LinkedListTest);
			addTestSuite(LinkedListIteratorTest);
			
			addTestSuite(TreapTest);
			addTestSuite(TreapIteratorTest);

			// iterators

			addTestSuite(ArrayIteratorTest);
			addTestSuite(FilterIteratorTest);
			addTestSuite(CollectionFilterIteratorTest);
			addTestSuite(RecursiveIteratorTest);
			addTestSuite(RecursiveFilterIteratorTest);

			// utils

			addTestSuite(StringComparatorTest);

		}
		
	}
}
