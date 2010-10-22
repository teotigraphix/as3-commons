package org.as3commons.logging.setup.target {
	import nl.demonsters.debugger.MonsterDebugger;

	import org.as3commons.logging.LogLevel;
	import org.as3commons.logging.level.DEBUG;
	import org.as3commons.logging.level.ERROR;
	import org.as3commons.logging.level.FATAL;
	import org.as3commons.logging.level.INFO;
	import org.as3commons.logging.level.WARN;
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
			DEFAULT_COLORS[ DEBUG ] = MonsterDebugger.COLOR_NORMAL;
			DEFAULT_COLORS[ FATAL ] = MonsterDebugger.COLOR_ERROR;
			DEFAULT_COLORS[ ERROR ] = MonsterDebugger.COLOR_ERROR;
			DEFAULT_COLORS[ INFO ] = MonsterDebugger.COLOR_NORMAL;
			DEFAULT_COLORS[ WARN ] = MonsterDebugger.COLOR_WARNING;
		}
		public static const INSTANCE: MonsterDebuggerTarget = new MonsterDebuggerTarget();
		
		private var _colors: Dictionary;
		private var _formatter:LogMessageFormatter;
		
		public function MonsterDebuggerTarget( format: String = null, colors: Dictionary = null ) {
			_formatter = new LogMessageFormatter( format || DEFAULT_FORMAT );
			_colors = colors || DEFAULT_COLORS;
		}
		
		public function log(name: String, shortName: String, level: LogLevel, timeStamp: Number, message: *, parameters: Array): void {
			if( message is String ) {
				MonsterDebugger.trace( name, _formatter.format( name, shortName, level, timeStamp, message, parameters), _colors[ level ] );
			} else {
				MonsterDebugger.trace( name, message, _colors[ level ] );
			}
		}
	}
}
