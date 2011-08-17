package org.as3commons.logging.util {
	import org.as3commons.logging.level.DEBUG;
	import org.as3commons.logging.level.ERROR;
	import org.as3commons.logging.level.FATAL;
	import org.as3commons.logging.level.INFO;
	import org.as3commons.logging.level.WARN;
	
	/**
	 * @author mh
	 */
	public const LEVEL_NAMES: Object = {};
	{
		LEVEL_NAMES[DEBUG] = "DEBUG";
		LEVEL_NAMES[FATAL] = "FATAL";
		LEVEL_NAMES[ERROR] = "ERROR";
		LEVEL_NAMES[INFO] = "INFO";
		LEVEL_NAMES[WARN] = "WARN";
	}
}
