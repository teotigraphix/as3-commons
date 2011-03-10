/**
 * Copyright 2009 Maxim Cassian Porges
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package org.as3commons.bytecode.util {
	import flash.utils.ByteArray;

	/**
	 * A pairing of symmetric read/write <code>Function</code>s for dealing with primitives in the ABC file format.
	 * These are used to specify the reader/writer responsible for parsing and outputting opcode arguments.
	 *
	 * <p>
	 * The two function references point to static functions in <code>AbcSpec</code> Rather than using this class
	 * directly, it is recommended that you just use the constants already made available to you in <code>AbcSpec</code>.
	 * </p>
	 *
	 * @see AbcSpec
	 * @see org.as3commons.bytecode.abc.enum.Opcode
	 */
	public final class ReadWritePair {
		private var _reader:Function;
		private var _writer:Function;

		public function ReadWritePair(readerFunction:Function, writerFunction:Function) {
			_reader = readerFunction;
			_writer = writerFunction;
		}

		public function get reader():Function {
			return _reader;
		}

		/**
		 * Applies the read function and shifts the <code>ByteArray</code> position forward by whatever
		 * number of spots is required to read the value.
		 */
		public function read(byteArray:ByteArray):* {
			return reader.apply(AbcSpec, [byteArray]);
		}

		/**
		 * Applies the write function and shifts the <code>ByteArray</code> position forward by whatever
		 * number of spots is required to write the value.
		 */
		public function write(value:*, byteArray:ByteArray):Function {
			return writer.apply(AbcSpec, [value, byteArray]);
		}

		public function get writer():Function {
			return _writer;
		}
	}
}