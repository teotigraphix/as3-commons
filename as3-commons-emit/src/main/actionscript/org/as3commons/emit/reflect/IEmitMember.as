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
	import org.as3commons.emit.bytecode.QualifiedName;
	import org.as3commons.reflect.Type;

	public interface IEmitMember {

		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------

		//----------------------------------
		//  declaringType
		//----------------------------------

		/**
		 * Returns the <code>EmitType</code> object that declares this member.
		 */
		function get declaringType():Type;

		/**
		 * @private
		 */
		function set declaringType(value:Type):void;

		//----------------------------------
		//  fullName
		//----------------------------------

		function get fullName():String;

		function set fullName(value:String):void;

		//----------------------------------
		//  isStatic
		//----------------------------------

		function get isStatic():Boolean;

		function set isStatic(value:Boolean):void;

		//----------------------------------
		//  name
		//----------------------------------

		/**
		 * Returns the name of this member.
		 */
		function get name():String;

		/**
		 * @private
		 */
		function set name(value:String):void;

		//----------------------------------
		//  namespaceURI
		//----------------------------------

		function get namespaceURI():String;

		function set namespaceURI(value:String):void;

		//----------------------------------
		//  qname
		//----------------------------------

		function get qname():QualifiedName;

		function set qname(value:QualifiedName):void;

		//----------------------------------
		//  visibility
		//----------------------------------

		function get visibility():uint;

		function set visibility(value:uint):void;
	}
}