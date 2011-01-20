package org.as3commons.logging.setup.target {
	
	import org.as3commons.logging.LOGGER_FACTORY;
	import org.as3commons.logging.level.*;
	import org.as3commons.logging.LoggerFactory;
	import org.as3commons.logging.Logger;
	import org.as3commons.logging.LogLevel;
	import org.as3commons.logging.setup.ILogTarget;
	
	/**
	 * @author Martin Heidegger
	 * @version 2
	 * 
	 */
	public final class BufferTarget implements ILogTarget 
	{
		public static const INSTANCE: BufferTarget = new BufferTarget();
		
		private const _logStatements: Array /* <LogStatement> */ = new Array();
		
		public function BufferTarget() {}
		
		public function log(name: String, shortName: String, level: LogLevel,
							timeStamp: Number, message: *, params: Array): void {
			_logStatements.push(
				new BufferStatement( name, shortName, level, timeStamp, message, params )
			);
		}
		
		public function flush(factory:LoggerFactory): void {
			factory = factory || LOGGER_FACTORY;
			var i: int = _logStatements.length;
			while(--i-(-1)) {
				var statement: BufferStatement = BufferStatement(_logStatements.shift());
				var logger: Logger = factory.getLogger(statement.name) as Logger;
				
				var logTarget: ILogTarget;
				if(statement.level == DEBUG) {
					logTarget = logger.debugTarget;
				} else if(statement.level == INFO) {
					logTarget = logger.infoTarget;
				} else if(statement.level == WARN) {
					logTarget = logger.warnTarget;
				} else if(statement.level == ERROR) {
					logTarget = logger.errorTarget;
				} else if(statement.level == FATAL) {
					logTarget = logger.fatalTarget;
				}
				
				if(logTarget) {
					logTarget.log(
						statement.name, statement.shortName, statement.level,
						statement.timeStamp, statement.message, statement.parameters
					);
				}
			}
		}
	}
}