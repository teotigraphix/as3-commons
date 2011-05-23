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

	import flash.utils.getQualifiedClassName;

	import org.as3commons.stageprocessing.IObjectSelector;

	/**
	 * <code>IObjectSelector</code> approving or denying objects based on fully qualified class name.
	 * to be matched against an array of Regexp (default behaviour approves objects whose name do not match
	 * all passed regexp, approves all objects if no regexp is passed, deny the rest).
	 *
	 * @author Martino Piccinato
	 * @author Christophe Herreman
	 * @see String#search() String.search()
	 */
	public class ClassNameBasedObjectSelector implements IObjectSelector {

		// --------------------------------------------------------------------
		//
		// Constructor
		//
		// --------------------------------------------------------------------

		/**
		 * Creates a new ClassBasedObjectSelector.
		 *
		 * @param regexpArray The array of <code>Regexp</code> to match the object fully qualified
		 * class name against.
		 * @param approveOnMatch if <code>true</code> will revert the selector logic and
		 * approve the object in case the fully qualified name MATCHES all passed regexps.
		 *
		 */
		public function ClassNameBasedObjectSelector(regexpArray:Array = null, approveOnMatch:Boolean = false) {
			this.classRegexpArray = regexpArray;
			this.approveOnMatch = approveOnMatch;
		}

		// --------------------------------------------------------------------
		//
		// Properties
		//
		// --------------------------------------------------------------------

		// ----------------------------
		// classRegexpArray
		// ----------------------------

		private var _classRegexpArray:Array;

		/**
		 * @param regexpArray The array of <code>Regexp</code> to match the object fully qualified
		 * class name against.
		 */
		public function set classRegexpArray(regexpArray:Array):void {
			_classRegexpArray = regexpArray;
			if (_classRegexpArray) {
				_classRegexpArray = _classRegexpArray.map(function(item:String, index:int, arr:Array):RegExp {
					return new RegExp(item);
				});
			}
		}

		// ----------------------------
		// approveOnMatch
		// ----------------------------

		private var _approveOnMatch:Boolean;

		/**
		 * @param value if <code>true</code> will revert the selector logic and
		 * approve the object in case the fully qualified name MATCHES all passed regexps.
		 * @default <code>false</code>
		 */
		public function set approveOnMatch(value:Boolean):void {
			_approveOnMatch = value;
		}

		// --------------------------------------------------------------------
		//
		// Implementation: IObjectSelector
		//
		// --------------------------------------------------------------------

		/**
		 * @inheritDoc
		 */
		public function approve(object:Object):Boolean {
			if (objectMatchRegexps(object)) {
				return _approveOnMatch;
			} else {
				return !_approveOnMatch;
			}
		}


		// --------------------------------------------------------------------
		//
		// Private Methods
		//
		// --------------------------------------------------------------------

		/**
		 * Returns true if the qualified class name of the given object matches any of the regular expressions in
		 * this selector.
		 * @param object
		 * @return true if a match, false if not
		 */
		private function objectMatchRegexps(object:Object):Boolean {
			if (!_classRegexpArray)
				return true;

			var className:String = getQualifiedClassName(object);
			for each (var re:RegExp in _classRegexpArray) {
				if (className.search(re) > -1) {
					return true;
				}
			}
			return false;
		}

	}
}
