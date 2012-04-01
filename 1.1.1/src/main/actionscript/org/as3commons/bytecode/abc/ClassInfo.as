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
	import org.as3commons.bytecode.typeinfo.Metadata;
	import org.as3commons.lang.StringUtils;

	/**
	 * as3commons-bytecode representation of <code>class_info</code> in the ABC file format.
	 *
	 * @see http://www.adobe.com/devnet/actionscript/articles/avm2overview.pdf     "Class" in the AVM Spec (page 32)
	 */
	public final class ClassInfo extends BaseTypeInfo {

		public var staticInitializer:MethodInfo;

		public var classMultiname:QualifiedName;

		public var metadata:Vector.<Metadata>;

		public function ClassInfo() {
			super();
		}

		public function toString():String {
			return StringUtils.substitute("ClassInfo[\n\tstaticInitializer={0}\n\ttraits=[\n\t\t{1}\n\t]\n]", staticInitializer, traits.join("\n\t\t"));
		}

		override public function equals(other:Object):Boolean {
			var result:Boolean = super.equals(other);
			if (result) {
				var otherClassInfo:ClassInfo = other as ClassInfo;
				if (otherClassInfo != null) {
					if (!staticInitializer.equals(otherClassInfo.staticInitializer)) {
						return false;
					}
					if (!classMultiname.equals(otherClassInfo.classMultiname)) {
						return false;
					}
					if (metadata != null) {
						if (metadata.length != otherClassInfo.metadata.length) {
							return false;
						}
						var len:int = metadata.length;
						var i:int;
						var md:Metadata;
						var otherMd:Metadata;
						for (i = 0; i < len; ++i) {
							md = metadata[i];
							otherMd = otherClassInfo.metadata[i];
							if (!md.equals(otherMd)) {
								return false;
							}
						}
					}
					return true;
				} else {
					return false;
				}
			}
			return result;
		}
	}
}
