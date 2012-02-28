package {
	import org.as3commons.logging.util.SWFInfo;
	import org.as3commons.logging.setup.target.SOSTarget;
	import org.as3commons.logging.setup.SimpleTargetSetup;
	import org.as3commons.logging.api.LOGGER_FACTORY;
    import org.as3commons.logging.simple.*;
	import flash.display.Sprite;

	/**
	 * @author mh
	 */
	public class SOSTest extends Sprite {
		public function SOSTest() {
			LOGGER_FACTORY.setup = new SimpleTargetSetup( new SOSTarget() );
			SWFInfo.init(stage);
			org.as3commons.logging.simple.info("1Hello World");
			org.as3commons.logging.simple.info("2Hello World\nis fun!");
			org.as3commons.logging.simple.info("3Hello World is very funny");
			org.as3commons.logging.simple.info("4Hello World is very funny, but we dont tell you");
			org.as3commons.logging.simple.info("5Hello World is very funny, but we dont tell you what we want to do.");
			org.as3commons.logging.simple.info("6Hello World is very funny, but we dont tell you what we want to do and all the things we dont want to do.");
			org.as3commons.logging.simple.info("7Hello World is very funny, but we dont tell you what we want to do and all the things we dont want to do. This is sooo much fun");
			org.as3commons.logging.simple.info("8Hello World is very funny, but we dont tell you what we want to do and all the things we dont want to do. This is sooo much fun, i hope we hit the 100 characters");
		}
	}
}
