package org.as3commons.logging.setup.target {
	import flash.text.TextField;
	import flexunit.framework.TestCase;
	import org.as3commons.logging.level.DEBUG;
	import org.as3commons.logging.util.START_TIME;



	/**
	 * @author mh
	 */
	public class TextFieldTest extends TestCase {
		
		private const textField: TextField = new TextField();
		private var lineEnd : String;
		
		public function TextFieldTest() {}
		
		private var target: TextFieldTarget;
		
		override public function setUp():void {
			textField.appendText( "t\n" );
			// The line ending of a textfield varies with operating system... perhaps
			lineEnd = textField.text.charAt( textField.length-1 );
		}
		
		public function testDefaultFormat(): void {
			target = new TextFieldTarget();
			
			target.log( "longName", "shortName", DEBUG, 123-START_TIME, "Hello World {0} {1}", ["my","dear"], null );
			
			assertEquals( target.text, "9:0:0.123 DEBUG - shortName - Hello World my dear" + lineEnd );
		}
		
		public function testRedirection(): void {
			var field: TextField = new TextField();
			target = new TextFieldTarget( null, field );
			
			target.log( "longName", "shortName", DEBUG, 123-START_TIME, "Hello World", [], null );
			
			assertEquals( target.text, "" );
			assertEquals( field.text, "9:0:0.123 DEBUG - shortName - Hello World" + lineEnd );
		}
		
		public function testCustomFormat(): void {
			target = new TextFieldTarget( "{shortName}\n" );
			
			target.log( "longName", "shortName", DEBUG, 123-START_TIME, "Hello World", [], null );
			
			assertEquals( target.text, "shortName" + lineEnd );
		}
	}
}
