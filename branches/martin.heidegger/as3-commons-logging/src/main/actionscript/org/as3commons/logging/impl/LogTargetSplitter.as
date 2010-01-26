package org.as3commons.logging.impl {
	import org.as3commons.logging.LogLevel;
	import org.as3commons.logging.ILogTarget;
	import org.as3commons.logging.ILogTargetFactory;

	/**
	 * @author mh
	 */
	public class LogTargetSplitter implements ILogTargetFactory {
		
		private var _factories:Array /* ILogTargetFactory */;
		
		public function LogTargetSplitter( ...factories: Array ) {
			_factories = factories;
		}
		
		public function getLogTarget(name:String):ILogTarget {
			var result: ILogTarget;
			const l:int = _factories.length;
			for( var i: int = 0; i<l; ++i )
			{
				var target: ILogTarget = ILogTargetFactory( _factories[i] ).getLogTarget(name);
				if( target && target.logLevel != LogLevel.NONE )
				{
					if( result ) {
						target = new MultipleLoggerFactoryNode( result, target );
					}
					result = target;
				}
			}
			return result;
		}
	}
}

import org.as3commons.logging.LogLevel;
import org.as3commons.logging.ILogTarget;

class MultipleLoggerFactoryNode implements ILogTarget {

	private var _logTargetA:ILogTarget;
	private var _logTargetB:ILogTarget;
	private var _logLevel: LogLevel;

	public function MultipleLoggerFactoryNode( logTargetA: ILogTarget, logTargetB: ILogTarget ) {
		_logTargetA = logTargetA;
		_logTargetB = logTargetB;
		_logLevel = logTargetA.logLevel.or( logTargetB.logLevel );
	}

	
	
	public function get logLevel(): LogLevel
	{
		return _logLevel;
	}
	
	public function log(name: String, level: LogLevel, timeMs: Number, message: String, parameters: Array): void
	{
		if( _logTargetA.logLevel.matches( level ) )
		{
			_logTargetA.log(name, level, timeMs, message, parameters);
		}
		if( _logTargetB.logLevel.matches( level ) )
		{
			_logTargetB.log(name, level, timeMs, message, parameters);
		}
	}
}