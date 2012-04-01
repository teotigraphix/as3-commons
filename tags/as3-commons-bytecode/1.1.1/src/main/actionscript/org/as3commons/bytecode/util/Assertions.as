/**
 * Copyright 2009 Maxim Cassian Porges
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package org.as3commons.bytecode.util {
	import org.as3commons.bytecode.abc.LNamespace;
	import org.as3commons.bytecode.abc.enum.NamespaceKind;

	/**
	 * Utility class offering assertions to be used within the test suite and the as3commons-bytecode project code.
	 */
	public final class Assertions {
		/**
		 * Given two arrays, asserts that the lengths and contents are identical. Does not care about the order
		 * of items within the arrays, only that the contents all match.
		 *
		 * <p>
		 * This is a as3commons-bytecode-specific utility and has a few hacks in it, so don't get excited about using it
		 * for general array comparison. For example, even though private namespaces must match as object
		 * references in the AVM2 spec, this method is forgiving in this regard in order to allow array
		 * contents to be checked for semantic equivalence.
		 * </p>
		 *
		 * @param a  The first array for the comparison
		 * @param b The secon array to compare <code>firstArray</code> against
		 * @return    <code>true</code> if both arrays match, <code>false</code> otherwise.
		 */
		public static function assertArrayContentsEqual(a:*, b:*):Boolean {
			return assertArrayOrVectorContentsEqual(a, b);
		}

		public static function assertVectorContentsEqual(a:*, b:*):Boolean {
			return assertArrayOrVectorContentsEqual(a, b);
		}

		// --------------------------------------------------------------------
		//
		// Private Methods
		//
		// --------------------------------------------------------------------

		private static function assertArrayOrVectorContentsEqual(firstArray:*, secondArray:*):Boolean {
			if (firstArray.length != secondArray.length) {
				throw new Error("Array lengths (" + firstArray.length + "," + secondArray.length + ") do not match");
			}

			var contentsMatch:Boolean = firstArray.every(function(item:Object, index:int, array:Array):Boolean {
				var matchFound:Boolean = false;
				for each (var current:Object in secondArray) {
					if (current.hasOwnProperty("equals")) {
						if (current.equals(item)) {
							matchFound = true;
							break;
						} else {
							// as3commons-bytecode-specific exception for private LNamespaces. Allow value equality so that
							// sample LNamespaces can be provided for comparison in tests
							if (current is LNamespace) {
								if (LNamespace(current).kind == NamespaceKind.PRIVATE_NAMESPACE) {
									if (LNamespace(current).name == item.name) {
										matchFound = true;
										break;
									}
								}
							}
						}
					} else {
						if (current == item) {
							matchFound = true;
							break;
						}
					}
				}

				return matchFound;
			});

			if (!contentsMatch) {
				throw new Error("Array contents to do not match.");
			}

			return true;
		}
	}
}
