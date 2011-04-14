package org.as3commons.collections.utils {
	import org.as3commons.collections.LinkedMap;
	import flash.utils.getQualifiedClassName;
	import flexunit.framework.TestCase;

	import org.as3commons.collections.Map;
	import org.as3commons.collections.framework.IMap;
	public class MapsTest extends TestCase {
		private var map : IMap;
		
		override public function setUp() : void {
			map = new Map();
		}
		
		public function test_itemOrError_notMapped() : void {
			const expectedErrorMessage : String = "expected error message";
			var thrownError : ArgumentError;
			
			try {
				Maps.itemOrError(map, "non-existant-key", expectedErrorMessage);
			}
			catch (e : Error) {
				thrownError = e as ArgumentError;
			}
			
			assertNotNull("ArgumentError was thrown", thrownError);
			assertEquals("ArgumentError used the supplied error message", expectedErrorMessage, thrownError.message);
		}
		
		public function test_itemOrError_mapped() : void {
			const expectedItem : * = "an item";
			const key : * = "a key";
			var thrownError : Error;
			
			map.add(key, expectedItem);
			
			try {
				const result : * = Maps.itemOrError(map, key);
			}
			catch (e : Error) {
				thrownError = e;
			}
			
			assertNull("No error was thrown", thrownError);
			assertEquals("Expected item was retrieved from the map", expectedItem, result);
		}
		
		public function test_itemOrValue_notMapped() : void {
			const expectedDefaultValue : * = "a default value";
			
			const result : * = Maps.itemOrValue(map, "non-existant-key", expectedDefaultValue);
			
			assertEquals("Expected default value is returned when no mapping exists", expectedDefaultValue, result);
		}
		
		public function test_itemOrValue_mapped() : void {
			const mappedItem : * = "a mapped item";
			const key : * = "a key";
			
			map.add(key, mappedItem);
			const result : * = Maps.itemOrValue(map, key, "a default value which will not be used");
			
			assertEquals("Mapped item is returned when a prior mapping exists", mappedItem, result);
		}
		
		public function test_itemOrAdd_notMapped() : void {
			const item : * = "a new item";
			const key : * = "a key";
			
			const result : * = Maps.itemOrAdd(map, key, item);
			
			assertEquals("Supplied item is now mapped to the key", item, map.itemFor(key));
			assertEquals("Mapped item is returned by the call when no mapping exists", item, result);
		}
		
		public function test_itemOrAdd_priorMapping() : void {
			const newItem : * = "a new item";
			const previouslyMappedItem : * = "a previously mapped item";
			const key : * = "a key";
			
			map.add(key, previouslyMappedItem);
			const result : * = Maps.itemOrAdd(map, key, newItem);
			
			assertEquals("Previously mapped item is not replaced", previouslyMappedItem, map.itemFor(key));
			assertEquals("Previously mapped item is returned by the call when a prior mapping exists", previouslyMappedItem, result);
		}
		
		public function test_filterKeys() : void {
			map.add(1, "One");
			map.add(2, "Two");
			map.add(3, "Three");
			map.add(4, "Four");
			map.add(5, "Five");
			map.add(6, "Six");
			
			const keyIsEvenNumberPredicate : Function = function(key : int) : Boolean {
				return (key % 2 == 0);
			};
			const result : IMap = Maps.filterKeys(map, keyIsEvenNumberPredicate);
			
			assertEquals("Resulting map contains 3 entries", 3, result.size);
			assertEquals("Resulting map is of the supplied type", getQualifiedClassName(map), getQualifiedClassName(result));
			assertEquals("Expected entry retained in map", "Two", result.itemFor(2));
			assertEquals("Expected entry retained in map", "Four", result.itemFor(4));
			assertEquals("Expected entry retained in map", "Six", result.itemFor(6));
		}
		
		public function test_filterKeys_emptyResult() : void {
			const sourceMap : IMap = new LinkedMap();
			sourceMap.add(1, "One");
			sourceMap.add(2, "Two");
			
			const keyIsStringPredicate : Function = function(key : *) : Boolean {
				return key is String;
			};
			const result :IMap = Maps.filterKeys(sourceMap, keyIsStringPredicate);
			
			assertEquals("Resulting map is empty", 0, map.size);
			assertEquals("Resulting map is of the supplied type", getQualifiedClassName(sourceMap), getQualifiedClassName(result));
		}
	}
}
