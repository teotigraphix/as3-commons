package org.as3commons.logging.impl {
	import org.as3commons.logging.ILogTarget;
	import org.as3commons.logging.ILogTargetFactory;

	/**
	 * @author mh
	 */
	public class LoggerFactoryMerger implements ILogTargetFactory {
		
		private var _factories:Array /* ILogTargetFactory */;
		
		public function LoggerFactoryMerger( factories: Array ) {
			_factories = factories;
		}
		
		public function getLogTarget(name:String):ILogTarget {
			var result: ILogTarget;
			const l:int = _factories.length;
			for( var i: int = 0; i<l; ++i )
			{
				var target: ILogTarget = ILogTargetFactory( _factories[i] ).getLogTarget(name);
				if( target && ( target.warnEnabled || target.errorEnabled || target.fatalEnabled || target.infoEnabled || target.debugEnabled)) {
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

import org.as3commons.logging.ILogTarget;

class MultipleLoggerFactoryNode implements ILogTarget {

	private var _logTargetA:ILogTarget;
	private var _logTargetB:ILogTarget;
	private var _infoEnabled:Boolean;
	private var _debugEnabled:Boolean;
	private var _warnEnabled:Boolean;
	private var _errorEnabled:Boolean;
	private var _fatalEnabled:Boolean;
	private var _infoBothEnabled:Boolean;
	private var _warnBothEnabled:Boolean;
	private var _debugBothEnabled:Boolean;
	private var _errorBothEnabled:Boolean;
	private var _fatalBothEnabled:Boolean;

	public function MultipleLoggerFactoryNode( logTargetA: ILogTarget, logTargetB: ILogTarget ) {
		_logTargetA = logTargetA;
		_logTargetB = logTargetB;
		_infoBothEnabled = logTargetA.infoEnabled && logTargetB.infoEnabled;
		_infoEnabled = logTargetA.infoEnabled || logTargetB.infoEnabled;
		_warnBothEnabled = logTargetA.warnEnabled && logTargetB.warnEnabled;
		_warnEnabled = logTargetA.warnEnabled || logTargetB.warnEnabled;
		_debugBothEnabled = logTargetA.debugEnabled && logTargetB.debugEnabled;
		_debugEnabled = logTargetA.debugEnabled || logTargetB.debugEnabled;
		_errorBothEnabled = logTargetA.errorEnabled && logTargetB.errorEnabled;
		_errorEnabled = logTargetA.errorEnabled || logTargetB.errorEnabled;
		_fatalBothEnabled = logTargetA.fatalEnabled && logTargetB.fatalEnabled;
		_fatalEnabled = logTargetA.fatalEnabled || logTargetB.fatalEnabled;
	}

	public function debug(name: String, message : String, parameters : Array) : void{
		if( _debugBothEnabled ) {
			_logTargetA.debug(name, message, parameters);
			_logTargetB.debug(name, message, parameters);
		} else if( _logTargetA.debugEnabled ) {
			_logTargetA.debug(name, message, parameters);
		} else if( _debugEnabled ) {
			_logTargetB.debug(name, message, parameters);
		}
	}
	
	public function info(name : String, message : String, parameters : Array) : void{
		if( _infoBothEnabled ) {
			_logTargetA.info(name, message, parameters);
			_logTargetB.info(name, message, parameters);
		} else if( _logTargetA.infoEnabled ) {
			_logTargetA.info(name, message, parameters);
		} else if( _infoEnabled ) {
			_logTargetB.info(name, message, parameters);
		}
	}
	
	public function warn(name : String, message : String, parameters : Array) : void{
		if( _warnBothEnabled ) {
			_logTargetA.warn(name, message, parameters);
			_logTargetB.warn(name, message, parameters);
		} else if( _logTargetA.infoEnabled ) {
			_logTargetA.warn(name, message, parameters);
		} else if( _warnEnabled ) {
			_logTargetB.warn(name, message, parameters);
		}
	}
	
	public function error(name : String, message : String, parameters : Array) : void{
		if( _errorBothEnabled ) {
			_logTargetA.error(name, message, parameters);
			_logTargetB.error(name, message, parameters);
		} else if( _logTargetA.infoEnabled ) {
			_logTargetA.error(name, message, parameters);
		} else if( _errorEnabled ) {
			_logTargetB.error(name, message, parameters);
		}
	}
	
	public function fatal(name : String, message : String, parameters : Array) : void{
		if( _fatalBothEnabled ) {
			_logTargetA.fatal(name, message, parameters);
			_logTargetB.fatal(name, message, parameters);
		} else if( _logTargetA.infoEnabled ) {
			_logTargetA.fatal(name, message, parameters);
		} else if( _fatalEnabled ) {
			_logTargetB.fatal(name, message, parameters);
		}
	}
	
	public function get debugEnabled(): Boolean {
		return _debugEnabled;
	}

	public function get infoEnabled(): Boolean {
		return _infoEnabled;
	}

	public function get warnEnabled(): Boolean {
		return _warnEnabled;
	}

	public function get errorEnabled(): Boolean {
		return _errorEnabled;
	}

	public function get fatalEnabled(): Boolean {
		return _fatalEnabled;
	}
}