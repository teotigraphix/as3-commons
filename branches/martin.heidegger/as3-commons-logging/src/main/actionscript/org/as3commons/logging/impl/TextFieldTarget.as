package org.as3commons.logging.impl {
	
	import org.as3commons.logging.ILogTarget;
	import org.as3commons.logging.ILogTargetFactory;
	import org.as3commons.logging.LogLevel;
	import org.as3commons.logging.LogTargetLevel;
	import org.as3commons.logging.util.LogMessageFormatter;

	import flash.text.TextField;

	
	/**
	 * @author martin.heidegger
	 */
	public class TextFieldTarget extends TextField implements ILogTarget, ILogTargetFactory {
		
		public static const DEFAULT_FORMAT: String = "{time} {logLevel} - {shortName} - {message}";
		public static const INSTANCE: TextFieldTarget = new TextFieldTarget();
		
		private var _formatter: LogMessageFormatter;
		
		public function TextFieldTarget ( format:String = null) {
			_formatter = new LogMessageFormatter( format || DEFAULT_FORMAT );
		}
		
		public function log(name: String, shortName: String, level: LogLevel, timeStamp: Number, message: String, parameters: Array): void {
			this.text += _formatter.format( name, shortName, level, timeStamp, message, parameters ) + "\n";
		}
		
		public function get logTargetLevel(): LogTargetLevel {
			return LogTargetLevel.ALL;
		}
		
		public function getLogTarget(name: String): ILogTarget {
			return this;
		}
	}
}
