package org.as3commons.logging.impl 
{
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
		
		public static const DEFAULT_FORMAT: String = "{time} {name}: {message}";
		public static const DEFAULT_FILE_PATTERN: String = File.applicationDirectory.resolvePath("{file}.{date}.log").nativePath;
		
		private static const DATE: RegExp = /{date}/g;
		private static const FILE: RegExp = /{file}/g;
		
		private var _filePattern:String;
		private var _file:File;
		private var _stream:FileStream;
		private var _formerDate:*;
		private var _format:String;

		public function AirFileLogTarget( filePattern: String = null, format: String = null ) {
			
			if( filePattern ) {
				_filePattern = filePattern;
			} else {
				_filePattern = DEFAULT_FILE_PATTERN;
			}
			if( format ) {
				_format = format;
			} else {
				_format = DEFAULT_FORMAT;
			}
			_stream = new FileStream();
		}
		
		public function getLogTarget(name:String):ILogTarget {
			return this;
		}
		
		override public function log(name:String, shortName:String, level:LogLevel, timeMs: Number,message:String, params:Array):void {
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
			}
			_stream.writeUTFBytes( LogMessageFormatter.format( _format, name, shortName, level, timeMs, message, params ) + "\n" );
		}

		private function renameOldFile(file: File, date: Date, no: int): void {
			var newName: String = createFileName( date, no );
			var newFile: File = new File( newName );
			if( newFile.exists ) {
				renameOldFile( newFile, date, no+1 );
			}
			file.moveTo( newFile );
		}

		private function createFileName(date:Date, no: int = -1):String {
			var yearName: String = date.fullYearUTC.toString();
			var monthName: String = (date.monthUTC+1).toString();
			if( monthName.length == 1 ) {
				monthName = "0"+monthName;
			}
			var dayName: String = date.dateUTC.toString();
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
