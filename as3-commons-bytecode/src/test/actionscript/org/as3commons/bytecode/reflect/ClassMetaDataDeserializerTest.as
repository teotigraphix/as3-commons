package org.as3commons.bytecode.reflect {
	import flash.utils.ByteArray;

	import flexunit.framework.TestCase;

	import org.as3commons.bytecode.TestConstants;

	public class ClassMetaDataDeserializerTest extends TestCase {

		private var _ds:ClassMetadataDeserializer;

		public function ClassMetaDataDeserializerTest(methodName:String = null) {
			super(methodName);
		}

		override public function setUp():void {
			super.setUp();
			_ds = new ClassMetadataDeserializer();
		}

		public function testRead():void {
			var ba:ByteArray = TestConstants.getMetadataLookupTest();
			var typeCache:ByteCodeTypeCache = new ByteCodeTypeCache();
			_ds.read(typeCache, ba, null, false);
			var lookup:Object = typeCache.metaDataLookup;
			assertNotNull(lookup['testmetadata']);
			var arr:Array = typeCache.getClassesWithMetadata('TestMetadata');
			assertEquals(3, arr.length);
			assertTrue(arr.indexOf('com.classes.test.AnnotatedClass') > -1);
			assertTrue(arr.indexOf('com.classes.test.DoubleAnnotatedClass') > -1);
			assertTrue(arr.indexOf('com.classes.test.TripleAnnotatedClass') > -1);
			assertNotNull(lookup['moretestmetadata']);
			arr = typeCache.getClassesWithMetadata('MoreTestMetadata');
			assertEquals(2, arr.length);
			assertTrue(arr.indexOf('com.classes.test.DoubleAnnotatedClass') > -1);
			assertTrue(arr.indexOf('com.classes.test.TripleAnnotatedClass') > -1);
			assertNotNull(lookup['lasttestmetadata']);
			arr = typeCache.getClassesWithMetadata('LastTestMetadata');
			assertEquals(1, arr.length);
			assertTrue(arr[0] = 'com.classes.test.TripleAnnotatedClass');

			var classNames:Array = typeCache.definitionNames;
			//fifth class is some sprite class that gets automatically compiled into a swc
			assertEquals(5, classNames.length);
			assertTrue(classNames.indexOf('com.classes.test.AnnotatedClass') > -1);
			assertTrue(classNames.indexOf('com.classes.test.DoubleAnnotatedClass') > -1);
			assertTrue(classNames.indexOf('com.classes.test.TripleAnnotatedClass') > -1);
			assertTrue(classNames.indexOf('com.classes.test.NormalClass') > -1);
		}
	}
}