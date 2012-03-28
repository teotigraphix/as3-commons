/*
 * Copyright 2007-2010 the original author or authors.
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
package org.as3commons.bytecode.reflect {
	import flash.utils.ByteArray;

	import org.as3commons.bytecode.TestConstants;
	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.assertNotNull;
	import org.flexunit.asserts.assertTrue;

	public class ClassMetaDataDeserializerTest {

		private var _ds:ClassMetadataDeserializer;

		public function ClassMetaDataDeserializerTest() {

		}

		[Before]
		public function setUp():void {

			_ds = new ClassMetadataDeserializer();
		}

		[Test]
		public function testRead():void {
			var ba:ByteArray = TestConstants.getMetadataLookupTest();
			var typeCache:ByteCodeTypeCache = new ByteCodeTypeCache();
			_ds.read(typeCache, ba, null, false);
			var lookup:Object = typeCache.metaDataLookup;
			assertNotNull(lookup['testmetadata']);
			var arr:Array = typeCache.getClassesWithMetadata('TestMetadata');
			assertEquals(3, arr.length);
			assertTrue(arr.indexOf('com.classes.test.AnnotatedClass') > -1);
			assertTrue(arr.indexOf('com.classes.test.DoubleAnnotatedClass') > -1);
			assertTrue(arr.indexOf('com.classes.test.TripleAnnotatedClass') > -1);
			assertNotNull(lookup['moretestmetadata']);
			arr = typeCache.getClassesWithMetadata('MoreTestMetadata');
			assertEquals(2, arr.length);
			assertTrue(arr.indexOf('com.classes.test.DoubleAnnotatedClass') > -1);
			assertTrue(arr.indexOf('com.classes.test.TripleAnnotatedClass') > -1);
			assertNotNull(lookup['lasttestmetadata']);
			arr = typeCache.getClassesWithMetadata('LastTestMetadata');
			assertEquals(1, arr.length);
			assertTrue(arr[0] = 'com.classes.test.TripleAnnotatedClass');

			var classNames:Array = typeCache.definitionNames;
			//fifth class is some sprite class that gets automatically compiled into a swc
			assertEquals(5, classNames.length);
			assertTrue(classNames.indexOf('com.classes.test.AnnotatedClass') > -1);
			assertTrue(classNames.indexOf('com.classes.test.DoubleAnnotatedClass') > -1);
			assertTrue(classNames.indexOf('com.classes.test.TripleAnnotatedClass') > -1);
			assertTrue(classNames.indexOf('com.classes.test.NormalClass') > -1);
		}
	}
}