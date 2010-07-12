package org.as3commons.logging.setup.target {
	import org.as3commons.logging.LogLevel;
	import org.as3commons.logging.LoggerFactory;
	import org.as3commons.logging.setup.ILogTarget;
	import org.as3commons.logging.util.LogMessageFormatter;
	import org.as3commons.logging.util.SWFInfo;

	import flash.desktop.NativeApplication;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;

	/**
	 * @author mh
	 */
	public final class AirFileTarget implements ILogTarget {
		
		public static const DEFAULT_FILE_PATTERN: String = File.applicationDirectory.resolvePath("{file}.{date}.log").nativePath;
		public static const INSTANCE: AirFileTarget = new AirFileTarget();
		
		private static const DATE: RegExp = /{date}/g;
		private static const FILE: RegExp = /{file}/g;
		private static const MONTHS: Array = [ "JAN", "FEB", "MAR", "APR", "MAY", "JUN", "JUL", "AUG", "SEP", "OCT", "NOV", "DEC" ];
		
		private var _filePattern:String;
		private var _file:File;
		private var _stream:FileStream;
		private var _formerDate:*;
		
		// Not customizable since the log-file header would need to adapt
		private const _formatter: LogMessageFormatter  = new LogMessageFormatter( "{logTime} {logLevel} {name} \"{message_dqt}\"" );
		
		public function AirFileTarget( filePattern: String = null ) {
			_filePattern = filePattern || DEFAULT_FILE_PATTERN;
			_stream = new FileStream();
		}
		
		public function log(name:String, shortName:String, level:LogLevel, timeStamp: Number,message:String, params:Array):void {
			var date: Date = new Date();
			if( date.dateUTC != _formerDate || !_file.exists ) {
				if( _file ) {
					_stream.close();
					_stream = new FileStream();
					_file.cancel();
					_file = null;
				}
				_formerDate = date.dateUTC;
				_file = new File( createFileName( date ) );
				if( _file.exists ) {
					renameOldFile( _file, date, 1 );
				}
				_stream.openAsync( _file, FileMode.APPEND );
				_stream.writeUTFBytes( "#Version: 1.0\n" +
									   "#Software: " + SWFInfo.SHORT_URL + "(running in Adobe Air " + NativeApplication.nativeApplication.runtimeVersion + ", publisherID: " + NativeApplication.nativeApplication.publisherID + ")\n" +
									   "#Date: " + date.dateUTC + "-" + MONTHS[ date.monthUTC ] + "-" + date.fullYearUTC + " " + date.hoursUTC + ":" + date.minutesUTC + ":" + date.secondsUTC + "." + date.millisecondsUTC + "\n"+
									   "#Fields: time x-method x-name x-comment\n");
			}
			_stream.writeUTFBytes( _formatter.format( name, shortName, level, timeStamp, message, params ) + "\n" );
		}
		
		private function renameOldFile(file: File, date: Date, no: int): void {
			var newName: String = createFileName( date, no );
			var newFile: File = new File( newName );
			if( newFile.exists ) {
				renameOldFile( newFile, date, no+1 );
			}
			file.moveTo( newFile );
		}

		private function createFileName(date:Date, no: int = -1): String {
			var yearName: String = date.fullYearUTC.toString();
			var monthName: String = (date.monthUTC+1).toString();
			if(monthName.length == 1) {
				monthName = "0"+monthName;
			}
			var dayName: String = date.dateUTC.toString();
			if(dayName.length == 1 ) {
				dayName = "0"+dayName;
			}
			var dateString: String =  yearName+monthName+dayName;
			if(no != -1) {
				dateString += "." + no;
			}
			var file: String = SWFInfo.SHORT_URL;
			if(file == SWFInfo.URL_ERROR) {
				file = "out";
			}
			return _filePattern.replace( DATE, dateString ).replace( FILE, file);
		}
	}
}