package org.as3commons.logging 
{

	
	/**
	 * @author martin.heidegger
	 */
	public final class LogSetupLevel 
	{
		private static const _levels:Array = [];

		public static const NONE:LogSetupLevel       = getLevelByValue( 0x0001 );
		public static const FATAL_ONLY:LogSetupLevel = getLevelByValue( 0x0002 );
		public static const FATAL:LogSetupLevel      = NONE.or( FATAL_ONLY );
		public static const ERROR_ONLY:LogSetupLevel = getLevelByValue( 0x0004 );
		public static const ERROR:LogSetupLevel      = FATAL.or( ERROR_ONLY );
		public static const WARN_ONLY:LogSetupLevel  = getLevelByValue( 0x0008 );
		public static const WARN:LogSetupLevel       = ERROR.or( WARN_ONLY );
		public static const INFO_ONLY:LogSetupLevel  = getLevelByValue( 0x0010 );
		public static const INFO:LogSetupLevel       = WARN.or( INFO_ONLY );
		public static const DEBUG_ONLY:LogSetupLevel = getLevelByValue( 0x0020 );
		public static const DEBUG:LogSetupLevel      = INFO.or( DEBUG_ONLY );
		public static const ALL:LogSetupLevel        = DEBUG;
		
		public static function getLevelByValue(value:int):LogSetupLevel {
			return _levels[value] || new LogSetupLevel(value);
		}
		
		private var _value:int;
		
		public function LogSetupLevel(value:int) {
			if( _levels[value] ) {
				throw Error( "LogTargetLevel exists already!" );
			}
			_levels[value] = this;
			_value = value;
		}
		
		public function matches(toLevel:LogLevel):Boolean {
			return (_value & toLevel.value) == toLevel.value;
		}
		
		public function or( otherLevel:LogSetupLevel ):LogSetupLevel {
			return getLevelByValue( _value | otherLevel.value );
		}
		
		public function get value(): int {
			return _value;
		}
	}
}
