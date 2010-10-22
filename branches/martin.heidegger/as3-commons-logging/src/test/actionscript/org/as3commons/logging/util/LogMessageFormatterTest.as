package org.as3commons.logging.util {
	import flexunit.framework.TestCase;

	import org.as3commons.logging.LogTests;

	/**
	 * @author mh
	 */
	public class LogMessageFormatterTest extends TestCase {
		private static const SECOND : Number = 1000;
		private static const MINUTE : Number = SECOND * 60;
		private static const HOUR : Number = MINUTE * 60;
		private static const DAY : Number = HOUR * 24;
		
		public function testTypos(): void {
			assertEquals( "{MESSAGE}", new LogMessageFormatter( "{MESSAGE}" ).format( null, null, null, NaN, "a message", null ) );
			assertEquals( "{ message }", new LogMessageFormatter( "{ message }" ).format( null, null, null, NaN, "a message", null ) );
			assertEquals( "{me ssage}", new LogMessageFormatter( "{me ssage}" ).format( null, null, null, NaN, "a message", null ) );
			assertEquals( "{meSsage}", new LogMessageFormatter( "{meSsage}" ).format( null, null, null, NaN, "a message", null ) );
		}
		
		public function testBraces(): void {
			assertEquals( "{a message", new LogMessageFormatter( "{{message}" ).format( null, null, null, NaN, "a message", null ) );
			assertEquals( "{a message}a message", new LogMessageFormatter( "{{message}}{message}" ).format( null, null, null, NaN, "a message", null ) );
			assertEquals( "}a message", new LogMessageFormatter( "}{message}" ).format( null, null, null, NaN, "a message", null ) );
			assertEquals( "{a message", new LogMessageFormatter( "{{message}" ).format( null, null, null, NaN, "a message", null ) );
			assertEquals( "{message}", new LogMessageFormatter( "{{message}}" ).format( null, null, null, NaN, "message", null ) );
			assertEquals( "{{message}a{name}", new LogMessageFormatter( "{{{message}}a{{name}}" ).format( "name", null, null, NaN, "message", null ) );
		}
		
		public function testMultipleOccurances(): void {
			assertEquals( "a a a", new LogMessageFormatter( "{message} {message} {message}" ).format( null, null, null, NaN, "a", null ) );
			assertEquals( "a name a", new LogMessageFormatter( "{message} {name} {message}" ).format( "name", null, null, NaN, "a", null ) );
		}
		
		public function testMixedMessages(): void {
			var time: Date = new Date( DAY + MINUTE + SECOND + 23 );
			
			assertEquals( "TimeUTC: (0:1:1.23), Time: \"9:1:1.23\", Message: [hello world]", new LogMessageFormatter( "TimeUTC: ({timeUTC}), Time: \"{time}\", Message: [{message}]" ).format( "", "", null, time.time, "hello world", null ));
		}
		
		public function testSimpleMessages(): void {
			
			var time: Date = new Date( DAY + MINUTE + SECOND + 23 );
			
			assertEquals( "hello", new LogMessageFormatter( "hello" ).format( null, null, null, NaN, null, null ) );
			assertEquals( "a name", new LogMessageFormatter( "{name}" ).format( "a name", null, null, NaN, null, null ) );
			assertEquals( "null", new LogMessageFormatter( "{name}" ).format( null, null, null, NaN, null, null ) );
			assertEquals( "null", new LogMessageFormatter( "{name}" ).format( undefined, null, null, NaN, null, null ) );
			assertEquals( "a short name", new LogMessageFormatter( "{shortName}" ).format( null, "a short name", null, NaN, null, null ) );
			assertEquals( "null", new LogMessageFormatter( "{shortName}" ).format( null, null, null, NaN, null, null ) );
			assertEquals( "null", new LogMessageFormatter( "{shortName}" ).format( null, undefined, null, NaN, null, null ) );
			assertEquals( "a message", new LogMessageFormatter( "{message}" ).format( null, null, null, NaN, "a message", null ) );
			assertEquals( "null", new LogMessageFormatter( "{message}" ).format( null, null, null, NaN, null, null ) );
			assertEquals( "null", new LogMessageFormatter( "{message}" ).format( null, null, null, NaN, undefined, null ) );
			assertEquals( "a message", new LogMessageFormatter( "{message_dqt}" ).format( null, null, null, NaN, "a message", null ) );
			assertEquals( "a mess\\\"age", new LogMessageFormatter( "{message_dqt}" ).format( null, null, null, NaN, "a mess\"age", null ) );
			assertEquals( "null", new LogMessageFormatter( "{message_dqt}" ).format( null, null, null, NaN, null, null ) );
			assertEquals( "null", new LogMessageFormatter( "{message_dqt}" ).format( null, null, null, NaN, undefined, null ) );
			assertEquals( "a message", new LogMessageFormatter( "{message_dqt}" ).format( null, null, null, NaN, "a message", null ) );
			assertEquals( "a mess\\\"age", new LogMessageFormatter( "{message_dqt}" ).format( null, null, null, NaN, "a mess\"age", null ) );
			assertEquals( "null", new LogMessageFormatter( "{message_dqt}" ).format( null, null, null, NaN, null, null ) );
			assertEquals( "null", new LogMessageFormatter( "{message_dqt}" ).format( null, null, null, NaN, undefined, null ) );
			assertEquals( "9:1:1.23", new LogMessageFormatter( "{time}" ).format( null, null, null, time.getTime(), null, null ) );
			assertEquals( "0:1:1.23", new LogMessageFormatter( "{timeUTC}" ).format( null, null, null, time.getTime(), null, null ) );
			assertEquals( "00:01:01.023", new LogMessageFormatter( "{logTime}" ).format( null, null, null, time.getTime(), null, null ) );
			assertEquals( "1970/1/2", new LogMessageFormatter( "{date}" ).format( null, null, null, time.getTime(), null, null ) );
			assertEquals( "1970/1/2", new LogMessageFormatter( "{dateUTC}" ).format( null, null, null, time.getTime(), null, null ) );
			assertEquals( "9:0:0.0", new LogMessageFormatter( "{time}" ).format( null, null, null, NaN, null, null ) );
			assertEquals( "9:0:0.0", new LogMessageFormatter( "{time}" ).format( null, null, null, null, null, null ) );
			assertEquals( "0:0:0.0", new LogMessageFormatter( "{timeUTC}" ).format( null, null, null, null, null, null ) );
			assertEquals( "{0}", new LogMessageFormatter( "{0}" ).format( null, null, null, null, null, ["a"] ) );
			assertEquals( "a", new LogMessageFormatter( "{message}" ).format( null, null, null, null, "{0}", ["a"] ) );
			assertEquals( "f", new LogMessageFormatter( "{message}" ).format( null, null, null, null, "{5}", ["a","b","c","d","e","f"] ) );
			assertEquals( SWFInfo.URL_ERROR, new LogMessageFormatter( "{swf}" ).format( null, null, null, null, null, null ) );
			assertEquals( SWFInfo.URL_ERROR, new LogMessageFormatter( "{shortSWF}" ).format( null, null, null, null, null, null ) );
			
			SWFInfo.init( LogTests.STAGE );
			assertEquals( SWFInfo.URL, new LogMessageFormatter( "{swf}" ).format( null, null, null, null, null, null ) );
			assertEquals( SWFInfo.SHORT_URL, new LogMessageFormatter( "{shortSWF}" ).format( null, null, null, null, null, null ) );
			SWFInfo.init( null );
		}
	}
}
