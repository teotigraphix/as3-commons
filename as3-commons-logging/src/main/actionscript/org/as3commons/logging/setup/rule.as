package org.as3commons.logging.setup {
	/**
	 * @author mh
	 */
	public function rule(target:ILogTarget, name:RegExp=null, person:RegExp=null, level:LogSetupLevel=null): SimpleRegExpSetup {
		return new SimpleRegExpSetup(target, name, person, level);
	}
}
