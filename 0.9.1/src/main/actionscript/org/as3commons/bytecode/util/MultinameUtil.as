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
	import org.as3commons.bytecode.abc.BaseMultiname;
	import org.as3commons.bytecode.abc.LNamespace;
	import org.as3commons.bytecode.abc.Multiname;
	import org.as3commons.bytecode.abc.MultinameG;
	import org.as3commons.bytecode.abc.NamespaceSet;
	import org.as3commons.bytecode.abc.QualifiedName;
	import org.as3commons.bytecode.abc.enum.BuiltIns;
	import org.as3commons.bytecode.abc.enum.NamespaceKind;
	import org.as3commons.lang.StringUtils;

	public final class MultinameUtil {

		public static const DOUBLE_COLON:String = "::";
		public static const SINGLE_COLON:String = ":";
		public static const DOUBLE_COLON_REGEXP:RegExp = /[:]+/;
		public static const PERIOD:String = ".";
		public static const FORWARD_SLASH:String = "/";

		public static function toQualifiedName(className:String, kind:NamespaceKind = null):QualifiedName {
			var name:QualifiedName;
			kind = (kind == null) ? NamespaceKind.PACKAGE_NAMESPACE : kind;

			switch (className) {
				case BuiltIns.OBJECT.fullName:
					name = BuiltIns.OBJECT;
					break;
				case BuiltIns.ANY.fullName:
					name = BuiltIns.ANY;
					break;
				case BuiltIns.BOOLEAN.fullName:
					name = BuiltIns.BOOLEAN;
					break;
				case BuiltIns.VOID.fullName:
					name = BuiltIns.VOID;
					break;
				case BuiltIns.DICTIONARY.fullName:
					name = BuiltIns.DICTIONARY;
					break;
				case BuiltIns.FUNCTION.fullName:
					name = BuiltIns.FUNCTION;
					break;
				case BuiltIns.NUMBER.fullName:
					name = BuiltIns.NUMBER;
					break;
				case BuiltIns.STRING.fullName:
					name = BuiltIns.STRING;
					break;
				default:
					var portions:Array;
					var namespacePortion:String;
					var classNamePortion:String;
					if (className.match(DOUBLE_COLON_REGEXP) != null) {
						portions = className.split(DOUBLE_COLON_REGEXP);
						namespacePortion = portions[0];
						classNamePortion = portions[1];
					} else {
						portions = className.split(PERIOD);
						classNamePortion = String(portions.pop());
						namespacePortion = portions.join(PERIOD);
					}
					name = new QualifiedName(classNamePortion, toLNamespace(className, kind));
					break;
			}

			return name;
		}

		public static function toMultiName(className:String, kind:NamespaceKind = null):Multiname {
			kind = (kind != null) ? kind : NamespaceKind.PACKAGE_NAMESPACE;
			var portions:Array;
			var classNamePortion:String;
			if (className.match(DOUBLE_COLON_REGEXP) != null) {
				portions = className.split(DOUBLE_COLON_REGEXP);
				classNamePortion = portions[1];
			} else {
				portions = className.split(PERIOD);
				classNamePortion = String(portions.pop());
			}
			var namesp:LNamespace = toLNamespace(className, kind)
			var namespSet:NamespaceSet = new NamespaceSet([namesp]);
			return new Multiname(classNamePortion, namespSet);
		}

		public static function toLNamespace(className:String, kind:NamespaceKind):LNamespace {
			var namesp:LNamespace;

			switch (className) {
				case BuiltIns.OBJECT.fullName:
					namesp = BuiltIns.OBJECT.nameSpace;
					break;
				case BuiltIns.BOOLEAN.fullName:
					namesp = BuiltIns.BOOLEAN.nameSpace;
					break;
				case BuiltIns.ANY.fullName:
					namesp = BuiltIns.ANY.nameSpace;
					break;
				case BuiltIns.VOID.fullName:
					namesp = BuiltIns.VOID.nameSpace;
					break;
				case BuiltIns.DICTIONARY.fullName:
					namesp = BuiltIns.DICTIONARY.nameSpace;
					break;
				case BuiltIns.FUNCTION.fullName:
					namesp = BuiltIns.FUNCTION.nameSpace;
					break;
				case BuiltIns.NUMBER.fullName:
					namesp = BuiltIns.NUMBER.nameSpace;
					break;
				case BuiltIns.STRING.fullName:
					namesp = BuiltIns.STRING.nameSpace;
					break;
				default:
					var portions:Array;
					var namespacePortion:String;
					var classNamePortion:String;
					if (className.match(DOUBLE_COLON_REGEXP) != null) {
						portions = className.split(DOUBLE_COLON_REGEXP);
						namespacePortion = portions[0];
						classNamePortion = portions[1];
					} else {
						portions = className.split(PERIOD);
						classNamePortion = String(portions.pop());
						namespacePortion = portions.join(PERIOD);
					}
					if (kind == NamespaceKind.PACKAGE_NAMESPACE) {
						namesp = new LNamespace(kind, namespacePortion);
					} else {
						namesp = new LNamespace(kind, namespacePortion + ':' + classNamePortion);
					}
					break;
			}

			return namesp;
		}

		/**
		 * Returns the package part of a fully qualified name. Fully qualifed names are expected
		 * to be in either of these formats:
		 * <ul>
		 * <li>com.classes.test.MyClass</li>
		 * <li>com.classes.test:MyClass</li>
		 * <li>com.classes.test::MyClass</li>
		 * </ul>
		 * @param fullName The specified fully qualified name.
		 * @return The package name.
		 */
		public static function extractPackageName(fullName:String):String {
			var matches:Array = fullName.match(MultinameUtil.DOUBLE_COLON_REGEXP);
			if (matches != null) {
				return fullName.split(MultinameUtil.DOUBLE_COLON_REGEXP)[0];
			} else {
				var idx:int = fullName.lastIndexOf(MultinameUtil.PERIOD);
				return fullName.substr(0, idx);
			}
		}

		public static function convertToQualifiedName(classMultiname:BaseMultiname):QualifiedName {
			if (classMultiname is QualifiedName) {
				return classMultiname as QualifiedName;
			}

			var qualifiedName:QualifiedName = null;
			if (classMultiname is Multiname) {
				// A QualifiedName can only have one namespace, so we ensure that this is the case
				// before attempting conversion
				var classMultinameAsMultiname:Multiname = classMultiname as Multiname;
				if (classMultinameAsMultiname.namespaceSet.namespaces.length == 1) {
					qualifiedName = new QualifiedName(classMultinameAsMultiname.name, classMultinameAsMultiname.namespaceSet.namespaces[0]);
				} else {
					trace("Multiname " + classMultiname + " has more than 1 namespace in its namespace set - unable to convert to QualifiedName.");
				}
			} else if (classMultiname is MultinameG) {
				qualifiedName = (classMultiname as MultinameG).qualifiedName;
			}

			return qualifiedName;
		}

		public static function extractNamespaceNameFromMethodName(methodName:String):String {
			if (!StringUtils.hasText(methodName)) {
				return "";
			}
			var parts:Array = methodName.split(FORWARD_SLASH);
			if (parts.length > 1) {
				var name:String = String(parts[1]);
				var nameParts:Array = name.split(SINGLE_COLON);
				nameParts.pop();
				return nameParts.join(SINGLE_COLON);
			} else {
				return "";
			}
		}

	}
}