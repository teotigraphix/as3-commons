/*
 * Copyright (c) 2008-2009 the original author or authors
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */
package org.as3commons.logging.setup.log4j {
	import org.as3commons.logging.setup.HierarchialSetup;
	import org.as3commons.logging.setup.LogSetupLevel;
	
	/**
	 * @author Martin Heidegger
	 * @since 2.7
	 * @see org.as3commons.logging.setup#log4j
	 */
	public class Log4JStyleSetup {
		
		use namespace log4j;
		
		private const _root: HierarchyEntry = new HierarchyEntry("");
		private var _threshold: LogSetupLevel;
		
		public const appender: Appenders = new Appenders();
		public const logger: LevelSetup = new LevelSetup( _root );
		public const additivity: AdditivitySetup = new AdditivitySetup(_root);
		
		public function Log4JStyleSetup() {}
		
		public function set rootLogger(value: String):void {
			parseValue(_root,value);
		}
		
		public function set threshold(level: String):void {
			_threshold = getLevel(level);
		}
		
		public function compile():HierarchialSetup {
			var setup: HierarchialSetup = new HierarchialSetup(".", _threshold);
			_root.applyTo( setup, appender.generateAppenders() );
			return setup;
		}
	}
}

import flash.utils.Proxy;
import flash.utils.flash_proxy;
import flash.utils.getDefinitionByName;
import org.as3commons.logging.api.ILogger;
import org.as3commons.logging.api.getLogger;
import org.as3commons.logging.setup.HierarchialSetup;
import org.as3commons.logging.setup.ILogTarget;
import org.as3commons.logging.setup.LogSetupLevel;
import org.as3commons.logging.setup.log4j.Log4JStyleSetup;
import org.as3commons.logging.setup.target.mergeTargets;
import org.as3commons.logging.util.instantiate;

namespace log4j;
	
use namespace log4j;

const LOGGER: ILogger = getLogger(Log4JStyleSetup);

dynamic class Appenders extends Proxy {
	
	log4j var _appenders: Object = {};
	
	override flash_proxy function getProperty(name: *): * {
		var nameStr: String = name;
		return _appenders[nameStr] ||= new AppenderGenerator(nameStr);
	}
	
	override flash_proxy function setProperty(name: *, value: *) : void {
		(flash_proxy::getProperty(name) as AppenderGenerator)._value = value;
	}
	
	log4j function generateAppenders(): Object {
		var appenders: Object = {};
		for( var appenderName: String in _appenders ){
			var target: ILogTarget = AppenderGenerator( _appenders[appenderName] ).getAppender();
			appenders[appenderName] = target;
		}
		return appenders;
	}
}

dynamic class PropertyContainer extends Proxy {
	
	log4j var _properties : Object = {};
	log4j var _name: String;
	log4j var _value: *;
	
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
	
	override flash_proxy function getProperty(name: *): * {
		var nameStr: String = name;
		return _properties[nameStr] ||= new PropertyContainer( name );
	}
	
	override flash_proxy function setProperty(name: *, value: *) : void {
		(flash_proxy::getProperty(name) as PropertyContainer)._value = value;
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
		return target;
	}
}

dynamic class LevelSetup extends Proxy {
	
	log4j var _children: Object = {};
	log4j var _entry: HierarchyEntry;
	
	public function LevelSetup( entry: HierarchyEntry ) {
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
	internal var _entry: HierarchyEntry;
	
	public function AdditivitySetup( entry: HierarchyEntry ) {
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

function parseValue(entry: HierarchyEntry, value: String):HierarchyEntry {
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

class HierarchyEntry {
	
	internal var _appenders: Array = [];
	internal var _level: LogSetupLevel;
	internal var _additive: Boolean = true;
	internal var _name: String;
	internal var _children: Object = new Object();
	
	public function HierarchyEntry(name: String) {
		_name = name;
		_level = LogSetupLevel.NONE;
	}
	
	public function child(name:String): HierarchyEntry {
		return _children[name] ||= new HierarchyEntry(_name == "" ? name : _name+"."+name);
	}
	
	public function applyTo(setup: HierarchialSetup, appenderLookup: Object ) : void {
		var target: ILogTarget;
		for each( var appenderName: String in _appenders ) {
			target = mergeTargets( target, appenderLookup[appenderName] );
		}
		setup.setHierarchy(_name, target, _level, _additive);
		for each( var child: HierarchyEntry in _children ) {
			child.applyTo( setup, appenderLookup );
		}
	}
}