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

    /**
     * @author Christophe Herreman
     * @author James Ghandour
     */
    public class ArrayUtilsTest extends TestCase {

        public function ArrayUtilsTest(methodName:String = null) {
            super(methodName);
        }

        public function testIndexOfEquality():void {
            assertEquals(-1, ArrayUtils.indexOfEquality(null, null));
            assertEquals(-1, ArrayUtils.indexOfEquality(null, 1234));
            assertEquals(-1, ArrayUtils.indexOfEquality([], null));
            assertEquals(-1, ArrayUtils.indexOfEquality(["a"], "b"));
            assertEquals(0, ArrayUtils.indexOfEquality(["1"], "1"));
            assertEquals(0, ArrayUtils.indexOfEquality(["1"], 1));
            assertEquals(1, ArrayUtils.indexOfEquality(["a", "b"], "b"));
        }

        public function testIndexOfStrictEquality():void {
            assertEquals(-1, ArrayUtils.indexOfStrictEquality(null, null));
            assertEquals(-1, ArrayUtils.indexOfStrictEquality(null, 1234));
            assertEquals(-1, ArrayUtils.indexOfStrictEquality([], null));
            assertEquals(-1, ArrayUtils.indexOfStrictEquality(["a"], "b"));
            assertEquals(0, ArrayUtils.indexOfStrictEquality(["1"], "1"));
            assertEquals(-1, ArrayUtils.indexOfStrictEquality(["1"], 1));
            assertEquals(1, ArrayUtils.indexOfStrictEquality(["a", "b"], "b"));
        }

        public function testIndexOfEquals():void {
            assertEquals(-1, ArrayUtils.indexOfEquals(null, null));
            assertEquals(-1, ArrayUtils.indexOfEquals(null, new EqualsImplementation()));
            assertEquals(-1, ArrayUtils.indexOfEquals([], null));
            assertEquals(-1, ArrayUtils.indexOfEquals([new EqualsImplementation("a")], new EqualsImplementation("b")));
            assertEquals(0, ArrayUtils.indexOfEquals([new EqualsImplementation("a")], new EqualsImplementation("a")));
            assertEquals(1, ArrayUtils.indexOfEquals([new EqualsImplementation("a"), new EqualsImplementation("b")], new EqualsImplementation("b")));
        }

        public function testIndexOfComparable():void {
            assertEquals(-1, ArrayUtils.indexOfComparable(null, null));
            assertEquals(-1, ArrayUtils.indexOfComparable(null, 1234));
            assertEquals(-1, ArrayUtils.indexOfComparable([], null));
            assertEquals(-1, ArrayUtils.indexOfComparable(["a"], "b"));
            assertEquals(0, ArrayUtils.indexOfComparable(["1"], "1"));
            assertEquals(-1, ArrayUtils.indexOfComparable(["1"], 1));
            assertEquals(1, ArrayUtils.indexOfComparable(["a", "b"], "b"));
        }

        public function testGetLenth():void {
            assertEquals(0, ArrayUtils.getLength(null));
            assertEquals(0, ArrayUtils.getLength([]));
            assertEquals(1, ArrayUtils.getLength([{a: "b"}]));
        }

        public function testGetUniqueValues():void {
            assertTrue(ArrayUtils.isSame([], ArrayUtils.getUniqueValues(null)));
            assertTrue(ArrayUtils.isSame([], ArrayUtils.getUniqueValues([])));
            assertTrue(ArrayUtils.isSame([1, 2, 3, 4, 5], ArrayUtils.getUniqueValues([1, 2, 3, 4, 5, 2, 3, 4, 5])));
        }

        public function testContains():void {
            assertFalse(ArrayUtils.contains(null, null));
            assertFalse(ArrayUtils.contains([], null));
            var obj:Object = {a: "a"};
            assertFalse(ArrayUtils.contains([obj], {a: "b"}));
            assertTrue(ArrayUtils.contains([obj], obj));
        }

        public function testGetItemAt():void {
            assertNull(ArrayUtils.getItemAt(null, 2));
            assertNull(ArrayUtils.getItemAt([], 2));
            assertNull(ArrayUtils.getItemAt([1, 2], 3));
            assertEquals(5, ArrayUtils.getItemAt([1, 2], 3, 5));
            assertEquals(5, ArrayUtils.getItemAt([1, 2, 3, 4, 5], 4, 15));
        }

        public function testRemoveAll():void {
            ArrayUtils.removeAll(null);
            ArrayUtils.removeAll([]);
            var testArray:Array = [{a: "b"}, {b: "c"}];
            ArrayUtils.removeAll(testArray);
            assertEquals(0, testArray.length);
        }

        public function testIsNotEmpty():void {
            assertFalse(ArrayUtils.isNotEmpty(null));
            assertFalse(ArrayUtils.isNotEmpty([]));
            assertTrue(ArrayUtils.isNotEmpty([{a: "b"}]));
        }

        public function testIsEmpty():void {
            assertTrue(ArrayUtils.isEmpty(null));
            assertTrue(ArrayUtils.isEmpty([]));
            assertFalse(ArrayUtils.isEmpty([{a: "b"}]));
        }

    }
}
