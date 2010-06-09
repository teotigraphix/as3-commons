package org.as3commons.logging.impl {
	
	import flash.desktop.NativeApplication;
	import org.as3commons.logging.ILogTarget;
	import org.as3commons.logging.ILogTargetFactory;
	import org.as3commons.logging.LogLevel;
	import org.as3commons.logging.LogManager;
	import org.as3commons.logging.util.LogMessageFormatter;

	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	
	/**
	 * @author mh
	 */
	public class AirFileLogTarget extends AbstractLogTarget implements ILogTargetFactory, ILogTarget{
		
		public static const DEFAULT_FILE_PATTERN: String = File.applicationDirectory.resolvePath("{file}.{date}.log").nativePath;
		public static const INSTANCE: AirFileLogTarget = new AirFileLogTarget();
		
		private static const DATE: RegExp = /{date}/g;
		private static const FILE: RegExp = /{file}/g;
		private static const MONTHS: Array = [ "JAN", "FEB", "MAR", "APR", "MAY", "JUN", "JUL", "AUG", "SEP", "OCT", "NOV", "DEC" ];
		
		private var _filePattern:String;
		private var _file:File;
		private var _stream:FileStream;
		private var _formerDate:*;
		
		// Not customizable since the log-file header would need to adapt
		private var _format:String = "{logTime} {logLevel} {name} \"{message_dqt}\"";
		
		public function AirFileLogTarget( filePattern: String = null ) {
			_filePattern = filePattern || DEFAULT_FILE_PATTERN;
			_stream = new FileStream();
		}
		
		public function getLogTarget(name:String):ILogTarget {
			return this;
		}
		
		override public function log(name:String, shortName:String, level:LogLevel, timeStamp: Number,message:String, params:Array):void {
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
									   "#Software: " + LogManager.SWF_SHORT_URL + "(running in Adobe Air " + NativeApplication.nativeApplication.runtimeVersion + ", publisherID: " + NativeApplication.nativeApplication.publisherID + ")\n" +
									   "#Date: " + date.dateUTC + "-" + MONTHS[ date.monthUTC ] + "-" + date.fullYearUTC + " " + date.hoursUTC + ":" + date.minutesUTC + ":" + date.secondsUTC + "." + date.millisecondsUTC + "\n"+
									   "#Fields: time x-method x-name x-comment\n");
			}
			_stream.writeUTFBytes( LogMessageFormatter.format( _format, name, shortName, level, timeStamp, message, params ) + "\n" );
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
			var result: String =  yearName+monthName+dayName;
			if(no != -1) {
				result += "." + no;
			}
			var file: String = LogManager.SWF_SHORT_URL;
			if(file == LogManager.SWF_URL_ERROR) {
				file = "out";
			}
			return _filePattern.replace( DATE, result ).replace( FILE, file );
		}
	}
}
