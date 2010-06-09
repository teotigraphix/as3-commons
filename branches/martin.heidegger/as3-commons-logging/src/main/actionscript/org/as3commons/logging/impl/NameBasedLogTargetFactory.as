package org.as3commons.logging.impl {
	
	import org.as3commons.logging.ILogTarget;
	import org.as3commons.logging.ILogTargetFactory;
	
	/**
	 * @author Martin
	 */
	public class NameBasedLogTargetFactory implements ILogTargetFactory {

		private var _loggerFactories:Object /* <String, ILogger> */ = {};
		
		public function setLogger(name:String,logger:ILogTargetFactory): void
		{
			_loggerFactories[name] = logger;
		}
		
		public function getLogTarget(name:String):ILogTarget {
			var factory:ILogTargetFactory = _loggerFactories[name];
			if(factory)
			{
				return factory.getLogTarget(name);
			}
			return null;
		}
	}
}
