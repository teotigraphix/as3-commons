package org.as3commons.logging.setup {
	/**
	 * @author mh
	 */
	public class PropertiesSetup {
		
		private var _properties:Object;
		
		public function PropertiesSetup(properties:Object=null) {
			this.properties = properties;
		}
		
		public function set properties(properties : Object) : void {
			_properties = properties || {};
			# Set root logger level to DEBUG and its only appender to A1.
			log4j.rootLogger=DEBUG, A1
			
			# A1 is set to be a ConsoleAppender.
			log4j.appender.A1=org.apache.log4j.ConsoleAppender
			
			# A1 uses PatternLayout.
			log4j.appender.A1.layout=org.apache.log4j.PatternLayout
			log4j.appender.A1.layout.ConversionPattern=%-4r [%t] %-5p %c %x - %m%n
		}
	}
}
