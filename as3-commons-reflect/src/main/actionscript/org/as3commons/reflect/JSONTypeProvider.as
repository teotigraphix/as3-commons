package org.as3commons.reflect {
	import avmplus.DescribeType;

	import flash.errors.IllegalOperationError;
	import flash.system.ApplicationDomain;

	import org.as3commons.lang.ClassUtils;

	public class JSONTypeProvider extends AbstractTypeProvider {

		private var _describeTypeJSON:Function;

		/**
		 * describeTypeJSON JSON parser
		 */
		public function JSONTypeProvider() {
			super();
			initJSONTypeProvider();
		}

		protected function initJSONTypeProvider():void {
			_describeTypeJSON = DescribeType.getJSONFunction();
			if (_describeTypeJSON == null) {
				throw new IllegalOperationError("describeTypeJSON not supported in currently installed flash player");
			}
		}

		override public function getType(cls:Class, applicationDomain:ApplicationDomain):Type {
			var type:Type = new Type(applicationDomain);
			var fullyQualifiedClassName:String = org.as3commons.lang.ClassUtils.getFullyQualifiedName(cls, true);

			// Add the Type to the cache before assigning any values to prevent looping.
			// Due to the work-around implemented for constructor argument types
			// in getTypeDescription(), an instance is created, which could also
			// lead to infinite recursion if the constructor uses Type.forName().
			// Therefore it is important to seed the cache before calling
			// getTypeDescription (thanks to Jürgen Failenschmid for reporting this)
			typeCache.put(fullyQualifiedClassName, type);
			var instanceInfo:Object = _describeTypeJSON(cls, DescribeType.GET_INSTANCE_INFO);
			var classInfo:Object = _describeTypeJSON(cls, DescribeType.GET_CLASS_INFO);
			type.fullName = fullyQualifiedClassName;
			type.name = org.as3commons.lang.ClassUtils.getNameFromFullyQualifiedName(fullyQualifiedClassName);
			type.clazz = cls;
			type.isDynamic = instanceInfo.isDynamic;
			type.isFinal = instanceInfo.isFinal;
			type.isStatic = instanceInfo.isStatic;
			type.alias = instanceInfo.alias;
			type.isInterface = false;
			type.constructor = parseConstructor(type, instanceInfo.traits.constructor, applicationDomain);
			type.accessors = parseAccessors(type, instanceInfo.traits.accessors, applicationDomain, false).concat(parseAccessors(type, classInfo.traits.accessors, applicationDomain, true));
			type.methods = parseMethods(type, instanceInfo.traits.methods, applicationDomain, false).concat(parseMethods(type, classInfo.traits.methods, applicationDomain, true));
			type.staticConstants = parseMembers(Constant, classInfo.traits.variables, fullyQualifiedClassName, true, true, applicationDomain);
			type.constants = parseMembers(Constant, instanceInfo.traits.variables, fullyQualifiedClassName, false, true, applicationDomain);
			type.staticVariables = parseMembers(Variable, classInfo.traits.variables, fullyQualifiedClassName, true, false, applicationDomain);
			type.variables = parseMembers(Variable, instanceInfo.traits.variables, fullyQualifiedClassName, false, false, applicationDomain);
			type.extendsClasses = instanceInfo.traits.bases.concat();
			parseMetaData(instanceInfo.traits.metadata, type);
			type.interfaces = parseImplementedInterfaces(instanceInfo.traits.interfaces);

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

		protected function parseConstructor(type:Type, constructor:Array, applicationDomain:ApplicationDomain):Constructor {
			if ((constructor != null) && (constructor.length > 0)) {
				var params:Array = parseParameters(constructor, applicationDomain);
				return new Constructor(type.fullName, applicationDomain, params);
			} else {
				return new Constructor(type.fullName, applicationDomain);
			}
		}

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

		private function parseImplementedInterfaces(interfacesDescription:Array):Array {
			var result:Array = [];
			if (interfacesDescription != null) {
				for each (var fullyQualifiedInterfaceName:String in interfacesDescription) {
					result[result.length] = org.as3commons.lang.ClassUtils.convertFullyQualifiedName(fullyQualifiedInterfaceName);
				}
			}
			return result;
		}

		private function parseMethods(type:Type, methods:Array, applicationDomain:ApplicationDomain, isStatic:Boolean):Array {
			var result:Array = [];

			for each (var methodObj:Object in methods) {
				var params:Array = parseParameters(methodObj.parameters, applicationDomain);
				var method:Method = new Method(type.fullName, methodObj.name, isStatic, params, methodObj.returnType, applicationDomain);
				method.as3commons_reflect::setNamespaceURI(methodObj.uri);
				parseMetaData(methodObj.metadata, method);
				result.push(method);
			}
			return result;
		}

		private function parseParameters(params:Array, applicationDomain:ApplicationDomain):Array {
			var result:Array = [];
			var idx:int = 0;
			for each (var paramObj:Object in params) {
				var param:Parameter = new Parameter(idx++, paramObj.type, applicationDomain, paramObj.optional);
				result[result.length] = param;
			}
			return result;
		}

		private function parseAccessors(type:Type, accessors:Array, applicationDomain:ApplicationDomain, isStatic:Boolean):Array {
			var result:Array = [];

			for each (var acc:Object in accessors) {
				var accessor:Accessor = new Accessor(acc.name, AccessorAccess.fromString(acc.access), acc.type, acc.declaredBy, isStatic, applicationDomain);
				accessor.as3commons_reflect::setNamespaceURI(acc.uri);
				parseMetaData(acc.metadata, accessor);
				result[result.length] = accessor;
			}
			return result;
		}

		private function parseMetaData(metaDataNodes:Array, metaData:IMetaDataContainer):void {
			for each (var metaDataObj:Object in metaDataNodes) {
				var metaDataArgs:Array = [];

				for each (var metaDataArgNode:Object in metaDataObj.value) {
					metaDataArgs[metaDataArgs.length] = new MetaDataArgument(metaDataArgNode.key, metaDataArgNode.value);
				}
				metaData.addMetaData(new MetaData(metaDataObj.name, metaDataArgs));
			}
		}

		private function parseMembers(memberClass:Class, members:Array, declaringType:String, isStatic:Boolean, isConstant:Boolean, applicationDomain:ApplicationDomain):Array {
			var result:Array = [];

			for each (var m:Object in members) {
				if ((isConstant) && (m.access != AccessorAccess.READ_ONLY.name)) {
					continue;
				} else if ((!isConstant) && (m.access == AccessorAccess.READ_ONLY.name)) {
					continue;
				}
				var member:IMember = new memberClass(m.name, m.type, declaringType, isStatic, applicationDomain);
				if (member is INamespaceOwner) {
					INamespaceOwner(member).as3commons_reflect::setNamespaceURI(m.uri);
				}
				parseMetaData(m.metadata, member);
				result[result.length] = member;
			}
			return result;
		}

	}
}