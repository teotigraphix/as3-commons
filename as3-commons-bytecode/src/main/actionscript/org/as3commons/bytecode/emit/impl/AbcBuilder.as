/*
 * Copyright 2007-2010 the original author or authors.
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
	import flash.utils.Dictionary;

	import org.as3commons.bytecode.abc.AbcFile;
	import org.as3commons.bytecode.abc.ClassInfo;
	import org.as3commons.bytecode.abc.InstanceInfo;
	import org.as3commons.bytecode.abc.MethodInfo;
	import org.as3commons.bytecode.emit.IAbcBuilder;
	import org.as3commons.bytecode.emit.IPackageBuilder;
	import org.as3commons.bytecode.typeinfo.Metadata;
	import org.as3commons.lang.Assert;
	import org.as3commons.lang.StringUtils;

	public class AbcBuilder implements IAbcBuilder {

		private static const PACKAGE_NAME_EXISTS_ERROR:String = "Package with name {0} is already defined.";

		private var _packageBuilders:Dictionary;

		public function AbcBuilder() {
			super();
			init();
		}

		private function init():void {
			_packageBuilders = new Dictionary;
		}

		public function definePackage(name:String):IPackageBuilder {
			if (_packageBuilders[name] != null) {
				throw new IllegalOperationError(StringUtils.substitute(PACKAGE_NAME_EXISTS_ERROR, name));
			}
			var pb:PackageBuilder = new PackageBuilder(name);
			_packageBuilders[name] = pb;
			return pb;
		}

		/**
		 * Returns an <code>AbcFile</code> containing all the generated type information,
		 * ready to be loaded into an AVM.
		 * @return The specified <code>AbcFile</code>.
		 */
		public function build():AbcFile {
			var abcFile:AbcFile = new AbcFile();
			for each (var pb:IPackageBuilder in _packageBuilders) {
				var arr:Array = pb.build();
				for each (var inst:Object in arr) {
					if (inst is ClassInfo) {
						abcFile.addClassInfo(ClassInfo(inst));
					} else if (inst is InstanceInfo) {
						abcFile.addInstanceInfo(InstanceInfo(inst));
					} else if (inst is MethodInfo) {
						addMethodInfo(abcFile, MethodInfo(inst));
					} else if (inst is Metadata) {
						abcFile.addMetadataInfo(Metadata(inst));
					}
				}
			}
			return abcFile;
		}

		protected function addMethodInfo(abcFile:AbcFile, methodInfo:MethodInfo):void {
			abcFile.addMethodInfo(methodInfo);
			abcFile.addMethodBody(methodInfo.methodBody);
		}

	}

}