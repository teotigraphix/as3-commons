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
package org.as3commons.reflect {
	import flash.system.ApplicationDomain;

	import org.as3commons.lang.ClassUtils;
	import org.as3commons.lang.StringUtils;

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
		private function concatMetadata(type:Type, metadataContainers:Array, propertyName:String):void {
			for each (var container:IMetadataContainer in metadataContainers) {
				type[propertyName].some(function(item:MetadataContainer, index:int, arr:Array):Boolean {
					if (Object(item).name == Object(container).name) {
						var metadataList:Array = container.metadata;
						var numMetadata:int = metadataList.length;
						for (var j:int = 0; j < numMetadata; j++) {
							if (!item.hasExactMetadata(metadataList[j])) {
								item.addMetadata(metadataList[j]);
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
			var fullyQualifiedClassName:String = ClassUtils.getFullyQualifiedName(cls);

			// Add the Type to the cache before assigning any values to prevent looping.
			// Due to the work-around implemented for constructor argument types
			// in getTypeDescription(), an instance is created, which could also
			// lead to infinite recursion if the constructor uses Type.forName().
			// Therefore it is important to seed the cache before calling
			// getTypeDescription (thanks to Jürgen Failenschmid for reporting this)
			typeCache.put(fullyQualifiedClassName, type);
			var description:XML = ReflectionUtils.getTypeDescription(cls);
			type.fullName = fullyQualifiedClassName;
			type.name = ClassUtils.getNameFromFullyQualifiedName(fullyQualifiedClassName);
			var param:Class = ClassUtils.getClassParameterFromFullyQualifiedName(description.@name, applicationDomain);
			if (param != null) {
				type.parameters[type.parameters.length] = param;
			}
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
			parseMetadata(description.factory[0].metadata, type);
			type.interfaces = parseImplementedInterfaces(description.factory.implementsInterface);

			// Combine metadata from implemented interfaces
			var numInterfaces:int = type.interfaces.length;
			for (var i:int = 0; i < numInterfaces; i++) {
				var interfaze:Type = Type.forName(type.interfaces[i], applicationDomain);
				concatMetadata(type, interfaze.methods, "methods");
				concatMetadata(type, interfaze.accessors, "accessors");
				var interfaceMetadata:Array = interfaze.metadata;
				var numMetadata:int = interfaceMetadata.length;

				for (var j:int = 0; j < numMetadata; j++) {
					if (!type.hasExactMetadata(interfaceMetadata[j])) {
						type.addMetadata(interfaceMetadata[j]);
					}
				}
			}

			type.createMetadataLookup();

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
				parseMetadata(m.metadata, member);
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
					fullyQualifiedInterfaceName = ClassUtils.convertFullyQualifiedName(fullyQualifiedInterfaceName);
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
				parseMetadata(methodXML.metadata, method);
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
				var accessor:Accessor = Accessor.newInstance(accessorXML.@name, AccessorAccess.fromString(accessorXML.@access), accessorXML.@type.toString(), accessorXML.@declaredBy.toString(), isStatic, applicationDomain);
				if (StringUtils.hasText(accessorXML.@uri)) {
					accessor.as3commons_reflect::setNamespaceURI(accessorXML.@uri.toString());
				}
				parseMetadata(accessorXML.metadata, accessor);
				result[result.length] = accessor;
			}
			return result;
		}

		/**
		 * Parses Metadata objects from the given metadataNodes XML data and adds them to the given metadata array.
		 */
		private function parseMetadata(metadataNodes:XMLList, metadata:IMetadataContainer):void {
			for each (var metadataXML:XML in metadataNodes) {
				var metadataArgs:Array = [];

				for each (var metadataArgNode:XML in metadataXML.arg) {
					metadataArgs[metadataArgs.length] = MetadataArgument.newInstance(metadataArgNode.@key, metadataArgNode.@value);
				}
				metadata.addMetadata(Metadata.newInstance(metadataXML.@name, metadataArgs));
			}
		}
	}
}
