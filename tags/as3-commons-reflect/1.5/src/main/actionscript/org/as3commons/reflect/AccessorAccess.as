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
package org.as3commons.reflect {
	import flash.utils.Dictionary;

	import org.as3commons.lang.Assert;

	/**
	 * Enum of an accessor's access properties.
	 *
	 * @author Christophe Herreman
	 *
	 * @see Accessor
	 */
	public final class AccessorAccess {

		private static const _lookup:Dictionary = new Dictionary();
		private static var _enumCreated:Boolean = false;

		public static const READ_ONLY:AccessorAccess = new AccessorAccess(READ_ONLY_VALUE);
		public static const WRITE_ONLY:AccessorAccess = new AccessorAccess(WRITE_ONLY_VALUE);
		public static const READ_WRITE:AccessorAccess = new AccessorAccess(READ_WRITE_VALUE);

		private static const READ_ONLY_VALUE:String = "readonly";
		private static const WRITE_ONLY_VALUE:String = "writeonly";
		private static const READ_WRITE_VALUE:String = "readwrite";

		private var _name:String;

		{
			_enumCreated = true;
		}

		/**
		 * Creates a new <code>AccessorAccess</code> instance.
		 *
		 * @param name the name of the accessor access
		 */
		public function AccessorAccess(name:String) {
			Assert.state(!_enumCreated, "AccessorAccess enum was already created");
			_name = name;
			_lookup[_name] = this;
		}

		public static function fromString(access:String):AccessorAccess {
			return _lookup[access] as AccessorAccess;
		}

		/**
		 * Returns the name of this AccessorAccess instance.
		 */
		public function get name():String {
			return _name;
		}
	}
}
