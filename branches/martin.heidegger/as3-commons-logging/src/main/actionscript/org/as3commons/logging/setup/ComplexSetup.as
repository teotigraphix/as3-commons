package org.as3commons.logging.setup {
	import org.as3commons.logging.ILogSetup;
	import org.as3commons.logging.Logger;

	/**
	 * @author Martin Heidegger
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
