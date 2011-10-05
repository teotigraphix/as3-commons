package org.as3commons.logging.setup {
	import flash.utils.getDefinitionByName;
	import avmplus.getQualifiedClassName;
	import flash.utils.describeType;
	import flash.display.Sprite;
	import org.as3commons.logging.api.LOGGER_FACTORY;
	import org.as3commons.logging.api.getLogger;
	import org.as3commons.logging.setup.log4j.log4j;
	import org.as3commons.logging.setup.target.SOSTarget;
	import org.as3commons.logging.setup.target.TraceTarget;

	/**
	 * @author mh
	 */
	public class Log4JSetupTest extends Sprite {
		public function Log4JSetupTest() {
			
			log4j.appender.trace = new TraceTarget();
			log4j.appender.sos = new SOSTarget();
			log4j.appender.funny = "org.as3commons.logging.setup.target::SOSTarget";
			log4j.appender.funny.format = "Hello World {message}";
			log4j.logger.org.as3commons.logging = "WARN, trace";
			log4j.threshold = "WARN";
			log4j.rootLogger = "INFO, funny";
			log4j.logger.mycompany = "WARN, sos, trace";
			log4j.additivity.org.as3commons = false;
			log4j.additivity.mycompany = false;
			
			LOGGER_FACTORY.setup = new SimpleTargetSetup(new TraceTarget());
			LOGGER_FACTORY.setup = log4j.compile();
			
			getLogger("mycompany").warn("hi");
			getLogger("org.as3commons.logging").warn("ho");
			getLogger().info("Hi, not shown because of threshold");
			getLogger().warn("Even setting the format to an appender works, awesome");
		}
	}
}
