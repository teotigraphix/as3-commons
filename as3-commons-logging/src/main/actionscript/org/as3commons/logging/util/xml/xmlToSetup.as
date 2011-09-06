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
package org.as3commons.logging.util.xml {
	
	import org.as3commons.logging.api.ILogSetup;
	import org.as3commons.logging.setup.LogSetupLevel;
	import org.as3commons.logging.setup.SimpleRegExpSetup;
	import org.as3commons.logging.setup.mergeSetups;
	import org.as3commons.logging.setup.target.mergeTargets;
	
	/**
	 * 
	 * 
	 * @author Martin Heidegger
	 * @since 2.6
	 * @see org.as3commons.logging.util.xml#xmlToTarget()
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
