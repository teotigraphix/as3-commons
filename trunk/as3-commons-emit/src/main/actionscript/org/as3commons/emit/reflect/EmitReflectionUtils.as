/*
 * Copyright (c) 2007-2009-2010 the original author or authors
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */
package org.as3commons.emit.reflect {
	import org.as3commons.emit.bytecode.BCNamespace;
	import org.as3commons.emit.bytecode.NamespaceKind;
	import org.as3commons.emit.bytecode.QualifiedName;
	import org.as3commons.reflect.INamespaceOwner;

	/**
	 *
	 * @author Andrew Lewisohn
	 */
	public class EmitReflectionUtils {

		/**
		 *
		 */
		public static function getMemberFullName(declaringType:EmitType, name:String):String {
			return (declaringType.isInterface) ? declaringType.fullName.concat("/", declaringType.fullName, ":", name) : declaringType.fullName.concat("/", name);
		}

		/**
		 *
		 */
		public static function getMemberQualifiedName(member:IEmitMember):QualifiedName {
			var namespaceURI:String = INamespaceOwner(member).namespaceURI;
			var packageName:String = EmitType(member.declaringType).packageName;

			return (member.visibility == EmitMemberVisibility.PUBLIC) ? new QualifiedName(new BCNamespace(namespaceURI, NamespaceKind.PACKAGE_NAMESPACE), member.name) : new QualifiedName(new BCNamespace(packageName + ":" + member.declaringType.name, member.visibility), member.name);
		}

		/**
		 *
		 */
		public static function getRequiredArgumentCount(method:EmitMethod):uint {
			var i:uint = 0;

			for (; i < method.parameters.length; i++) {
				var param:EmitParameter = method.parameters[i];

				if (param.isOptional) {
					return i;
				}
			}

			return method.parameters.length;
		}
	}
}