package {
	import com.pblabs.engine.PBE;
	import com.pblabs.engine.debug.Logger;
	import flash.display.Sprite;

	/**
	 * @author mh
	 */
	public class SizePBEMin extends Sprite {
		public function SizePBEMin() {
			PBE.IS_SHIPPING_BUILD = true;
			Logger.startup();
			Logger.debug( this, "constructor", "Hello World" );
		}
	}
}
