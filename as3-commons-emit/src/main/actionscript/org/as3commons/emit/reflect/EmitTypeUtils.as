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

	import org.as3commons.emit.SWFConstant;
	import org.as3commons.emit.bytecode.AbstractMultiname;
	import org.as3commons.emit.bytecode.BCNamespace;
	import org.as3commons.emit.bytecode.GenericName;
	import org.as3commons.emit.bytecode.MultipleNamespaceName;
	import org.as3commons.emit.bytecode.NamespaceKind;
	import org.as3commons.emit.bytecode.NamespaceSet;
	import org.as3commons.emit.bytecode.QualifiedName;
	import org.as3commons.lang.Assert;
	import org.as3commons.lang.ClassUtils;

	public class EmitTypeUtils {

		//--------------------------------------------------------------------------
		//
		//  Class properties
		//
		//--------------------------------------------------------------------------

		public static var _rest:EmitType;

		public static function get REST():EmitType {
			if (_rest == null) {
				_rest = new EmitType(null, new QualifiedName(BCNamespace.packageNS(SWFConstant.EMPTY_STRING), SWFConstant.PARAMS_IDENTIFIER));
			}
			return _rest;
		}

		public static var _untyped:EmitType;

		public static function get UNTYPED():EmitType {
			if (_untyped == null) {
				_untyped = new EmitType(null, new QualifiedName(BCNamespace.packageNS(SWFConstant.ASTERISK), SWFConstant.ASTERISK));
			}
			return _untyped;
		}

		public static var _void:EmitType;
		private static const genericExpr:RegExp = /^([^\<]+)\.\<.+\>$/;
		private static const paramsExpr:RegExp = /\<(.+)\>$/;
		private static const paramTypeNamesDelimiter:RegExp = /\s*,\s*/;

		public static function get VOID():EmitType {
			if (_void == null) {
				_void = new EmitType(null, new QualifiedName(BCNamespace.packageNS(SWFConstant.EMPTY_STRING), SWFConstant.VOID_IDENTIFIER));
			}
			return _void;
		}

		//--------------------------------------------------------------------------
		//
		//  Class methods
		//
		//--------------------------------------------------------------------------

		public static function getGenericName(genericTypeDefinition:EmitType, genericParams:Array):GenericName {
			Assert.notNull(genericTypeDefinition, "genericTypeDefinition argument must not be null");
			Assert.notNull(genericParams, "genericParams argument must not be null");
			genericParams = genericParams.map(function(type:EmitType, ... args):AbstractMultiname {
					return type.multiname;
				});

			return new GenericName(genericTypeDefinition.multiname, genericParams);
		}

		public static function getGenericTypeDefinition(typeName:String):EmitType {
			Assert.notNull(typeName, "typeName argument must not be null");
			var genericTypeName:String = genericExpr.exec(typeName)[1].toString();

			return EmitType.forName(genericTypeName);
		}

		public static function getGenericParameters(typeName:String):Array {
			Assert.notNull(typeName, "typeName argument must not be null");
			var genericParameters:Array = [];
			var result:Object = paramsExpr.exec(typeName);

			if (result != null) {
				// TODO: Update with correct delimiter
				var paramTypeNames:Array = result[1].toString().split(paramTypeNamesDelimiter);

				for each (var paramTypeName:String in paramTypeNames) {
					genericParameters.push(EmitType.forName(paramTypeName));
				}
			}

			return genericParameters;
		}

		public static function getMultiNamespaceName(qname:QualifiedName):MultipleNamespaceName {
			Assert.notNull(qname, "qname argument must not be null");
			return new MultipleNamespaceName(qname.name, new NamespaceSet([qname.ns]));
		}

		public static function getQualifiedName(typeName:String):QualifiedName {
			Assert.notNull(typeName, "typeName argument must not be null");
			var ns:String;
			var nsKind:uint;
			var name:String;

			if (typeName.indexOf(SWFConstant.DOUBLE_COLON) == -1) {
				ns = SWFConstant.EMPTY_STRING;
				nsKind = NamespaceKind.PACKAGE_NAMESPACE;
				name = typeName;
			} else {
				ns = typeName.substr(0, typeName.indexOf(SWFConstant.DOUBLE_COLON));
				name = typeName.substr(typeName.indexOf(SWFConstant.DOUBLE_COLON) + 2);
				nsKind = ClassUtils.isPrivateClass(ns) ? NamespaceKind.PRIVATE_NS : NamespaceKind.PACKAGE_NAMESPACE;
			}

			return new QualifiedName(new BCNamespace(ns, nsKind), name);
		}

		public static function getTypeNamespace(qname:QualifiedName):BCNamespace {
			Assert.notNull(qname, "qname argument must not be null");
			var typeNamespaceKind:uint = (qname.ns.kind == NamespaceKind.PACKAGE_NAMESPACE) ? NamespaceKind.NAMESPACE : NamespaceKind.PROTECTED_NAMESPACE;
			return new BCNamespace(qname.ns.name.concat(SWFConstant.COLON, qname.name), typeNamespaceKind);
		}
	}
}