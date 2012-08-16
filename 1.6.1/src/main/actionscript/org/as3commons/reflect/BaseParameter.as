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

	import org.as3commons.lang.IEquals;
	import org.as3commons.reflect.util.CacheUtil;

	/**
	 * Provides information of a parameter passed to a method.
	 *
	 * @author Christophe Herreman
	 * @author Andrew Lewisohn
	 */
	public class BaseParameter implements IEquals {

		private var _applicationDomain:ApplicationDomain;

		private static const _cache:Object = {};

		public static function newInstance(type:String, applicationDomain:ApplicationDomain, isOptional:Boolean=false):BaseParameter {
			var cacheKey:String = getCacheKey(type, applicationDomain, isOptional);
			if (!_cache[cacheKey]) {
				_cache[cacheKey] = new BaseParameter(type, applicationDomain, isOptional);
			}
			return _cache[cacheKey];
		}

		private static function getCacheKey(type:String, applicationDomain:ApplicationDomain, isOptional:Boolean):String {
			var appDomainIndex:int = CacheUtil.getApplicationDomainIndex(applicationDomain);
			return [type, appDomainIndex, isOptional].join(":");
		}

		// -------------------------------------------------------------------------
		//
		//  Constructor
		//
		// -------------------------------------------------------------------------

		/**
		 * Creates a new <code>BaseParameter</code> object.
		 *
		 * @param type the class type of the parameter
		 * @param isOptional whether the parameter is optional or not
		 */
		public function BaseParameter(type:String, applicationDomain:ApplicationDomain, isOptional:Boolean=false) {
			typeName = type;
			_applicationDomain = applicationDomain;
			_isOptional = isOptional;
		}

		// -------------------------------------------------------------------------
		//
		//  Properties
		//
		// -------------------------------------------------------------------------

		// ----------------------------
		// isOptional
		// ----------------------------

		private var _isOptional:Boolean;

		public function get isOptional():Boolean {
			return _isOptional;
		}

		// ----------------------------
		// type
		// ----------------------------

		protected var typeName:String;

		public function get type():Type {
			return (typeName != null) ? Type.forName(typeName, _applicationDomain) : null;
		}

		// -------------------------------------------------------------------------
		//
		//  Methods: AS3Commons Reflect Internal Use
		//
		// -------------------------------------------------------------------------

		as3commons_reflect function setIsOptional(value:Boolean):void {
			_isOptional = value;
		}

		as3commons_reflect function setType(value:String):void {
			typeName = value;
		}

		public function equals(other:Object):Boolean {
			var that:BaseParameter = other as BaseParameter;
			if (that) {
				return valuesAreEqual(that.typeName, that._applicationDomain, that.isOptional);
			}
			return false;
		}

		private function valuesAreEqual(typeName:String, appDomain:ApplicationDomain, isOptional:Boolean):Boolean {
			return ((appDomain === _applicationDomain) && (typeName == this.typeName) && (isOptional == this.isOptional));
		}

	}
}
