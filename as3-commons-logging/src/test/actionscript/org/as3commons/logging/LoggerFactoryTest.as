package org.as3commons.logging {
	
	import flexunit.framework.Assert;
	import flexunit.framework.TestCase;
	
	public class LoggerFactoryTest extends TestCase {
		
		public function LoggerFactoryTest() {
		}
		
		// --------------------------------------------------------------------
		//
		// LoggerFactory.getClassLogger()
		//
		// --------------------------------------------------------------------
		
		/**
		 * 
		 */
		public function testGetClassLogger_shouldReplaceColonsWithDot():void {
			var logger:ILogger = LoggerFactory.getClassLogger(LoggerFactoryTest);
			Assert.assertTrue(logger.name.indexOf(":") == -1);
			Assert.assertEquals("org.as3commons.logging.LoggerFactoryTest", logger.name);
		}
	}
}