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
			var p:Parameter = new Parameter(1, null, ApplicationDomain.currentDomain, false);
			assertEquals(1, p.index);
			assertNull(p.type);
			assertFalse(p.isOptional);
		}

		// --------------------------------------------------------------------
		//
		// as3commons_reflect
		//
		// --------------------------------------------------------------------

		public function testSetProperties():void {
			var p:Parameter = new Parameter(1, null, ApplicationDomain.currentDomain, false);
			p.as3commons_reflect::setIndex(2);
			p.as3commons_reflect::setIsOptional(true);
			p.as3commons_reflect::setType(Type.forClass(String).fullName);
			assertEquals(2, p.index);
			assertEquals(true, p.isOptional);
			assertEquals(Type.forClass(String), p.type);
		}

		public function testNewInstance():void {
			var appDomain:ApplicationDomain = ApplicationDomain.currentDomain;
			var pm1:Parameter = Parameter.newInstance(1, "MyClass", appDomain, false);
			var pm2:Parameter = Parameter.newInstance(1, "MyClass", appDomain, false);
			var pm3:Parameter = Parameter.newInstance(1, "MyClass", appDomain, false);
			assertStrictlyEquals(pm1, pm2);
			assertStrictlyEquals(pm1, pm3);
		}

		public function testNewInstanceWithDifferentIsOptional():void {
			var appDomain:ApplicationDomain = ApplicationDomain.currentDomain;
			var pm1:Parameter = Parameter.newInstance(1, "MyClass", appDomain, false);
			var pm2:Parameter = Parameter.newInstance(1, "MyClass", appDomain, true);
			assertFalse(pm1 === pm2);
		}

		public function testNewInstanceWithDifferentType():void {
			var appDomain:ApplicationDomain = ApplicationDomain.currentDomain;
			var pm1:Parameter = Parameter.newInstance(1, "MyClass", appDomain, false);
			var pm2:Parameter = Parameter.newInstance(1, "MyClass2", appDomain, false);
			assertFalse(pm1 === pm2);
		}

		public function testNewInstanceWithDifferentIndex():void {
			var appDomain:ApplicationDomain = ApplicationDomain.currentDomain;
			var pm1:Parameter = Parameter.newInstance(1, "MyClass", appDomain, false);
			var pm2:Parameter = Parameter.newInstance(2, "MyClass", appDomain, false);
			assertFalse(pm1 === pm2);
		}

	}
}
