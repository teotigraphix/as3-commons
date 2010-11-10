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
	import flash.system.ApplicationDomain;

	import org.as3commons.lang.HashArray;

	/**
	 * Abstract base class for members of a <code>class</object>.
	 *
	 * @author Christophe Herreman
	 * @author Andrew Lewisohn
	 */
	public class AbstractMember extends MetaDataContainer implements IMember, INamespaceOwner {

		// -------------------------------------------------------------------------
		//
		//  Variables
		//
		// -------------------------------------------------------------------------

		protected var applicationDomain:ApplicationDomain;

		/**
		 * @private
		 * Stores the string name of the declaringType impl.
		 */
		private var declaringTypeName:String;

		/**
		 * @private
		 * Stores the string name of the type impl.
		 */
		private var typeName:String;

		// -------------------------------------------------------------------------
		//
		//  Constructor
		//
		// -------------------------------------------------------------------------

		/**
		 * Creates a new AbstractMember object.
		 *
		 * @param name the name of the member
		 * @param type the type of the member
		 * @param declaringType the type that declares the member
		 * @param isStatic whether this member is static
		 * @param metadata an array of MetaData objects describing this member
		 */
		public function AbstractMember(name:String, type:String, declaringType:String, isStatic:Boolean, applicationDomain:ApplicationDomain, metaData:HashArray = null) {
			super(metaData);
			_name = name;
			_isStatic = isStatic;
			typeName = type;
			declaringTypeName = declaringType;
			this.applicationDomain = applicationDomain;
		}

		// -------------------------------------------------------------------------
		//
		//  Properties
		//
		// -------------------------------------------------------------------------

		// ----------------------------
		// declaringType
		// ----------------------------

		public function get declaringType():Type {
			//Do NOT store a reference to the declaring type here, always do a forName() lookup
			//otherwise this will lead to a circular reference between the AbstractMember and Type instances,
			//which will in turn result in a memory leak.
			return Type.forName(declaringTypeName, applicationDomain);
		}

		// ----------------------------
		// isStatic
		// ----------------------------

		private var _isStatic:Boolean;

		public function get isStatic():Boolean {
			return _isStatic;
		}

		// ----------------------------
		// name
		// ----------------------------

		private var _name:String;

		public function get name():String {
			return _name;
		}

		// ----------------------------
		// namespaceURI
		// ----------------------------

		private var _namespaceURI:String;

		public function get namespaceURI():String {
			return _namespaceURI;
		}

		// ----------------------------
		// type
		// ----------------------------

		public function get type():Type {
			return Type.forName(typeName, applicationDomain);
		}

		// -------------------------------------------------------------------------
		//
		//  Methods: AS3Commons Reflect Internal Use
		//
		// -------------------------------------------------------------------------

		as3commons_reflect function setDeclaringType(value:String):void {
			declaringTypeName = value;
		}

		as3commons_reflect function setIsStatic(value:Boolean):void {
			_isStatic = value;
		}

		as3commons_reflect function setName(value:String):void {
			_name = value;
		}

		as3commons_reflect function setNamespaceURI(value:String):void {
			_namespaceURI = value;
		}

		as3commons_reflect function setType(value:String):void {
			typeName = value;
		}
	}
}
