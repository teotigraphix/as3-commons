package org.as3commons.logging.impl 
{
	import nl.demonsters.debugger.MonsterDebugger;

	import org.as3commons.logging.ILogTarget;
	import org.as3commons.logging.ILogTargetFactory;
	import org.as3commons.logging.LogLevel;
	import org.as3commons.logging.util.LogMessageFormatter;

	import flash.utils.Dictionary;

	
	/**
	 * @author Martin Heidegger
	 */
	public class MonsterDebuggerTarget extends AbstractLogTarget implements ILogTarget, ILogTargetFactory
	{
		public static const DEFAULT_FORMAT: String = "{time} {shortName} - {message}";
		public static const DEFAULT_COLORS: Dictionary = new Dictionary();
		public static const INSTANCE: MonsterDebuggerTarget = new MonsterDebuggerTarget();
		{
			DEFAULT_COLORS[ LogLevel.DEBUG ] = MonsterDebugger.COLOR_NORMAL;
			DEFAULT_COLORS[ LogLevel.FATAL ] = MonsterDebugger.COLOR_ERROR;
			DEFAULT_COLORS[ LogLevel.ERROR ] = MonsterDebugger.COLOR_ERROR;
			DEFAULT_COLORS[ LogLevel.INFO ] = MonsterDebugger.COLOR_NORMAL;
			DEFAULT_COLORS[ LogLevel.WARN ] = MonsterDebugger.COLOR_WARNING;
		}
		private var _format: String;
		private var _colors: Dictionary;

		public function MonsterDebuggerTarget( format: String = null, colors: Dictionary = null )
		{
			_format = format || DEFAULT_FORMAT;
			_colors = colors || DEFAULT_COLORS;
		}
		
		override public function log(name: String, shortName: String, level: LogLevel, timeStamp: Number, message: String, parameters: Array): void
		{
			MonsterDebugger.trace( name, LogMessageFormatter.format( _format, name, shortName, level, timeStamp, message, parameters), _colors[ level ] );
		}
		
		public function getLogTarget(name: String): ILogTarget
		{
			return this;
		}
	}
}
