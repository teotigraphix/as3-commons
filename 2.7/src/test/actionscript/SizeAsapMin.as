package {
	import avmplus.getQualifiedClassName;
	import org.asaplibrary.util.debug.Log;
	import flash.display.Sprite;

	/**
	 * @author mh
	 */
	public class SizeAsapMin extends Sprite {
		
		public static const name: String = getQualifiedClassName(SizeAsapMin);
		
		public function SizeAsapMin() {
			Log.showTrace(false);
			Log.debug("Hello World",name);
		}
	}
}
