package org.as3commons.logging.impl 
{
	import org.as3commons.logging.ILogTarget;
	import org.as3commons.logging.ILogTargetFactory;
	import org.as3commons.logging.LogLevel;
	import org.as3commons.logging.LogTargetLevel;
	import org.as3commons.logging.util.LogMessageFormatter;

	import flash.text.TextField;

	
	/**
	 * @author martin.heidegger
	 */
	public class TextFieldTarget extends TextField implements ILogTarget, ILogTargetFactory
	{
		private var _format: String;

		public function TextFieldTarget ( format:String = null) {
			if (!format) {
				_format = LogMessageFormatter.DEFAULT_FORMAT;
			} else {
				_format = format;
			}
		}
		
		public function log(name: String, shortName: String, level: LogLevel, timeMs: Number, message: String, parameters: Array): void {
			this.text += LogMessageFormatter.format( _format, name, shortName, level, timeMs, message, parameters ) + "\n";
		}
		
		public function get logTargetLevel(): LogTargetLevel {
			return LogTargetLevel.ALL;
		}

		public function getLogTarget(name: String): ILogTarget {
			return this;
		}
	}
}
