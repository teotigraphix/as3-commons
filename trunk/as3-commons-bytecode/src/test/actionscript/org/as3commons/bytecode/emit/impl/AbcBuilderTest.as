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
	import flash.events.Event;

	import flash.events.IOErrorEvent;
	import flash.system.ApplicationDomain;

	import flexunit.framework.TestCase;

	import org.as3commons.bytecode.abc.AbcFile;
	import org.as3commons.bytecode.abc.MethodInfo;
	import org.as3commons.bytecode.abc.Op;
	import org.as3commons.bytecode.abc.enum.Opcode;
	import org.as3commons.bytecode.emit.IAbcBuilder;
	import org.as3commons.bytecode.emit.IClassBuilder;
	import org.as3commons.bytecode.emit.IMethodBodyBuilder;
	import org.as3commons.bytecode.emit.IMethodBuilder;
	import org.as3commons.bytecode.swf.AbcClassLoader;

	public class AbcBuilderTest extends TestCase {

		private var _abcBuilder:IAbcBuilder;
		private var _loader:AbcClassLoader;

		public function AbcBuilderTest() {
			super();
		}

		override public function setUp():void {
			_abcBuilder = new AbcBuilder();
			_loader = new AbcClassLoader();
		}

		public function testBuild():void {
			var classBuilder:IClassBuilder = _abcBuilder.definePackage("com.myclasses.test").defineClass("MyTest");
			var methodBuilder:IMethodBuilder = classBuilder.defineMethod();
			methodBuilder.name = "testMe";
			var methodBodyBuilder:IMethodBodyBuilder = methodBuilder.defineMethodBody();
			methodBodyBuilder.addOpcode(new Op(Opcode.getlocal_0));
			methodBodyBuilder.addOpcode(new Op(Opcode.returnvoid));
			var abcFile:AbcFile = _abcBuilder.build();
//			assertEquals(1,abcFile.methodInfo.length);
//			assertTrue(abcFile.methodInfo[0] is MethodInfo);
			_loader.addEventListener(Event.COMPLETE, addAsync(successHandler, 5000), false, 0, true);
			_loader.addEventListener(IOErrorEvent.IO_ERROR, addAsync(errorHandler, 5000), false, 0, true);
			_loader.loadAbcFile(abcFile);
		}

		private function errorHandler(event:IOErrorEvent):void {
			fail("loader error: " + event.text);
		}

		private function successHandler(event:Event):void {
			var cls:Class = ApplicationDomain.currentDomain.getDefinition("com.myclasses.test.MyTest") as Class;
			assertNotNull(cls);
		}
	}
}