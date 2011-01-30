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
package org.as3commons.logging.setup {
	
	import org.as3commons.logging.ILogSetup;
	import org.as3commons.logging.Logger;
	
	/**
	 * 
	 * 
	 * @author Martin Heidegger
	 * @since 2
	 */
	public class RegExpSetup implements ILogSetup {
		
		private var _firstRule: RegExpRule;
		private var _lastRule: RegExpRule;
		
		public function RegExpSetup() {}
		
		public function addTargetRule(rule:RegExp, target:ILogTarget, level:LogSetupLevel=null): RegExpSetup {
			return addRule(
				rule,
				level ? new RegExpLevelTargetSetup(target, level) : new SimpleTargetSetup(target)
			);
		}
		
		public function addRule(rule: RegExp, setup: ILogSetup): RegExpSetup {
			var newRule: RegExpRule = new RegExpRule(rule, setup);
			if( _lastRule ) {
				_lastRule.next = newRule;
			} else {
				_firstRule = newRule;
			}
			_lastRule = newRule;
			return this;
		}
		
		public function addNoLogRule(regExp:RegExp): RegExpSetup {
			return addRule(regExp,new SimpleTargetSetup(null));
		}
		
		public function applyTo(logger:Logger):void {
			logger.allTargets = null;
			var current: RegExpRule = _firstRule;
			var name: String = logger.name;
			while( current ) {
				if( current.rule.test(name) ) {
					current.setup.applyTo(logger);
				}
				current = current.next;
			}
		}
		
		public function dispose(): void {
			var current: RegExpRule = _firstRule;
			while( current ) {
				current = current.dispose();
			}
			_firstRule = null;
		}
	}
}

import org.as3commons.logging.ILogSetup;
import org.as3commons.logging.Logger;
import org.as3commons.logging.setup.ILogTarget;
import org.as3commons.logging.setup.LogSetupLevel;

internal class RegExpRule {
	public var rule: RegExp;
	public var setup: ILogSetup;
	public var next: RegExpRule;
	
	public function RegExpRule(rule: RegExp, setup: ILogSetup) {
		this.rule = rule;
		this.setup = setup;
	}
	
	public function dispose():RegExpRule {
		var result: RegExpRule = next;
		rule = null;
		setup = null;
		next = null;
		return result;
	}
}

internal class RegExpLevelTargetSetup implements ILogSetup {
	
	/** Level to set the target to. */
	private var _level:LogSetupLevel;
	
	/** Target which should be used. */
	private var _target:ILogTarget;
	
	/**
	 * Constructs a new <code>LevelTargetSetup</code>.
	 * 
	 * @param target Target which should be receiving the log output.
	 * @param level Level at which the target should be receiving the output.
	 */
	public function RegExpLevelTargetSetup(target:ILogTarget, level:LogSetupLevel) {
		_target = target;
		_level = level;
	}
	
	/**
	 * @inheritDoc
	 */
	public function applyTo(logger:Logger):void {
		_level.applyTo(logger, _target);
	}
}