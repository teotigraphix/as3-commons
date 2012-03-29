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
package org.as3commons.bytecode.error {

	/**
	 * Thrown when a Multiname cannot be converted to a QualifiedName.
	 *
	 * <p>
	 * There are a few cases where Multinames are present in ABC files where a QualifiedName is expected by the
	 * spec, so in these cases we attempt to convert them to a QualifiedName. If this conversion fails for whatever
	 * reason, this error is thrown.
	 * </p>
	 *
	 * @see org.as3commons.bytecode.abc.Multiname
	 * @see org.as3commons.bytecode.abc.QualifiedName
	 */
	public class MultinameConversionError extends Error {
		public function MultinameConversionError(message:String = "", id:int = 0) {
			super(message, id);
		}
	}
}