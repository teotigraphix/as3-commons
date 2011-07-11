package {
	import org.as3commons.logging.util.SWFInfo;
	import org.as3commons.logging.simple.info;
	import org.as3commons.logging.setup.target.SOSTarget;
	import org.as3commons.logging.setup.SimpleTargetSetup;
	import org.as3commons.logging.api.LOGGER_FACTORY;
	import flash.display.Sprite;

	/**
	 * @author mh
	 */
	public class SOSTest extends Sprite {
		public function SOSTest() {
			LOGGER_FACTORY.setup = new SimpleTargetSetup( new SOSTarget() );
			SWFInfo.init(stage);
			info("1Hello World");
			info("2Hello World\nis fun!");
			info("3Hello World is very funny");
			info("4Hello World is very funny, but we dont tell you");
			info("5Hello World is very funny, but we dont tell you what we want to do.");
			info("6Hello World is very funny, but we dont tell you what we want to do and all the things we dont want to do.");
			info("7Hello World is very funny, but we dont tell you what we want to do and all the things we dont want to do. This is sooo much fun");
			info("8Hello World is very funny, but we dont tell you what we want to do and all the things we dont want to do. This is sooo much fun, i hope we hit the 100 characters");
		}
	}
}
