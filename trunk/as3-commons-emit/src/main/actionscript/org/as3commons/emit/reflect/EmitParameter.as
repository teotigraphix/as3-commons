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
package org.as3commons.emit.reflect {
	import org.as3commons.reflect.Parameter;
	import org.as3commons.reflect.Type;
	import org.as3commons.reflect.as3commons_reflect;

	public class EmitParameter extends Parameter {

		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------

		/**
		 * Constructor.
		 */
		public function EmitParameter(name:String, index:int, type:EmitType, isOptional:Boolean = false) {
			super(index, type, isOptional);

			_name = name;
		}

		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------

		//----------------------------------
		//  index
		//----------------------------------

		public function set index(value:int):void {
			as3commons_reflect::setIndex(value);
		}

		//----------------------------------
		//  isOptional
		//----------------------------------

		public function set isOptional(value:Boolean):void {
			as3commons_reflect::setIsOptional(value);
		}

		//----------------------------------
		//  name
		//----------------------------------

		private var _name:String;

		public function get name():String {
			return _name;
		}

		public function set name(value:String):void {
			_name = value;
		}

		//----------------------------------
		//  type
		//----------------------------------

		public function set type(value:Type):void {
			as3commons_reflect::setType(value);
		}
	}
}