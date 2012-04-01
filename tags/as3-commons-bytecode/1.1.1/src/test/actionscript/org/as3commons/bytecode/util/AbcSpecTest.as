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
package org.as3commons.bytecode.util {
	import flash.utils.ByteArray;
	import flash.utils.Endian;

	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.assertFalse;
	import org.flexunit.asserts.fail;

	public class AbcSpecTest {

		private var _testArray:ByteArray;

		public function AbcSpecTest() {
		}

		[Before]
		public function setUp():void {
			_testArray = AbcSpec.newByteArray();
		}

		[Test]
		public function testByteArray():void {
			var ba:ByteArray = AbcSpec.newByteArray();
			assertEquals(Endian.LITTLE_ENDIAN, ba.endian);
			assertEquals(0, ba.position);
		}

		[Test]
		public function testU30():void {
			AbcSpec.writeU30(1073741823, _testArray);
			_testArray.position = 0;
			var i:uint = AbcSpec.readU30(_testArray);
			assertEquals(1073741823, i);
		}

		[Test]
		public function testU30WithNegativeValue():void {
			try {
				AbcSpec.writeU30(-1, _testArray);
				fail("Should have thrown out of range error");
			} catch (e:Error) {
			}
		}

		[Test]
		public function testU30WithTooLargeValue():void {
			try {
				AbcSpec.writeU30(1073741824, _testArray);
				fail("Should have thrown out of range error");
			} catch (e:Error) {
			}
		}

		[Test]
		public function testU16():void {
			AbcSpec.writeU16(65535, _testArray);
			_testArray.position = 0;
			var i:uint = AbcSpec.readU16(_testArray);
			assertEquals(65535, i);
		}

		[Test]
		public function testU16WithNegativeValue():void {
			try {
				AbcSpec.writeU16(-1, _testArray);
				fail("Should have thrown out of range error");
			} catch (e:Error) {
			}
		}

		[Test]
		public function testU16WithTooLargeValue():void {
			try {
				AbcSpec.writeU30(65536, _testArray);
				fail("Should have thrown out of range error");
			} catch (e:Error) {
			}
		}

		[Test]
		public function testU8():void {
			AbcSpec.writeU8(255, _testArray);
			_testArray.position = 0;
			var i:uint = AbcSpec.readU16(_testArray);
			assertEquals(255, i);
		}

		[Test]
		public function testU8WithNegativeValue():void {
			try {
				AbcSpec.writeU8(-1, _testArray);
				fail("Should have thrown out of range error");
			} catch (e:Error) {
			}
		}

		[Test]
		public function testU8WithTooLargeValue():void {
			try {
				AbcSpec.writeU8(256, _testArray);
				fail("Should have thrown out of range error");
			} catch (e:Error) {
			}
		}

		[Test]
		public function testU32():void {
			AbcSpec.writeU32(1073741824, _testArray);
			_testArray.position = 0;
			var i:uint = AbcSpec.readU32(_testArray);
			assertEquals(1073741824, i);
		}

		[Test]
		public function testU32WithNegativeValue():void {
			AbcSpec.writeU32(-1, _testArray);
			_testArray.position = 0;
			var i:uint = AbcSpec.readU32(_testArray);
			assertFalse((i == -1));
		}

		[Test]
		public function testS24():void {
			AbcSpec.writeS24(-8388606, _testArray);
			_testArray.position = 0;
			var i:int = AbcSpec.readS24(_testArray);
			assertEquals(-8388606, i);
			_testArray.clear();
			AbcSpec.writeS24(8388606, _testArray);
			_testArray.position = 0;
			i = AbcSpec.readS24(_testArray);
			assertEquals(8388606, i);
		}

		[Test]
		public function testS32():void {
			AbcSpec.writeS32(-int.MAX_VALUE, _testArray);
			_testArray.position = 0;
			var i:int = AbcSpec.readS32(_testArray);
			assertEquals(-int.MAX_VALUE, i);
			_testArray.clear();
			AbcSpec.writeS32(int.MAX_VALUE, _testArray);
			_testArray.position = 0;
			i = AbcSpec.readS32(_testArray);
			assertEquals(int.MAX_VALUE, i);
		}

	}
}