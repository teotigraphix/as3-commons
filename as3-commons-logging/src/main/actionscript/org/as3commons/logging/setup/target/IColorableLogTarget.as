package org.as3commons.logging.setup.target {
	import org.as3commons.logging.setup.ILogTarget;
	
	/**
	 * 
	 * @author Martin Heidegger
	 * @version 1.0
	 * @since 2.1
	 */
	public interface IColorableLogTarget extends ILogTarget {
		
		/**
		 * The colors used to to send the log statement.
		 * 
		 * <p>This target supports custom colors for log statements. These
		 * can be changed dynamically if you pass here a Dictionary with Colors (numbers)
		 * used for all levels:</p>
		 * 
		 * @example <listing>
		 *     import org.as3commons.logging.level.*;
		 *     
		 *     target.colors = {
		 *       DEBUG: 0x00FF00,
		 *       INFO: 0x00FFFF,
		 *       WARN: 0xFF0000,
		 *       ERROR: 0x0000FF,
		 *       FATAL: 0xFFFF00
		 *     };
		 * </listing>
		 */
		function set colors( colors:Object ):void;
	}
}
