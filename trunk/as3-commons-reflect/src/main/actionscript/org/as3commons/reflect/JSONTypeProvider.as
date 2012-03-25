package org.as3commons.reflect {
	import avmplus.DescribeType;

	import flash.errors.IllegalOperationError;
	import flash.system.ApplicationDomain;

	import org.as3commons.lang.ClassUtils;

	public class JSONTypeProvider extends AbstractTypeProvider {
		public static const ALIAS_NOT_AVAILABLE:String = "Alias not available when using JSONTypeProvider";

		private var _describeTypeJSON:Function;
		private var _ignoredMetadata:Array = ["__go_to_definition_help", "__go_to_ctor_definition_help"];

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
			typeCache.put(fullyQualifiedClassName, type, applicationDomain);
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
			var i:int;
			var j:int;
			var interfaze:Type;
			var interfaceMetadata:Array;
			var numMetadata:int;
			var metadata:Metadata;
			for (i = 0; i < numInterfaces; i++) {
				interfaze = Type.forName(type.interfaces[int(i)], applicationDomain);
				if (interfaze != null) {
					concatMetadata(type, interfaze.methods, "methods");
					concatMetadata(type, interfaze.accessors, "accessors");
					interfaceMetadata = interfaze.metadata;
					numMetadata = interfaceMetadata.length;

					for (j = 0; j < numMetadata; j++) {
						metadata = interfaceMetadata[int(j)];
						if (!type.hasExactMetadata(metadata)) {
							type.addMetadata(metadata);
						}
					}
				}
			}

			type.createMetadataLookup();

			return type;
		}

		protected function parseConstructor(type:Type, constructor:Array, applicationDomain:ApplicationDomain):Constructor {
			if ((constructor) && (constructor.length > 0)) {
				var params:Array = parseParameters(constructor, applicationDomain);
				return new Constructor(type.fullName, applicationDomain, params);
			} else {
				return new Constructor(type.fullName, applicationDomain);
			}
		}

		private function concatMetadata(type:Type, metadataContainers:Array, propertyName:String):void {
			if (!metadataContainers) {
				return;
			}
			var metadataList:Array;
			var numMetadata:int;
			var j:int;
			var i:int;
			var container:IMetadataContainer;
			var len:int = metadataContainers.length;
			for (i = 0; i < len; ++i) {
				container = metadataContainers[i];
				type[propertyName].some(function(item:MetadataContainer, index:int, arr:Array):Boolean {
					if (Object(item).name == Object(container).name) {
						metadataList = container.metadata;
						numMetadata = metadataList.length;
						for (j = 0; j < numMetadata; j++) {
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
			if (!interfacesDescription) {
				return result;
			}
			var i:int;
			var len:int = interfacesDescription.length;
			for (i = 0; i < len; ++i) {
				result[result.length] = ClassUtils.convertFullyQualifiedName(interfacesDescription[i]);
			}
			return result;
		}

		private function parseMethods(type:Type, methods:Array, applicationDomain:ApplicationDomain, isStatic:Boolean):Array {
			var result:Array = [];
			if (!methods) {
				return result;
			}
			var params:Array;
			var method:Method;
			var i:int;
			var len:int = methods.length;
			var methodObj:Object;
			for (i = 0; i < len; ++i) {
				methodObj = methods[i];
				params = parseParameters(methodObj.parameters, applicationDomain);
				method = new Method(methodObj.declaredBy, methodObj.name, isStatic, params, methodObj.returnType, applicationDomain);
				method.as3commons_reflect::setNamespaceURI(methodObj.uri);
				parseMetadata(methodObj.metadata, method);
				result[result.length] = method;
			}
			return result;
		}

		private function parseParameters(params:Array, applicationDomain:ApplicationDomain):Array {
			var result:Array = [];
			if (!params) {
				return result;
			}
			var i:int;
			var len:int = params.length;
			var paramObj:Object;
			for (i = 0; i < len; ++i) {
				paramObj = params[i];
				result[result.length] = BaseParameter.newInstance(paramObj.type, applicationDomain, paramObj.optional);
			}
			return result;
		}

		private function parseAccessors(type:Type, accessors:Array, applicationDomain:ApplicationDomain, isStatic:Boolean):Array {
			var result:Array = [];
			if (!accessors) {
				return result;
			}
			var i:int;
			var len:int = accessors.length;
			var acc:Object;
			var accessor:Accessor;
			for (i = 0; i < len; ++i) {
				acc = accessors[i];
				accessor = Accessor.newInstance(acc.name, AccessorAccess.fromString(acc.access), acc.type, acc.declaredBy, isStatic, applicationDomain);
				accessor.as3commons_reflect::setNamespaceURI(acc.uri);
				parseMetadata(acc.metadata, accessor);
				result[result.length] = accessor;
			}
			return result;
		}

		private function parseMetadata(metadataNodes:Array, metadata:IMetadataContainer):void {
			if (!metadataNodes) {
				return;
			}
			var i:int;
			var len:int = metadataNodes.length;
			var acc:Object;
			var metadataObj:Object;
			var metadataName:String;
			var metadataArgs:Array;
			for (i = 0; i < len; ++i) {
				metadataObj = metadataNodes[i];
				metadataName = metadataObj.name;

				if (!isIgnoredMetadata(metadataName)) {
					metadataArgs = [];
					for each (var metadataArgNode:Object in metadataObj.value) {
						metadataArgs[metadataArgs.length] = MetadataArgument.newInstance(metadataArgNode.key, metadataArgNode.value);
					}
					metadata.addMetadata(Metadata.newInstance(metadataName, metadataArgs));
				}
			}
		}

		private function isIgnoredMetadata(metadataName:String):Boolean {
			return (_ignoredMetadata.indexOf(metadataName) > -1);
		}

		private function parseMembers(type:Type, memberClass:Class, members:Array, declaringType:String, isStatic:Boolean, isConstant:Boolean, applicationDomain:ApplicationDomain):Array {
			var result:Array = [];
			if (!members) {
				return result;
			}
			var i:int;
			var len:int = members.length;
			var m:Object;
			var member:IMember;
			for (i = 0; i < len; ++i) {
				m = members[i];
				if ((isConstant) && (m.access != AccessorAccess.READ_ONLY.name)) {
					continue;
				} else if ((!isConstant) && (m.access == AccessorAccess.READ_ONLY.name)) {
					continue;
				}
				member = memberClass["newInstance"](m.name, m.type, declaringType, isStatic, applicationDomain);
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
