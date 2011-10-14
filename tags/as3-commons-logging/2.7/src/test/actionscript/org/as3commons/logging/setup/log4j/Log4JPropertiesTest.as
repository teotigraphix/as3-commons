package org.as3commons.logging.setup.log4j {
	import flexunit.framework.TestCase;

	import org.as3commons.logging.api.Logger;
	import org.as3commons.logging.setup.target.TraceTarget;

	import flash.utils.getQualifiedClassName;

	/**
	 * @author mh
	 */
	public class Log4JPropertiesTest extends TestCase {
		
		public function testProperties(): void {
			var logger: Logger = new Logger("name");
			
			log4jPropertiesToSetup(
				"log4j.appender.trace="+getQualifiedClassName(TraceTarget)+"\n"
				+ "log4j.rootLogger=all, trace"
			).applyTo(logger);
			
			assertTrue( logger.debugTarget is TraceTarget );
		}
		
		public function testMultilineValue(): void {
			
			var logger: Logger = new Logger("name");
			log4jPropertiesToSetup(
				"log4j.appender.\\\\="+getQualifiedClassName(TraceTarget)+"\n"
				+ "log4j.rootLogger=all, \\\\"
			).applyTo(logger);
			assertTrue( logger.debugTarget is TraceTarget );
			
			logger = new Logger("name");
			log4jPropertiesToSetup(
				"log4j.appender.topa="+getQualifiedClassName(TraceTarget)+"\n"
				+ "log4j.rootLogger=all, \\\n"
				+ ",topa"
			).applyTo(logger);
			assertTrue( logger.debugTarget is TraceTarget );
			
			logger = new Logger("name");
			log4jPropertiesToSetup(
				"log4j.appender.topa="+getQualifiedClassName(TraceTarget)+"\n"
				+ "log4j.rootLogger=all, \\\n"
				+ "\\\n"
				+ ",topa"
			).applyTo(logger);
			assertTrue( logger.debugTarget is TraceTarget );
		}
		
		public function testSpecialKeyNames(): void {
			var logger: Logger = new Logger("t\u1234");
			
			log4jPropertiesToSetup(
				"log4j.appender.trace="+getQualifiedClassName(TraceTarget)+"\n"
				+ "log4j.logger.t\\u1234=all, trace"
			).applyTo(logger);
			
			assertTrue( "Unicode logger names", logger.debugTarget is TraceTarget );
			
			logger = new Logger("t\r");
			log4jPropertiesToSetup(
				"log4j.appender.trace="+getQualifiedClassName(TraceTarget)+"\n"
				+ "log4j.logger.t\\r=all, trace"
			).applyTo(logger);
			assertTrue( "\\r logger names", logger.debugTarget is TraceTarget );
			
			logger = new Logger("t\n");
			log4jPropertiesToSetup(
				"log4j.appender.trace="+getQualifiedClassName(TraceTarget)+"\n"
				+ "log4j.logger.t\\n=all, trace"
			).applyTo(logger);
			assertTrue( "\\n logger names", logger.debugTarget is TraceTarget );
			
			logger = new Logger("t\b");
			log4jPropertiesToSetup(
				"log4j.appender.trace="+getQualifiedClassName(TraceTarget)+"\n"
				+ "log4j.logger.t\\b=all, trace"
			).applyTo(logger);
			assertTrue( "\\b logger names", logger.debugTarget is TraceTarget );
			
			log4jPropertiesToSetup(
				"log4j.appender.t\\u1234="+getQualifiedClassName(TraceTarget)+"\n"
				+ "log4j.rootLogger=all, t\\u1234"
			).applyTo(logger);
			assertTrue( "Unicode appender names", logger.debugTarget is TraceTarget );
			
			log4jPropertiesToSetup(
				"log4j.appender.t\\u1234="+getQualifiedClassName(TraceTarget)+"\n"
				+ "log4j.rootLogger=all, t\u1234"
			).applyTo(logger);
			assertTrue( "Unicode appender names", logger.debugTarget is TraceTarget );
			
			log4jPropertiesToSetup(
				"log4j.appender.t\u1234="+getQualifiedClassName(TraceTarget)+"\n"
				+ "log4j.rootLogger=all, t\\u1234"
			).applyTo(logger);
			assertTrue( "Unicode appender names", logger.debugTarget is TraceTarget );
			
			log4jPropertiesToSetup(
				"log4j.appender.t\\n="+getQualifiedClassName(TraceTarget)+"\n"
				+ "log4j.rootLogger=all, t\\\\n"
			).applyTo(logger);
			assertTrue( "\\n appender names", logger.debugTarget is TraceTarget );
			
			log4jPropertiesToSetup(
				"log4j.appender.t\\r="+getQualifiedClassName(TraceTarget)+"\n"
				+ "log4j.rootLogger=all, t\\\\r"
			).applyTo(logger);
			assertTrue( "\\r appender names", logger.debugTarget is TraceTarget );
			
			log4jPropertiesToSetup(
				"log4j.appender.t\\b="+getQualifiedClassName(TraceTarget)+"\n"
				+ "log4j.rootLogger=all, t\\\\b"
			).applyTo(logger);
			assertTrue( "\\b appender names", logger.debugTarget is TraceTarget );
			
			log4jPropertiesToSetup(
				"log4j.appender.t\\\\="+getQualifiedClassName(TraceTarget)+"\n"
				+ "log4j.rootLogger=all, t\\\\"
			).applyTo(logger);
			assertTrue( "\\\\ appender names", logger.debugTarget is TraceTarget );
		}
		
		public function testCommenting(): void {
			var logger: Logger = new Logger("name");
			
			log4jPropertiesToSetup(
				  "#log4j.rootLogger=all, trace"
				+ "log4j.appender.trace="+getQualifiedClassName(TraceTarget)+"\n"
			).applyTo(logger);
			assertNull( "First line should be commented", logger.debugTarget );
			
			log4jPropertiesToSetup(
				  "    #log4j.rootLogger=all, trace"
				+ "log4j.appender.trace="+getQualifiedClassName(TraceTarget)+"\n"
			).applyTo(logger);
			assertNull( "Spaces need to be ignored", logger.debugTarget );
			
			log4jPropertiesToSetup(
				  "\t\n\r\t#log4j.rootLogger=all, trace"
				+ "log4j.appender.trace="+getQualifiedClassName(TraceTarget)+"\n"
			).applyTo(logger);
			assertNull( "Spaces need to be ignored", logger.debugTarget );
			
			log4jPropertiesToSetup(
				  "!log4j.rootLogger=all, trace"
				+ "log4j.appender.trace="+getQualifiedClassName(TraceTarget)+"\n"
			).applyTo(logger);
			assertNull( "Both sort of comments need to work", logger.debugTarget );
			
			log4jPropertiesToSetup(
				  "    !log4j.rootLogger=all, trace"
				+ "log4j.appender.trace="+getQualifiedClassName(TraceTarget)+"\n"
			).applyTo(logger);
			assertNull( "Both sort of comments need to work, with spaces", logger.debugTarget );
			
			log4jPropertiesToSetup(
				  " \t\n\r  !log4j.rootLogger=all, trace"
				+ "log4j.appender.trace="+getQualifiedClassName(TraceTarget)+"\n"
			).applyTo(logger);
			assertNull( "Both sort of comments need to work, with spaces", logger.debugTarget );
		}
	}
}
