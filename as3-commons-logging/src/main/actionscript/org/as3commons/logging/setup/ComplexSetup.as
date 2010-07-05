package org.as3commons.logging.setup {
	import org.as3commons.logging.ILogSetup;
	import org.as3commons.logging.LogTargetLevel;

	/**
	 * @author Martin
	 */
	public class ComplexSetup implements ILogSetup {
		
		private var _firstRule: ComplexRule;
		private var _lastRule: ComplexRule;
		
		public function addTargetRule( rule:RegExp,target:ILogTarget, level:LogTargetLevel = null): ComplexSetup {
			return addSetupRule( rule, new TargetSetup(target, level) );
		}
		
		public function addSetupRule( rule: RegExp, setup: ILogSetup ): ComplexSetup {
			var newRule: ComplexRule = new ComplexRule( rule, setup );
			if( _lastRule ) {
				_lastRule.next = newRule;
			} else {
				_firstRule = newRule;
			}
			_lastRule = newRule;
			return this;
		}
		
		public function addNoLogRule(regExp:RegExp): ComplexSetup {
			return addSetupRule(regExp,new TargetSetup(null,LogTargetLevel.NONE));
		}
		
		public function getTarget(name:String):ILogTarget {
			var setup: ILogSetup = getSetup(name);
			if( setup ) {
				return setup.getTarget(name);
			} else {
				return null;
			}
		}
		
		public function getLevel(name:String):LogTargetLevel {
			var setup: ILogSetup = getSetup(name);
			if( setup ) {
				return setup.getLevel(name);
			} else {
				return LogTargetLevel.NONE;
			}
		}
		
		public function getSetup( name: String ): ILogSetup {
			var current: ComplexRule = _firstRule;
			var lastMatch: ComplexRule = null;
			while( current ) {
				if( current.rule.test(name) ) {
					lastMatch = current;
				}
				current = current.next;
			}
			if( lastMatch ) {
				return lastMatch.setup;
			} else {
				return null;
			}
		}
		
		public function dispose(): void {
			var current: ComplexRule = _firstRule;
			while( current ) {
				current = current.dispose();
			}
		}
	}
}

import org.as3commons.logging.ILogSetup;

internal class ComplexRule {
	public var rule: RegExp;
	public var setup: ILogSetup;
	public var next: ComplexRule;
	
	public function ComplexRule( rule: RegExp, setup: ILogSetup ) {
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
