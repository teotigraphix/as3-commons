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
	 * <code>IObjectSelector</code> approving or denying objects based on fully qualified class names
	 * to be matched against an Vector of Regexp (default behaviour approves objects whose name do not match
	 * all passed regexp, approves all objects if no regexp is passed, deny the rest).
	 *
	 * @author Martino Piccinato
	 * @author Christophe Herreman
	 * @see String#search() String.search()
	 */
	public class ClassNameBasedObjectSelector implements IObjectSelector {

		/**
		 * Creates a new ClassBasedObjectSelector.
		 *
		 * @param regexpArray The array of <code>Regexp</code> to match the object fully qualified
		 * class name against.
		 * @param approveOnMatch if <code>true</code> will revert the selector logic and
		 * approve the object in case the fully qualified name MATCHES all passed regexps.
		 *
		 */
		public function ClassNameBasedObjectSelector(regexpList:Vector.<String>=null, approveOnMatch:Boolean=false) {
			super();
			_classNameRegexpList = (regexpList != null) ? new Vector.<RegExp>() : null;
			for each (var item:String in regexpList) {
				_classNameRegexpList[_classNameRegexpList.length] = new RegExp(item);
			}
			this.approveOnMatch = approveOnMatch;
		}

		private var _classNameRegexpList:Vector.<RegExp>;

		/**
		 * @param regexpArray The array of <code>Regexp</code> to match the object fully qualified
		 * class name against.
		 */
		public function set classNameRegexpList(value:Vector.<RegExp>):void {
			_classNameRegexpList = value;
		}

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
			if (!_classNameRegexpList)
				return true;

			var className:String = getQualifiedClassName(object);
			for each (var re:RegExp in _classNameRegexpList) {
				if (className.search(re) > -1) {
					return true;
				}
			}
			return false;
		}

	}
}
