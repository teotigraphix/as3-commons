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
package org.as3commons.reflect {

	import flash.system.ApplicationDomain;

	import org.as3commons.lang.ClassUtils;
	import org.as3commons.lang.StringUtils;
	import org.as3commons.reflect.Accessor;
	import org.as3commons.reflect.AccessorAccess;
	import org.as3commons.reflect.Constant;
	import org.as3commons.reflect.Constructor;
	import org.as3commons.reflect.IMember;
	import org.as3commons.reflect.IMetaDataContainer;
	import org.as3commons.reflect.INamespaceOwner;
	import org.as3commons.reflect.ITypeProvider;
	import org.as3commons.reflect.MetaData;
	import org.as3commons.reflect.MetaDataArgument;
	import org.as3commons.reflect.MetaDataContainer;
	import org.as3commons.reflect.Method;
	import org.as3commons.reflect.Parameter;
	import org.as3commons.reflect.ReflectionUtils;
	import org.as3commons.reflect.Type;
	import org.as3commons.reflect.TypeCache;
	import org.as3commons.reflect.Variable;
	import org.as3commons.reflect.as3commons_reflect;

	/**
	 * describeType XML parser
	 */
	public class XmlTypeProvider extends AbstractTypeProvider {


		public function XmlTypeProvider() {
			super();
		}

		/**
		 *
		 */
		private function concatMetadata(type:Type, metaDataContainers:Array, propertyName:String):void {
			for each (var container:IMetaDataContainer in metaDataContainers) {
				type[propertyName].some(function(item:MetaDataContainer, index:int, arr:Array):Boolean {
					if (Object(item).name == Object(container).name) {
						var metaDataList:Array = container.metaData;
						var numMetaData:int = metaDataList.length;
						for (var j:int = 0; j < numMetaData; j++) {
							if (!item.hasExactMetaData(metaDataList[j])) {
								item.addMetaData(metaDataList[j]);
							}
						}
						return true;
					}
					return false;
				});
			}
		}

		override public function getType(cls:Class, applicationDomain:ApplicationDomain):Type {
			var type:Type = new Type(applicationDomain);
			var fullyQualifiedClassName:String = org.as3commons.lang.ClassUtils.getFullyQualifiedName(cls);

			// Add the Type to the cache before assigning any values to prevent looping.
			// Due to the work-around implemented for constructor argument types
			// in getTypeDescription(), an instance is created, which could also
			// lead to infinite recursion if the constructor uses Type.forName().
			// Therefore it is important to seed the cache before calling
			// getTypeDescription (thanks to Jürgen Failenschmid for reporting this)
			typeCache.put(fullyQualifiedClassName, type);
			var description:XML = ReflectionUtils.getTypeDescription(cls);
			type.fullName = fullyQualifiedClassName;
			type.name = org.as3commons.lang.ClassUtils.getNameFromFullyQualifiedName(fullyQualifiedClassName);
			type.clazz = cls;
			type.isDynamic = (description.@isDynamic.toString() == "true");
			type.isFinal = (description.@isFinal.toString() == "true");
			type.isStatic = (description.@isStatic.toString() == "true");
			type.alias = description.@alias;
			type.isInterface = (cls === Object) ? false : (description.factory.extendsClass.length() == 0);
			type.constructor = parseConstructor(type, description.factory.constructor, applicationDomain);
			type.accessors = parseAccessors(type, description, applicationDomain);
			type.methods = parseMethods(type, description, applicationDomain);
			type.staticConstants = parseMembers(Constant, description.constant, fullyQualifiedClassName, true, applicationDomain);
			type.constants = parseMembers(Constant, description.factory.constant, fullyQualifiedClassName, false, applicationDomain);
			type.staticVariables = parseMembers(Variable, description.variable, fullyQualifiedClassName, true, applicationDomain);
			type.variables = parseMembers(Variable, description.factory.variable, fullyQualifiedClassName, false, applicationDomain);
			type.extendsClasses = parseExtendsClasses(description.factory.extendsClass, type.applicationDomain);
			parseMetaData(description.factory[0].metadata, type);
			type.interfaces = parseImplementedInterfaces(description.factory.implementsInterface);

			// Combine metadata from implemented interfaces
			var numInterfaces:int = type.interfaces.length;
			for (var i:int = 0; i < numInterfaces; i++) {
				var interfaze:Type = Type.forName(type.interfaces[i], applicationDomain);
				concatMetadata(type, interfaze.methods, "methods");
				concatMetadata(type, interfaze.accessors, "accessors");
				var interfaceMetaData:Array = interfaze.metaData;
				var numMetaData:int = interfaceMetaData.length;

				for (var j:int = 0; j < numMetaData; j++) {
					if (!type.hasExactMetaData(interfaceMetaData[j])) {
						type.addMetaData(interfaceMetaData[j]);
					}
				}
			}

			type.createMetaDataLookup();

			return type;
		}

		/**
		 *
		 */
		private function parseConstructor(type:Type, constructorXML:XMLList, applicationDomain:ApplicationDomain):Constructor {
			if (constructorXML.length() > 0) {
				var params:Array = parseParameters(constructorXML[0].parameter, applicationDomain);
				return new Constructor(type.fullName, applicationDomain, params);
			} else {
				return new Constructor(type.fullName, applicationDomain);
			}
		}

		/**
		 *
		 */
		private function parseMethods(type:Type, xml:XML, applicationDomain:ApplicationDomain):Array {
			var classMethods:Array = parseMethodsByModifier(type, xml.method, true, applicationDomain);
			var instanceMethods:Array = parseMethodsByModifier(type, xml.factory.method, false, applicationDomain);
			return classMethods.concat(instanceMethods);
		}

		/**
		 *
		 */
		private function parseAccessors(type:Type, xml:XML, applicationDomain:ApplicationDomain):Array {
			var classAccessors:Array = parseAccessorsByModifier(type, xml.accessor, true, applicationDomain);
			var instanceAccessors:Array = parseAccessorsByModifier(type, xml.factory.accessor, false, applicationDomain);
			return classAccessors.concat(instanceAccessors);
		}

		/**
		 *
		 */
		private function parseMembers(memberClass:Class, members:XMLList, declaringType:String, isStatic:Boolean, applicationDomain:ApplicationDomain):Array {
			var result:Array = [];

			for each (var m:XML in members) {
				var member:IMember = new memberClass(m.@name, m.@type.toString(), declaringType, isStatic, applicationDomain);
				if (member is INamespaceOwner) {
					INamespaceOwner(member).as3commons_reflect::setNamespaceURI(m.@uri.toString());
				}
				parseMetaData(m.metadata, member);
				result[result.length] = member;
			}
			return result;
		}

		private function parseImplementedInterfaces(interfacesDescription:XMLList):Array {
			var result:Array = [];

			if (interfacesDescription) {
				var numInterfaces:int = interfacesDescription.length();
				for (var i:int = 0; i < numInterfaces; i++) {
					var fullyQualifiedInterfaceName:String = interfacesDescription[i].@type.toString();
					fullyQualifiedInterfaceName = org.as3commons.lang.ClassUtils.convertFullyQualifiedName(fullyQualifiedInterfaceName);
					result[result.length] = fullyQualifiedInterfaceName;
				}
			}
			return result;

		}

		/**
		 *
		 */
		private function parseExtendsClasses(extendedClasses:XMLList, applicationDomain:ApplicationDomain):Array {
			var result:Array = [];
			for each (var node:XML in extendedClasses) {
				result[result.length] = node.@type.toString();
			}
			return result;
		}

		private function parseMethodsByModifier(type:Type, methodsXML:XMLList, isStatic:Boolean, applicationDomain:ApplicationDomain):Array {
			var result:Array = [];

			for each (var methodXML:XML in methodsXML) {
				var params:Array = parseParameters(methodXML.parameter, applicationDomain);
				var method:Method = new Method(type.fullName, methodXML.@name, isStatic, params, methodXML.@returnType, applicationDomain);
				method.as3commons_reflect::setNamespaceURI(methodXML.@uri);
				parseMetaData(methodXML.metadata, method);
				result[result.length] = method;
			}
			return result;
		}

		private function parseParameters(paramsXML:XMLList, applicationDomain:ApplicationDomain):Array {
			var params:Array = [];

			for each (var paramXML:XML in paramsXML) {
				var param:Parameter = new Parameter(paramXML.@index, paramXML.@type, applicationDomain, paramXML.@optional == "true" ? true : false);
				params[params.length] = param;
			}

			return params;
		}

		private function parseAccessorsByModifier(type:Type, accessorsXML:XMLList, isStatic:Boolean, applicationDomain:ApplicationDomain):Array {
			var result:Array = [];

			for each (var accessorXML:XML in accessorsXML) {
				var accessor:Accessor = new Accessor(accessorXML.@name, AccessorAccess.fromString(accessorXML.@access), accessorXML.@type.toString(), accessorXML.@declaredBy.toString(), isStatic, applicationDomain);
				if (StringUtils.hasText(accessorXML.@uri)) {
					accessor.as3commons_reflect::setNamespaceURI(accessorXML.@uri.toString());
				}
				parseMetaData(accessorXML.metadata, accessor);
				result[result.length] = accessor;
			}
			return result;
		}

		/**
		 * Parses MetaData objects from the given metaDataNodes XML data and adds them to the given metaData array.
		 */
		private function parseMetaData(metaDataNodes:XMLList, metaData:IMetaDataContainer):void {
			for each (var metaDataXML:XML in metaDataNodes) {
				var metaDataArgs:Array = [];

				for each (var metaDataArgNode:XML in metaDataXML.arg) {
					metaDataArgs[metaDataArgs.length] = new MetaDataArgument(metaDataArgNode.@key, metaDataArgNode.@value);
				}
				metaData.addMetaData(new MetaData(metaDataXML.@name, metaDataArgs));
			}
		}
	}
}