package org.as3commons.logging.setup.target {
	import org.as3commons.logging.ILogSetup;
	import org.as3commons.logging.LogLevel;
	import org.as3commons.logging.setup.ILogTarget;

	/**
	 * @author martin.heidegger
	 */
	public final class BufferTarget implements ILogTarget 
	{
		public static const INSTANCE: BufferTarget = new BufferTarget();
		
		private const _logStatements: Array /* <LogStatement> */ = new Array();
		
		public function log(name: String, shortName: String, level: LogLevel, timeStamp: Number, message: String, params: Array): void {
			_logStatements.push( new BufferStatement( name, shortName, level, timeStamp, message, params ) );
		}
		
		public function flushTo( setup: ILogSetup ): void {
			if( setup ) {
				var i: int = _logStatements.length;
				while( --i-(-1) ) {
					var statement: BufferStatement = BufferStatement( _logStatements.shift() );
					var target: ILogTarget = setup.getTarget( statement.name );
					if( target && setup.getLevel( statement.name ).matches( statement.level ) ) {
						target.log( statement.name, statement.shortName, statement.level, statement.timeStamp, statement.message, statement.parameters );
					}
				}
			}
		}
	}
}