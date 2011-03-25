package org.as3commons.ui.layout.framework {

	/**
	 * @author Jens Struwe 21.03.2011
	 */
	public interface IMultilineLayout extends ILayout {

		/*
		 * Config - Gap
		 */

		function set hGap(hGap : uint) : void;
		
		function get hGap() : uint;
		
		function set vGap(vGap : uint) : void;
		
		function get vGap() : uint;

	}
}
