/*
 * Copyright (c) 2007-2009-2010 the original author or authors
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */
package org.as3commons.emit.bytecode {

	public class MultinameKind {
		public static const QUALIFIED_NAME:uint = 0x07;
		public static const QUALIFIED_NAME_ATTRIBUTE:uint = 0x0D;
		public static const RUNTIME_QUALIFIED_NAME:uint = 0x0F;
		public static const RUNTIME_QUALIFIED_NAME_ATTRIBUTE:uint = 0x10;
		public static const RUNTIME_QUALIFIED_NAME_LATE:uint = 0x11;
		public static const RUNTIME_QUALIFIED_NAME_LATE_ATTRIBUTE:uint = 0x12;
		public static const MULTINAME:uint = 0x09;
		public static const MULTINAME_ATTRIBUTE:uint = 0x0E;
		public static const MULTINAME_LATE:uint = 0x1B;
		public static const MULTINAME_LATE_ATTRIBUTE:uint = 0x1C;
		public static const GENERIC:uint = 0x1D;

	}
}