package org.as3commons.logging.setup.target {
	import org.as3commons.logging.LogLevel;
	import org.as3commons.logging.setup.ILogTarget;
	import org.as3commons.logging.util.LogMessageFormatter;

	import flash.utils.Dictionary;

	/**
	 * @author Martin Heidegger
	 */
	public final class MonsterDebuggerTarget implements ILogTarget {
		public static const DEFAULT_FORMAT: String = "{time} {shortName} - {message}";
		public static const DEFAULT_COLORS: Dictionary = new Dictionary();
		{
			DEFAULT_COLORS[ LogLevel.DEBUG ] = MonsterDebugger.COLOR_NORMAL;
			DEFAULT_COLORS[ LogLevel.FATAL ] = MonsterDebugger.COLOR_ERROR;
			DEFAULT_COLORS[ LogLevel.ERROR ] = MonsterDebugger.COLOR_ERROR;
			DEFAULT_COLORS[ LogLevel.INFO ] = MonsterDebugger.COLOR_NORMAL;
			DEFAULT_COLORS[ LogLevel.WARN ] = MonsterDebugger.COLOR_WARNING;
		}
		public static const INSTANCE: MonsterDebuggerTarget = new MonsterDebuggerTarget();
		
		private var _colors: Dictionary;
		private var _formatter:LogMessageFormatter;
		
		public function MonsterDebuggerTarget( format: String = null, colors: Dictionary = null ) {
			_formatter = new LogMessageFormatter( format || DEFAULT_FORMAT );
			_colors = colors || DEFAULT_COLORS;
		}
		
		public function log(name: String, shortName: String, level: LogLevel, timeStamp: Number, message: String, parameters: Array): void {
			MonsterDebugger.trace( name, _formatter.format( name, shortName, level, timeStamp, message, parameters), _colors[ level ] );
		}
	}
}
