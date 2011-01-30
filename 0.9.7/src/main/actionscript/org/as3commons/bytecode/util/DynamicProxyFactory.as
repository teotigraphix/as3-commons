/**
 * Copyright 2009 Maxim Cassian Porges
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package org.as3commons.bytecode.util {
	import org.as3commons.bytecode.abc.AbcFile;
	import org.as3commons.bytecode.abc.BaseMultiname;
	import org.as3commons.bytecode.abc.ClassInfo;
	import org.as3commons.bytecode.abc.ClassTrait;
	import org.as3commons.bytecode.abc.InstanceInfo;
	import org.as3commons.bytecode.abc.LNamespace;
	import org.as3commons.bytecode.abc.MethodBody;
	import org.as3commons.bytecode.abc.MethodInfo;
	import org.as3commons.bytecode.abc.MethodTrait;
	import org.as3commons.bytecode.abc.Multiname;
	import org.as3commons.bytecode.abc.MultinameL;
	import org.as3commons.bytecode.abc.NamespaceSet;
	import org.as3commons.bytecode.abc.QualifiedName;
	import org.as3commons.bytecode.abc.ScriptInfo;
	import org.as3commons.bytecode.abc.SlotOrConstantTrait;
	import org.as3commons.bytecode.abc.enum.BuiltIns;
	import org.as3commons.bytecode.abc.enum.MethodFlag;
	import org.as3commons.bytecode.abc.enum.NamespaceKind;
	import org.as3commons.bytecode.abc.enum.Opcode;
	import org.as3commons.bytecode.abc.enum.TraitKind;
	import org.as3commons.bytecode.typeinfo.Argument;

	/**
	 * Generates runtime subclasses with as3commons-bytecode enhancements for method interception.
	 */
	//TODO: What about intercepting superclass methods? If this is necessary, you'd have to walk the entire class hierarchy to find all the MethodInfos and MethodTraits
	//TODO: Refactor serialization so that constantpool is serialized last - this will make adding items late in the game work. Currently items added during opcode serialization get added to the pool too late, resulting in "CPool X out of range X" errors 
	public class DynamicProxyFactory {
		public static const AS3COMMONS_BYTECODE_NAMESPACE_NAME:String = "http://org.as3commons.bytecode.abc.ninjitsoft.com";
		public static const AS3COMMONS_BYTECODE_NAMESPACE:LNamespace = new LNamespace(NamespaceKind.NAMESPACE, AS3COMMONS_BYTECODE_NAMESPACE_NAME); // Namespace[namespace::http://org.as3commons.bytecode.abc.ninjitsoft.com]
		public static const AS3COMMONS_BYTECODE_PKG_INTERNAL_NAMESPACE:LNamespace = new LNamespace(NamespaceKind.PACKAGE_INTERNAL_NAMESPACE, AS3COMMONS_BYTECODE_NAMESPACE_NAME); // Namespace[namespace::http://org.as3commons.bytecode.abc.ninjitsoft.com]
		public static const HANDLER_MAPPINGS_QNAME:QualifiedName = new QualifiedName("handlerMappings", AS3COMMONS_BYTECODE_NAMESPACE);
		public static const SET_HANDLER_QNAME:QualifiedName = new QualifiedName("setHandler", AS3COMMONS_BYTECODE_NAMESPACE);
		public static const PROXY_INVOCATION_QNAME:QualifiedName = new QualifiedName("proxyInvocation", AS3COMMONS_BYTECODE_NAMESPACE);
		public static const METHOD_INVOCATION_QNAME:QualifiedName = new QualifiedName("MethodInvocation", new LNamespace(NamespaceKind.PACKAGE_NAMESPACE, "org.as3commons.bytecode.abc.template"));

		private var _abcFile:AbcFile;

		public function DynamicProxyFactory(abcFile:AbcFile) {
			_abcFile = abcFile;
		}

		/**
		 * Takes the given <code>AbcFile</code> and enhances its definition to include properties and instructions
		 * enabling method interception.
		 *
		 * <p>
		 * Note that this method modifies the given <code>AbcFile</code> reference, and once it completes the
		 * reference will represent the dynamic subclass and not the original class passed in. Please make a copy
		 * of the original <code>AbcFile</code> definition before calling this method if you need it for anything.
		 * </p>
		 *
		 * @param abcFile     The <code>AbcFile</code> to enhance
		 * @param dynamicSubclassName     The name to give to the dynamic subclass. If no name is specified, as3commons-bytecode assigns the name <code>[original class name]_EnhancedByAs3commonsBytecode</code>.
		 * @param classIndex  The index in to the <code>AbcFile</code> pointing to the class/instance definition that the caller wishes to be enhanced. Defaults to 0, which indicates the first entry (and is usually sufficient for <code>AbcFiles</code> containing only a single class definition).
		 */
		public function createProxy(subClassName:String = null, classIndex:int = 0):void {
			// Get a reference to the instance that will be subclassed/proxied
			var instance:InstanceInfo = _abcFile.instanceInfo[classIndex];

			var packageName:String = instance.classMultiname.nameSpace.name;
			var superClassName:String = instance.classMultiname.name;
			// If a name has not been specified, make one up
			if (subClassName == null) {
				subClassName = superClassName + "_EnhancedByAs3commonsBytecode";
			}
			var fullyQualifiedSubclassName:String = packageName + ":" + subClassName;
			var fullyQualifiedSuperclassName:String = packageName + ":" + superClassName;
			var packageNamespace:LNamespace = addNamespace(NamespaceKind.PACKAGE_NAMESPACE, packageName); //  i.e. Namespace[public::org.as3commons.bytecode.abc.template]
			var subClassQName:QualifiedName = addQualifiedName(subClassName, packageNamespace);

			var dynamicSubclassProtectedNamespace:LNamespace = addNamespace(NamespaceKind.PROTECTED_NAMESPACE, fullyQualifiedSubclassName); //  Namespace[protectedNamespace::org.as3commons.bytecode.abc.template:DynamicSubClass]
			_abcFile.constantPool.addNamespace(LNamespace.FLASH_UTILS);
			_abcFile.constantPool.addNamespace(AS3COMMONS_BYTECODE_NAMESPACE);

			var as3commonsByteCodeRequiredMultinames:Array = [HANDLER_MAPPINGS_QNAME, SET_HANDLER_QNAME, PROXY_INVOCATION_QNAME, METHOD_INVOCATION_QNAME, BuiltIns.DICTIONARY, BuiltIns.FUNCTION, BuiltIns.VOID];
			for each (var requiredMultiname:BaseMultiname in as3commonsByteCodeRequiredMultinames) {
				_abcFile.constantPool.addMultiname(requiredMultiname);
			}

			addHandlerMappingsSlot(instance);
			addSetHandlerMethod(instance);
			weaveHandlerMappingsCreationInToConstructor(instance);
			addProxyInvocation(instance);

			var superClassMethodImplementationNamespaceSet:NamespaceSet = new NamespaceSet([new LNamespace(NamespaceKind.PRIVATE_NAMESPACE, packageName + ":" + subClassName), // such as "org.as3commons.bytecode.abc.template:BaseClass_EnhancedByAs3CommonsByteCode"
				new LNamespace(NamespaceKind.PRIVATE_NAMESPACE, subClassName + ".as$1"), // such as "BaseClass_EnhancedByorg.as3commons.bytecode.abc.as$1"
				LNamespace.PUBLIC, new LNamespace(NamespaceKind.PACKAGE_NAMESPACE, packageName), // such as "org.as3commons.bytecode.abc.template"
				new LNamespace(NamespaceKind.PACKAGE_INTERNAL_NAMESPACE, packageName), // such as "org.as3commons.bytecode.abc.template"
				new LNamespace(NamespaceKind.STATIC_PROTECTED_NAMESPACE, packageName + ":" + subClassName), // such as "org.as3commons.bytecode.abc.template:BaseClass_EnhancedByAs3CommonsByteCode"
				new LNamespace(NamespaceKind.STATIC_PROTECTED_NAMESPACE, packageName + ":" + superClassName), // such as "org.as3commons.bytecode.abc.template:BaseClass"
				new LNamespace(NamespaceKind.STATIC_PROTECTED_NAMESPACE, "Object"), new LNamespace(NamespaceKind.PROTECTED_NAMESPACE, packageName + ":" + superClassName) // such as "org.as3commons.bytecode.abc.template:BaseClass"
				]);

			overrideMethods(instance, superClassMethodImplementationNamespaceSet);
			overrideProperties(instance, superClassMethodImplementationNamespaceSet);
			weaveScriptInitializer(superClassName, packageNamespace, classIndex, subClassQName);

			var staticInitializer:MethodBody = ClassInfo(_abcFile.classInfo[classIndex]).staticInitializer.methodBody;
			staticInitializer.initScopeDepth = 4;
			staticInitializer.maxScopeDepth = 5;

			// Replace the class/superclass name, protected namespace, and ClassTrait multiname. The stomping of the
			// ClassTrait multiname replacement got rid of the error: 
			// "ReferenceError: Error #1056: Cannot create property org.as3commons.bytecode.abc.template::DynamicSubClass on global. at global$init()"
			instance.superclassMultiname = instance.classMultiname;
			instance.classMultiname = subClassQName;
			instance.protectedNamespace = dynamicSubclassProtectedNamespace;

			//NOTE: I'm assuming that the ClassTrait is always the last trait on the ScriptInfo. Seems to work so far.
			var scriptInfoTraits:Array = ScriptInfo(_abcFile.scriptInfo[0]).traits;
			var classTrait:ClassTrait = scriptInfoTraits[scriptInfoTraits.length - 1];
			classTrait.traitMultiname = subClassQName;
		}

		public function addHandlerMappingsSlot(instance:InstanceInfo):void {
			var handlerMappingsTrait:SlotOrConstantTrait = new SlotOrConstantTrait();
			handlerMappingsTrait.traitMultiname = HANDLER_MAPPINGS_QNAME;
			handlerMappingsTrait.traitKind = TraitKind.SLOT;
			handlerMappingsTrait.slotId = 0;
			handlerMappingsTrait.typeMultiname = BuiltIns.DICTIONARY;
			handlerMappingsTrait.vindex = 0;
			handlerMappingsTrait.vkind = null;
			instance.traits.push(handlerMappingsTrait);
		}

		public function addSetHandlerMethod(instance:InstanceInfo):void {
			var setHandler:MethodInfo = addMethod(instance, SET_HANDLER_QNAME, [new Argument(BuiltIns.STRING), new Argument(BuiltIns.FUNCTION)], BuiltIns.VOID);

			var setHandlerBody:MethodBody = setHandler.methodBody;
			setHandlerBody.maxStack = 3;
			setHandlerBody.localCount = 3;
			setHandlerBody.initScopeDepth = 5;
			setHandlerBody.maxScopeDepth = 6;
			setHandlerBody.opcodes = [Opcode.getlocal_0.op(), Opcode.pushscope.op(), Opcode.getlocal_0.op(), Opcode.getproperty.op([HANDLER_MAPPINGS_QNAME]), Opcode.getlocal_1.op(), Opcode.getlocal_2.op(),
				//TODO: there are a ton of multinames in this nsset in the compiled version - add them back in
				Opcode.setproperty.op([new MultinameL(new NamespaceSet([LNamespace.PUBLIC]))]), Opcode.returnvoid.op()];
		}

		//TODO: Determine how additional constructor args affect the stack values
		public function weaveHandlerMappingsCreationInToConstructor(instance:InstanceInfo):void {
			var constructorMethodBody:MethodBody = instance.constructor.methodBody;
			constructorMethodBody.maxStack = 3;
			constructorMethodBody.localCount = 3;
			constructorMethodBody.initScopeDepth = 5;
			constructorMethodBody.maxScopeDepth = 6;

			// Explicitly blank out the constructor opcodes, and then get a reference to them for rebuilding the constructor
			constructorMethodBody.opcodes = [];
			var ops:Array = constructorMethodBody.opcodes;
			ops.push(Opcode.getlocal_0.op());
			ops.push(Opcode.pushscope.op());
			ops.push(Opcode.getlocal_0.op());

			// The number of arguments to the superclass constructor will vary. Here, we vary the call to super()
			// to match the number of arguments it's expecting.
			var numberOfConstructorArgs:int = constructorMethodBody.methodSignature.argumentCollection.length;
			for (var constructorArgIndex:int = 1; constructorArgIndex <= numberOfConstructorArgs; ++constructorArgIndex) {
				switch (constructorArgIndex) {
					case 1:
						ops.push(Opcode.getlocal_1.op());
						break;

					case 2:
						ops.push(Opcode.getlocal_2.op());
						break;

					case 3:
						ops.push(Opcode.getlocal_3.op());
						break;

					default:
						ops.push(Opcode.getlocal.op([constructorArgIndex]));
						break;
				}
			}
			ops.push(Opcode.constructsuper.op([numberOfConstructorArgs])); // call constructor with the number of args on the stack

			// These opcodes weave in the handlerMappings Dictionary
			ops.push(Opcode.getlocal_0.op());
			ops.push(Opcode.findpropstrict.op([BuiltIns.DICTIONARY]));
			ops.push(Opcode.constructprop.op([BuiltIns.DICTIONARY, 0]));
			ops.push(Opcode.initproperty.op([HANDLER_MAPPINGS_QNAME]));
			ops.push(Opcode.returnvoid.op());
		}

		public function addProxyInvocation(instance:InstanceInfo):void {
			var proxyInvocationMethodInfo:MethodInfo = addMethod(instance, PROXY_INVOCATION_QNAME, [new Argument(METHOD_INVOCATION_QNAME)], BuiltIns.ANY);
			var body:MethodBody = proxyInvocationMethodInfo.methodBody;

			var publicNamespaceSet:NamespaceSet = new NamespaceSet([LNamespace.PUBLIC]);
			var methodNameMultiname:Multiname = addMultiname("methodName", new NamespaceSet([LNamespace.PUBLIC]));
			var methodNameMultinameLate:MultinameL = addMultinameL(new NamespaceSet([new LNamespace(NamespaceKind.PACKAGE_NAMESPACE, "")]));
			var applyMultiname:Multiname = addMultiname("apply", publicNamespaceSet);
			var booleanMultiname:Multiname = addMultiname("Boolean", publicNamespaceSet);
			var proceedMultiname:Multiname = addMultiname("proceed", new NamespaceSet([LNamespace.PUBLIC, METHOD_INVOCATION_QNAME.nameSpace // this needs to be in the package namespace for MethodInvocation - was previously new LNamespace(NamespaceKind.PACKAGE_NAMESPACE, "org.as3commons.bytecode.abc.template") 
				]));

			body.methodSignature = proxyInvocationMethodInfo;
			body.maxStack = 3;
			body.localCount = 3;
			body.initScopeDepth = 5;
			body.maxScopeDepth = 6;
			body.opcodes = [Opcode.getlocal_0.op(), Opcode.pushscope.op(), Opcode.getlocal_0.op(), Opcode.getproperty.op([HANDLER_MAPPINGS_QNAME]), Opcode.getlocal_1.op(), Opcode.getproperty.op([methodNameMultiname]), Opcode.getproperty.op([methodNameMultinameLate]), Opcode.coerce.op([BuiltIns.FUNCTION]), Opcode.setlocal_2.op(), Opcode.findpropstrict.op([booleanMultiname]), Opcode.getlocal_2.op(), Opcode.callproperty.op([booleanMultiname, 1]), Opcode.iffalse.op([9]), Opcode.getlocal_2.op(), Opcode.getlocal_0.op(), Opcode.getlocal_1.op(), Opcode.newarray.op([1]), Opcode.callproperty.op([applyMultiname, 2]), Opcode.returnvalue.op(), Opcode.getlocal_1.op(), Opcode.callproperty.op([proceedMultiname, 0]), Opcode.returnvalue.op()];
		}

		public function overrideProperties(instance:InstanceInfo, superClassMethodInvocationNamespaceSet:NamespaceSet):void {
			// If there are getters, weave in a method for calling the superclass for the property values. This may be used by MethodInvocation.proceed()
			var getterTraits:Array = instance.getterTraits;
			if (getterTraits.length > 0) {
				var methodInvocationGetterHelperQName:QualifiedName = addQualifiedName("getProperty", AS3COMMONS_BYTECODE_NAMESPACE);
				var methodInvocationGetter:MethodInfo = addMethod(instance, methodInvocationGetterHelperQName, [new Argument(BuiltIns.STRING)], BuiltIns.ANY);

				// Weave opcodes for getter to invoke the superclass's implementation
				var body:MethodBody = methodInvocationGetter.methodBody;
				body.localCount = 2;
				body.maxScopeDepth = 6;
				body.maxStack = 2;
				var opcodes:Array = body.opcodes;
				opcodes.push(Opcode.getlocal_0.op());
				opcodes.push(Opcode.pushscope.op());
				opcodes.push(Opcode.getlocal_0.op());
				opcodes.push(Opcode.getlocal_1.op());
				opcodes.push(Opcode.getsuper.op([addMultinameL(superClassMethodInvocationNamespaceSet)]));
				opcodes.push(Opcode.returnvalue.op());
			}

			// Weave opcodes to override all the original getter methods with a call to
			// MethodInvocation, with flags to the constructor indicating this method is a getter 
			for each (var getterTrait:MethodTrait in getterTraits) {
				var originalGetterBody:MethodBody = getterTrait.traitMethod.methodBody;
				originalGetterBody.localCount = 2;
				originalGetterBody.maxScopeDepth = 6;
				originalGetterBody.maxStack = 7;
				originalGetterBody.initScopeDepth = 5;
				var newGetterOps:Array = [];
				newGetterOps.push(Opcode.getlocal_0.op());
				newGetterOps.push(Opcode.pushscope.op());
				newGetterOps.push(Opcode.getlocal_0.op());
				newGetterOps.push(Opcode.findpropstrict.op([METHOD_INVOCATION_QNAME]));
				newGetterOps.push(Opcode.getlocal_0.op());
				newGetterOps.push(Opcode.pushstring.op([getterTrait.traitMultiname.name]));
				newGetterOps.push(Opcode.getlocal_1.op());
				newGetterOps.push(Opcode.pushnull.op());
				newGetterOps.push(Opcode.pushbyte.op([1]));
				newGetterOps.push(Opcode.constructprop.op([METHOD_INVOCATION_QNAME, 5]));
				newGetterOps.push(Opcode.callproperty.op([PROXY_INVOCATION_QNAME, 1]));
				newGetterOps.push(Opcode.returnvalue.op());
				originalGetterBody.opcodes = newGetterOps;
				getterTrait.isOverride = true;
			}

			// If there are setters, also weave in a method helper for potential use by MethodInvocation.proceed()
			var setterTraits:Array = instance.setterTraits;
			if (setterTraits.length > 0) {
				var setterHelperMethodName:QualifiedName = addQualifiedName("setProperty", AS3COMMONS_BYTECODE_NAMESPACE);
				var setterHelper:MethodInfo = addMethod(instance, setterHelperMethodName, [new Argument(BuiltIns.STRING), new Argument(BuiltIns.STRING)], BuiltIns.VOID);

				// Weave opcodes for the setter to invoke the superclass's implementation
				var setterBody:MethodBody = setterHelper.methodBody;
				setterBody.localCount = 3;
				setterBody.maxScopeDepth = 6;
				setterBody.maxStack = 3;
				setterBody.initScopeDepth = 5;
				var setOpcodes:Array = setterBody.opcodes;
				setOpcodes.push(Opcode.getlocal_0.op());
				setOpcodes.push(Opcode.pushscope.op());
				setOpcodes.push(Opcode.getlocal_0.op());
				setOpcodes.push(Opcode.getlocal_1.op());
				setOpcodes.push(Opcode.getlocal_2.op());
				setOpcodes.push(Opcode.setsuper.op([addMultinameL(superClassMethodInvocationNamespaceSet)]));
				setOpcodes.push(Opcode.returnvoid.op());
			}

			// Weave opcodes to override all the original setter methods with a call to
			// MethodInvocation, with flags to the constructor indicating this method is a setter 
			for each (var setterTrait:MethodTrait in setterTraits) {
				var originalSetterBody:MethodBody = setterTrait.traitMethod.methodBody;
				originalSetterBody.localCount = 3;
				originalSetterBody.maxScopeDepth = 6;
				originalSetterBody.maxStack = 7;
				originalSetterBody.initScopeDepth = 5;
				var newSetterOps:Array = [];
				newSetterOps.push(Opcode.getlocal_0.op());
				newSetterOps.push(Opcode.pushscope.op());
				newSetterOps.push(Opcode.getlocal_0.op());
				newSetterOps.push(Opcode.findpropstrict.op([METHOD_INVOCATION_QNAME]));
				newSetterOps.push(Opcode.getlocal_0.op());
				newSetterOps.push(Opcode.pushstring.op([setterTrait.traitMultiname.name]));
				newSetterOps.push(Opcode.getlocal_2.op());
				newSetterOps.push(Opcode.pushnull.op());
				newSetterOps.push(Opcode.pushbyte.op([2]));
				newSetterOps.push(Opcode.constructprop.op([METHOD_INVOCATION_QNAME, 5]));
				newSetterOps.push(Opcode.callproperty.op([PROXY_INVOCATION_QNAME, 1]));
				newSetterOps.push(Opcode.pop.op());
				newSetterOps.push(Opcode.returnvoid.op());
				originalSetterBody.opcodes = newSetterOps;
				setterTrait.isOverride = true;

				// The override needs args, so flip that flag
				setterTrait.traitMethod.flags |= MethodFlag.NEED_ARGUMENTS.value;
			}
		}

		public function overrideMethods(instance:InstanceInfo, superClassMethodImplementationNSSet:NamespaceSet /*, packageName : String, subClassName : String, superClassName : String*/):void {
			// Replace opcodes in all non-as3commons-bytecode method bodies
			for each (var methodTrait:MethodTrait in instance.methodTraits) {
				if (!methodTrait.traitMultiname.nameSpace.equals(AS3COMMONS_BYTECODE_NAMESPACE)) {
					var instanceMethodBody:MethodBody = methodTrait.traitMethod.methodBody;
					methodTrait.isOverride = true;

					var instanceMethodSignature:MethodInfo = instanceMethodBody.methodSignature;
					var instanceMethodName:QualifiedName = methodTrait.traitMultiname;
					var newOpcodes:Array = [];

					// First block is the same for methods with and without return types
					newOpcodes.push(Opcode.getlocal_0.op()); // getlocal_0      
					newOpcodes.push(Opcode.pushscope.op()); // pushscope       
					newOpcodes.push(Opcode.getlocal_0.op()); // getlocal_0      
					newOpcodes.push(Opcode.findpropstrict.op([METHOD_INVOCATION_QNAME])); // findpropstrict  [Multiname[name=MethodInvocation, nsset=[Namespace[...
					newOpcodes.push(Opcode.getlocal_0.op()); // getlocal_0      
					newOpcodes.push(Opcode.pushstring.op([instanceMethodName.name])); // pushstring      [methodName]

					// Next, we need to change the opcodes based upon what the method signature looks like. It is different for
					// methods with optional args, methods with rest args, and regular methods
					var methodHasOptionalArgs:Boolean = MethodFlag.flagPresent(instanceMethodSignature.flags, MethodFlag.HAS_OPTIONAL);
					var methodHasRestArgs:Boolean = MethodFlag.flagPresent(instanceMethodSignature.flags, MethodFlag.NEED_REST);
					var methodNeitherHasOptionalNorRest:Boolean = (!methodHasOptionalArgs && !methodHasRestArgs);

					var numberOfArgumentsToMethod:int = instanceMethodSignature.argumentCollection.length;
					var maxStack:int;

					if (methodNeitherHasOptionalNorRest) {
						// All regular methods have the same body and the max stack if always 6 
						maxStack = 6;

						// Turn on the NEED_ARGUMENTS flag since the constructor to MethodInvocation accepts the arguments array
						instanceMethodSignature.flags |= MethodFlag.NEED_ARGUMENTS.value;

						// Get a reference to the "arguments" entry. From the AVM spec (page 15):
						//      "If NEED_ARGUMENTS is set in method_info.flags, the method_info.param_count+1 register is set up 
						//      to reference an “arguments” object that holds all the actual arguments: see ECMA-262 for more 
						//      information.  (The AVM2 is not strictly compatible with ECMA-262; it creates an Array object for 
						//      the “arguments” object, whereas ECMA-262 requires a plain Object.)" 
						var argumentsEntryIndex:int = (numberOfArgumentsToMethod + 1);
						switch (argumentsEntryIndex) {
							case 1:
								newOpcodes.push(Opcode.getlocal_1.op());
								break;

							case 2:
								newOpcodes.push(Opcode.getlocal_2.op());
								break;

							case 3:
								newOpcodes.push(Opcode.getlocal_3.op());
								break;

							default:
								newOpcodes.push(Opcode.getlocal.op([argumentsEntryIndex]));
								break;
						}
					}

					if (methodHasOptionalArgs) {
						// Max stack size for NEED_OPTIONAL is 4 plus the number of arguments 
						maxStack = (4 + numberOfArgumentsToMethod);

						// For NEED_OPTIONAL, we also all the arguments on to the stack and wrap them in an array. If we don't do this, the "arguments"
						// array only contains the values passed in (i.e. the optional values omitted by the caller are null) which means that the
						// default values are not available to the advice at runtime.  
						for (var optionalArgumentIndex:int = 1; optionalArgumentIndex <= numberOfArgumentsToMethod; ++optionalArgumentIndex) {
							switch (optionalArgumentIndex) {
								case 1:
									newOpcodes.push(Opcode.getlocal_1.op());
									break;

								case 2:
									newOpcodes.push(Opcode.getlocal_2.op());
									break;

								case 3:
									newOpcodes.push(Opcode.getlocal_3.op());
									break;

								default:
									newOpcodes.push(Opcode.getlocal.op([optionalArgumentIndex]));
									break;
							}
						}
						newOpcodes.push(Opcode.newarray.op([numberOfArgumentsToMethod]));
					}

					if (methodHasRestArgs) {
						// Methods with NEED_REST are always 5 plus the number of arguments
						maxStack = (5 + numberOfArgumentsToMethod);

						// If NEED_REST is enabled, we need to push the method arguments on to the stack, add the item one index beyond the 
						// number of arguments (which is the ...rest array), and then bundle all these items in to an Array. We do this
						// because the "arguments" array is not available to us for this kind of method, so we are essentially simulating it.
						for (var argumentIndex:int = 1; argumentIndex <= (numberOfArgumentsToMethod + 1); ++argumentIndex) {
							switch (argumentIndex) {
								case 1:
									newOpcodes.push(Opcode.getlocal_1.op());
									break;

								case 2:
									newOpcodes.push(Opcode.getlocal_2.op());
									break;

								case 3:
									newOpcodes.push(Opcode.getlocal_3.op());
									break;

								default:
									newOpcodes.push(Opcode.getlocal.op([argumentIndex]));
									break;
							}
						}
						newOpcodes.push(Opcode.newarray.op([(numberOfArgumentsToMethod + 1)]));
					}

					// Everybody gets the following block too. First we set up the multi/names/spaces/sets...
					// NOTE:   technically this ran fine with just the PUBLIC namespace after the multiname for the baseclass
					//         was fixed, but I'd like to keep all the namespaces just in case.
					var superClassMethodImplementationMultiname:Multiname = addMultiname(instanceMethodName.name, superClassMethodImplementationNSSet);

					// ... then we weave the stack
					newOpcodes.push(Opcode.getlocal_0.op());
					newOpcodes.push(Opcode.getsuper.op([superClassMethodImplementationMultiname]));
					newOpcodes.push(Opcode.constructprop.op([METHOD_INVOCATION_QNAME, 4]));
					newOpcodes.push(Opcode.callproperty.op([PROXY_INVOCATION_QNAME, 1]));

					// The last few opcodes change based upon whether or not the method returns a value
					var methodReturnsVoid:Boolean = instanceMethodSignature.returnType.equals(BuiltIns.VOID);
					if (methodReturnsVoid) {
						newOpcodes.push(Opcode.pop.op());
						newOpcodes.push(Opcode.returnvoid.op());
					} else {
						newOpcodes.push(Opcode.returnvalue.op());
					}
					instanceMethodBody.opcodes = newOpcodes;

					//TODO: Do these values change based upon how many method arguments there are?
					// Modify the method body stats
					instanceMethodBody.maxStack = maxStack;
					instanceMethodBody.localCount = (methodReturnsVoid) ? 5 : 4;
					instanceMethodBody.initScopeDepth = 5;
					instanceMethodBody.maxScopeDepth = 6;
				}
			}
		}

		/**
		 * Although DynamicSubClass's template ABC file produced a different constructor stack than everything
		 * else, I have not seen adverse affects from just using the following stack. Basically, the superclass
		 * is the only thing that goes on the stack, and then we call <code>initproperty</code> on the runtime
		 * proxy and all seems to be good with the world.
		 *
		 * <p>
		 * Subclasses of classes other than Object look like this:
		 * <code>
		 *         //maxStack=2, localCount=1, initScopeDepth=1, maxScopeDepth=3
		 *         getlocal_0
		 *         pushscope
		 *         getscopeobject      [0]
		 *         findpropstrict      [QName[Namespace[public::org.as3commons.bytecode.abc.template]:SubClassOfSubClass]]
		 *         getproperty         [QName[Namespace[public::org.as3commons.bytecode.abc.template]:SubClassOfSubClass]]
		 *         pushscope
		 *         findpropstrict      [Multiname[name=SubClassOfSubClass, nsset=[Namespace[public], Namespace[public::org.as3commons.bytecode.abc.template], Namespace[private::SubClassOfSubClassOfSubClass.as$1], Namespace[packageInternalNamespace::org.as3commons.bytecode.abc.template]]]]
		 *         getproperty         [Multiname[name=SubClassOfSubClass, nsset=[Namespace[public], Namespace[public::org.as3commons.bytecode.abc.template], Namespace[private::SubClassOfSubClassOfSubClass.as$1], Namespace[packageInternalNamespace::org.as3commons.bytecode.abc.template]]]]
		 *         newclass            [ClassInfo[...
		 *         popscope
		 *         initproperty        [QName[Namespace[public::org.as3commons.bytecode.abc.template]:SubClassOfSubClassOfSubClass]]
		 *         returnvoid
		 * </code>
		 * </p>
		 *
		 * <p>
		 * Subclasses of Object look like this:
		 * <code>
		 *         //maxStack=2, localCount=1, initScopeDepth=1, maxScopeDepth=3
		 *         getlocal_0
		 *         pushscope
		 *         getscopeobject      [0]
		 *         findpropstrict      [QName[Namespace[public]:Object]]
		 *         getproperty         [QName[Namespace[public]:Object]]
		 *         pushscope
		 *         findpropstrict      [Multiname[name=Object, nsset=[Namespace[private::BaseClass.as$1], Namespace[public], Namespace[public::org.as3commons.bytecode.abc.template], Namespace[packageInternalNamespace::org.as3commons.bytecode.abc.template]]]]
		 *         getproperty         [Multiname[name=Object, nsset=[Namespace[private::BaseClass.as$1], Namespace[public], Namespace[public::org.as3commons.bytecode.abc.template], Namespace[packageInternalNamespace::org.as3commons.bytecode.abc.template]]]]
		 *         newclass            [ClassInfo[...
		 *         popscope
		 *         initproperty        [QName[Namespace[public::org.as3commons.bytecode.abc.template]:BaseClass]]
		 *         returnvoid
		 * </code>
		 * </p>
		 */
		public function weaveScriptInitializer(superClassName:String, packageNamespace:LNamespace, classIndex:int, subClassQName:QualifiedName):void {
			// Modify the script initializer
			var baseClassQName:QualifiedName = new QualifiedName(superClassName, packageNamespace);
			_abcFile.constantPool.addMultiname(baseClassQName);

			// Create the namespace set for the superclass instantiation
			// NOTE: It was really important not to skimp on the namespace set for the multiname here.
			var baseClassMultiname:Multiname = addMultiname(superClassName, new NamespaceSet([new LNamespace(NamespaceKind.PRIVATE_NAMESPACE, subClassQName.name + ".as$1"), // such as "BaseClass_EnhancedByorg.as3commons.bytecode.abc.as$1"
				LNamespace.PUBLIC, packageNamespace, new LNamespace(NamespaceKind.PACKAGE_INTERNAL_NAMESPACE, packageNamespace.name) // such as "org.as3commons.bytecode.abc.template"
				]));
			// The ABC spec says the following on page 15:
			//      "One of the entries in the ABC file is an array of script_info entries (see the next chapter).  Each of these 
			//      entries contains a reference to an initialization method for the script and a set of traits to be defined in the 
			//      script’s environment.  The last entry in that array is the entry point for the ABC file; that is, the last entry’s 
			//      initialization method contains the first bytecode that’s run when the ABC file is executed."
			// With nothing else to go on, I am going to assume that the script we want to enhance is always going to be the last entry.
			// I guess we'll find out if I was right when I write the SWF loader... :)  
			var scriptInitializer:MethodBody = ScriptInfo(_abcFile.scriptInfo[_abcFile.scriptInfo.length - 1]).scriptInitializer.methodBody;
			scriptInitializer.maxStack = 2;
			scriptInitializer.localCount = 1;
			scriptInitializer.initScopeDepth = 1;
			scriptInitializer.maxScopeDepth = 3;
			scriptInitializer.opcodes = [Opcode.getlocal_0.op(), Opcode.pushscope.op(), Opcode.getscopeobject.op([0]), Opcode.findpropstrict.op([baseClassQName]), Opcode.getproperty.op([baseClassQName]), Opcode.pushscope.op(), Opcode.findpropstrict.op([baseClassMultiname]), Opcode.getproperty.op([baseClassMultiname]), Opcode.newclass.op([_abcFile.classInfo[classIndex]]), Opcode.popscope.op(), Opcode.initproperty.op([subClassQName]), Opcode.returnvoid.op()];
		}

		public function addNamespace(kind:NamespaceKind, name:String):LNamespace {
			var ns:LNamespace = new LNamespace(kind, name);
			_abcFile.constantPool.addNamespace(ns);
			return ns;
		}

		public function addQualifiedName(name:String, nameSpace:LNamespace):QualifiedName {
			var qualifiedName:QualifiedName = new QualifiedName(name, nameSpace);
			_abcFile.constantPool.addMultiname(qualifiedName);

			return qualifiedName;
		}

		private function addMethod(instance:InstanceInfo, methodName:QualifiedName, args:Array, returnType:QualifiedName, isOverride:Boolean = false, traitKind:TraitKind = null):MethodInfo {
			if (traitKind == null) {
				traitKind = TraitKind.METHOD;
			}

			// Create the method signature
			var methodInfo:MethodInfo = new MethodInfo();
			methodInfo.as3commonsBytecodeName = methodName;
			methodInfo.methodName = "";
			methodInfo.returnType = returnType;
			for each (var argument:Argument in args) {
				methodInfo.argumentCollection.push(argument);
			}
			_abcFile.methodInfo.push(methodInfo);

			// Add the method trait
			var methodTrait:MethodTrait = new MethodTrait();
			methodTrait.traitMultiname = methodName;
			methodTrait.traitKind = traitKind;
			methodTrait.isOverride = isOverride;
			methodTrait.dispositionId = 0;
			methodTrait.traitMethod = methodInfo;
			instance.traits.push(methodTrait);

			// Add the method body
			var methodBody:MethodBody = new MethodBody();
			_abcFile.methodBodies.push(methodBody);

			// Introduce everybody to each other
			methodBody.methodSignature = methodInfo;
			methodInfo.methodBody = methodBody;

			return methodInfo;
		}

		public function addMultiname(name:String, namespaceSet:NamespaceSet):Multiname {
			var multiname:Multiname = new Multiname(name, namespaceSet);
			_abcFile.constantPool.addMultiname(multiname);

			return multiname;
		}

		public function addMultinameL(namespaceSet:NamespaceSet):MultinameL {
			var multinameL:MultinameL = new MultinameL(namespaceSet);
			_abcFile.constantPool.addMultiname(multinameL);

			return multinameL;
		}
	}
}

// How to trace (just for shits 'n giggles)
//            var traceMultinamePosition : int = abcFile.constantPool.getMultinamePositionByName("trace");
//            var message : String = "This is a message woven in by as3commons-bytecode!";
//            abcFile.constantPool.addString(message);
//            setHandlerBody.opcodes = [
//                Opcode.getlocal_0.op(),
//                Opcode.pushscope.op(),
//                Opcode.findpropstrict.op([abcFile.constantPool.multinamePool[traceMultinamePosition]]),
//                Opcode.pushstring.op([message]),
//                Opcode.callproperty.op([abcFile.constantPool.multinamePool[traceMultinamePosition, 1]]),
//                Opcode.pop.op(),
//                Opcode.returnvoid.op()
//            ];