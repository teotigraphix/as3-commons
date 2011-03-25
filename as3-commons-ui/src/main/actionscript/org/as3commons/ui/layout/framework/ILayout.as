package org.as3commons.ui.layout.framework {

	import flash.display.Sprite;
	import org.as3commons.collections.framework.IIterable;
	import org.as3commons.collections.framework.IRecursiveIterator;
	import org.as3commons.ui.layout.CellConfig;


	/**
	 * @author Jens Struwe 21.03.2011
	 */
	public interface ILayout extends ILayoutItem, IIterable {

		/*
		 * Config - Cell
		 */

		function setCellConfig(cellConfig : CellConfig, hIndex : int = -1, vIndex : int = -1) : void;

		function getCellConfig(hIndex : int = -1, vIndex : int = -1) : CellConfig;

		/*
		 * Config - Min Size
		 */

		function set minWidth(minWidth : uint) : void;
		
		function get minWidth() : uint;
		
		function set minHeight(minHeight : uint) : void;
		
		function get minHeight() : uint;

		/*
		 * Add, Get, Remove
		 */
		
		function add(...args) : void;
		
		function addAll(container : Sprite) : void;
		
		function getLayoutItem(...args) : ILayoutItem;
		
		function recursiveIterator() : IRecursiveIterator;
		
		function remove(key : *) : void;

		/*
		 * Layout
		 */

		function layout(container : Sprite, relayout : Boolean = false) : void;

	}
}
