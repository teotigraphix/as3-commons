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

import org.flexunit.asserts.assertFalse;
import org.flexunit.asserts.assertTrue;

/**
 * @author Christophe Herreman
 */
public class DictionaryUtilsTest {

	public function DictionaryUtilsTest() {
	}

	[Test]
	public function testContainsKey():void {
		var d:Dictionary = new Dictionary();
		var key:Object = new Object();
		assertFalse(DictionaryUtils.containsKey(d, key));

		d[key] = "a value";
		assertTrue(DictionaryUtils.containsKey(d, key));

		delete d[key];
		assertFalse(DictionaryUtils.containsKey(d, key));
	}

	[Test]
	public function testContainsValue():void {
		var d:Dictionary = new Dictionary();
		var key:Object = new Object();
		var value:Object = new Object();
		assertFalse(DictionaryUtils.containsValue(d, value));

		d[key] = value;
		assertTrue(DictionaryUtils.containsValue(d, value));

		delete d[key];
		assertFalse(DictionaryUtils.containsValue(d, value));
	}

	[Test]
	public function testDeleteKeys():void {
		var key1:Object = {};
		var key2:Object = {};
		var key3:Object = {};
		var key4:Object = {};

		var value1:Object = {};
		var value2:Object = {};
		var value3:Object = {};
		var value4:Object = {};

		var dictionary:Dictionary = new Dictionary();
		dictionary[key1] = value1;
		dictionary[key2] = value2;
		dictionary[key3] = value3;

		DictionaryUtils.deleteKeys(dictionary, [key1, key3, key4]);

		assertFalse(DictionaryUtils.containsKey(dictionary, key1));
		assertFalse(DictionaryUtils.containsKey(dictionary, key3));
		assertFalse(DictionaryUtils.containsKey(dictionary, key4));
		assertTrue(DictionaryUtils.containsKey(dictionary, key2));
	}

	[Test]
	public function testDeleteKeys_withInvalidKeys():void {
		var key1:Object = {};
		var key2:Object = {};
		var key3:Object = {};

		var value1:Object = {};
		var value2:Object = {};
		var value3:Object = {};

		var dictionary:Dictionary = new Dictionary();
		dictionary[key1] = value1;
		dictionary[key2] = value2;
		dictionary[key3] = value3;

		DictionaryUtils.deleteKeys(dictionary, [key1, {}, key3]);

		assertFalse(DictionaryUtils.containsKey(dictionary, key1));
		assertFalse(DictionaryUtils.containsKey(dictionary, key3));
		assertTrue(DictionaryUtils.containsKey(dictionary, key2));
	}

	[Test]
	public function testDeleteKeys_withNullValue():void {
		var key1:Object = {};
		var key2:Object = {};
		var key3:Object = {};

		var value1:Object = {};
		var value2:Object = {};
		var value3:Object = {};

		var dictionary:Dictionary = new Dictionary();
		dictionary[key1] = value1;
		dictionary[key2] = value2;
		dictionary[key3] = value3;

		DictionaryUtils.deleteKeys(dictionary, [null]);

		assertTrue(DictionaryUtils.containsKey(dictionary, key1));
		assertTrue(DictionaryUtils.containsKey(dictionary, key3));
		assertTrue(DictionaryUtils.containsKey(dictionary, key2));
	}

}
}
