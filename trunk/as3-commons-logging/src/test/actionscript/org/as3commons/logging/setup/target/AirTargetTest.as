package org.as3commons.logging.setup.target {
	import org.as3commons.logging.util.SWF_URL;
	import flexunit.framework.TestCase;

	import org.as3commons.logging.STAGE;
	import org.as3commons.logging.level.DEBUG;
	import org.as3commons.logging.level.ERROR;
	import org.as3commons.logging.util.START_TIME;
	import org.as3commons.logging.util.SWFInfo;
	import org.as3commons.logging.util.assertRegExp;

	import flash.events.Event;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;



	/**
	 * @author mh
	 */
	public class AirTargetTest extends TestCase {
		
		public function AirTargetTest(){}
		
		private var _target: AirFileTarget;
		private var _filesToDelete : Array;
		private var _randomTime : Number;
		private var _randomTime2 : Number;
		private var _eventHolder : Function;
		
		override public function setUp(): void {
			SWFInfo.init(STAGE);
			_filesToDelete = [];
		}
		
		public function testMe(): void {
			
			var startTime: Number = START_TIME;
			
			_randomTime = (Math.random() * 12345678) % 1;
			_randomTime2 = (Math.random() * 12345678) % 1;
			
			_target = new AirFileTarget();
			_target.log( "test", "test", DEBUG, _randomTime-START_TIME, "Hello World", [], null, null, null );
			_eventHolder = addAsync( analyzeFile, 1000 );
			_target.addEventListener( Event.COMPLETE, _eventHolder );
			_target.log( "test.the.long.way", "way", ERROR, _randomTime2-START_TIME, "Some statement with \n new lines and \" doublequotes and \t tabs and # s", null, null, null, null );
		}
		
		private function analyzeFile(e : Event): void {
			_target.removeEventListener(Event.COMPLETE, _eventHolder);
			var home: File = File.applicationStorageDirectory;
			var listing: Array = home.getDirectoryListing().sortOn( "modificationDate", Array.DESCENDING );
			var file: File = new File( File( listing[0] ).nativePath );
			_filesToDelete.push( file );
			
			var url: String = SWF_URL.split(".").join("\\.").substr(5);
			var fileNameRegExp: RegExp = new RegExp("^"+url+"\\.(?P<year>(.{4}))(?P<month>(.{1,2}))(?P<day>(.{1,2}))\\.(?P<iter>([0-9]*\\.))?log$");
			
			var parsed: Object = fileNameRegExp.exec( file.name ); 
			assertNotNull( "Last modified File " + file.name + " didnt match the file regexp ("+fileNameRegExp+")", parsed );
			assertEquals( parsed["month"], file.modificationDate.monthUTC+1 );
			assertEquals( parsed["year"], file.modificationDate.fullYearUTC );
			assertEquals( parsed["day"], file.modificationDate.dateUTC );
			
			var lines: Array = readFile( file );
			assertEquals( "#Version: 1.0", lines.shift() );
			assertRegExp( /^#Software\: \S* v(\S|\.)* \(running in Adobe Air (\S|\.)*\, publisherID\: (\S|\.)* \)$/, lines.shift() );
			assertRegExp( /^#Date\: (?P<date>.{1,2})\-(?P<month>.{3})\-(?P<year>.{4}) .{1,2}:.{1,2}:.{1,2}\..{1,3}$/, lines.shift() );
			assertEquals( "#Fields: time x-method x-name x-comment", lines.shift() );
			
			assertEquals( logDate(_randomTime) + " DEBUG test \"Hello World\"",lines.shift());
			assertEquals( logDate(_randomTime2) + " ERROR test.the.long.way \"Some statement with \\n new lines and \\\" doublequotes and 	 tabs and # s\"", lines.shift() );
		}
		
		private function logDate( num: Number ): String {
			var _now: Date = new Date( num );
			var hrs: String = _now.hoursUTC.toString();
			if( hrs.length == 1 ) {
				hrs = "0"+hrs;
			}
			var mins: String = _now.minutesUTC.toString();
			if( mins.length == 1 ) {
				mins = "0"+mins;
			}
			var secs: String = _now.secondsUTC.toString();
			if( secs.length == 1 ) {
				secs = "0"+secs;
			}
			var ms: String = _now.millisecondsUTC.toString();
			if( ms.length == 1 ) {
				ms = "00"+ms;
			} else if( ms.length == 2 ) {
				ms = "0"+ms;
			}
			return hrs+":"+mins+":"+secs+"."+ms;
		}
		
		public function readFile( file: File ): Array {
			var stream: FileStream = new FileStream();
			stream.open( file, FileMode.READ );
			var result: String = stream.readUTFBytes( file.size );
			stream.close();
			return result.split("\n");
		}
		
		override public function tearDown() : void {
			_target.dispose();
			
			for each ( var file: File in _filesToDelete ) {
				file.deleteFile();
			}
			
			_filesToDelete = null;
			
			SWFInfo.init( null );
		}
	}
}
