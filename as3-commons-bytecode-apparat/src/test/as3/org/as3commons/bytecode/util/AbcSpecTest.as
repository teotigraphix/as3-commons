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
	import apparat.memory.Memory;
	
	import flash.system.ApplicationDomain;
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	
	import flexunit.framework.TestCase;

	public class AbcSpecTest extends TestCase {

		protected var bytes:ByteArray;

		public function AbcSpecTest(methodName:String = null) {
			super(methodName);
		}

		override public function setUp():void {
			super.setUp();
			bytes = new ByteArray();
			bytes.length = ApplicationDomain.MIN_DOMAIN_MEMORY_LENGTH;
			Memory.select(bytes);
		}
		
		public function testU8():void {
			const input:int = 255;
			var result:int;
			var address:int = 0;
			
			AbcSpec.writeU8(input, address);
			address = 0;
			AbcSpec.readU8(address, result);
			
			assertEquals(input, result);
		}

		public function testU30():void {
			const input:int = 1073741823;
			var result:int;
			var address:int = 0;
			
			AbcSpec.writeU30(input, address);
			address = 0;
			AbcSpec.readU30(address, result);
			
			assertEquals(input, result);
		}
		
		public function testU16():void {
			const input:int = 65535;
			var result:int;
			var address:int = 0;
			
			AbcSpec.writeU16(input, address);
			address = 0;
			AbcSpec.readU16(address, result);
			
			assertEquals(input, result);
		}

		public function testU32():void {
			const input:int = 1073741824;
			var result:int;
			var address:int = 0;
			
			AbcSpec.writeU32(input, address);
			address = 0;
			AbcSpec.readU32(address, result);
			
			assertEquals(input, result);
		}

		public function testS24():void {
			const neg:int = -8388606;
			const pos:int = 8388606;
			var result:int;
			var address:int = 0;
			
			AbcSpec.writeS24(neg, address);
			AbcSpec.writeS24(pos, address);
			
			address = 0;
			
			AbcSpec.readS24(address, result);
			assertEquals(neg, result);
			
			AbcSpec.readS24(address, result);
			assertEquals(pos, result);
		}

		public function testS32():void {
			const min:int = -int.MAX_VALUE;
			const max:int = int.MAX_VALUE;
			var result:int;
			var address:int = 0;
			
			AbcSpec.writeS32(min, address);
			AbcSpec.writeS32(max, address);
			
			address = 0;
			
			AbcSpec.readS32(address, result);
			assertEquals(min, result);
			
			AbcSpec.readS32(address, result);
			assertEquals(max, result);
		}
	}
}