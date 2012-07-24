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

	import flash.utils.Dictionary;

	import flexunit.framework.Assert;
	import flexunit.framework.TestCase;

	import org.as3commons.lang.testclasses.PublicClass;
	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.assertFalse;
	import org.flexunit.asserts.assertNotNull;
	import org.flexunit.asserts.assertTrue;

	/**
	 * @author Christophe Herreman
	 * @author James Ghandour
	 */
	public class ObjectUtilsTest {

		public function ObjectUtilsTest() {
		}

		[Test]
		public function testIsExplicitInstanceOf():void {
			assertTrue(ObjectUtils.isExplicitInstanceOf(this, ObjectUtilsTest));
			assertFalse(ObjectUtils.isExplicitInstanceOf(this, TestCase));
		}

		[Test]
		public function testIsExplicitInstanceOf_withString():void {
			assertTrue(ObjectUtils.isExplicitInstanceOf("test", String));
		}

		[Test]
		public function testGetIterator():void {
			var iterator:IIterator = ObjectUtils.getIterator(new PublicClass());
			assertNotNull(iterator);
			assertNotNull(iterator.next());
		}

		[Test]
		public function testToDictionary():void {
			var obj:Object = {a:"a1", b:"b2"};
			var dict:Dictionary = ObjectUtils.toDictionary(obj);
			assertEquals(dict["a"], "a1");
			assertEquals(dict["b"], "b2");
		}

		[Test]
		public function testMerging():void {
			var objA:Object = {a:"1"};
			var objB:Object = {b:"2"};
			flexunit.framework.Assert.assertObjectEquals("Merging has to result in a object with both properties", {a: "1",b: "2"}, ObjectUtils.merge(objA, objB));
			flexunit.framework.Assert.assertObjectEquals("Merging may not modify A", {a: "1"}, objA);
			flexunit.framework.Assert.assertObjectEquals("Merging may not modify B", {b: "2"}, objB);
			objA = {a:"a1",b:"a2"};
			objB = {b:"b2",c:"b3"};
			flexunit.framework.Assert.assertObjectEquals("Merging has to take the master property", {
				a:"a1", b:"a2", c:"b3"}, ObjectUtils.merge(objA, objB));

		}

        [Test]
        public function testCompare_equalSimpleObjects():void {
            var object:Object = {a:"1"};
            var other:Object = {a:"1"};

            assertTrue(ObjectUtils.compare(object, other));
        }

        [Test]
        public function testCompare_nonEqualObjects():void {
            var object:Object = {a:"1"};
            var other:Object = {a:"2"};

            assertFalse(ObjectUtils.compare(object, other));
        }

        [Test]
        public function testCompare_equalComplexObject():void {
            var object:Object = {a:"1", b:{c:"1"}, d:[1,2,3], e:[{f:1},{g:false},{h:"1"}]};
            var other:Object = {a:"1", b:{c:"1"}, d:[1,2,3], e:[{f:1},{g:false},{h:"1"}]};

            assertTrue(ObjectUtils.compare(object, other));
        }

        [Test]
        public function testCompare_withANullObject():void {
            var object:Object = null;
            var other:Object = {a:"1"};

            assertFalse(ObjectUtils.compare(object, other));
        }

        [Test]
        public function testCompare_withTwoNullObjects():void {
            var object:Object = null;
            var other:Object = null;

            assertTrue(ObjectUtils.compare(object, other));
        }
	}
}