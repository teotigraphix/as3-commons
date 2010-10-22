package org.as3commons.logging.setup.target {
	import org.as3commons.logging.LogLevel;
	import org.as3commons.logging.setup.ILogTarget;
	import org.as3commons.logging.util.LogMessageFormatter;

	import flash.text.TextField;

	/**
	 * @author martin.heidegger
	 */
	public final class TextFieldTarget extends TextField implements ILogTarget {
		
		public static const DEFAULT_FORMAT: String = "{time} {logLevel} - {shortName} - {message}";
		
		private var _formatter: LogMessageFormatter;
		private var _textField:TextField;
		
		public function TextFieldTarget( format:String = null, textField: TextField = null ) {
			_textField = textField || this;
			_formatter = new LogMessageFormatter( format || DEFAULT_FORMAT );
		}
		
		public function log(name:String, shortName:String, level:LogLevel, timeStamp:Number, message:*, parameters:Array):void {
			_textField.appendText( _formatter.format( name, shortName, level, timeStamp, message, parameters ) + "\n" );
		}
	}
}