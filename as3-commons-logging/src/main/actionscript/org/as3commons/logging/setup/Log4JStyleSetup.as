package org.as3commons.logging.setup {
	import org.as3commons.logging.api.ILogSetup;
	import org.as3commons.logging.api.Logger;
	/**
	 * @author Martin Heidegger
	 * @since 2.7
	 */
	public class Log4JStyleSetup implements ILogSetup {
		
		public const appender: Object = {};
		private const _root: ValueEntry = new ValueEntry("");
		
		public function set rootLogger(value: String): void {
			parseValue(_root,value);
		}
		
		public const logger: LevelSetup = new LevelSetup( _root );
		public const additivity: AdditivitySetup = new AdditivitySetup( _root );
		
		public function applyTo( logger: Logger ): void {
			var parts: Array = logger.name.split(".");
			var entry: ValueEntry = _root;
			_root.applyTo(logger, appender);
			for each( var part: String in parts ) {
				entry = entry._children[part];
				if( entry ) {
					entry.applyTo(logger, appender);
				} else {
					break;
				}
			}
			
		}
	}
}
import org.as3commons.logging.setup.target.mergeTargets;
import org.as3commons.logging.api.Logger;
import org.as3commons.logging.setup.ILogTarget;
import org.as3commons.logging.setup.LogSetupLevel;

import flash.utils.Proxy;
import flash.utils.flash_proxy;

dynamic class LevelSetup extends Proxy {
	
	internal var _children: Object = {};
	internal var _entry: ValueEntry;
	
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
	var i: int = valueArr.length;
	while(--i-(-1)) {
		var child:String = trim(valueArr[i]);
		if( child.length > 0 ) {
			valueArr[i] = child;
		} else {
			valueArr.splice(i,1); // don't need empty values don't we
		}
	}
	var levelStr: String = valueArr.shift();
	levelStr = levelStr.toUpperCase();
	var level:LogSetupLevel = LogSetupLevel.NONE;
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
	}
	if( level != LogSetupLevel.NONE ) {
		entry._level = level;
		entry._appenders = valueArr;
	}
	return entry;
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
	
	public function applyTo(logger: Logger, appender:Object):void {
		var targets: Array = [];
		for each( var appenderName: String in _appenders ) {
			targets.push(appender[appenderName]);
		}
		var target: ILogTarget = mergeTargets(targets);
		
		if( !_additive ) {
			logger.allTargets = null;
			_level.applyTo(logger, target);
		} else {
			if(_level.valueOf() & LogSetupLevel.DEBUG_ONLY.valueOf()) logger.debugTarget = mergeTargets(logger.debugTarget,target);
			if(_level.valueOf() & LogSetupLevel.INFO_ONLY.valueOf())  logger.infoTarget  = mergeTargets(logger.infoTarget,target);
			if(_level.valueOf() & LogSetupLevel.WARN_ONLY.valueOf())  logger.warnTarget  = mergeTargets(logger.warnTarget,target);
			if(_level.valueOf() & LogSetupLevel.ERROR_ONLY.valueOf()) logger.errorTarget = mergeTargets(logger.errorTarget,target);
			if(_level.valueOf() & LogSetupLevel.FATAL_ONLY.valueOf()) logger.fatalTarget = mergeTargets(logger.fatalTarget,target);
		}
	}
}