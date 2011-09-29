package org.as3commons.reflect {
	import flash.system.ApplicationDomain;
	import flash.utils.getQualifiedClassName;

	import flexunit.framework.Assert;
	import flexunit.framework.TestCase;

	import org.as3commons.reflect.testclasses.ComplexClass;
	import org.as3commons.reflect.testclasses.PublicClass;

	public class TypeCacheTest extends TestCase {

		private var cache:TypeCache;

		override public function setUp():void {
			cache = new TypeCache();
			cache.put(getQualifiedClassName(PublicClass), Type.forClass(PublicClass), Type.currentApplicationDomain);

		}

		public function TypeCacheTest(methodName:String=null) {
			super(methodName);
		}

		public function testClear():void {
			Assert.assertEquals(1, cache.size(Type.currentApplicationDomain));

			cache.clear();
			Assert.assertEquals(0, cache.size(Type.currentApplicationDomain));
		}

		public function testContains():void {
			Assert.assertTrue(cache.contains(getQualifiedClassName(PublicClass), Type.currentApplicationDomain));
		}

		public function testGet():void {
			Assert.assertNotNull(cache.get(getQualifiedClassName(PublicClass), Type.currentApplicationDomain));
		}

		public function testPut():void {
			try {
				cache.put(getQualifiedClassName(ComplexClass), Type.forClass(ComplexClass), Type.currentApplicationDomain);
			} catch (e:Error) {
				fail("Attempt to put new key/value threw an error.");
			}
		}
	}
}
