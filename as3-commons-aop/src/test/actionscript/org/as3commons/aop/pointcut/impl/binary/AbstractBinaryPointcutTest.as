package org.as3commons.aop.pointcut.impl.binary {
	import org.as3commons.aop.pointcut.IBinaryPointcut;
	import org.as3commons.aop.pointcut.IPointcut;
	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.assertNotNull;

	public class AbstractBinaryPointcutTest {

		public function AbstractBinaryPointcutTest() {
		}

		// --------------------------------------------------------------------
		//
		// Tests - new
		//
		// --------------------------------------------------------------------

		[Test(expects="org.as3commons.lang.IllegalArgumentError")]
		public function testNewWithNullLeftAndRight():void {
			new AbstractBinaryPointcut(null, null);
		}

		[Test(expects="org.as3commons.lang.IllegalArgumentError")]
		public function testNewWithNullLeft():void {
			new AbstractBinaryPointcut(null, new PointcutImpl());
		}

		[Test(expects="org.as3commons.lang.IllegalArgumentError")]
		public function testNewWithNullRight():void {
			new AbstractBinaryPointcut(new PointcutImpl(), null);
		}

		// --------------------------------------------------------------------
		//
		// Tests
		//
		// --------------------------------------------------------------------

		[Test]
		public function testLeft():void {
			var left:IPointcut = new PointcutImpl();
			var pointcut:IBinaryPointcut = new AbstractBinaryPointcut(left, new PointcutImpl());
			assertNotNull(pointcut.left);
			assertEquals(left, pointcut.left);
		}

		[Test]
		public function testRight():void {
			var right:IPointcut = new PointcutImpl();
			var pointcut:IBinaryPointcut = new AbstractBinaryPointcut(new PointcutImpl(), right);
			assertNotNull(pointcut.right);
			assertEquals(right, pointcut.right);
		}

	}
}

import org.as3commons.aop.pointcut.IPointcut;

class PointcutImpl implements IPointcut {

	public function PointcutImpl() {
	}

	public function matches(criterion:* = null):Boolean {
		return false;
	}
}
