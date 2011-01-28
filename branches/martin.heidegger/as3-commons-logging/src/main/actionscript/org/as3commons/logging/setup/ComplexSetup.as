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
	 * @author Martin Heidegger
	 * @since 2
	 */
	public class ComplexSetup implements ILogSetup {
		
		private var _firstRule: ComplexRule;
		private var _lastRule: ComplexRule;
		
		public function ComplexSetup() {}
		
		public function addTargetRule(rule:RegExp, target:ILogTarget, level:LogSetupLevel = null): ComplexSetup {
			return addSetupRule(
				rule,
				level ? new LevelTargetSetup(target, level) : new SimpleTargetSetup(target)
			);
		}
		
		public function addSetupRule(rule: RegExp, setup: ILogSetup): ComplexSetup {
			var newRule: ComplexRule = new ComplexRule(rule, setup);
			if( _lastRule ) {
				_lastRule.next = newRule;
			} else {
				_firstRule = newRule;
			}
			_lastRule = newRule;
			return this;
		}
		
		public function addNoLogRule(regExp:RegExp): ComplexSetup {
			return addSetupRule(regExp,new SimpleTargetSetup(null));
		}
		
		public function applyTo(logger:Logger):void {
			var current: ComplexRule = _firstRule;
			var lastMatch: ComplexRule = null;
			var name: String = logger.name;
			while( current ) {
				if( current.rule.test(name) ) {
					lastMatch = current;
				}
				current = current.next;
			}
			if ( lastMatch ) {
				lastMatch.setup.applyTo(logger);
			} else {
				logger.allTargets = null;
			}
		}
		
		public function dispose(): void {
			var current: ComplexRule = _firstRule;
			while( current ) {
				current = current.dispose();
			}
			_firstRule = null;
		}
	}
}

import org.as3commons.logging.ILogSetup;

internal class ComplexRule {
	public var rule: RegExp;
	public var setup: ILogSetup;
	public var next: ComplexRule;
	
	public function ComplexRule(rule: RegExp, setup: ILogSetup) {
		this.rule = rule;
		this.setup = setup;
	}
	
	public function dispose():ComplexRule {
		var result: ComplexRule = next;
		rule = null;
		setup = null;
		next = null;
		return result;
	}
}
