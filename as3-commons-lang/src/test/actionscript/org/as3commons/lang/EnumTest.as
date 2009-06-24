package org.as3commons.lang {
	
	import flexunit.framework.TestCase;
	
	import org.as3commons.lang.testclasses.Day;
	
	public class EnumTest extends TestCase {
		
		public function EnumTest(methodName:String = null) {
			super(methodName);
		}
		
		//
		
		public function testNew():void {
			var enum:Enum = new Enum("myEnum");
			assertEquals("myEnum", enum.name);
			
			var enum2:Enum = new Enum("");
			assertEquals("", enum2.name);
			
			var enum3:Enum = new Enum(null);
			assertEquals(null, enum3.name);
			
			var enum4:Enum = new Enum("   ");
			assertEquals("", enum4.name);
		}
		
		public function testGetValues():void {
			var values:Array = Enum.getValues(Day);
			assertNotNull(values);
			assertEquals(7, values.length);
			
			var values2:Array = Enum.getValues(Day);
			assertNotNull(values2);
			assertEquals(7, values2.length);
		}
		
		public function testGetValues_shouldNotContainDuplicateValues():void {
			new Enum("myEnum");
			
			var numValues:uint = Enum.getValues(Enum).length;
			
			new Enum("myEnum");
			
			assertEquals(numValues, Enum.getValues(Enum).length);
		}
	}
}