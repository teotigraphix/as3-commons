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
package org.as3commons.aop.pointcut.impl.name {
	import org.as3commons.aop.pointcut.INameMatcher;
	import org.as3commons.lang.StringUtils;

	/**
	 * Name matcher that allows simple name matching or pattern matching
	 * on the method name.
	 *
	 * The following patterns are accepted: "xxx", "*xxx", "xxx*", "xxx*yyy"
	 *
	 * @author Christophe Herreman
	 */
	public class NameMatcher extends NameRegistry implements INameMatcher {

		// --------------------------------------------------------------------
		//
		// Constructor
		//
		// --------------------------------------------------------------------

		public function NameMatcher(nameOrNames:* = null) {
			super(nameOrNames);
		}

		// --------------------------------------------------------------------
		//
		// Public Methods
		//
		// --------------------------------------------------------------------

		public function match(name:String):Boolean {
			return (containsName(name) || matchPattern(name));
		}

		// --------------------------------------------------------------------
		//
		// Private Methods
		//
		// --------------------------------------------------------------------

		private function matchPattern(name:String):Boolean {
			for each (var pattern:String in names) {
				if (matchSinglePattern(pattern, name)) {
					return true;
				}
			}
			return false;
		}

		/**
		 * Note: based on Spring Java code by Juergen Hoeller
		 */
		private function matchSinglePattern(pattern:String, name:String):Boolean {
			if (pattern == null || name == null) {
				return false;
			}
			var firstIndex:int = pattern.indexOf('*');
			if (firstIndex == -1) {
				return (pattern === name);
			}
			if (firstIndex == 0) {
				if (pattern.length == 1) {
					return true;
				}
				var nextIndex:int = pattern.indexOf('*', firstIndex + 1);
				if (nextIndex == -1) {
					return StringUtils.endsWith(name, pattern.substring(1));
				}
				var part:String = pattern.substring(1, nextIndex);
				var partIndex:int = name.indexOf(part);
				while (partIndex != -1) {
					if (matchSinglePattern(pattern.substring(nextIndex), name.substring(partIndex + part.length))) {
						return true;
					}
					partIndex = name.indexOf(part, partIndex + 1);
				}
				return false;
			}
			return (name.length >= firstIndex &&
					pattern.substring(0, firstIndex) === (name.substring(0, firstIndex)) &&
					matchSinglePattern(pattern.substring(firstIndex), name.substring(firstIndex)));
		}
	}
}
