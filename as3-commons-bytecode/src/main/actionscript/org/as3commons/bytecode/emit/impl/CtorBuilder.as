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
package org.as3commons.bytecode.emit.impl {
	import flash.errors.IllegalOperationError;

	import org.as3commons.bytecode.abc.LNamespace;
	import org.as3commons.bytecode.abc.MethodInfo;
	import org.as3commons.bytecode.abc.MethodTrait;
	import org.as3commons.bytecode.abc.QualifiedName;
	import org.as3commons.bytecode.abc.TraitInfo;
	import org.as3commons.bytecode.abc.enum.BuiltIns;
	import org.as3commons.bytecode.abc.enum.NamespaceKind;
	import org.as3commons.bytecode.abc.enum.TraitKind;
	import org.as3commons.bytecode.emit.ICtorBuilder;
	import org.as3commons.bytecode.emit.IMetadataBuilder;
	import org.as3commons.bytecode.emit.enum.MemberVisibility;
	import org.as3commons.bytecode.io.AbcDeserializer;
	import org.as3commons.bytecode.util.MultinameUtil;

	public class CtorBuilder extends MethodBuilder implements ICtorBuilder {

		public static const STATIC_CONSTRUCTOR_NAME_SUFFIX:String = '$cinit';
		private static const CONSTRUCTORS_CANNOT_HAVE_METADATA_ERROR:String = "Constructors cannot have metadata";

		public function CtorBuilder() {
			super("", MemberVisibility.PUBLIC);
			returnType = BuiltIns.ANY.fullName;
		}

		override public function build(initScopeDepth:uint = 1):MethodInfo {
			var mi:MethodInfo = super.build(initScopeDepth);
			mi.returnType = MultinameUtil.toQualifiedName(returnType, NamespaceKind.NAMESPACE);
			mi.as3commonsBytecodeName = AbcDeserializer.CONSTRUCTOR_BYTECODENAME;
			return mi;
		}

		override protected function buildTrait():TraitInfo {
			var trait:MethodTrait = (methodInfo != null) ? MethodTrait(methodInfo.as3commonsByteCodeAssignedMethodTrait) : new MethodTrait();
			trait.traitKind = TraitKind.METHOD;
			trait.isFinal = isFinal;
			trait.isOverride = false;
			var qname:QualifiedName = new QualifiedName(LNamespace.ASTERISK.name, LNamespace.ASTERISK);
			if ((trait.traitMultiname == null) || (trait.traitMultiname.equals(qname) == false)) {
				trait.traitMultiname = qname;
			}
			return trait;
		}

		override public function defineMetadata(name:String = null, arguments:Array = null):IMetadataBuilder {
			throw new IllegalOperationError(CONSTRUCTORS_CANNOT_HAVE_METADATA_ERROR);
		}

	}
}
