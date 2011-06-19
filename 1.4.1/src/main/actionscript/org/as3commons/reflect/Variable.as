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

	/**
	 * A property defined with the <code>var</code> keyword.
	 *
	 * @author Christophe Herreman
	 */
	public class Variable extends Field {

		private static const _cache:Dictionary = new Dictionary();

		/**
		 * Creates a new <code>Variable</code> object.
		 *
		 * @param name the name of the variable
		 * @param type the data type of the variable
		 * @param declaringType the type that declares the variable
		 * @param isStatic whether or not this member is static (class member)
		 */
		public function Variable(name:String, type:String, declaringType:String, isStatic:Boolean, applicationDomain:ApplicationDomain, metadata:HashArray = null) {
			super(name, type, declaringType, isStatic, applicationDomain, metadata);
		}

		public static function newInstance(name:String, type:String, declaringType:String, isStatic:Boolean, applicationDomain:ApplicationDomain, metadata:HashArray = null):Variable {
			var variable:Variable = new Variable(name, type, declaringType, isStatic, applicationDomain, metadata);
			return doCacheCheck(variable);
		}

		public static function addToCache(variable:Variable):void {
			var cacheKey:String = variable.name.toUpperCase();
			var instances:Array = _cache[cacheKey];
			if (instances == null) {
				instances = [];
				instances[0] = variable;
				_cache[cacheKey] = instances;
			} else {
				instances[instances.length] = variable;
			}
		}

		public static function doCacheCheck(variable:Variable):Variable {
			var instances:Array = _cache[variable.name.toUpperCase()];
			if (instances == null) {
				addToCache(variable);
			} else {
				var found:Boolean = false;
				for each (var vr:Variable in instances) {
					if (vr.equals(variable)) {
						variable = vr;
						found = true;
						break;
					}
				}
				if (!found) {
					addToCache(variable);
				}
			}
			return variable;
		}

	}
}
