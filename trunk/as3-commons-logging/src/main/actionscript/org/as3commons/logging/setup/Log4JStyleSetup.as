package org.as3commons.logging.setup {
	import org.as3commons.logging.api.ILogSetup;
	import org.as3commons.logging.api.Logger;
	/**
	 * @author Martin Heidegger
	 * @since 2.7
	 */
	public class Log4JStyleSetup implements ILogSetup {
		
		use namespace log4j;
		
		private const _root: ValueEntry = new ValueEntry("");
		private var _threshold : LogSetupLevel;
		private var _appenderLookup : Object;
		
		public function set rootLogger(value: String): void {
			parseValue(_root,value);
		}
		
		public const appender: Appenders = new Appenders();
		public const logger: LevelSetup = new LevelSetup( _root );
		public const additivity: AdditivitySetup = new AdditivitySetup( _root );
		
		public function set threshold(level: String): void {
			_threshold = getLevel(level);
		}
		
		public function init():void {
			_appenderLookup = appender.generateAppenders();
		}
		
		public function applyTo( logger: Logger ): void {
			
			_root.applyTo(logger, _appenderLookup, _threshold);
			if( logger.name != "" ) {
				var parts: Array = logger.name.split(".");
				var entry: ValueEntry = _root;
				
				// TODO: is the init method really better?
				//if ( appender.changed ) {
				//	_appenderLookup = appender.generateAppenders();
				//}
				if( logger.name )
				for each( var part: String in parts ) {
					entry = entry._children[part];
					if( entry ) {
						entry.applyTo(logger, _appenderLookup, _threshold);
					} else {
						break;
					}
				}
			}
		}
	}
}
import flash.utils.getDefinitionByName;
import org.as3commons.logging.util.instantiate;
import org.as3commons.logging.api.ILogger;
import org.as3commons.logging.api.Logger;
import org.as3commons.logging.api.getLogger;
import org.as3commons.logging.setup.ILogTarget;
import org.as3commons.logging.setup.Log4JStyleSetup;
import org.as3commons.logging.setup.LogSetupLevel;
import org.as3commons.logging.setup.target.mergeTargets;

import flash.utils.Proxy;
import flash.utils.flash_proxy;

namespace log4j;
	
use namespace log4j;

const LOGGER: ILogger = getLogger(Log4JStyleSetup);

dynamic class Appenders extends Proxy {
	
	log4j var _appenders: Object = {};
	log4j var _changed: Boolean = true;
	
	override flash_proxy function getProperty(name: *): * {
		var nameStr: String = name;
		return _appenders[nameStr] ||= new AppenderGenerator(nameStr);
	}
	
	override flash_proxy function setProperty(name: *, value: *) : void {
		(flash_proxy::getProperty(name) as AppenderGenerator)._value = value;
		_changed = true;
	}
	
	log4j function generateAppenders(): Object {
		var appenders: Object = {};
		for( var appenderName: String in _appenders ){
			var target: ILogTarget = AppenderGenerator( _appenders[appenderName] ).getAppender();
			appenders[appenderName] = target;
		}
		_changed = false;
		return appenders;
	}
	
	log4j function get changed(): Boolean {
		if( _changed ) {
			return true;
		}
		for( var child: String in _appenders ) {
			if( (_appenders[child] as AppenderGenerator).changed ) {
				return true;
			}
		}
		return false;
	}
}


dynamic class PropertyContainer extends Proxy {
	
	log4j var _properties : Object = {};
	log4j var _name: String;
	log4j var _value: *;
	log4j var _changed: Boolean = false;
	
	public function PropertyContainer(propertyName: String) {
		_name = propertyName;
	}
	
	log4j function applyProperty(instance:*, stack: Array): void {
		try {
			instance[_name] = _value;
			var child: String;
			if( _value ) {
				stack.push(_name);
				for( child in _properties ) {
					if( child != "Threshold" || stack.length != 0) {
						// Ignore the "Threshold" child as its used in the setup process
						(_properties[child] as PropertyContainer).applyProperty(_value, stack);
					}
				}
				stack.pop();
			} else {
				for( child in _properties ) {
					if( LOGGER.warnEnabled ) {
						LOGGER.warn("Can not set child properties for '{1}' of appender '{0}' as its 'null'", [stack[0], stack.slice(1, stack.length).join(".")]);
					}
					break;
				}
			}
		} catch( e: Error ) {
			if( LOGGER.warnEnabled ) {
				LOGGER.warn("Can not set property '{1}' of appender '{0}'", [stack[0], stack.slice(1, stack.length).join(".")]);
			}
		}
	}
	
	log4j function get changed(): Boolean {
		if( _changed ) {
			return true;
		}
		for( var child: String in _properties ) {
			if( (_properties[child] as PropertyContainer).changed ) {
				return true;
			}
		}
		return false;
	}
	
	log4j function set changed(changed: Boolean): void {
		_changed = changed;
		for( var child: String in _properties ) {
			(_properties[child] as PropertyContainer).changed = changed;
		}
	}
	
	override flash_proxy function getProperty(name: *): * {
		var nameStr: String = name;
		return _properties[nameStr] ||= new PropertyContainer( name );
	}
	
	override flash_proxy function setProperty(name: *, value: *) : void {
		(flash_proxy::getProperty(name) as PropertyContainer)._value = value;
		_changed = true;
	}
	
	
}

dynamic class AppenderGenerator extends PropertyContainer {
	
	public function AppenderGenerator(name: String) {
		super( name);
	}
	
	log4j function getAppender(): ILogTarget {
		var target: ILogTarget;
		if( _value is ILogTarget ) {
			target = _value;
		} else if( _value is String ) {
			var cls: *;
			try {
				cls = getDefinitionByName( _value );
			} catch (e:Error) {}
			if( cls ) {
				try {
					target = ILogTarget( instantiate( cls ) );
				} catch( e: Error ) {
					if( LOGGER.warnEnabled ) {
						LOGGER.warn( "Appender '{0}' could not be instantiated as '{1}' due to error '{2}'", [_name, _value, e] );
					}
				}
			} else if( LOGGER.warnEnabled ) {
				LOGGER.warn( "Appender '{0}' can not be instantiated from class '{1}' because the class wasn't available at runtime.", [_name, _value] );
			}
		} else if( LOGGER.warnEnabled ) {
			LOGGER.warn( "Appender '{0}' could not be used as its no ILogTarget implementation or string! Defined as: {1}", [_name, _value] );
		}
		
		if( target ) {
			var stack: Array;
			for( var name: String in _properties ) {
				(_properties[name] as PropertyContainer).applyProperty(target, stack ||= [_name]);
			}
		}
		changed = false;
		return target;
	}
}

dynamic class LevelSetup extends Proxy {
	
	log4j var _children: Object = {};
	log4j var _entry: ValueEntry;
	
	public function LevelSetup( entry: ValueEntry ) {
		_entry = entry;
	}
	
	override flash_proxy function getProperty(name: *): * {
		var nameStr: String = name;
		return _children[nameStr] ||= new LevelSetup( _entry.child(nameStr) );
	}
	
	override flash_proxy function setProperty(name: *, value: *) : void {
		parseValue( _entry.child(name), value );
	}
}

dynamic class AdditivitySetup extends Proxy {
	
	internal var _children: Object = {};
	internal var _entry: ValueEntry;
	
	public function AdditivitySetup( entry: ValueEntry ) {
		_entry = entry;
	}
	
	override flash_proxy function getProperty(name: *): * {
		var nameStr: String = name;
		return _children[nameStr] ||= new AdditivitySetup( _entry.child(nameStr) );
	}
	
	override flash_proxy function setProperty(name: *, value: *) : void {
		var valueStr: String = value;
		_entry.child(name)._additive = valueStr.toUpperCase() == "TRUE";
	}
}

function parseValue(entry: ValueEntry, value: String):ValueEntry {
	var valueArr: Array = value.split(",");
	var levelStr: String = trim(valueArr.shift());
	var i: int = valueArr.length;
	while(--i-(-1)) {
		var child:String = trim(valueArr[i]);
		if( child.length > 0 ) {
			valueArr[i] = child;
		} else {
			valueArr.splice(i,1); // don't need empty values don't we
		}
	}
	entry._level = getLevel( levelStr );
	entry._appenders = valueArr.length > 0 ? valueArr : null;
	return entry;
}

function getLevel(levelStr:String): LogSetupLevel {
	levelStr = levelStr.toUpperCase();
	var level:LogSetupLevel = null;
	if( levelStr == "DEBUG" ) {
		level = LogSetupLevel.DEBUG;
	} else if( levelStr == "INFO" ) {
		level = LogSetupLevel.INFO;
	} else if( levelStr == "WARN" ) {
		level = LogSetupLevel.WARN;
	} else if( levelStr == "ERROR" ) {
		level = LogSetupLevel.ERROR;
	} else if( levelStr == "FATAL" ) {
		level = LogSetupLevel.FATAL;
	} else if( levelStr == "NONE" ) {
		level = LogSetupLevel.NONE;
	} else if( levelStr == "ALL" ) {
		level = LogSetupLevel.ALL;
	}
	return level;
}

function trim(str:String): String {
	 return str.replace(/^\s*/, '').replace(/\s*$/, '');
}

class ValueEntry {
	
	internal var _appenders: Array = [];
	internal var _level: LogSetupLevel;
	internal var _additive: Boolean = true;
	internal var _name: String;
	internal var _children: Array = new Array();
	
	public function ValueEntry(name: String) {
		_name = name;
		_level = LogSetupLevel.NONE;
	}
	
	public function child(name:String): ValueEntry {
		return _children[name] ||= new ValueEntry(_name+name);
	}
	
	public function applyTo(logger: Logger, appenderLookup:Object, threshold: LogSetupLevel):void {
		var targets: Array = [];
		for each( var appenderName: String in _appenders ) {
			targets.push(appenderLookup[appenderName]);
		}
		var target: ILogTarget = mergeTargets(targets);
		
		if( !_additive ) {
			logger.allTargets = null;
		}
		
		if(_level.valueOf() & LogSetupLevel.DEBUG_ONLY.valueOf() & threshold.valueOf()) logger.debugTarget = mergeTargets(logger.debugTarget,target);
		if(_level.valueOf() & LogSetupLevel.INFO_ONLY.valueOf()  & threshold.valueOf()) logger.infoTarget  = mergeTargets(logger.infoTarget,target);
		if(_level.valueOf() & LogSetupLevel.WARN_ONLY.valueOf()  & threshold.valueOf()) logger.warnTarget  = mergeTargets(logger.warnTarget,target);
		if(_level.valueOf() & LogSetupLevel.ERROR_ONLY.valueOf() & threshold.valueOf()) logger.errorTarget = mergeTargets(logger.errorTarget,target);
		if(_level.valueOf() & LogSetupLevel.FATAL_ONLY.valueOf() & threshold.valueOf()) logger.fatalTarget = mergeTargets(logger.fatalTarget,target);
	}
}