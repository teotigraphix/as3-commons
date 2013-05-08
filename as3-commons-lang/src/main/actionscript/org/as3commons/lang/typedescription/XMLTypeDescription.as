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
import flash.utils.describeType;
import flash.utils.getQualifiedClassName;

import org.as3commons.lang.*;

public class XMLTypeDescription implements ITypeDescription {

	private var _clazz:Class;

	private var _instanceInfo:XML;
	private var _classInfo:XML;

	public function XMLTypeDescription(clazz:Class) {
		_clazz = clazz;

		_classInfo = describeType(clazz);
		_instanceInfo = _classInfo.factory[0];
	}

	public function get clazz():Class {
		return _clazz;
	}

	public function get classInfo():* {
		return _classInfo;
	}

	public function get instanceInfo():* {
		return _instanceInfo;
	}

	public function isImplementationOf(interfaze:Class):Boolean {
		var result:Boolean;

		if (clazz == null) {
			result = false;
		} else {
			result = (instanceInfo.implementsInterface.(@type == getQualifiedClassName(interfaze)).length() != 0);
		}
		return result;
	}

	public function isInformalImplementationOf(interfaze:Class):Boolean {
		var result:Boolean = true;

		if (interfaze == null) {
			result = false;
		} else {
			var interfaceInstanceInfo:XML = new XMLTypeDescription(interfaze).instanceInfo;

			// Test whether the interface's accessors have equivalent matches in the class
			var interfaceAccessors:XMLList = interfaceInstanceInfo.accessor;
			for each (var interfaceAccessor:XML in interfaceAccessors) {
				var accessorMatchesInClass:XMLList = instanceInfo.accessor.(@name == interfaceAccessor.@name && @access == interfaceAccessor.@access && @type == interfaceAccessor.@type)
				if (accessorMatchesInClass.length() < 1) {
					result = false;
					break;
				}
			}

			// Test whether the interface's methods and their parameters are found in the class
			var interfaceMethods:XMLList = interfaceInstanceInfo.method;
			for each (var interfaceMethod:XML in interfaceMethods) {
				var methodMatchesInClass:XMLList = instanceInfo.method.(@name == interfaceMethod.@name && @returnType == interfaceMethod.@returnType);
				if (methodMatchesInClass.length() < 1) {
					result = false;
					break;
				}
				var interfaceMethodParameters:XMLList = interfaceMethod.parameter;
				var classMethodParameters:XMLList = methodMatchesInClass.parameter;
				if (interfaceMethodParameters.length() != classMethodParameters.length()) {
					result = false;
				}
				for each (var interfaceParameter:XML in interfaceMethodParameters) {
					var parameterMatchesInClass:XMLList = methodMatchesInClass.parameter.(@index == interfaceParameter.@index && @type == interfaceParameter.@type && @optional == interfaceParameter.@optional);
					if (parameterMatchesInClass.length() < 1) {
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
		return (instanceInfo.extendsClass.(@type == parentName).length() != 0);
	}


	public function isInterface():Boolean {
		return (clazz === Object) ? false : (instanceInfo.extendsClass.length() == 0);
	}

	public function getFullyQualifiedImplementedInterfaceNames(replaceColons:Boolean = false):Array {
		var result:Array = [];
		var interfacesDescription:XMLList = instanceInfo.implementsInterface;

		if (interfacesDescription) {
			var numInterfaces:int = interfacesDescription.length();

			for (var i:int = 0; i < numInterfaces; i++) {
				var fullyQualifiedInterfaceName:String = interfacesDescription[i].@type.toString();

				if (replaceColons) {
					fullyQualifiedInterfaceName = ClassUtils.convertFullyQualifiedName(fullyQualifiedInterfaceName);
				}
				result[result.length] = fullyQualifiedInterfaceName;
			}
		}
		return result;
	}

	public function getProperties(statik:Boolean = false, readable:Boolean = true, writable:Boolean = true):Object {
		var xml:XML = (statik) ? classInfo : instanceInfo;
		var properties:XMLList;

		if (readable && writable) {
			// Only properties that are both read and writable
			properties = xml.accessor.(@access == Access.READ_WRITE) + xml.variable;
		} else if (!readable && !writable) {
			properties = new XMLList();
		} else if (!writable) {
			// All readable properties
			properties = xml.constant + xml.accessor.(@access == Access.READ_ONLY);
		} else {
			// All writable properties
			properties = xml.accessor.(@access == Access.WRITE_ONLY);
		}

		var result:Object = {};
		var node:XML;

		for each (node in properties) {
			var nodeClass:Class;
			try {
				nodeClass = ClassUtils.forName(node.@type);
			} catch (e:Error) {
				nodeClass = Object;
			}
			if (node.@uri && QName(node.@uri).localName != "") {
				result[node.@uri + "::" + node.@name] = nodeClass;
			} else {
				result[node.@name] = nodeClass;
			}
		}

		return result;
	}

	public function getSuperClass():Class {
		var result:Class;
		var superClasses:XMLList = instanceInfo.extendsClass;

		if (superClasses.length() > 0) {
			result = ClassUtils.forName(superClasses[0].@type);
		}

		return result;
	}

}
}
