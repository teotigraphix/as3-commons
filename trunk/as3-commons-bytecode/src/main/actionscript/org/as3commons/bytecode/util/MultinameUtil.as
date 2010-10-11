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
package org.as3commons.bytecode.util {
	import org.as3commons.bytecode.abc.LNamespace;
	import org.as3commons.bytecode.abc.QualifiedName;
	import org.as3commons.bytecode.abc.enum.BuiltIns;
	import org.as3commons.bytecode.abc.enum.NamespaceKind;

	public final class MultinameUtil {

		public static const OBJECT_NAME:String = "Object";
		public static const DOUBLE_COLON:String = "::";
		public static const PERIOD:String = ".";

		public static function toQualifiedName(className:String):QualifiedName {
			var name:QualifiedName;

			switch (className) {
				case OBJECT_NAME:
					name = BuiltIns.OBJECT;
					break;
				default:
					var portions:Array;
					var namespacePortion:String;
					var classNamePortion:String;
					if (className.indexOf(DOUBLE_COLON) > -1) {
						portions = className.split(DOUBLE_COLON);
						namespacePortion = portions[0];
						classNamePortion = portions[1];
					} else {
						portions = className.split(PERIOD);
						classNamePortion = String(portions.pop());
						namespacePortion = portions.join(PERIOD);
					}
					name = new QualifiedName(classNamePortion, new LNamespace(NamespaceKind.PROTECTED_NAMESPACE, namespacePortion));
					break;
			}

			return name;
		}

	}
}