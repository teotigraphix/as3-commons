/*
 * Copyright 2007-2010 the original author or authors.
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
package org.as3commons.bytecode.emit.util {
	import flash.errors.IllegalOperationError;

	import org.as3commons.bytecode.abc.enum.ConstantKind;
	import org.as3commons.lang.ClassUtils;

	public final class BuildUtil {
		private static const ILLEGAL_DEFAULT_TYPE:String = "Type of instance cannot be used as a default argument value: ";

		public static function toConstantKind(instance:Object):ConstantKind {
			if (instance is int) {
				return ConstantKind.INT;
			} else if (instance is uint) {
				return ConstantKind.UINT;
			} else if (instance is Number) {
				return ConstantKind.DOUBLE;
			} else if (instance is Boolean) {
				return (instance == true) ? ConstantKind.TRUE : ConstantKind.FALSE;
			} else if (instance == null) {
				return ConstantKind.NULL;
			}
			throw new IllegalOperationError(ILLEGAL_DEFAULT_TYPE + instance.toString());
		}
	}
}