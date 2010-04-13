package org.as3commons.collections.framework.core {
	import org.as3commons.collections.SortedMap;
	import org.as3commons.collections.framework.ICollectionIterator;
	import org.as3commons.collections.framework.IIterator;
	import org.as3commons.collections.framework.ISortedMap;
	import org.as3commons.collections.framework.core.SortedMapNode;
	import org.as3commons.collections.framework.core.SortedNode;
	import org.as3commons.collections.framework.core.as3commons_collections;
	import org.as3commons.collections.mocks.SortedMapMock;
	import org.as3commons.collections.testhelpers.AbstractIteratorTest;
	import org.as3commons.collections.testhelpers.TestComparator;
	import org.as3commons.collections.testhelpers.UniqueMapKey;
	import org.as3commons.collections.units.iterators.ICollectionIteratorStartIndexTests;
	import org.as3commons.collections.units.iterators.IMapIteratorTests;

	/**
	 * @author jes 30.03.2010
	 */
	public class SortedMapIteratorTest extends AbstractIteratorTest {

		use namespace as3commons_collections;

		/*
		 * AbstractIteratorTest
		 */

		override public function createCollection() : * {
			return new SortedMapMock(new TestComparator());
		}

		override public function fillCollection(items : Array) : void {
			SortedMapMock(collection).clear();
			for each (var item : * in items) {
				SortedMapMock(collection).add(UniqueMapKey.key, item);
			}
		}

		override public function getIterator(index : uint = 0) : IIterator {
			var key : *;
			if (index) {
				var sortedMap : SortedMap = collection as SortedMap;
				var i : uint = 0;
				var node : SortedNode = sortedMap.mostLeftNode_internal();
			
				while (node) {
					if (i == index) {
						key = SortedMapNode(node).key;
						break;
					}
					node = sortedMap.nextNode_internal(node);
					i++;
				}
			}
			
			var iterator : ICollectionIterator = SortedMapMock(collection).iterator(key) as ICollectionIterator;
			if (index && key === undefined) iterator.end();
			
			return iterator;
		}

		override public function toArray() : Array {
			return ISortedMap(collection).toArray();
		}

		/*
		 * Units
		 */

		/*
		 * MapIterator tests
		 */

		public function test_mapIterator() : void {
			new IMapIteratorTests(this).runAllTests();
		}

		/*
		 * StartIndexTests tests
		 */

		public function test_collectionIteratorStartIndex() : void {
			new ICollectionIteratorStartIndexTests(this).runAllTests();
		}

	}
}
