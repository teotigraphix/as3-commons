package org.as3commons.logging.impl 
{
	import org.as3commons.logging.ILogTarget;
	import org.as3commons.logging.ILogTargetFactory;
	import org.as3commons.logging.LogTargetLevel;

	
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
				if( target && target.logTargetLevel != LogTargetLevel.NONE )
				{
					if( result ) {
						target = new SplitterNode( result, target );
					}
					result = target;
				}
			}
			return result;
		}
	}
}

import org.as3commons.logging.ILogTarget;
import org.as3commons.logging.LogLevel;
import org.as3commons.logging.LogTargetLevel;

class SplitterNode implements ILogTarget {

	private var _logTargetA:ILogTarget;
	private var _logTargetB:ILogTarget;
	private var _logTargetLevel: LogTargetLevel;

	public function SplitterNode( logTargetA: ILogTarget, logTargetB: ILogTarget ) {
		_logTargetA = logTargetA;
		_logTargetB = logTargetB;
		_logTargetLevel = logTargetA.logTargetLevel.or( logTargetB.logTargetLevel );
	}
	
	public function get logTargetLevel(): LogTargetLevel
	{
		return _logTargetLevel;
	}
	
	public function log(name: String, shortName: String, level: LogLevel, timeStamp: Number, message: String, parameters: Array): void
	{
		if( _logTargetA.logTargetLevel.matches( level ) )
		{
			_logTargetA.log(name, shortName, level, timeStamp, message, parameters);
		}
		if( _logTargetB.logTargetLevel.matches( level ) )
		{
			_logTargetB.log(name, shortName, level, timeStamp, message, parameters);
		}
	}
}