package org.as3commons.logging.setup {
	import org.as3commons.logging.api.LOGGER_FACTORY;
	import org.as3commons.logging.api.getLogger;
	import org.as3commons.logging.setup.target.SOSTarget;
	import org.as3commons.logging.setup.target.TraceTarget;

	import flash.display.Sprite;
	/**
	 * @author mh
	 */
	public class Log4JSetupTest extends Sprite {
		public function Log4JSetupTest() {
			
			log4j.appender.trace = new TraceTarget();
			log4j.appender.sos = new SOSTarget();
			log4j.logger.org.as3commons.logging = "WARN, trace";
			log4j.additivity.org.as3commons = false;
			log4j.logger.mycompany = "WARN, sos, trace";
			
			LOGGER_FACTORY.setup = log4j;
			
			getLogger("mycompany").warn("hi");
			getLogger("org.as3commons.logging").warn("ho");
		}

	}
}
