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
package org.as3commons.bytecode.abc {
	import org.as3commons.bytecode.abc.enum.TraitKind;
	import org.as3commons.lang.StringUtils;

	/**
	 * as3commons-bytecode representation of <code>instance_info</code> in the ABC file format.
	 *
	 * @see http://www.adobe.com/devnet/actionscript/articles/avm2overview.pdf     "Instance" in the AVM Spec (page 28)
	 */
	public final class InstanceInfo extends BaseTypeInfo {

		//shortcut for emit.* package
		public var classInfo:ClassInfo;

		public var classMultiname:QualifiedName;
		public var superclassMultiname:BaseMultiname;
		public var protectedNamespace:LNamespace;
		public var interfaceMultinames:Vector.<BaseMultiname>;
		public var instanceInitializer:MethodInfo;
		public var isProtected:Boolean;
		public var isFinal:Boolean;
		public var isSealed:Boolean;
		public var isInterface:Boolean;

		public function InstanceInfo() {
			super();
			interfaceMultinames = new Vector.<BaseMultiname>();
		}

		/**
		 * I can never remember that "instanceInitializer" is the constructor, so I made this convenience method.
		 */
		public function get constructor():MethodInfo {
			return instanceInitializer;
		}

		public function get interfaceCount():int {
			return interfaceMultinames.length;
		}

		public function toString():String {
			return StringUtils.substitute("InstanceInfo[\n\tclassName={0}\n\tsuperclassName={1}\n\tisProtected={2}\n\tprotectedNamespace={3}\n\tinterfaceCount={4}\n\tinterfaces={5}\n\tinstanceInitializer={6}\n\ttraits=[\n\t\t{7}\n\t]\n]", classMultiname, superclassMultiname, isProtected, protectedNamespace, interfaceCount, interfaceMultinames, instanceInitializer, traits.join("\n\t\t"));
		}

		override public function equals(other:Object):Boolean {
			var result:Boolean = super.equals(other);
			if (result) {
				var otherInstanceInfo:InstanceInfo = other as InstanceInfo;
				if (otherInstanceInfo != null) {
					if (!classMultiname.equals(otherInstanceInfo.classMultiname)) {
						return false;
					}
					if (!superclassMultiname.equals(otherInstanceInfo.superclassMultiname)) {
						return false;
					}
					if (protectedNamespace != null) {
						if (!protectedNamespace.equals(otherInstanceInfo.protectedNamespace)) {
							return false;
						}
					}
					if (interfaceCount != otherInstanceInfo.interfaceCount) {
						return false;
					}
					var len:int = interfaceCount;
					var i:int;
					var multiName:BaseMultiname;
					var otherMultiName:BaseMultiname;
					for (i = 0; i < len; ++i) {
						multiName = interfaceMultinames[i];
						otherMultiName = otherInstanceInfo.interfaceMultinames[i];
						if (!multiName.equals(otherMultiName)) {
							return false;
						}
					}
					if (!instanceInitializer.equals(otherInstanceInfo.instanceInitializer)) {
						return false;
					}
					if (isProtected != otherInstanceInfo.isProtected) {
						return false;
					}
					if (isFinal != otherInstanceInfo.isFinal) {
						return false;
					}
					if (isSealed != otherInstanceInfo.isSealed) {
						return false;
					}
					if (isInterface != otherInstanceInfo.isInterface) {
						return false;
					}
				} else {
					return false;
				}
			}
			return result;
		}
	}
}
