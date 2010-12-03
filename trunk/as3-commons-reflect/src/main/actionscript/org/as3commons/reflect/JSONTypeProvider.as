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
			var fullyQualifiedClassName:String = org.as3commons.lang.ClassUtils.getFullyQualifiedName(cls);

			// Add the Type to the cache before assigning any values to prevent looping.
			// Due to the work-around implemented for constructor argument types
			// in getTypeDescription(), an instance is created, which could also
			// lead to infinite recursion if the constructor uses Type.forName().
			// Therefore it is important to seed the cache before calling
			// getTypeDescription (thanks to Jürgen Failenschmid for reporting this)
			typeCache.put(fullyQualifiedClassName, type);
			var description:Object = _describeTypeJSON(cls, DescribeType.INCLUDE_TRAITS); //DescribeType.GET_FULL
			type.fullName = fullyQualifiedClassName;
			type.name = org.as3commons.lang.ClassUtils.getNameFromFullyQualifiedName(fullyQualifiedClassName);
			type.clazz = cls;
			type.isDynamic = description.isDynamic;
			type.isFinal = description.isFinal;
			type.isStatic = description.isStatic;
			type.alias = "alias";
			type.isInterface = "";
			type.constructor = parseConstructor(type, description.constructor, applicationDomain);
			type.accessors = parseAccessors(type, description.accessors, applicationDomain);
			type.methods = null; //parseMethods(type, description, applicationDomain);
			type.staticConstants = null; //parseMembers(Constant, description.constant, fullyQualifiedClassName, true, applicationDomain);
			type.constants = null; //parseMembers(Constant, description.factory.constant, fullyQualifiedClassName, false, applicationDomain);
			type.staticVariables = null; //parseMembers(Variable, description.variable, fullyQualifiedClassName, true, applicationDomain);
			type.variables = null; //parseMembers(Variable, description.factory.variable, fullyQualifiedClassName, false, applicationDomain);
			type.extendsClasses = null; //parseExtendsClasses(description.factory.extendsClass, type.applicationDomain);
			//parseMetaData(description.factory[0].metadata, type);
			type.interfaces = null; //parseImplementedInterfaces(description.factory.implementsInterface);

			// Combine metadata from implemented interfaces
			/*var numInterfaces:int = type.interfaces.length;
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

			type.createMetaDataLookup();*/

			return type;
		}

		protected function parseConstructor(type:Type, constructor:Array, applicationDomain:ApplicationDomain):Constructor {
			if (constructor.length() > 0) {
				var params:Array = parseParameters(constructor, applicationDomain);
				return new Constructor(type.fullName, applicationDomain, params);
			} else {
				return new Constructor(type.fullName, applicationDomain);
			}
		}

		private function parseParameters(params:Array, applicationDomain:ApplicationDomain):Array {
			var params:Array = [];
			var idx:int = 0;
			for each (var paramObj:Object in params) {
				var param:Parameter = new Parameter(idx++, paramObj.type, applicationDomain, paramObj.optional);
				params[params.length] = param;
			}
			return params;
		}

		private function parseAccessors(type:Type, accessors:Array, applicationDomain:ApplicationDomain):Array {
			//var classAccessors:Array = parseAccessorsByModifier(type, xml.accessor, true, applicationDomain);
			//var instanceAccessors:Array = parseAccessorsByModifier(type, xml.factory.accessor, false, applicationDomain);
			//return classAccessors.concat(instanceAccessors);
			return [];
		}

	}
}