package org.as3commons.reflect {
import flash.errors.IllegalOperationError;
import flash.system.ApplicationDomain;

import org.as3commons.lang.ClassUtils;
import org.as3commons.lang.ITypeDescription;
import org.as3commons.lang.typedescription.JSONTypeDescription;

public class JSONTypeProvider extends AbstractTypeProvider implements ITypeMemberProvider {

	public static const ALIAS_NOT_AVAILABLE:String = "Alias not available when using JSONTypeProvider";

	private var _ignoredMetadata:Array = ["__go_to_definition_help", "__go_to_ctor_definition_help"];

	/**
	 * describeTypeJSON JSON parser
	 */
	public function JSONTypeProvider() {
		super();
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

		var typeDescription:ITypeDescription = ClassUtils.getTypeDescription(cls, applicationDomain);

		if (!typeDescription is JSONTypeDescription) {
			throw new IllegalOperationError("describeTypeJSON not supported in currently installed flash player");
		}

		type.typeDescription = typeDescription;
		type.fullName = fullyQualifiedClassName;
		type.name = ClassUtils.getNameFromFullyQualifiedName(fullyQualifiedClassName);

		var instanceInfo:Object = getInstanceInfo(type);

		var param:Class = ClassUtils.getClassParameterFromFullyQualifiedName(instanceInfo.name, applicationDomain);
		if (param != null) {
			type.parameters[type.parameters.length] = param;
		}
		type.clazz = cls;
		type.isDynamic = instanceInfo.isDynamic;
		type.isFinal = instanceInfo.isFinal;
		type.isStatic = instanceInfo.isStatic;
		type.alias = ALIAS_NOT_AVAILABLE;
		type.isInterface = (cls === Object) ? false : (instanceInfo.traits.bases.length == 0);
		type.extendsClasses = instanceInfo.traits.bases.concat();
		type.interfaces = parseImplementedInterfaces(instanceInfo.traits.interfaces);

		return type;
	}

	public function getConstructorForType(type:Type):Constructor {
		var constructors:Array = getInstanceInfo(type).traits.constructor;

		return parseConstructor(type, constructors, type.applicationDomain);
	}

	public function getAccessorsForType(type:Type):Array {
		return parseAccessors(getInstanceInfo(type).traits.accessors, type.applicationDomain, false)
				.concat(parseAccessors(getClassInfo(type).traits.accessors, type.applicationDomain, true));
	}

	public function getMethodsForType(type:Type):Array {
		return parseMethods(getInstanceInfo(type).traits.methods, type.applicationDomain, false)
				.concat(parseMethods(getClassInfo(type).traits.methods, type.applicationDomain, true));
	}

	public function getStaticConstantsForType(type:Type):Array {
		return parseMembers(Constant, getClassInfo(type).traits.variables, type.fullName, true, true, type.applicationDomain);
	}

	public function getConstantsForType(type:Type):Array {
		return parseMembers(Constant, getInstanceInfo(type).traits.variables, type.fullName, false, true, type.applicationDomain);
	}

	public function getStaticVariablesForType(type:Type):Array {
		return parseMembers(Variable, getClassInfo(type).traits.variables, type.fullName, true, false, type.applicationDomain);
	}

	public function getVariablesForType(type:Type):Array {
		return parseMembers(Variable, getInstanceInfo(type).traits.variables, type.fullName, false, false, type.applicationDomain);
	}

	public function getMetadataForType(type:Type):Array {
		var result:Array;
		var metadataArray:Array = parseMetadata(getInstanceInfo(type).traits.metadata);

		// Combine metadata from implemented interfaces
		var numInterfaces:int = type.interfaces.length;
		var i:int;
		var j:int;
		var interfaze:Type;
		var interfaceMetadata:Array;
		var numMetadata:int;
		var metadata:Metadata;
		for (i = 0; i < numInterfaces; i++) {
			interfaze = Type.forName(type.interfaces[int(i)], type.applicationDomain);
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

		return result;
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
			type[propertyName].some(function (item:MetadataContainer, index:int, arr:Array):Boolean {
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

	private function parseMethods(methods:Array, applicationDomain:ApplicationDomain, isStatic:Boolean):Array {
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

			addMetadataToMetadataContainer(parseMetadata(methodObj.metadata), method);

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

	private function parseAccessors(accessors:Array, applicationDomain:ApplicationDomain, isStatic:Boolean):Array {
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

			addMetadataToMetadataContainer(parseMetadata(acc.metadata), accessor);

			result[result.length] = accessor;
		}
		return result;
	}

	private function addMetadataToMetadataContainer(metadataArray:Array, metadataContainer:IMetadataContainer):void {
		for each (var metadataInstance:Metadata in metadataArray) {
			metadataContainer.addMetadata(metadataInstance);
		}
	}

	private function parseMetadata(metadataNodes:Array):Array {
		var result:Array = [];

		if (metadataNodes) {
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

					result.push(Metadata.newInstance(metadataName, metadataArgs));
				}
			}
		}

		return result;
	}

	private function isIgnoredMetadata(metadataName:String):Boolean {
		return (_ignoredMetadata.indexOf(metadataName) > -1);
	}

	private function parseMembers(memberClass:Class, members:Array, declaringType:String, isStatic:Boolean, isConstant:Boolean, applicationDomain:ApplicationDomain):Array {
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

			addMetadataToMetadataContainer(parseMetadata(m.metadata), member);

			result[result.length] = member;
		}
		return result;
	}

	private function getInstanceInfo(type:Type):Object {
		return (type && type.typeDescription) ? type.typeDescription.instanceInfo : null;
	}

	private function getClassInfo(type:Type):Object {
		return (type && type.typeDescription) ? type.typeDescription.classInfo : null;
	}

}
}
