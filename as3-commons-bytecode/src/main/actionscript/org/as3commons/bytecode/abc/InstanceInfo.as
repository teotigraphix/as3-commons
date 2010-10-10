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
	public class InstanceInfo {

		public var classMultiname:QualifiedName;
		public var superclassMultiname:BaseMultiname;
		public var protectedNamespace:LNamespace;
		public var interfaceMultinames:Array;
		public var instanceInitializer:MethodInfo;
		public var traits:Array;

		public var isProtected:Boolean;
		public var isFinal:Boolean;
		public var isSealed:Boolean;
		public var isInterface:Boolean;

		public function InstanceInfo() {
			super();
			initInstanceInfo();
		}

		private function initInstanceInfo():void {
			interfaceMultinames = [];
			traits = [];
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

		public function get slotOrConstantTraits():Array {
			var matchingTraits:Array = [];
			for each (var trait:TraitInfo in traits) {
				if (trait is SlotOrConstantTrait) {
					matchingTraits[matchingTraits.length] = trait;
				}
			}
			return matchingTraits;
		}

		public function filterTraits(traitKind:TraitKind):Array {
			return traits.filter(function(trait:TraitInfo, index:int, array:Array):Boolean {
				return (trait.traitKind == traitKind);
			});
		}

		public function get methodTraits():Array {
			return filterTraits(TraitKind.METHOD);
		}

		public function get getterTraits():Array {
			return filterTraits(TraitKind.GETTER);
		}

		public function get setterTraits():Array {
			return filterTraits(TraitKind.SETTER);
		}

		public function toString():String {
			return StringUtils.substitute("InstanceInfo[\n\tclassName={0}\n\tsuperclassName={1}\n\tisProtected={2}\n\tprotectedNamespace={3}\n\tinterfaceCount={4}\n\tinterfaces={5}\n\tinstanceInitializer={6}\n\ttraits=[\n\t\t{7}\n\t]\n]", classMultiname, superclassMultiname, isProtected, protectedNamespace, interfaceCount, interfaceMultinames, instanceInitializer, traits.join("\n\t\t"));
		}
	}
}