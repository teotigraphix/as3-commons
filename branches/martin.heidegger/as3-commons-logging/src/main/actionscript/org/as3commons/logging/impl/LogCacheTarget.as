package org.as3commons.logging.impl {
	
	import org.as3commons.logging.LogLevel;
	import org.as3commons.logging.ILogTarget;
	import org.as3commons.logging.ILogTargetFactory;
	
	/**
	 * @author martin.heidegger
	 */
	public class LogCacheTarget extends AbstractLogTarget implements ILogTarget, ILogTargetFactory 
	{
		public static const INSTANCE: LogCacheTarget = new LogCacheTarget();
		
		private var _logStatements: Array /* <LogStatement> */ = new Array();
		
		override public function log(name: String, shortName: String, level: LogLevel, timeStamp: Number, message: String, params: Array): void {
			_logStatements.push( new LogCacheStatement( name, shortName, level, timeStamp, message, params ) );
		}
		
		public function flushTo( factory: ILogTargetFactory ): void {
			var i: int = _logStatements.length;
			while( --i-(-1) ) {
				var statement: LogCacheStatement = LogCacheStatement( _logStatements.shift() );
				var target: ILogTarget = factory.getLogTarget( statement.name );
				if( target && target.logTargetLevel.matches( statement.level ) ) {
					target.log( statement.name, statement.shortName, statement.level, statement.timeMs, statement.message, statement.params );
				}
			}
		}
		
		public function getLogTarget(name: String): ILogTarget {
			return this;
		}
	}
}