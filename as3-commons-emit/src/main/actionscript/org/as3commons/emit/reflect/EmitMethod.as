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
	import org.as3commons.emit.SWFConstant;
	import org.as3commons.emit.bytecode.BCNamespace;
	import org.as3commons.emit.bytecode.NamespaceKind;
	import org.as3commons.emit.bytecode.QualifiedName;
	import org.as3commons.lang.Assert;
	import org.as3commons.reflect.Method;
	import org.as3commons.reflect.Type;
	import org.as3commons.reflect.as3commons_reflect;

	public class EmitMethod extends Method implements IEmitMember {

		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------

		/**
		 * Constructor.
		 */
		public function EmitMethod(declaringType:EmitType, name:String, fullName:String, visibility:uint, isStatic:Boolean, isOverride:Boolean, parameters:Array, returnType:*, metaData:Array = null, ns:String = null) {
			super(declaringType, name, isStatic, parameters, returnType, metaData);
			initEmitMethod(isOverride, visibility, ns, fullName, declaringType, name);
		}

		protected function initEmitMethod(isOverride:Boolean, visibility:uint, ns:String, fullName:String, declaringType:EmitType, name:String):void {
			Assert.notNull(fullName, "fullName argument must not be null");
			Assert.notNull(declaringType, "declaringType argument must not be null");
			Assert.notNull(name, "name argument must not be null");
			_isOverride = isOverride;
			_visibility = visibility;
			as3commons_reflect::setNamespaceURI(ns || SWFConstant.EMPTY_STRING);
			_qname = EmitReflectionUtils.getMemberQualifiedName(this);
			as3commons_reflect::setFullName(fullName || EmitReflectionUtils.getMemberFullName(declaringType, name));
		}


		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------

		//----------------------------------
		//  declaringType
		//----------------------------------

		public function set declaringType(value:Type):void {
			as3commons_reflect::setDeclaringType(value);
		}

		//----------------------------------
		//  fullName
		//----------------------------------

		public function set fullName(value:String):void {
			as3commons_reflect::setFullName(value);
		}

		//----------------------------------
		//  isOverride
		//----------------------------------

		private var _isOverride:Boolean = false;

		public function get isOverride():Boolean {
			return _isOverride;
		}

		public function set isOverride(value:Boolean):void {
			_isOverride = value;
		}

		//----------------------------------
		//  isStatic
		//----------------------------------

		public function set isStatic(value:Boolean):void {
			as3commons_reflect::setIsStatic(value);
		}

		//----------------------------------
		//  name
		//----------------------------------

		public function set name(value:String):void {
			as3commons_reflect::setName(value);
		}

		//----------------------------------
		//  namespaceURI
		//----------------------------------

		public function set namespaceURI(value:String):void {
			as3commons_reflect::setNamespaceURI(value);
		}

		//----------------------------------
		//  visibility
		//----------------------------------

		private var _visibility:uint;

		public function get visibility():uint {
			return _visibility;
		}

		public function set visibility(value:uint):void {
			_visibility = value;
		}

		//----------------------------------
		//  qname
		//----------------------------------

		private var _qname:QualifiedName;

		public function get qname():QualifiedName {
			return _qname;
		}

		public function set qname(value:QualifiedName):void {
			_qname = value;
		}
	}
}