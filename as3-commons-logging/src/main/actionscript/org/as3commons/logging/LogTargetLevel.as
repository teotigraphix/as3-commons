package org.as3commons.logging 
{

	
	/**
	 * @author martin.heidegger
	 */
	public class LogTargetLevel 
	{
		private static const _levels:Array = [];

		public static const NONE:LogTargetLevel       = getLevelByValue( 0x0001 );
		public static const FATAL_ONLY:LogTargetLevel = getLevelByValue( 0x0002 );
		public static const FATAL:LogTargetLevel      = NONE.or( FATAL_ONLY );
		public static const ERROR_ONLY:LogTargetLevel = getLevelByValue( 0x0004 );
		public static const ERROR:LogTargetLevel      = FATAL.or( ERROR_ONLY );
		public static const WARN_ONLY:LogTargetLevel  = getLevelByValue( 0x0008 );
		public static const WARN:LogTargetLevel       = ERROR.or( WARN_ONLY );
		public static const INFO_ONLY:LogTargetLevel  = getLevelByValue( 0x0010 );
		public static const INFO:LogTargetLevel       = WARN.or( INFO_ONLY );
		public static const DEBUG_ONLY:LogTargetLevel = getLevelByValue( 0x0020 );
		public static const DEBUG:LogTargetLevel      = INFO.or( DEBUG_ONLY );
		public static const ALL:LogTargetLevel        = DEBUG;

		public static function getLevelByValue(value:int):LogTargetLevel {
			var result:LogTargetLevel = _levels[value];
			if( !result ) {
				result = new LogTargetLevel(value);
			}
			return result;
		}

		private var _value:int;

		public function LogTargetLevel(value:int) {
			if( _levels[value] ) {
				throw Error( "LogTargetLevel exists already!" );
			}
			_levels[value] = this;
			_value = value;
		}

		public function matches(toLevel:LogLevel):Boolean {
			return (_value & toLevel.value) == toLevel.value;
		}

		public function or( otherLevel:LogTargetLevel ):LogTargetLevel {
			return getLevelByValue( _value | otherLevel.value );
		}
		
		public function get value(): int {
			return _value;
		}
	}
}
