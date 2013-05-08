/*
 * Copyright (c) 2007-2013 the original author or authors
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
package org.as3commons.lang.typedescription {
import avmplus.DescribeType;
import avmplus.getQualifiedClassName;

import org.as3commons.lang.*;

public class JSONTypeDescription implements ITypeDescription {

	private static var _describeTypeJSON:Function = DescribeType.getJSONFunction();

	private var _clazz:Class;

	private var _instanceInfo:Object;
	private var _classInfo:Object;

	public function JSONTypeDescription(clazz:Class) {
		_clazz = clazz;

		_instanceInfo = _describeTypeJSON(clazz, DescribeType.GET_INSTANCE_INFO);
		_classInfo = _describeTypeJSON(clazz, DescribeType.GET_CLASS_INFO);
	}

	public function get clazz():Class {
		return _clazz;
	}

	public function get instanceInfo():* {
		return _instanceInfo;
	}

	public function get classInfo():* {
		return _classInfo;
	}

	public function isImplementationOf(interfaze:Class):Boolean {
		var result:Boolean;

		if (clazz == null) {
			result = false;
		} else {
			var interfaceName:String = getQualifiedClassName(interfaze);
			var interfaces:Array = instanceInfo.traits.interfaces;

			return ArrayUtils.contains(interfaces, interfaceName);
		}

		return result;
	}

	public function isInformalImplementationOf(interfaze:Class):Boolean {
		var result:Boolean = true;

		if (interfaze == null) {
			result = false;
		} else {
			var interfaceInstanceInfo:Object = new JSONTypeDescription(interfaze).instanceInfo;

			// Test whether the interface's accessors have equivalent matches in the class
			var interfaceAccessors:Array = interfaceInstanceInfo.traits.accessors;

			for each (var interfaceAccessor:XML in interfaceAccessors) {
				var accessorMatchesInClass:Array = getMembers(instanceInfo.traits.accessors, interfaceAccessor.name, interfaceAccessor.access, interfaceAccessor.type);

				if (ArrayUtils.isEmpty(accessorMatchesInClass)) {
					result = false;
					break;
				}
			}

			// Test whether the interface's methods and their parameters are found in the class
			var interfaceMethods:Array = interfaceInstanceInfo.traits.methods;

			for each (var interfaceMethod:Object in interfaceMethods) {
				var methodMatchesInClass:Array = getMethods(instanceInfo.traits.methods, interfaceMethod.name, interfaceMethod.returnType);

				if (ArrayUtils.isEmpty(methodMatchesInClass)) {
					result = false;
					break;
				}

				var interfaceMethodParameters:Array = interfaceMethod.parameters;
				var classMethodParameters:Array = methodMatchesInClass[0].parameters;

				if (interfaceMethodParameters.length != classMethodParameters.length) {
					result = false;
				}

				for (var i:int = 0; i < interfaceMethodParameters.length; i++) {
					var interfaceMethodParameter:Object = interfaceMethodParameters[i];
					var parameterMatchesInClass:Array = getParameters(classMethodParameters, i, interfaceMethodParameter.type, interfaceMethodParameter.optional);

					if (ArrayUtils.isEmpty(parameterMatchesInClass)) {
						result = false;
						break;
					}
				}
			}
		}

		return result;
	}

	public function isSubclassOf(parentClass:Class):Boolean {
		var parentName:String = getQualifiedClassName(parentClass);
		var baseClasses:Array = instanceInfo.traits.bases;

		return ArrayUtils.contains(baseClasses, parentName);
	}

	public function isInterface():Boolean {
		return (clazz === Object) ? false : (ArrayUtils.isEmpty(instanceInfo.traits.bases));
	}

	public function getFullyQualifiedImplementedInterfaceNames(replaceColons:Boolean = false):Array {
		var result:Array = [];
		var interfaces:Array = instanceInfo.traits.interfaces;

		if (!interfaces) {
			return result;
		}
		var i:int;
		var len:int = interfaces.length;
		for (i = 0; i < len; ++i) {
			var fullyQualifiedInterfaceName:String = interfaces[i];

			if (replaceColons) {
				fullyQualifiedInterfaceName = ClassUtils.convertFullyQualifiedName(fullyQualifiedInterfaceName);
			}

			result[result.length] = fullyQualifiedInterfaceName;
		}
		return result;
	}

	public function getProperties(statik:Boolean = false, readable:Boolean = true, writable:Boolean = true):Object {
		var info:Object = (statik) ? classInfo : instanceInfo;
		var properties:Array;

		if (readable && writable) {
			// Only properties that are both read and writable
			properties = getMembers(info.traits.accessors, Access.READ_WRITE).concat(getMembers(info.traits.variables, Access.READ_WRITE));
		} else if (!readable && !writable) {
			properties = [];
		} else if (!writable) {
			// All readable properties
			properties = getMembers(info.traits.accessors, Access.READ_ONLY).concat(getMembers(info.traits.variables, Access.READ_ONLY));
		} else {
			// All writable properties
			properties = getMembers(info.traits.accessors, Access.WRITE_ONLY).concat(getMembers(info.traits.variables, Access.WRITE_ONLY));
		}

		var result:Object = {};
		var node:Object;

		for each (node in properties) {
			var nodeClass:Class;

			try {
				nodeClass = ClassUtils.forName(node.type);
			} catch (e:Error) {
				nodeClass = Object;
			}
			if (node.uri && QName(node.uri).localName != "") {
				result[node.uri + "::" + node.name] = nodeClass;
			} else {
				result[node.name] = nodeClass;
			}
		}

		return result;
	}

	public function getSuperClass():Class {
		var result:Class;
		var superClasses:Array = instanceInfo.traits.bases;

		if (ArrayUtils.isNotEmpty(superClasses)) {
			result = ClassUtils.forName(superClasses[0]);
		}
		return result;
	}


	private function getMembers(members:Array, access:String = null, name:String = null, type:String = null):Array {
		var result:Array = [];

		if (!members) {
			return result;
		}

		var i:int;
		var len:int = members.length;
		var member:Object;

		for (i = 0; i < len; ++i) {
			member = members[i];

			var nameMatches:Boolean = (StringUtils.isNotEmpty(name)) ? member.name == name : true;
			var accessMatches:Boolean = (StringUtils.isNotEmpty(access)) ? member.access == access : true;
			var typeMatches:Boolean = (StringUtils.isNotEmpty(type)) ? member.type == type : true;

			if (nameMatches && accessMatches && typeMatches) {
				result[result.length] = member;
			}
		}

		return result;
	}

	private function getMethods(methods:Array, name:String = null, returnType:String = null):Array {
		var result:Array = [];

		if (!methods) {
			return result;
		}

		var i:int;
		var len:int = methods.length;
		var method:Object;

		for (i = 0; i < len; ++i) {
			method = methods[i];

			var nameMatches:Boolean = (StringUtils.isNotEmpty(name)) ? method.name == name : true;
			var returnTypeMatches:Boolean = (StringUtils.isNotEmpty(returnType)) ? method.returnType == returnType : true;

			if (nameMatches && returnTypeMatches) {
				result[result.length] = method;
			}
		}

		return result;
	}

	private function getParameters(params:Array, index:int, type:String, optional:Boolean = false):Array {
		var result:Array = [];

		if (!params) {
			return result;
		}

		var i:int;
		var len:int = params.length;
		var param:Object;

		for (i = 0; i < len; ++i) {
			param = params[i];

			var indexMatches:Boolean = (index == i);
			var typeMatches:Boolean = (StringUtils.isNotEmpty(type)) ? param.type == type : true;
			var optionalMatches:Boolean = (param.optional == optional);

			if (indexMatches && typeMatches && optionalMatches) {
				result[result.length] = param;
			}
		}

		return result;
	}

}
}
