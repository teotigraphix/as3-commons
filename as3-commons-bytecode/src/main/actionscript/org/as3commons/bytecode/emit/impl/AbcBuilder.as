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
	import org.as3commons.bytecode.emit.IAbcBuilder;
	import org.as3commons.bytecode.emit.IPackageBuilder;
	import org.as3commons.lang.Assert;

	public class AbcBuilder implements IAbcBuilder {

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
				throw new IllegalOperationError("Package with name " + name + " is already defined.");
			}
			var pb:PackageBuilder = new PackageBuilder(name);
			_packageBuilders[name] = pb;
			return pb;
		}

		public function build():AbcFile {
            var abcFile:AbcFile = new AbcFile();
			return abcFile;
		}
	}

}