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
	import flash.utils.Dictionary;

	import org.as3commons.lang.HashArray;
	import org.as3commons.lang.IEquals;

	/**
	 * A member defined by getter and setter functions.
	 *
	 * @author Christophe Herreman
	 * @author Andrew Lewisohn
	 *
	 * @see AccessorAccess
	 */
	public class Accessor extends Field implements IEquals {

		// --------------------------------------------------------------------
		//
		// Class variables
		//
		// --------------------------------------------------------------------

		private static const _cache:Dictionary = new Dictionary();

		// --------------------------------------------------------------------
		//
		// Class methods
		//
		// --------------------------------------------------------------------

		public static function newInstance(name:String, access:AccessorAccess, type:String, declaringType:String, isStatic:Boolean, applicationDomain:ApplicationDomain, metadata:HashArray = null):Accessor {
			var cacheKey:String = getCacheKey(name, access, type, declaringType, isStatic, applicationDomain, metadata);
			if (!_cache[cacheKey]) {
				_cache[cacheKey] = new Accessor(name, access, type, declaringType, isStatic, applicationDomain, metadata);
			}
			return _cache[cacheKey];
		}

		private static function getCacheKey(name:String, access:AccessorAccess, type:String, declaringType:String, isStatic:Boolean, applicationDomain:ApplicationDomain, metadata:HashArray):String {
			var cacheKey:String = AbstractMember.getCacheKey(Accessor, name, type, declaringType, isStatic, applicationDomain, metadata);
			return [cacheKey, access.name].join(":");
		}

		// -------------------------------------------------------------------------
		//
		//  Constructor
		//
		// -------------------------------------------------------------------------

		/**
		 * Creates a new <code>Accessor</code> instance.
		 *
		 * @param name the name of the variable
		 * @param access the access of the accessor
		 * @param type the data type of the variable
		 * @param declaringType the type that declares the variable
		 * @param isStatic whether or not this member is static (class member)
		 */
		public function Accessor(name:String, access:AccessorAccess, type:String, declaringType:String, isStatic:Boolean, applicationDomain:ApplicationDomain, metadata:HashArray = null) {
			super(name, type, declaringType, isStatic, applicationDomain, metadata);
			_access = access;
		}

		// -------------------------------------------------------------------------
		//
		//  Properties
		//
		// -------------------------------------------------------------------------

		// ----------------------------
		// access
		// ----------------------------

		private var _access:AccessorAccess;

		public function get access():AccessorAccess {
			return _access;
		}

		// ----------------------------
		// readable
		// ----------------------------

		/**
		 * @return <code>true</code> if the accessor can be used to read the value (the "get" accessor is present),
		 * <code>false</code> otherwise. This property is the same as the isReadable method.
		 */
		public function get readable():Boolean {
			return isReadable();
		}

		// ----------------------------
		// writeable
		// ----------------------------

		/**
		 * @return <code>true</code> if the accessor can be used to read the value (the "set" accessor is present),
		 * <code>false</code> otherwise. This property is the same as the isWriteable method.
		 */
		public function get writeable():Boolean {
			return isWriteable();
		}

		// -------------------------------------------------------------------------
		//
		//  Methods
		//
		// -------------------------------------------------------------------------

		/**
		 * @return <code>true</code> if the accessor can be used to read the value (the "get" accessor is present),
		 * <code>false</code> otherwise.
		 */
		public function isReadable():Boolean {
			return (_access == AccessorAccess.READ_ONLY || _access == AccessorAccess.READ_WRITE);
		}

		/**
		 * @return <code>true</code> if the accessor can be used to read the value (the "set" accessor is present),
		 * <code>false</code> otherwise.
		 */
		public function isWriteable():Boolean {
			return (_access == AccessorAccess.WRITE_ONLY || _access == AccessorAccess.READ_WRITE);
		}

		override public function equals(other:Object):Boolean {
			var otherAccessor:Accessor = other as Accessor;
			var result:Boolean = false;
			if (otherAccessor != null) {
				result = super.equals(other);
				if (result) {
					result = (otherAccessor.access === this.access);
				}
				if (result) {
					result = compareMetadata(otherAccessor.metadata);
				}
			}
			return result;
		}

		// -------------------------------------------------------------------------
		//
		//  Methods: AS3Commons Reflect Internal Use
		//
		// -------------------------------------------------------------------------

		as3commons_reflect function setAccess(value:AccessorAccess):void {
			_access = value;
		}

	}
}
