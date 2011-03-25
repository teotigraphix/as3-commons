package org.as3commons.ui.layout.framework.core.config {

	import flash.display.Sprite;

	/**
	 * @author Jens Struwe 24.03.2011
	 */
	public class RenderConfig {

		public var container : Sprite;

		public var show : Boolean = false;
		public var hide : Boolean = false;

		public var renderCallback : Function;
		public var hideCallback : Function;
		public var showCallback : Function;
		
		public function clone() : RenderConfig {
			var config : RenderConfig = new RenderConfig();
			config.container = container;
			config.show = show;
			config.hide = hide;
			config.renderCallback = renderCallback;
			config.hideCallback = hideCallback;
			config.showCallback = showCallback;
			return config;
		}

	}
}
