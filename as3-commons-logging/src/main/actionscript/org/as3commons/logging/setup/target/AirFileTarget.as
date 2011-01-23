/*
 * Copyright (c) 2008-2009 the original author or authors
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */
package org.as3commons.logging.setup.target {
	
	import org.as3commons.logging.LogLevel;
	import org.as3commons.logging.setup.ILogTarget;
	import org.as3commons.logging.util.LogMessageFormatter;
	import org.as3commons.logging.util.SWFInfo;
	import org.as3commons.logging.util.SWF_SHORT_URL;
	
	import flash.desktop.NativeApplication;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.OutputProgressEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	
	/**
	 * @author Martin Heidegger
	 * @since 2
	 */
	public final class AirFileTarget extends EventDispatcher implements ILogTarget {
		
		/* Default file pattern to be used for new files. */
		public static const DEFAULT_FILE_PATTERN: String =
				File.applicationStorageDirectory.resolvePath("{file}.{date}.log").nativePath;
		
		/*  */
		public static const INSTANCE: AirFileTarget = new AirFileTarget();
		
		private static const DATE: RegExp = /{date}/g;
		private static const FILE: RegExp = /{file}/g;
		private static const MONTHS: Array = [ "JAN", "FEB", "MAR", "APR", "MAY",
												"JUN", "JUL", "AUG", "SEP", "OCT",
												"NOV", "DEC" ];
		
		private var _filePattern:String;
		private var _file:File;
		private var _stream:FileStream;
		private var _formerDate:*;
		
		// Not customizable since the log-file header would need to adapt
		private const _formatter: LogMessageFormatter =
				new LogMessageFormatter( "{logTime} {logLevel} {name} \"{message_dqt}\"" );
		
		public function AirFileTarget( filePattern: String = null ) {
			_filePattern = filePattern || DEFAULT_FILE_PATTERN;
		}
		
		public function log(name:String, shortName:String, level:LogLevel,
							timeStamp: Number,message:*, params:Array):void {
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
									   "#Software: " + descriptor.ns::name + " v"
									   + descriptor.ns::version + " (running in Adobe Air "
									   + NativeApplication.nativeApplication.runtimeVersion
									   + ", publisherID: " + NativeApplication.nativeApplication.publisherID
									   + " )\n" +
									   "#Date: " + date.dateUTC + "-" + MONTHS[ date.monthUTC ]
									   + "-" + date.fullYearUTC + " " + date.hoursUTC
									   + ":" + date.minutesUTC + ":" + date.secondsUTC
									   + "." + date.millisecondsUTC + "\n"+
									   "#Fields: time x-method x-name x-comment\n");
			}
			_stream.writeUTFBytes(
				_formatter.format( name, shortName, level, timeStamp, message, params )
				+ "\n"
			);
		}
		
		public function dispose(): void {
			if(_file) {
				_stream.close();
				_stream = null;
				_file.cancel();
				_file = null;
			}
		}
		
		private function disposeFinished(event: Event): void {
			if(event.target == _stream) {
				dispatchEvent( new Event( Event.COMPLETE ) );
			} else {
				IEventDispatcher(event.target).removeEventListener(
					OutputProgressEvent.OUTPUT_PROGRESS, disposeFinished);
			}
		}
		
		private function renameOldFile(file: File, date: Date, no: int): void {
			var newName: String = createFileName( date, no );
			var newFile: File = new File( newName );
			if(newFile.exists) {
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
			var file : String = SWF_SHORT_URL;
			if (file == SWFInfo.URL_ERROR) {
				file = "out";
			}
			return _filePattern.replace( DATE, dateString ).replace( FILE, file);
		}
	}
}