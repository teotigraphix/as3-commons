/*
 * Copyright (c) 2007-2009-2010 the original author or authors
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */
package org.as3commons.reflect {

	import flash.system.ApplicationDomain;

	import flexunit.framework.TestCase;

	/**
	 * @author Christophe Herreman
	 */
	public class ParameterTest extends TestCase {

		public function ParameterTest(methodName:String = null) {
			super(methodName);
		}

		public function testNewWithoutType():void {
			var p:Parameter = new Parameter(null, ApplicationDomain.currentDomain, false);
			assertNull(p.type);
			assertFalse(p.isOptional);
		}

		// --------------------------------------------------------------------
		//
		// as3commons_reflect
		//
		// --------------------------------------------------------------------

		public function testSetProperties():void {
			var p:Parameter = new Parameter(null, ApplicationDomain.currentDomain, false);
			p.as3commons_reflect::setIsOptional(true);
			p.as3commons_reflect::setType(Type.forClass(String).fullName);
			assertEquals(true, p.isOptional);
			assertEquals(Type.forClass(String), p.type);
		}

		public function testNewInstance():void {
			var appDomain:ApplicationDomain = ApplicationDomain.currentDomain;
			var pm1:Parameter = Parameter.newInstance("MyClass", appDomain, false);
			var pm2:Parameter = Parameter.newInstance("MyClass", appDomain, false);
			var pm3:Parameter = Parameter.newInstance("MyClass", appDomain, false);
			assertStrictlyEquals(pm1, pm2);
			assertStrictlyEquals(pm1, pm3);
			assertStrictlyEquals(pm2, pm3);
		}

		public function testNewInstanceWithDifferentIsOptional():void {
			var appDomain:ApplicationDomain = ApplicationDomain.currentDomain;
			var pm1:Parameter = Parameter.newInstance("MyClass", appDomain, false);
			var pm2:Parameter = Parameter.newInstance("MyClass", appDomain, true);
			assertFalse(pm1 === pm2);
		}

		public function testNewInstanceWithDifferentType():void {
			var appDomain:ApplicationDomain = ApplicationDomain.currentDomain;
			var pm1:Parameter = Parameter.newInstance("MyClass", appDomain, false);
			var pm2:Parameter = Parameter.newInstance("MyClass2", appDomain, false);
			assertFalse(pm1 === pm2);
		}

		/*public function testNewInstance_speed():void {
			for (var i:int = 0; i<1000; i++) {
				testNewInstance();
				testNewInstanceWithDifferentIsOptional();
				testNewInstanceWithDifferentType();
			}
		}*/

	}
}
