package org.as3commons.logging.setup.target {
	import com.carlcalderon.arthropod.Debug;

	import org.as3commons.logging.level.DEBUG;
	import org.as3commons.logging.level.ERROR;
	import org.as3commons.logging.level.FATAL;
	import org.as3commons.logging.level.INFO;
	import org.as3commons.logging.level.WARN;
	import org.as3commons.logging.setup.LogSetupLevel;
	import org.as3commons.logging.util.LogMessageFormatter;

	/**
	 * @author mh
	 */
	public class ArthopodTarget implements IFormattingLogTarget {
		
		public static const DEFAULT_FORMAT:String = "";
		
		/** Default colors used to color the output statements. */
		public static const DEFAULT_COLORS: Object = {};
		{
			DEFAULT_COLORS[DEBUG] = Debug.LIGHT_BLUE;
			DEFAULT_COLORS[INFO] = Debug.BLUE;
			DEFAULT_COLORS[WARN] = Debug.YELLOW;
			DEFAULT_COLORS[ERROR] = Debug.PINK;
			DEFAULT_COLORS[FATAL] = Debug.RED;
		}
		
		private var _formatter:LogMessageFormatter;
		private var _warnLevels:LogSetupLevel;
		private var _colors:Object;
		
		public function ArthopodTarget( format:String=null, colors:Object=null, warnLevels:LogSetupLevel=null ) {
			this.format = format;
			this.warnLevels = warnLevels;
			this.colors = colors;
		}
		
		public function set warnLevels( warnLevels:LogSetupLevel ):void {
			_warnLevels = warnLevels||LogSetupLevel.WARN_ONLY;
		}
		
		public function set format( format:String ):void {
			_formatter = new LogMessageFormatter(format||DEFAULT_FORMAT);
		}
		
		public function set colors( colors:Object ):void {
			_colors = colors||DEFAULT_COLORS;
		}
		
		public function log( name: String, shortName: String, level: int,
							 timeStamp: Number, message: *, parameters: Array,
							 person: String = null ): void {
			var color: uint = _colors[ level ];
			if( parameters.length == 0 ){
				if( message is String ) {
					message = _formatter.format(name, shortName, level, timeStamp, message, parameters, person);
					if( _warnLevels.valueOf() & level == level ) {
						Debug.warning( message );
					} else {
						Debug.log( message, color );
					}
				}
				if( message is Array ) {
					Debug.array( message );
				} else if( message is Object ){
					Debug.object( message );
				}
			} else {
				if( message is String ) {
					message = _formatter.format(name, shortName, level, timeStamp, message, parameters, person);
					if( _warnLevels.valueOf() & level == level ) {
						Debug.warning( message );
					} else {
						Debug.log( message, color );
					}
				}
			}
		}
	}
}
