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
package org.as3commons.bytecode.swf {
	import flash.utils.ByteArray;

	import org.as3commons.bytecode.emit.IClassBuilder;
	import org.as3commons.bytecode.emit.IInterfaceBuilder;

	/**
	 * <code>ISWFWeaver</code> implementation used to manipulate existing classes in a SWF file.
	 * @author Roland Zwaga
	 */
	public class SWFWeaver implements ISWFWeaver {

		private var _SWFWeaverIO:SWFWeaverIO;

		/**
		 * Creates a new <code>SWFWeaver</code> instance.
		 */
		public function SWFWeaver() {
			super();
			initSWFWeaver();
		}

		/**
		 * Initializes the current <code>SWFWeaver</code>.
		 */
		protected function initSWFWeaver():void {
			_SWFWeaverIO = new SWFWeaverIO();
		}

		public function initialize(byteArray:ByteArray):void {
			_SWFWeaverIO.read(byteArray);
		}

		public function getClassBuilder(className:String):IClassBuilder {
			return null;
		}

		public function getInterfaceBuilder(interfaceName:String):IInterfaceBuilder {
			return null;
		}

		public function serialize():void {
		}
	}
}