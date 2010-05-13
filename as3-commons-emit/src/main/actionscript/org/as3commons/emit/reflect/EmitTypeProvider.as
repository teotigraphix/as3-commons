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
	import flash.system.ApplicationDomain;
	import flash.utils.getQualifiedClassName;

	import org.as3commons.emit.SWFConstant;
	import org.as3commons.emit.bytecode.AbstractMultiname;
	import org.as3commons.emit.bytecode.QualifiedName;
	import org.as3commons.lang.Assert;
	import org.as3commons.lang.ClassUtils;
	import org.as3commons.reflect.AccessorAccess;
	import org.as3commons.reflect.Constructor;
	import org.as3commons.reflect.IMember;
	import org.as3commons.reflect.IMetaDataContainer;
	import org.as3commons.reflect.ITypeProvider;
	import org.as3commons.reflect.MetaData;
	import org.as3commons.reflect.MetaDataArgument;
	import org.as3commons.reflect.ReflectionUtils;
	import org.as3commons.reflect.Type;
	import org.as3commons.reflect.TypeCache;

	/**
	 * Internal xml parser
	 */
	internal class EmitTypeProvider implements ITypeProvider {

		private static const METHODS_COLLECTION_NAME:String = "methods";
		private static const ACCESSORS_COLLECTION_NAME:String = "accessors";
		private static const TRUE:String = "true";
		private static const ARG:String = "arg";
		private static var _typeCache:TypeCache;

		public function EmitTypeProvider() {
			_typeCache = new TypeCache();
		}

		public function clearCache():void {
			_typeCache.clear();
		}

		public function getType(cls:Class, applicationDomain:ApplicationDomain):Type {
			Assert.notNull(cls, "cls argument must not be null");
			var fullyQualifiedClassName:String = ClassUtils.getFullyQualifiedName(cls);
			var description:XML = ReflectionUtils.getTypeDescription(cls);
			var typeName:String = description.@name.toString();
			var genericParams:Array = EmitTypeUtils.getGenericParameters(typeName)
			var typeDefinition:EmitType = (genericParams.length > 0) ? org.as3commons.emit.reflect.EmitTypeUtils.getGenericTypeDefinition(typeName) : null;

			if (typeDefinition != null) {
				typeDefinition.genericParameters = genericParams;
			}

			var qname:QualifiedName = EmitTypeUtils.getQualifiedName(description.@name.toString());
			var multiname:AbstractMultiname = (typeDefinition != null) ? org.as3commons.emit.reflect.EmitTypeUtils.getGenericName(typeDefinition, genericParams) : qname;
			var type:EmitType = new EmitType(applicationDomain, qname, multiname, cls);

			// Add the Type to the cache before assigning any values to prevent looping.
			// Due to the work-around implemented for constructor argument types
			// in getTypeDescription(), an instance is created, which could also
			// lead to infinite recursion if the constructor uses Type.forName().
			// Therefore it is important to seed the cache before calling
			// getTypeDescription (thanks to Jürgen Failenschmid for reporting this)
			_typeCache.put(fullyQualifiedClassName, type);

			type.alias = description.@alias;
			type.clazz = cls;
			type.isDynamic = (description.@isDynamic.toString() == TRUE);
			type.isFinal = (description.@isFinal.toString() == TRUE);
			type.isInterface = (cls === Object) ? false : (description.factory.extendsClass.length() == 0);
			type.isStatic = (description.@isStatic.toString() == TRUE);
			type.extendsClasses = parseExtendsClasses(description.factory.extendsClass, type.applicationDomain);
			type.superClassType = (type.extendsClasses.length > 0 && !type.isInterface && type.clazz !== Object) ? EmitType.forName(getQualifiedClassName(type.extendsClasses[0]), applicationDomain) : null;

			type.accessors = parseAccessors(type, description);
			type.constants = parseMembers(EmitConstant, description.factory.constant, type, false);
			type.constructor = parseConstructor(type, description.factory.constructor, applicationDomain);
			type.constructorMethod = new EmitMethod(type, "ctor", null, EmitMemberVisibility.PUBLIC, false, false, type.constructor.parameters, EmitTypeUtils.UNTYPED, []);
			type.interfaces = ClassUtils.getImplementedInterfaces(cls, applicationDomain);
			type.methods = parseMethods(type, description, applicationDomain);
			type.staticConstants = parseMembers(EmitConstant, description.constant, type, true);
			type.staticVariables = parseMembers(EmitVariable, description.variable, type, true);
			type.variables = parseMembers(EmitVariable, description.factory.variable, type, false);
			parseMetaData(description.factory[0].metadata, type);

			// Combine metadata from implemented interfaces
			var interfaces:Array = type.interfaces;
			var numInterfaces:int = interfaces.length;

			for (var i:int = 0; i < numInterfaces; i++) {
				var interfaze:EmitType = EmitType.forClass(interfaces[i], applicationDomain);
				ReflectionUtils.concatTypeMetadata(type, interfaze.methods, METHODS_COLLECTION_NAME);
				ReflectionUtils.concatTypeMetadata(type, interfaze.accessors, ACCESSORS_COLLECTION_NAME);
				var interfaceMetaData:Array = interfaze.metaData;
				var numMetaData:int = interfaceMetaData.length;

				for (var j:int = 0; j < numMetaData; j++) {
					type.addMetaData(interfaceMetaData[j]);
				}
			}

			return type;
		}

		public function getTypeCache():TypeCache {
			return _typeCache;
		}

		/**
		 *
		 */
		private function parseConstructor(type:EmitType, constructorXML:XMLList, applicationDomain:ApplicationDomain):Constructor {
			Assert.notNull(type, "type argument must not be null");
			Assert.notNull(constructorXML, "constructorXML argument must not be null");
			if (constructorXML.length() > 0) {
				var params:Array = parseParameters(constructorXML[0].parameter, applicationDomain);
				return new Constructor(type, params);
			} else {
				return new Constructor(type);
			}
		}

		/**
		 *
		 */
		private function parseMethods(type:EmitType, xml:XML, applicationDomain:ApplicationDomain):Array {
			Assert.notNull(type, "type argument must not be null");
			Assert.notNull(xml, "xml argument must not be null");
			var classMethods:Array = parseMethodsByModifier(type, xml.method, true, applicationDomain);
			var instanceMethods:Array = parseMethodsByModifier(type, xml.factory.method, false, applicationDomain);
			return classMethods.concat(instanceMethods);
		}

		/**
		 *
		 */
		private function parseAccessors(type:EmitType, xml:XML):Array {
			Assert.notNull(type, "type argument must not be null");
			Assert.notNull(xml, "xml argument must not be null");
			var classAccessors:Array = parseAccessorsByModifier(type, xml.accessor, true);
			var instanceAccessors:Array = parseAccessorsByModifier(type, xml.factory.accessor, false);
			return classAccessors.concat(instanceAccessors);
		}

		/**
		 *
		 */
		private function parseMembers(memberClass:Class, members:XMLList, declaringType:EmitType, isStatic:Boolean):Array {
			Assert.notNull(memberClass, "memberClass argument must not be null");
			Assert.notNull(members, "members argument must not be null");
			Assert.notNull(declaringType, "declaringType argument must not be null");
			var result:Array = [];

			for each (var m:XML in members) {
				var uri:String = m.@uri.toString();
				var name:String = m.@name.toString();
				var type:EmitType = EmitType.forName(m.@type.toString());
				var member:IMember = new memberClass(declaringType, name, EmitReflectionUtils.getMemberFullName(declaringType, name), type, EmitMemberVisibility.PUBLIC, isStatic, uri);

				parseMetaData(m.metadata, member);
				result.push(member);
			}
			return result;
		}

		/**
		 *
		 */
		private function parseExtendsClasses(extendedClasses:XMLList, applicationDomain:ApplicationDomain):Array {
			Assert.notNull(extendedClasses, "extendedClasses argument must not be null");
			var result:Array = [];
			for each (var node:XML in extendedClasses) {
				var cls:Class = ClassUtils.forName(node.@type.toString(), applicationDomain);
				if (cls != null) {
					result[result.length] = cls;
				}
			}
			return result;
		}

		private function parseMethodsByModifier(type:EmitType, methodsXML:XMLList, isStatic:Boolean, applicationDomain:ApplicationDomain):Array {
			Assert.notNull(type, "type argument must not be null");
			Assert.notNull(methodsXML, "methodsXML argument must not be null");
			var result:Array = [];

			for each (var methodXML:XML in methodsXML) {
				if (methodXML.@declaredBy.toString().replace(SWFConstant.DOUBLE_COLON, SWFConstant.COLON) != type.fullName) {
					continue;
				}

				var uri:String = methodXML.@uri.toString();
				var name:String = methodXML.@name.toString();
				var isOverride:Boolean = (type.superClassType != null && type.superClassType.getDeclaredMethod(name) != null);
				var params:Array = parseParameters(methodXML.parameter, applicationDomain);
				var returnType:EmitType = EmitType.forName(methodXML.@returnType, applicationDomain);
				var method:EmitMethod = new EmitMethod(type, name, EmitReflectionUtils.getMemberFullName(type, name), EmitMemberVisibility.PUBLIC, isStatic, isOverride, params, returnType, [], uri);

				parseMetaData(methodXML.metadata, method);
				result.push(method);
			}
			return result;
		}

		private function parseParameters(paramsXML:XMLList, applicationDomain:ApplicationDomain):Array {
			Assert.notNull(paramsXML, "paramsXML argument must not be null");
			var params:Array = [];
			for each (var paramXML:XML in paramsXML) {
				var index:int = parseInt(paramXML.@index);
				var isOptional:Boolean = (paramXML.@optional == TRUE);
				var name:String = ARG + index.toString();
				var type:EmitType = EmitType.forName(paramXML.@type, applicationDomain);
				var param:EmitParameter = new EmitParameter(name, index, type, isOptional);
				params.push(param);
			}
			return params;
		}

		private function parseAccessorsByModifier(type:EmitType, accessorsXML:XMLList, isStatic:Boolean):Array {
			Assert.notNull(type, "type argument must not be null");
			Assert.notNull(accessorsXML, "accessorsXML argument must not be null");
			var result:Array = [];

			for each (var accessorXML:XML in accessorsXML) {
				if (accessorXML.@declaredBy.toString().replace(SWFConstant.DOUBLE_COLON, SWFConstant.COLON) != type.fullName) {
					continue;
				}

				var uri:String = accessorXML.@uri.toString();
				var name:String = accessorXML.@name.toString();
				var access:AccessorAccess = AccessorAccess.fromString(accessorXML.@access);
				var valueType:EmitType = EmitType.forName(accessorXML.@type.toString(), type.applicationDomain);
				var isOverride:Boolean = (type.superClassType != null && type.superClassType.getDeclaredProperty(name) != null);
				var accessor:EmitAccessor = new EmitAccessor(type, name, EmitReflectionUtils.getMemberFullName(type, name), access, valueType, EmitMemberVisibility.PUBLIC, isStatic, isOverride, [], uri);

				parseMetaData(accessorXML.metadata, accessor);
				result.push(accessor);
			}
			return result;
		}

		/**
		 * Parses MetaData objects from the given metaDataNodes XML data and adds them to the given metaData array.
		 */
		private function parseMetaData(metaDataNodes:XMLList, metaData:IMetaDataContainer):void {
			Assert.notNull(metaDataNodes, "metaDataNodes argument must not be null");
			Assert.notNull(metaData, "metaData argument must not be null");
			for each (var metaDataXML:XML in metaDataNodes) {
				var metaDataArgs:Array = [];

				for each (var metaDataArgNode:XML in metaDataXML.arg) {
					metaDataArgs.push(new MetaDataArgument(metaDataArgNode.@key, metaDataArgNode.@value));
				}
				metaData.addMetaData(new MetaData(metaDataXML.@name, metaDataArgs));
			}
		}
	}
}