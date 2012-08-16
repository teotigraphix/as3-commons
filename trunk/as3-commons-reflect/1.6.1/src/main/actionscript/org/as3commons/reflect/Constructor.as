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

	/**
	 * Provides information about a class constructor.
	 *
	 * @author Martino Piccinato
	 * @author Roland Zwaga
	 */
	public class Constructor {

		protected var _parameters:Array = [];

		private var _applicationDomain:ApplicationDomain;

		private var _declaringType:String;

		/**
		 * Creates a new Constructor object.
		 *
		 * @param declaringType The Type declaring the constrcutor.
		 * @param parameters an Array of Parameter objects being the parameters of the constructor.
		 */
		public function Constructor(declaringType:String, applicationDomain:ApplicationDomain, parameters:Array=null) {
			if (parameters != null) {
				_parameters = parameters;
			}
			_declaringType = declaringType;
			_applicationDomain = applicationDomain;
		}

		/**
		 * Returns the parameters of this Constructor.
		 */
		public function get parameters():Array {
			var result:Array = [];
			var len:int = _parameters.length;
			for (var i:int = 0; i < len; ++i) {
				result[result.length] = new Parameter(_parameters[i], i);
			}
			return result;
		}

		/**
		 * Returns the declaring type of this Constructor.
		 */
		public function get declaringType():Type {
			return Type.forName(_declaringType, _applicationDomain);
		}

		/**
		 * @return <code>true</code> if the constructor has no arguments, <code>false</code>
		 * otherwise.
		 */
		public function hasNoArguments():Boolean {
			return (_parameters.length == 0 ? true : false);
		}

	}
}
