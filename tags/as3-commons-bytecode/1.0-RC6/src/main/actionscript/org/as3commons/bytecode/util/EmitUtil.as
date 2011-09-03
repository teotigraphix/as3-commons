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
package org.as3commons.bytecode.util {
	import flash.utils.Dictionary;

	import org.as3commons.bytecode.abc.LNamespace;
	import org.as3commons.bytecode.abc.QualifiedName;
	import org.as3commons.bytecode.abc.enum.NamespaceKind;
	import org.as3commons.bytecode.emit.enum.MemberVisibility;
	import org.as3commons.lang.Assert;

	public final class EmitUtil {

		protected static const NAMESPACEKIND_LOOKUP:Dictionary = new Dictionary();
		{
			NAMESPACEKIND_LOOKUP[NamespaceKind.PACKAGE_NAMESPACE] = MemberVisibility.PUBLIC;
			NAMESPACEKIND_LOOKUP[NamespaceKind.PRIVATE_NAMESPACE] = MemberVisibility.PRIVATE;
			NAMESPACEKIND_LOOKUP[NamespaceKind.PACKAGE_INTERNAL_NAMESPACE] = MemberVisibility.INTERNAL;
			NAMESPACEKIND_LOOKUP[NamespaceKind.PROTECTED_NAMESPACE] = MemberVisibility.PROTECTED;
		}

		public static function getMemberVisibilityFromQualifiedName(qualifiedName:QualifiedName):MemberVisibility {
			CONFIG::debug {
				Assert.notNull(qualifiedName, "qualifiedName argument must not be null");
			}
			return getMemberVisibilityFromNamespace(qualifiedName.nameSpace);
		}

		public static function getMemberVisibilityFromNamespace(namespace:LNamespace):MemberVisibility {
			CONFIG::debug {
				Assert.notNull(namespace, "namespace argument must not be null");
			}
			return NAMESPACEKIND_LOOKUP[namespace.kind] as MemberVisibility;
		}

	}
}