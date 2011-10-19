/*
 * Copyright 2009-2010 the original author or authors.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package org.as3commons.lang {

    import flexunit.framework.TestCase;

    import org.as3commons.lang.testclasses.EqualsImplementation;
    import org.flexunit.asserts.assertEquals;
    import org.flexunit.asserts.assertFalse;
    import org.flexunit.asserts.assertNull;
    import org.flexunit.asserts.assertTrue;

    /**
     * @author Christophe Herreman
     * @author James Ghandour
     */
    public class ArrayUtilsTest {

        public function ArrayUtilsTest() {
        }

        [Test]
        public function testContainsAnyEquality():void {
            assertFalse(ArrayUtils.containsAnyEquality(null, null));
            assertFalse(ArrayUtils.containsAnyEquality([], null));
            assertFalse(ArrayUtils.containsAnyEquality(null, []));

            var obj1:Object = "a";
            var obj2:Object = "2";
            var obj3:Object = "c";
            var notExistObject:Object = "no";
            var fullArray:Array = [obj2, obj1, obj3];
            assertTrue(ArrayUtils.containsAnyEquality(fullArray, [obj1]));
            assertTrue(ArrayUtils.containsAnyEquality(fullArray, [obj2]));
            assertTrue(ArrayUtils.containsAnyEquality(fullArray, [obj3]));
            assertTrue(ArrayUtils.containsAnyEquality(fullArray, [obj1, obj2]));
            assertTrue(ArrayUtils.containsAnyEquality(fullArray, [obj2, obj3]));
            assertTrue(ArrayUtils.containsAnyEquality(fullArray, [obj1, obj3]));
            assertTrue(ArrayUtils.containsAnyEquality(fullArray, [obj1, obj2, obj3]));
            assertTrue(ArrayUtils.containsAnyEquality(fullArray, [notExistObject, obj1, obj2, obj3]));
            assertTrue(ArrayUtils.containsAnyEquality(fullArray, [2]));
            assertFalse(ArrayUtils.containsAnyEquality(fullArray, [notExistObject]));
        }

        [Test]
        public function testContainsAnyStrictEquality():void {
            assertFalse(ArrayUtils.containsAnyStrictEquality(null, null));
            assertFalse(ArrayUtils.containsAnyStrictEquality([], null));
            assertFalse(ArrayUtils.containsAnyStrictEquality(null, []));

            var obj1:Object = "a";
            var obj2:Object = "2";
            var obj3:Object = "c";
            var notExistObject:Object = "no";
            var fullArray:Array = [obj2, obj1, obj3];
            assertTrue(ArrayUtils.containsAnyStrictEquality(fullArray, [obj1]));
            assertTrue(ArrayUtils.containsAnyStrictEquality(fullArray, [obj2]));
            assertTrue(ArrayUtils.containsAnyStrictEquality(fullArray, [obj3]));
            assertTrue(ArrayUtils.containsAnyStrictEquality(fullArray, [obj1, obj2]));
            assertTrue(ArrayUtils.containsAnyStrictEquality(fullArray, [obj2, obj3]));
            assertTrue(ArrayUtils.containsAnyStrictEquality(fullArray, [obj1, obj3]));
            assertTrue(ArrayUtils.containsAnyStrictEquality(fullArray, [obj1, obj2, obj3]));
            assertTrue(ArrayUtils.containsAnyStrictEquality(fullArray, [notExistObject, obj1, obj2, obj3]));
            assertFalse(ArrayUtils.containsAnyStrictEquality(fullArray, [2]));
            assertFalse(ArrayUtils.containsAnyStrictEquality(fullArray, [notExistObject]));
        }

        [Test]
        public function testContainsAnyEquals():void {
            assertFalse(ArrayUtils.containsAnyEquals(null, null));
            assertFalse(ArrayUtils.containsAnyEquals([], null));
            assertFalse(ArrayUtils.containsAnyEquals(null, []));

            var obj1:IEquals = new EqualsImplementation("1");
            var obj2:IEquals = new EqualsImplementation("2");
            var obj3:IEquals = new EqualsImplementation("3");
            var notExistObject:IEquals = new EqualsImplementation("no");
            var fullArray:Array = [obj2, obj1, obj3];
            assertTrue(ArrayUtils.containsAnyEquals(fullArray, [obj1]));
            assertTrue(ArrayUtils.containsAnyEquals(fullArray, [obj2]));
            assertTrue(ArrayUtils.containsAnyEquals(fullArray, [obj3]));
            assertTrue(ArrayUtils.containsAnyEquals(fullArray, [obj1, obj2]));
            assertTrue(ArrayUtils.containsAnyEquals(fullArray, [obj2, obj3]));
            assertTrue(ArrayUtils.containsAnyEquals(fullArray, [obj1, obj3]));
            assertTrue(ArrayUtils.containsAnyEquals(fullArray, [obj1, obj2, obj3]));
            assertTrue(ArrayUtils.containsAnyEquals(fullArray, [notExistObject, obj1, obj2, obj3]));
            assertFalse(ArrayUtils.containsAnyEquals(fullArray, [notExistObject]));
        }

        [Test]
        public function testContainsAllEquality():void {
            assertFalse(ArrayUtils.containsAllEquality(null, null));
            assertFalse(ArrayUtils.containsAllEquality([], null));
            assertFalse(ArrayUtils.containsAllEquality(null, []));

            var obj1:Object = "a";
            var obj2:Object = "2";
            var obj3:Object = "c";

            var fullArray:Array = [obj2, obj1, obj3];
            assertTrue(ArrayUtils.containsAllEquality(fullArray, [obj1]));
            assertTrue(ArrayUtils.containsAllEquality(fullArray, [obj2]));
            assertTrue(ArrayUtils.containsAllEquality(fullArray, [obj3]));
            assertTrue(ArrayUtils.containsAllEquality(fullArray, [obj1, obj2]));
            assertTrue(ArrayUtils.containsAllEquality(fullArray, [obj1, obj2, obj3]));
            assertTrue(ArrayUtils.containsAllEquality(fullArray, [obj3, obj2]));
            assertTrue(ArrayUtils.containsAllEquality(fullArray, [ObjectUtils.clone(obj2)]));

            var subsetArray:Array = [obj2, obj3];
            assertFalse(ArrayUtils.containsAllEquality(subsetArray, [obj1]));
            assertTrue(ArrayUtils.containsAllEquality(subsetArray, [obj2]));
            assertTrue(ArrayUtils.containsAllEquality(subsetArray, [obj3]));
            assertFalse(ArrayUtils.containsAllEquality(subsetArray, [obj1, obj2]));
            assertFalse(ArrayUtils.containsAllEquality(subsetArray, [obj1, obj2, obj3]));
            assertTrue(ArrayUtils.containsAllEquality(subsetArray, [obj3, obj2]));
            assertTrue(ArrayUtils.containsAllEquality(subsetArray, ["2"]));
            assertTrue(ArrayUtils.containsAllEquality(subsetArray, [2]));
        }

        [Test]
        public function testContainsAllStrictEquality():void {
            assertFalse(ArrayUtils.containsAllStrictEquality(null, null));
            assertFalse(ArrayUtils.containsAllStrictEquality([], null));
            assertFalse(ArrayUtils.containsAllStrictEquality(null, []));

            var obj1:Object = "1";
            var obj2:Object = "2";
            var obj3:Object = "3";

            var fullArray:Array = [obj2, obj1, obj3];
            assertTrue(ArrayUtils.containsAllStrictEquality(fullArray, [obj1]));
            assertTrue(ArrayUtils.containsAllStrictEquality(fullArray, [obj2]));
            assertTrue(ArrayUtils.containsAllStrictEquality(fullArray, [obj3]));
            assertTrue(ArrayUtils.containsAllStrictEquality(fullArray, [obj1, obj2]));
            assertTrue(ArrayUtils.containsAllStrictEquality(fullArray, [obj1, obj2, obj3]));
            assertTrue(ArrayUtils.containsAllStrictEquality(fullArray, [obj3, obj2]));
            assertTrue(ArrayUtils.containsAllStrictEquality(fullArray, [ObjectUtils.clone(obj2)]));

            var subsetArray:Array = [obj2, obj3];
            assertFalse(ArrayUtils.containsAllStrictEquality(subsetArray, [obj1]));
            assertTrue(ArrayUtils.containsAllStrictEquality(subsetArray, [obj2]));
            assertTrue(ArrayUtils.containsAllStrictEquality(subsetArray, [obj3]));
            assertFalse(ArrayUtils.containsAllStrictEquality(subsetArray, [obj1, obj2]));
            assertFalse(ArrayUtils.containsAllStrictEquality(subsetArray, [obj1, obj2, obj3]));
            assertTrue(ArrayUtils.containsAllStrictEquality(subsetArray, [obj3, obj2]));
            assertTrue(ArrayUtils.containsAllStrictEquality(subsetArray, ["2"]));
            assertFalse(ArrayUtils.containsAllStrictEquality(subsetArray, [2]));
        }

        [Test]
        public function testContainsAllEquals():void {
            assertFalse(ArrayUtils.containsAllEquals(null, null));
            assertFalse(ArrayUtils.containsAllEquals([], null));
            assertFalse(ArrayUtils.containsAllEquals(null, []));

            var obj1:IEquals = new EqualsImplementation("1");
            var obj2:IEquals = new EqualsImplementation("2");
            var obj3:IEquals = new EqualsImplementation("3");

            var fullArray:Array = [obj2, obj1, obj3];
            assertTrue(ArrayUtils.containsAllEquals(fullArray, [obj1]));
            assertTrue(ArrayUtils.containsAllEquals(fullArray, [obj2]));
            assertTrue(ArrayUtils.containsAllEquals(fullArray, [obj3]));
            assertTrue(ArrayUtils.containsAllEquals(fullArray, [obj1, obj2]));
            assertTrue(ArrayUtils.containsAllEquals(fullArray, [obj1, obj2, obj3]));
            assertTrue(ArrayUtils.containsAllEquals(fullArray, [obj3, obj2]));
            assertTrue(ArrayUtils.containsAllEquals(fullArray, [new EqualsImplementation("2")]));

            var subsetArray:Array = [obj2, obj3];
            assertFalse(ArrayUtils.containsAllEquals(subsetArray, [obj1]));
            assertTrue(ArrayUtils.containsAllEquals(subsetArray, [obj2]));
            assertTrue(ArrayUtils.containsAllEquals(subsetArray, [obj3]));
            assertFalse(ArrayUtils.containsAllEquals(subsetArray, [obj1, obj2]));
            assertFalse(ArrayUtils.containsAllEquals(subsetArray, [obj1, obj2, obj3]));
            assertTrue(ArrayUtils.containsAllEquals(subsetArray, [obj3, obj2]));
            assertTrue(ArrayUtils.containsAllEquals(subsetArray, [new EqualsImplementation("2")]));
            assertFalse(ArrayUtils.containsAllEquals(subsetArray, [new EqualsImplementation("2 ")]));
        }

        [Test]
        public function testContainsEquality():void {
            assertFalse(ArrayUtils.containsEquality(null, null));
            assertFalse(ArrayUtils.containsEquality([], null));
            var obj:Object = {a: "a"};
            assertFalse(ArrayUtils.containsEquality([obj], {a: "b"}));
            assertFalse(ArrayUtils.containsEquality([obj], {a: "a"}));
            assertTrue(ArrayUtils.containsEquality([obj], obj));
        }

        [Test]
        public function testIndexOfEquality():void {
            assertEquals(-1, ArrayUtils.indexOfEquality(null, null));
            assertEquals(-1, ArrayUtils.indexOfEquality(null, 1234));
            assertEquals(-1, ArrayUtils.indexOfEquality([], null));
            assertEquals(-1, ArrayUtils.indexOfEquality(["a"], "b"));
            assertEquals(0, ArrayUtils.indexOfEquality(["1"], "1"));
            assertEquals(0, ArrayUtils.indexOfEquality(["1"], 1));
            assertEquals(1, ArrayUtils.indexOfEquality(["a", "b"], "b"));
        }

        [Test]
        public function testIndexOfStrictEquality():void {
            assertEquals(-1, ArrayUtils.indexOfStrictEquality(null, null));
            assertEquals(-1, ArrayUtils.indexOfStrictEquality(null, 1234));
            assertEquals(-1, ArrayUtils.indexOfStrictEquality([], null));
            assertEquals(-1, ArrayUtils.indexOfStrictEquality(["a"], "b"));
            assertEquals(0, ArrayUtils.indexOfStrictEquality(["1"], "1"));
            assertEquals(-1, ArrayUtils.indexOfStrictEquality(["1"], 1));
            assertEquals(1, ArrayUtils.indexOfStrictEquality(["a", "b"], "b"));
        }

        [Test]
        public function testIndexOfEquals():void {
            assertEquals(-1, ArrayUtils.indexOfEquals(null, null));
            assertEquals(-1, ArrayUtils.indexOfEquals(null, new EqualsImplementation()));
            assertEquals(-1, ArrayUtils.indexOfEquals([], null));
            assertEquals(-1, ArrayUtils.indexOfEquals([new EqualsImplementation("a")], new EqualsImplementation("b")));
            assertEquals(0, ArrayUtils.indexOfEquals([new EqualsImplementation("a")], new EqualsImplementation("a")));
            assertEquals(1, ArrayUtils.indexOfEquals([new EqualsImplementation("a"), new EqualsImplementation("b")], new EqualsImplementation("b")));
        }

        [Test]
        public function testRemoveAllItemsStrictEquality():void {
            var obj1:Object = "1";
            var obj2:Object = "2";
            var obj3:Object = "3";
            var fullArray:Array = [obj1, obj2, obj2, obj3, obj1, obj3];
            var testArray:Array = [];

            testArray = ArrayUtils.clone(fullArray);
            ArrayUtils.removeAllItemsStrictEquality(testArray, null);
            assertEquals(fullArray.length, testArray.length);
            ArrayUtils.removeAllItemsStrictEquality(testArray, []);
            assertEquals(fullArray.length, testArray.length);
            ArrayUtils.removeAllItemsStrictEquality(testArray, [null]);
            assertEquals(fullArray.length, testArray.length);
            ArrayUtils.removeAllItemsStrictEquality(testArray, [{a: "ccc"}]);
            assertEquals(fullArray.length, testArray.length);

            testArray = ArrayUtils.clone(fullArray);
            ArrayUtils.removeAllItemsStrictEquality(testArray, [{a: "ccc"}, obj1, null]);
            assertEquals(4, testArray.length);

            testArray = ArrayUtils.clone(fullArray);
            ArrayUtils.removeAllItemsStrictEquality(testArray, [{b: "ga"}, obj2, null]);
            assertEquals(4, testArray.length);

            testArray = ArrayUtils.clone(fullArray);
            ArrayUtils.removeAllItemsStrictEquality(testArray, [obj1, obj2, obj3]);
            assertEquals(0, testArray.length);
        }

        [Test]
        public function testRemoveItemEquality():void {
            var obj1:Object = "1";
            var obj2:Object = "2";
            var obj3:Object = "3";
            var fullArray:Array = [obj1, obj2, obj2, obj3, obj1, obj3];
            var testArray:Array = [];

            ArrayUtils.removeItemEquality(null, fullArray);
            ArrayUtils.removeItemEquality(fullArray, null);
            ArrayUtils.removeItemEquality(fullArray, []);
            ArrayUtils.removeItemEquality(fullArray, "#$@");
            assertEquals(6, fullArray.length);

            testArray = ArrayUtils.clone(fullArray);
            ArrayUtils.removeItemEquality(testArray, 1);
            assertEquals(4, testArray.length);
        }

        [Test]
        public function testRemoveItemStrictEquality():void {
            var obj1:Object = "1";
            var obj2:Object = "2";
            var obj3:Object = "3";
            var fullArray:Array = [obj1, obj2, obj2, obj3, obj1, obj3];
            var testArray:Array = [];

            ArrayUtils.removeItemStrictEquality(null, fullArray);
            ArrayUtils.removeItemStrictEquality(fullArray, null);
            ArrayUtils.removeItemStrictEquality(fullArray, []);
            ArrayUtils.removeItemStrictEquality(fullArray, "#$@");
            assertEquals(6, fullArray.length);

            testArray = ArrayUtils.clone(fullArray);
            ArrayUtils.removeItemStrictEquality(testArray, obj2);
            assertEquals(4, testArray.length);

            testArray = ArrayUtils.clone(fullArray);
            ArrayUtils.removeItemStrictEquality(testArray, 1);
            assertEquals(6, testArray.length);
        }

        [Test]
        public function testRemoveItemEquals():void {
            var obj1:IEquals = new EqualsImplementation("1");
            var obj2:IEquals = new EqualsImplementation("2");
            var obj3:IEquals = new EqualsImplementation("3");
            var fullArray:Array = [obj1, obj2, obj2, obj3, obj1, obj3];
            var testArray:Array = [];

            ArrayUtils.removeItemStrictEquality(null, fullArray);
            ArrayUtils.removeItemStrictEquality(fullArray, null);
            ArrayUtils.removeItemStrictEquality(fullArray, []);
            ArrayUtils.removeItemStrictEquality(fullArray, "#$@");
            assertEquals(6, fullArray.length);

            testArray = ArrayUtils.clone(fullArray);
            ArrayUtils.removeItemStrictEquality(testArray, obj2);
            assertEquals(4, testArray.length);

            testArray = ArrayUtils.clone(fullArray);
            ArrayUtils.removeItemStrictEquality(testArray, 1);
            assertEquals(6, testArray.length);
        }

        [Test]
        public function testGetLength():void {
            assertEquals(0, ArrayUtils.getLength(null));
            assertEquals(0, ArrayUtils.getLength([]));
            assertEquals(1, ArrayUtils.getLength([{a: "b"}]));
        }

        [Test]
        public function testGetUniqueValues():void {
            assertTrue(ArrayUtils.isSame([], ArrayUtils.getUniqueValues(null)));
            assertTrue(ArrayUtils.isSame([], ArrayUtils.getUniqueValues([])));
            assertTrue(ArrayUtils.isSame([1, 2, 3, 4, 5], ArrayUtils.getUniqueValues([1, 2, 3, 4, 5, 2, 3, 4, 5])));
        }

        [Test]
        public function testGetItemAt():void {
            assertNull(ArrayUtils.getItemAt(null, 2));
            assertNull(ArrayUtils.getItemAt([], 2));
            assertNull(ArrayUtils.getItemAt([1, 2], 3));
            assertEquals(5, ArrayUtils.getItemAt([1, 2], 3, 5));
            assertEquals(5, ArrayUtils.getItemAt([1, 2, 3, 4, 5], 4, 15));
        }

        [Test]
        public function testRemoveAll():void {
            ArrayUtils.removeAll(null);
            ArrayUtils.removeAll([]);
            var testArray:Array = [{a: "b"}, {b: "c"}];
            ArrayUtils.removeAll(testArray);
            assertEquals(0, testArray.length);
        }

        [Test]
        public function testAddAll():void {
            var original:Array = ["a", "b", "c"];
            var toAdd:Array = ["d", null, "e"];

            ArrayUtils.addAll(null, toAdd);
            ArrayUtils.addAll(original, []);
            ArrayUtils.addAll(original, null);
            assertEquals(3, original.length); // No changes

            ArrayUtils.addAll(original, [null]);
            assertEquals(4, original.length);
            ArrayUtils.addAll(original, toAdd);
            assertEquals(7, original.length);
        }

        [Test]
        public function testAddAllIgnoreNull():void {
            var original:Array = ["a", "b", "c"];
            var toAdd:Array = ["d", null, "e"];

            ArrayUtils.addAllIgnoreNull(null, toAdd);
            ArrayUtils.addAllIgnoreNull(original, null);
            ArrayUtils.addAllIgnoreNull(original, []);

            ArrayUtils.addAllIgnoreNull(original, toAdd);
            assertEquals(5, original.length);
            assertTrue(original.indexOf(null) < 0);
        }

        [Test]
        public function testAddIgnoreNull():void {
            var original:Array = ["a", "b", "c"];

            ArrayUtils.addIgnoreNull(null, null);
            ArrayUtils.addIgnoreNull(null, "ds");

            ArrayUtils.addIgnoreNull(original, null);
            ArrayUtils.addIgnoreNull(original, "d");
            assertEquals(4, original.length);
            assertTrue(original.indexOf(null) < 0);
        }

        [Test]
        public function testMoveElement():void {
            var original:Array = ["a", "b", "c"];

            ArrayUtils.moveElement(original, "a", 2);
            assertEquals("b", original[0]);
            assertEquals("c", original[1]);
            assertEquals("a", original[2]);
        }

        [Test]
        public function testIsNotEmpty():void {
            assertFalse(ArrayUtils.isNotEmpty(null));
            assertFalse(ArrayUtils.isNotEmpty([]));
            assertTrue(ArrayUtils.isNotEmpty([{a: "b"}]));
        }

        [Test]
        public function testIsEmpty():void {
            assertTrue(ArrayUtils.isEmpty(null));
            assertTrue(ArrayUtils.isEmpty([]));
            assertFalse(ArrayUtils.isEmpty([{a: "b"}]));
        }

    }
}
