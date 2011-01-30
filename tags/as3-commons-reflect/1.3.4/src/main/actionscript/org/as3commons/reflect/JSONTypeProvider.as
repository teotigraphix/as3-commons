package org.as3commons.reflect {
	import avmplus.DescribeType;

	import flash.errors.IllegalOperationError;
	import flash.system.ApplicationDomain;

	import org.as3commons.lang.ClassUtils;

	public class JSONTypeProvider extends AbstractTypeProvider {
		public static const ALIAS_NOT_AVAILABLE:String = "Alias not available when using JSONTypeProvider";

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
			var fullyQualifiedClassName:String = ClassUtils.getFullyQualifiedName(cls);

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
			type.name = ClassUtils.getNameFromFullyQualifiedName(fullyQualifiedClassName);
			var param:Class = ClassUtils.getClassParameterFromFullyQualifiedName(instanceInfo.name, applicationDomain);
			if (param != null) {
				type.parameters[type.parameters.length] = param;
			}
			type.clazz = cls;
			type.isDynamic = instanceInfo.isDynamic;
			type.isFinal = instanceInfo.isFinal;
			type.isStatic = instanceInfo.isStatic;
			type.alias = ALIAS_NOT_AVAILABLE;
			type.isInterface = (instanceInfo.traits.bases.length == 0);
			type.constructor = parseConstructor(type, instanceInfo.traits.constructor, applicationDomain);
			type.accessors = parseAccessors(type, instanceInfo.traits.accessors, applicationDomain, false).concat(parseAccessors(type, classInfo.traits.accessors, applicationDomain, true));
			type.methods = parseMethods(type, instanceInfo.traits.methods, applicationDomain, false).concat(parseMethods(type, classInfo.traits.methods, applicationDomain, true));
			type.staticConstants = parseMembers(type, Constant, classInfo.traits.variables, fullyQualifiedClassName, true, true, applicationDomain);
			type.constants = parseMembers(type, Constant, instanceInfo.traits.variables, fullyQualifiedClassName, false, true, applicationDomain);
			type.staticVariables = parseMembers(type, Variable, classInfo.traits.variables, fullyQualifiedClassName, true, false, applicationDomain);
			type.variables = parseMembers(type, Variable, instanceInfo.traits.variables, fullyQualifiedClassName, false, false, applicationDomain);
			type.extendsClasses = instanceInfo.traits.bases.concat();
			parseMetadata(instanceInfo.traits.metadata, type);
			type.interfaces = parseImplementedInterfaces(instanceInfo.traits.interfaces);

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

		protected function parseConstructor(type:Type, constructor:Array, applicationDomain:ApplicationDomain):Constructor {
			if ((constructor != null) && (constructor.length > 0)) {
				var params:Array = parseParameters(constructor, applicationDomain);
				return new Constructor(type.fullName, applicationDomain, params);
			} else {
				return new Constructor(type.fullName, applicationDomain);
			}
		}

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

		private function parseImplementedInterfaces(interfacesDescription:Array):Array {
			var result:Array = [];
			if (interfacesDescription != null) {
				for each (var fullyQualifiedInterfaceName:String in interfacesDescription) {
					result[result.length] = ClassUtils.convertFullyQualifiedName(fullyQualifiedInterfaceName);
				}
			}
			return result;
		}

		private function parseMethods(type:Type, methods:Array, applicationDomain:ApplicationDomain, isStatic:Boolean):Array {
			var result:Array = [];

			for each (var methodObj:Object in methods) {
				/*if (methodObj.declaredBy != type.fullName) {
					continue;
				}*/
				var params:Array = parseParameters(methodObj.parameters, applicationDomain);
				var method:Method = new Method(type.fullName, methodObj.name, isStatic, params, methodObj.returnType, applicationDomain);
				method.as3commons_reflect::setNamespaceURI(methodObj.uri);
				parseMetadata(methodObj.metadata, method);
				result[result.length] = method;
			}
			return result;
		}

		private function parseParameters(params:Array, applicationDomain:ApplicationDomain):Array {
			var result:Array = [];
			var idx:int = 1;
			for each (var paramObj:Object in params) {
				var param:Parameter = new Parameter(idx++, paramObj.type, applicationDomain, paramObj.optional);
				result[result.length] = param;
			}
			return result;
		}

		private function parseAccessors(type:Type, accessors:Array, applicationDomain:ApplicationDomain, isStatic:Boolean):Array {
			var result:Array = [];

			for each (var acc:Object in accessors) {
				/*if (acc.declaredBy != type.fullName) {
					continue;
				}*/
				var accessor:Accessor = new Accessor(acc.name, AccessorAccess.fromString(acc.access), acc.type, acc.declaredBy, isStatic, applicationDomain);
				accessor.as3commons_reflect::setNamespaceURI(acc.uri);
				parseMetadata(acc.metadata, accessor);
				result[result.length] = accessor;
			}
			return result;
		}

		private function parseMetadata(metadataNodes:Array, metadata:IMetadataContainer):void {
			for each (var metadataObj:Object in metadataNodes) {
				var metadataArgs:Array = [];

				for each (var metadataArgNode:Object in metadataObj.value) {
					metadataArgs[metadataArgs.length] = new MetadataArgument(metadataArgNode.key, metadataArgNode.value);
				}
				metadata.addMetadata(new Metadata(metadataObj.name, metadataArgs));
			}
		}

		private function parseMembers(type:Type, memberClass:Class, members:Array, declaringType:String, isStatic:Boolean, isConstant:Boolean, applicationDomain:ApplicationDomain):Array {
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
				parseMetadata(m.metadata, member);
				result[result.length] = member;
			}
			return result;
		}

	}
}