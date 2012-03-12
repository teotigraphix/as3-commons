package org.as3commons.logging.util {
	import flexunit.framework.TestCase;


	/**
	 * @author mh
	 */
	public class LogMessageFormatterTest extends TestCase {
		private static const SECOND : Number = 1000;
		private static const MINUTE : Number = SECOND * 60;
		private static const HOUR : Number = MINUTE * 60;
		private static const DAY : Number = HOUR * 24;
		
		public function testTypos(): void {
			assertEquals( "{MESSAGE}", new LogMessageFormatter( "{MESSAGE}" ).format( null, null, 0, NaN, "a message", null, null, null, null ) );
			assertEquals( "{ message }", new LogMessageFormatter( "{ message }" ).format( null, null, 0, NaN, "a message", null, null, null, null ) );
			assertEquals( "{me ssage}", new LogMessageFormatter( "{me ssage}" ).format( null, null, 0, NaN, "a message", null, null, null, null ) );
			assertEquals( "{meSsage}", new LogMessageFormatter( "{meSsage}" ).format( null, null, 0, NaN, "a message", null, null, null, null ) );
		}
		
		public function testBraces(): void {
			assertEquals( "{a message", new LogMessageFormatter( "{{message}" ).format( null, null, 0, NaN, "a message", null, null, null, null ) );
			assertEquals( "{a message}a message", new LogMessageFormatter( "{{message}}{message}" ).format( null, null, 0, NaN, "a message", null, null, null, null ) );
			assertEquals( "}a message", new LogMessageFormatter( "}{message}" ).format( null, null, 0, NaN, "a message", null, null, null, null ) );
			assertEquals( "{a message", new LogMessageFormatter( "{{message}" ).format( null, null, 0, NaN, "a message", null, null, null, null ) );
			assertEquals( "{message}", new LogMessageFormatter( "{{message}}" ).format( null, null, 0, NaN, "message", null, null, null, null ) );
			assertEquals( "{{message}a{name}", new LogMessageFormatter( "{{{message}}a{{name}}" ).format( "name", null, 0, NaN, "message", null, null, null, null ) );
		}
		
		public function testMultipleOccurances(): void {
			assertEquals( "a a a", new LogMessageFormatter( "{message} {message} {message}" ).format( null, null, 0, NaN, "a", null, null, null, null ) );
			assertEquals( "a name a", new LogMessageFormatter( "{message} {name} {message}" ).format( "name", null, 0, NaN, "a", null, null, null, null ) );
		}
		
		public function testMixedMessages(): void {
			var time: Date = new Date( DAY + MINUTE + SECOND + 23 );
			
			assertEquals( "TimeUTC: (0:1:1.23), Time: \"9:1:1.23\", Message: [hello world]", new LogMessageFormatter( "TimeUTC: ({timeUTC}), Time: \"{time}\", Message: [{message}]" ).format( "", "", 0, time.time-START_TIME, "hello world", null, null, null, null ));
		}
		
		public function testDeepLookup():void {
			assertEquals( "abc", new LogMessageFormatter( "{message}").format(null, null, 0, NaN, "{}", "abc", null, null, null) );
			assertEquals( "abc", new LogMessageFormatter( "{message}").format(null, null, 0, NaN, "{test}", {test:"abc"}, null, null, null) );
			assertEquals( "abc", new LogMessageFormatter( "{message}").format(null, null, 0, NaN, "{test.test}", {test:{test:"abc"}}, null, null, null) );
			assertEquals( "abc", new LogMessageFormatter( "{message}").format(null, null, 0, NaN, "{てすと}", {"てすと":"abc"}, null, null, null ) );
			assertEquals( "abc", new LogMessageFormatter( "{message}").format(null, null, 0, NaN, "{a-b}", {"a-b":"abc"}, null, null, null ) );
			assertEquals( "abc", new LogMessageFormatter( "{message}").format(null, null, 0, NaN, "{{}", {"{":"abc"}, null, null, null ) );
			assertEquals( "abc", new LogMessageFormatter( "{message}").format(null, null, 0, NaN, "{}}", {"}":"abc"}, null, null, null ) );
			assertEquals( "abc", new LogMessageFormatter( "{message}").format(null, null, 0, NaN, "{{}}", {"{}":"abc"}, null, null, null ) );
			assertEquals( "3", new LogMessageFormatter( "{message}").format(null, null, 0, NaN, "{length}", "abc", null, null, null ) );
			assertEquals( "null", new LogMessageFormatter( "{message}").format(null, null, 0, NaN, "{.length}", "abc", null, null, null ) );
			assertEquals( "null", new LogMessageFormatter( "{message}").format(null, null, 0, NaN, "{test.}", {"test":"abc"}, null, null, null ) );
			assertEquals( "null", new LogMessageFormatter( "{message}").format(null, null, 0, NaN, "{test..}", {"test":"abc"}, null, null, null ) );
			assertEquals( "null", new LogMessageFormatter( "{message}").format(null, null, 0, NaN, "{}", null, null, null, null ) );
			assertEquals( "null", new LogMessageFormatter( "{message}").format(null, null, 0, NaN, "{0}", null, null, null, null ) );
			assertEquals( "null", new LogMessageFormatter( "{message}").format(null, null, 0, NaN, "{0}", {}, null, null, null ) );
			assertEquals( "null", new LogMessageFormatter( "{message}").format(null, null, 0, NaN, "{1}", [], null, null, null ) );
			assertEquals( "null", new LogMessageFormatter( "{message}").format(null, null, 0, NaN, "{test..test}", {test:{test:"abc"}}, null, null, null) );
			assertEquals( "null", new LogMessageFormatter( "{message}").format(null, null, 0, NaN, "{test..test}", {test:{test:"abc"}}, null, null, null) );
			assertEquals( "null", new LogMessageFormatter( "{message}").format(null, null, 0, NaN, "{test..test}", <xml><test><anything><test>abc</test></anything></test></xml>, null, null, null ) );
			assertEquals( "[RangeError: Error #1125: The index 1 is out of range 0.]", new LogMessageFormatter( "{message}").format(null, null, 0, NaN, "{1}", new Vector.<String>(0), null, null, null ) );
		}
		
		public function testSimpleMessages(): void {
			
			var time: Date = new Date( DAY + MINUTE + SECOND + 23 );
			
			assertEquals( "hello", new LogMessageFormatter( "hello" ).format( null, null, 0, NaN, null, null, null, null, null ) );
			assertEquals( "a name", new LogMessageFormatter( "{name}" ).format( "a name", null, 0, NaN, null, null, null, null, null ) );
			assertEquals( "null", new LogMessageFormatter( "{name}" ).format( null, null, 0, NaN, null, null, null, null, null ) );
			assertEquals( "null", new LogMessageFormatter( "{name}" ).format( undefined, null, 0, NaN, null, null, null, null, null ) );
			assertEquals( "a short name", new LogMessageFormatter( "{shortName}" ).format( null, "a short name", 0, NaN, null, null, null, null, null ) );
			assertEquals( "null", new LogMessageFormatter( "{shortName}" ).format( null, null, 0, NaN, null, null, null, null, null ) );
			assertEquals( "null", new LogMessageFormatter( "{shortName}" ).format( null, undefined, 0, NaN, null, null, null, null, null ) );
			assertEquals( "a message", new LogMessageFormatter( "{message}" ).format( null, null, 0, NaN, "a message", null, null, null, null ) );
			assertEquals( "null", new LogMessageFormatter( "{message}" ).format( null, null, 0, NaN, null, null, null, null, null ) );
			assertEquals( "null", new LogMessageFormatter( "{message}" ).format( null, null, 0, NaN, undefined, null, null, null, null ) );
			assertEquals( "a message", new LogMessageFormatter( "{message_dqt}" ).format( null, null, 0, NaN, "a message", null, null, null, null ) );
			assertEquals( "a \\nm\\ness\\\"ag\\\"e", new LogMessageFormatter( "{message_dqt}" ).format( null, null, 0, NaN, "a \nm\ness\"ag\"e", null, null, null, null ) );
			assertEquals( "null", new LogMessageFormatter( "{message_dqt}" ).format( null, null, 0, NaN, null, null, null, null, null ) );
			assertEquals( "null", new LogMessageFormatter( "{message_dqt}" ).format( null, null, 0, NaN, undefined, null, null, null, null ) );
			assertEquals( "a message", new LogMessageFormatter( "{message_dqt}" ).format( null, null, 0, NaN, "a message", null, null, null, null ) );
			assertEquals( "a \\nm\\ness\\\"ag\\\"e", new LogMessageFormatter( "{message_dqt}" ).format( null, null, 0, NaN, "a \nm\ness\"ag\"e", null, null, null, null ) );
			assertEquals( "null", new LogMessageFormatter( "{message_dqt}" ).format( null, null, 0, NaN, null, null, null, null, null ) );
			assertEquals( "null", new LogMessageFormatter( "{message_dqt}" ).format( null, null, 0, NaN, undefined, null, null, null, null ) );
			assertEquals( "9:1:1.23", new LogMessageFormatter( "{time}" ).format( null, null, 0, time.getTime()-START_TIME, null, null, null, null, null ) );
			assertEquals( "0:1:1.23", new LogMessageFormatter( "{timeUTC}" ).format( null, null, 0, time.getTime()-START_TIME, null, null, null, null, null ) );
			assertEquals( "00:01:01.023", new LogMessageFormatter( "{logTime}" ).format( null, null, 0, time.getTime()-START_TIME, null, null, null, null, null ) );
			assertEquals( "1970/1/2", new LogMessageFormatter( "{date}" ).format( null, null, 0, time.getTime()-START_TIME, null, null, null, null, null ) );
			assertEquals( "1970/1/2", new LogMessageFormatter( "{dateUTC}" ).format( null, null, 0, time.getTime()-START_TIME, null, null, null, null, null ) );
			assertEquals( "1970/1/2", new LogMessageFormatter( "{dateUTC}" ).format( null, null, 0, time.getTime()-START_TIME, null, null, null, null, null ) );
			assertEquals( "9:0:0.0", new LogMessageFormatter( "{time}" ).format( null, null, 0, NaN, null, null, null, null, null ) );
			assertEquals( "0:0:0.0", new LogMessageFormatter( "{timeUTC}" ).format( null, null, 0, NaN, null, null, null, null, null ) );
			assertEquals( "GMT+0900", new LogMessageFormatter( "{gmt}" ).format( null, null, 0, null, null, null, null, null, null ) );
			assertEquals( "{0}", new LogMessageFormatter( "{0}" ).format( null, null, 0, NaN, null, ["a"], null, null, null ) );
			assertEquals( "{0}", new LogMessageFormatter( "{0}" ).format( null, null, 0, NaN, null, null, null, null, null ) );
			assertEquals( "a", new LogMessageFormatter( "{message}" ).format( null, null, 0, NaN, "{0}", ["a"], null, null, null ) );
			assertEquals( "f", new LogMessageFormatter( "{message}" ).format( null, null, 0, NaN, "{5}", ["a","b","c","d","e","f"], null, null, null ) );
			assertEquals( URL_ERROR, new LogMessageFormatter( "{swf}" ).format( null, null, 0, NaN, null, null, null, null, null ) );
			assertEquals( URL_ERROR, new LogMessageFormatter( "{shortSWF}" ).format( null, null, 0, NaN, null, null, null, null, null ) );
			
			SWFInfo.init( LogTests.STAGE );
			assertEquals( SWF_URL, new LogMessageFormatter( "{swf}" ).format( null, null, 0, NaN, null, null, null, null, null ) );
			assertEquals( SWF_SHORT_URL, new LogMessageFormatter( "{shortSWF}" ).format( null, null, 0, NaN, null, null, null, null, null ) );
			SWFInfo.init( null );
		}
	}
}
