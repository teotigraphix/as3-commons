package org.as3commons.logging.util.xml {
	
	import org.as3commons.logging.api.ILogSetup;
	import org.as3commons.logging.setup.LogSetupLevel;
	import org.as3commons.logging.setup.SimpleRegExpSetup;
	import org.as3commons.logging.setup.mergeSetups;
	import org.as3commons.logging.setup.target.mergeTargets;
	
	/**
	 * @author mh
	 */
	public function xmlToSetup(xml:XML, targetTypes:Object, instances:Object=null): ILogSetup {
		if (xml.namespace() == xmlNs) {
			var nodeName: String = xml.localName();
			if (!instances) instances = {};
			
			var target:XML;
			if (nodeName == "setup") {
				var rules: Array = [];
				var ruleNodes: XMLList = xml.xmlNs::rule;
				for each (target in (xml.xmlNs::target.(hasOwnProperty("@name")) + ruleNodes.xmlNs::target.(hasOwnProperty("@name"))) ) {
					instances[target.@name] = xmlToTarget(target, targetTypes);
				}
				for each (var rule:XML in ruleNodes) {
					rules.push( xmlToSetup(rule, targetTypes, instances) );
				}
				return mergeSetups(rules);
			} else if (nodeName == "rule") {
				var targets: Array = [];
				for each (target in xml.xmlNs::target) {
					var targetName: String;
					if (target.hasOwnProperty("@name")) {
						targetName = target.@name;
					}
					if (target.hasOwnProperty("@ref")) {
						targetName = target.@ref;
					}
					if (targetName) {
						// Referenced target
						targets.push( instances[targetName] );
					} else {
						// Unreferencable target
						targets.push( xmlToTarget(target, targetTypes) );
					}
				}
				var name: RegExp;
				if(xml.hasOwnProperty("@name")) {
					name = new RegExp("/"+xml.@name+"/");
				}
				var person: RegExp;
				if(xml.hasOwnProperty("@person")) {
					person = new RegExp("/"+xml.@person+"/");
				}
				var level: LogSetupLevel;
				if(xml.hasOwnProperty("@level")) {
					name = new RegExp("/"+xml.@level+"/");
				}
				return new SimpleRegExpSetup(mergeTargets(targets), name, person, level);
			}
		}
		return null;
	}
}
