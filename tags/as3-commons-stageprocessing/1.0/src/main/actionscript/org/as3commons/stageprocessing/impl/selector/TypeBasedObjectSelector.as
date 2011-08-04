/*
 * Copyright 2007-2011 the original author or authors.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package org.as3commons.stageprocessing.impl.selector {

	import flash.system.ApplicationDomain;

	import org.as3commons.lang.Assert;
	import org.as3commons.lang.ClassUtils;
	import org.as3commons.stageprocessing.IObjectSelector;

	/**
	 * <code>IObjectSelector</code> approving or denying objects based on their type.
	 * (default behaviour approves objects whose type matches one of the types in the typeArray).
	 * @author Roland Zwaga
	 */
	public class TypeBasedObjectSelector implements IObjectSelector {

		private var _applicationDomain:ApplicationDomain;

		/**
		 * Create a new <code>TypeBasedObjectSelector</code> instance.
		 * @param typeArray
		 * @param approveOnMatch
		 */
		public function TypeBasedObjectSelector(typeArray:Array, approveOnMatch:Boolean = true, appDomain:ApplicationDomain = null) {
			super();
			initTypeBasedObjectSelector(appDomain, typeArray, approveOnMatch);
		}

		public function get applicationDomain():ApplicationDomain {
			return _applicationDomain;
		}

		public function set applicationDomain(value:ApplicationDomain):void {
			_applicationDomain = value;
		}

		protected function initTypeBasedObjectSelector(appDomain:ApplicationDomain, typeArray:Array, approveOnMatch:Boolean):void {
			Assert.notNull(typeArray, "The typeArray argument must not be null");
			_applicationDomain = (appDomain != null) ? appDomain : ApplicationDomain.currentDomain;
			validateTypeArray(typeArray);
			_typeArray = typeArray;
			_approveOnMatch = approveOnMatch;
		}


		private var _approveOnMatch:Boolean = true;

		private var _typeArray:Array;

		/**
		 * <p>Returns true if the specified object is of a type in the typeArray and the approveOnMatch property is set to true.</p>
		 * @inheritDoc
		 */
		public function approve(object:Object):Boolean {
			var result:Boolean = _typeArray.some(function(item:Class, index:int, arr:Array):Boolean {
				return (object is item);
			});
			if (result) {
				return _approveOnMatch;
			} else {
				return !_approveOnMatch;
			}
		}

		/**
		 * When set to true the <code>approve()</code> method returns true when the specified object is of a type that
		 * is an item in the typeArray.
		 * @default true
		 */
		public function get approveOnMatch():Boolean {
			return _approveOnMatch;
		}

		/**
		 * @private
		 */
		public function set approveOnMatch(value:Boolean):void {
			_approveOnMatch = value;
		}

		/**
		 * An array of <code>Class</code> instance, the specified object will be checked to see if
		 * it is of any of these types.
		 */
		public function get typeArray():Array {
			return _typeArray;
		}

		/**
		 * @private
		 */
		public function set typeArray(value:Array):void {
			if (value !== _typeArray) {
				validateTypeArray(value);
				_typeArray = value;
			}
		}

		private function validateTypeArray(typeArray:Array):void {
			if (typeArray.some(function(item:Object, index:int, arr:Array):Boolean {
				if (item is String) {
					arr[index] = ClassUtils.forName(String(item), applicationDomain) as Class;
					return false;
				} else {
					return ((item is Class) == false);
				}
			})) {
				throw new Error("All items in the typeArray argument must be of type Class or able to be converted to type Class");
			}
		}
	}
}
