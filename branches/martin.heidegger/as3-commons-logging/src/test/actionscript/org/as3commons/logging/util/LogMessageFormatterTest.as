package org.as3commons.logging.util {
	import org.as3commons.logging.LogTests;
	import org.as3commons.logging.LoggerFactory;
	import flexunit.framework.TestCase;

	/**
	 * @author mh
	 */
	public class LogMessageFormatterTest extends TestCase {
		
		public function testTypos(): void {
			assertEquals( "{MESSAGE}", LogMessageFormatter.format( "{MESSAGE}", null, null, null, NaN, "a message", null ) );
			assertEquals( "{ message }", LogMessageFormatter.format( "{ message }", null, null, null, null, "a message", null ) );
			assertEquals( "{me ssage}", LogMessageFormatter.format( "{me ssage}", null, null, null, null, "a message", null ) );
			assertEquals( "{meSsage}", LogMessageFormatter.format( "{meSsage}", null, null, null, null, "a message", null ) );
		}
		
		public function testBraces(): void {
			assertEquals( "{a message", LogMessageFormatter.format( "{{message}", null, null, null, null, "a message", null ) );
			assertEquals( "{a message}a message", LogMessageFormatter.format( "{{message}}{message}", null, null, null, null, "a message", null ) );
			assertEquals( "}a message", LogMessageFormatter.format( "}{message}", null, null, null, null, "a message", null ) );
			assertEquals( "{a message", LogMessageFormatter.format( "{{message}", null, null, null, null, "a message", null ) );
			assertEquals( "{message}", LogMessageFormatter.format( "{{message}}", null, null, null, null, "message", null ) );
			assertEquals( "{{message}a{name}", LogMessageFormatter.format( "{{{message}}a{{name}}", "name", null, null, null, "message", null ) );
		}
		
		public function testMultipleOccurances(): void {
			assertEquals( "a a a", LogMessageFormatter.format( "{message} {message} {message}", null, null, null, null, "a", null ) );
			assertEquals( "a name a", LogMessageFormatter.format( "{message} {name} {message}", "name", null, null, null, "a", null ) );
		}
		
		public function testSimpleMessages(): void {
			
			var time: Date = new Date( 1970, 0, 1, 0, 1, 1, 23 );
			
			assertEquals( "hello", LogMessageFormatter.format( "hello", null, null, null, NaN, null, null ) );
			assertEquals( "a name", LogMessageFormatter.format( "{name}", "a name", null, null, NaN, null, null ) );
			assertEquals( "null", LogMessageFormatter.format( "{name}", null, null, null, NaN, null, null ) );
			assertEquals( "null", LogMessageFormatter.format( "{name}", undefined, null, null, NaN, null, null ) );
			assertEquals( "a short name", LogMessageFormatter.format( "{shortName}", null, "a short name", null, NaN, null, null ) );
			assertEquals( "null", LogMessageFormatter.format( "{shortName}", null, null, null, NaN, null, null ) );
			assertEquals( "null", LogMessageFormatter.format( "{shortName}", null, undefined, null, NaN, null, null ) );
			assertEquals( "a message", LogMessageFormatter.format( "{message}", null, null, null, NaN, "a message", null ) );
			assertEquals( "null", LogMessageFormatter.format( "{message}", null, null, null, NaN, null, null ) );
			assertEquals( "null", LogMessageFormatter.format( "{message}", null, null, null, NaN, undefined, null ) );
			assertEquals( "a message", LogMessageFormatter.format( "{message_dqt}", null, null, null, NaN, "a message", null ) );
			assertEquals( "a mess\\\"age", LogMessageFormatter.format( "{message_dqt}", null, null, null, NaN, "a mess\"age", null ) );
			assertEquals( "null", LogMessageFormatter.format( "{message_dqt}", null, null, null, NaN, null, null ) );
			assertEquals( "null", LogMessageFormatter.format( "{message_dqt}", null, null, null, NaN, undefined, null ) );
			assertEquals( "a message", LogMessageFormatter.format( "{message_dqt}", null, null, null, NaN, "a message", null ) );
			assertEquals( "a mess\\\"age", LogMessageFormatter.format( "{message_dqt}", null, null, null, NaN, "a mess\"age", null ) );
			assertEquals( "null", LogMessageFormatter.format( "{message_dqt}", null, null, null, NaN, null, null ) );
			assertEquals( "null", LogMessageFormatter.format( "{message_dqt}", null, null, null, NaN, undefined, null ) );
			assertEquals( "0:1:1.23", LogMessageFormatter.format( "{time}", null, null, null, time.getTime(), null, null ) );
			assertEquals( "23:1:1.23", LogMessageFormatter.format( "{timeUTC}", null, null, null, time.getTime(), null, null ) );
			assertEquals( "23:01:01.023", LogMessageFormatter.format( "{logTime}", null, null, null, time.getTime(), null, null ) );
			assertEquals( "1970/1/1", LogMessageFormatter.format( "{date}", null, null, null, time.getTime(), null, null ) );
			assertEquals( "1969/12/31", LogMessageFormatter.format( "{dateUTC}", null, null, null, time.getTime(), null, null ) );
			assertEquals( "1:0:0.0", LogMessageFormatter.format( "{time}", null, null, null, NaN, null, null ) );
			assertEquals( "1:0:0.0", LogMessageFormatter.format( "{time}", null, null, null, null, null, null ) );
			assertEquals( "0:0:0.0", LogMessageFormatter.format( "{timeUTC}", null, null, null, null, null, null ) );
			assertEquals( "{0}", LogMessageFormatter.format( "{0}", null, null, null, null, null, ["a"] ) );
			assertEquals( "a", LogMessageFormatter.format( "{message}", null, null, null, null, "{0}", ["a"] ) );
			assertEquals( "f", LogMessageFormatter.format( "{message}", null, null, null, null, "{5}", ["a","b","c","d","e","f"] ) );
			assertEquals( LoggerFactory.SWF_URL_ERROR, LogMessageFormatter.format( "{swf}", null, null, null, null, null, null ) );
			assertEquals( LoggerFactory.SWF_URL_ERROR, LogMessageFormatter.format( "{shortSWF}", null, null, null, null, null, null ) );
			
			LoggerFactory.initSWFURLs( LogTests.STAGE );
			assertEquals( LoggerFactory.SWF_URL, LogMessageFormatter.format( "{swf}", null, null, null, null, null, null ) );
			assertEquals( LoggerFactory.SWF_SHORT_URL, LogMessageFormatter.format( "{shortSWF}", null, null, null, null, null, null ) );
			LoggerFactory.initSWFURLs( null );
		}
	}
}
