package org.as3commons.logging.setup.target {
	import flash.events.OutputProgressEvent;
	import org.as3commons.logging.LogLevel;
	import org.as3commons.logging.setup.ILogTarget;
	import org.as3commons.logging.util.LogMessageFormatter;
	import org.as3commons.logging.util.SWFInfo;

	import flash.desktop.NativeApplication;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;

	/**
	 * @author mh
	 */
	public final class AirFileTarget extends EventDispatcher implements ILogTarget {
		
		public static const DEFAULT_FILE_PATTERN: String = File.applicationStorageDirectory.resolvePath("{file}.{date}.log").nativePath;
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
		}
		
		public function log(name:String, shortName:String, level:LogLevel, timeStamp: Number,message:*, params:Array):void {
			var date: Date = new Date();
			if( date.dateUTC != _formerDate || !_file.exists ) {
				
				dispose();
				_stream = new FileStream();
				_formerDate = date.dateUTC;
				_file = new File( createFileName( date ) );
				if( _file.exists ) {
					renameOldFile( _file, date, 1 );
				}
				_stream.addEventListener(OutputProgressEvent.OUTPUT_PROGRESS, disposeFinished, false, 0, true);
				_stream.openAsync(_file, FileMode.APPEND);
				var descriptor: XML = NativeApplication.nativeApplication.applicationDescriptor;
				var ns: Namespace = descriptor.namespace();
				_stream.writeUTFBytes("#Version: 1.0\n" +
									   "#Software: " + descriptor.ns::name + " v" + descriptor.ns::version + " (running in Adobe Air " + NativeApplication.nativeApplication.runtimeVersion + ", publisherID: " + NativeApplication.nativeApplication.publisherID + " )\n" +
									   "#Date: " + date.dateUTC + "-" + MONTHS[ date.monthUTC ] + "-" + date.fullYearUTC + " " + date.hoursUTC + ":" + date.minutesUTC + ":" + date.secondsUTC + "." + date.millisecondsUTC + "\n"+
									   "#Fields: time x-method x-name x-comment\n");
			}
			_stream.writeUTFBytes( _formatter.format( name, shortName, level, timeStamp, message, params ) + "\n" );
		}
		
		private function disposeFinished(event: Event): void {
			if( event.target == _stream ) {
				dispatchEvent( new Event( Event.COMPLETE ) );
			} else {
				IEventDispatcher(event.target).removeEventListener(
					OutputProgressEvent.OUTPUT_PROGRESS, disposeFinished);
			}
		}
		
		public function dispose(): void {
			if( _file ) {
				_stream.close();
				_stream = null;
				_file.cancel();
				_file = null;
			}
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