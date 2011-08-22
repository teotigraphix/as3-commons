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
	
	import flexunit.framework.TestCase;
	
	import org.as3commons.lang.testclasses.PublicClass;
	
	/**
	 * @author Christophe Herreman
	 * @author James Ghandour
	 */
	public class ObjectUtilsTest extends TestCase {
		
		public function ObjectUtilsTest(methodName:String = null) {
			super(methodName);
		}
		
		public function testIsExplicitInstanceOf():void {
			assertTrue(ObjectUtils.isExplicitInstanceOf(this, ObjectUtilsTest));
			assertFalse(ObjectUtils.isExplicitInstanceOf(this, TestCase));
		}
		
		public function testIsExplicitInstanceOf_withString():void {
			assertTrue(ObjectUtils.isExplicitInstanceOf("test", String));
		}
		
		public function testGetIterator():void {
			var iterator:IIterator = ObjectUtils.getIterator(new PublicClass());
			assertNotNull(iterator);
			assertNotNull(iterator.next());
		}
		
		public function testToDictionary():void {
			var obj : Object = {a:"a1", b:"b2"};
			var dict : Dictionary = ObjectUtils.toDictionary(obj);
			assertEquals(dict["a"], "a1");
			assertEquals(dict["b"], "b2");
		}
		
		public function testMerging():void {
			var objA: Object = {a:"1"};
			var objB: Object = {b:"2"};
			assertObjectEquals("Merging has to result in a object with both properties", {a: "1",b: "2"}, ObjectUtils.merge(objA, objB));
			assertObjectEquals("Merging may not modify A", {a: "1"}, objA);
			assertObjectEquals("Merging may not modify B", {b: "2"}, objB);
			objA = {a:"a1",b:"a2"};
			objB = {b:"b2",c:"b3"};
			assertObjectEquals("Mergin has to take the master property", {
				a:"a1", b:"a2", c:"b3"}, ObjectUtils.merge(objA, objB));
			
		}
	}
}