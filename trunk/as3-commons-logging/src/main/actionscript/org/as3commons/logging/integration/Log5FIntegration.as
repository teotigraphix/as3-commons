/*
 * Copyright (c) 2008-2009 the original author or authors
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */
package org.as3commons.logging.integration {
	
	import org.log5f.layouts.SimpleLayout;
	import org.log5f.Level;
	import org.as3commons.logging.api.ILogger;
	import org.as3commons.logging.api.getLogger;
	import org.log5f.core.Appender;
	import org.log5f.core.IAppender;
	import org.log5f.events.LogEvent;
	
	/**
	 * Appender to the Log5F framework that redirects statements to the Log5F framework
	 * to the as3commons logging setup.
	 * 
	 * <listing>
	 *   import org.as3commons.logging.integration.Log5FIntegration;
	 *   import org.log5f.LoggerManager;
	 *   import org.log5f.core.config.tags.LoggerTag;
	 *   import org.log5f.core.config.tags.ConfigurationTag;
	 *   
	 *   var tag: LoggerTag = new LoggerTag();
	 *   tag.appenders = [new Log5FIntegration()];
	 *   tag.level = "ALL";
	 *   
	 *   var setup: ConfigurationTag = new ConfigurationTag();
	 *   setup.objects = [tag];
	 *   
	 *   LoggerManager.configure(setup);
	 * </listing>
	 * 
	 * <p>Since Log5F has a different way to present variables we are required
	 * to use Log5F Layouts rendering. This makes as3commons layouting ineffective.
	 * Be sure to define the layout seperately for Log5F strings.</p>
	 * 
	 * @author Martin Heidegger mh@leichtgewicht.at
	 * @since 2.5.3
	 * @see http://log5f.org
	 */
	public final class Log5FIntegration extends Appender implements IAppender {
		
		/**
		 * Creates a new Log5FIntegration.
		 * Automatically defines the layout as "SimpleLayout". 
		 */
		public function Log5FIntegration() {
			layout = new SimpleLayout();
		}
		
		/**
		 * Logger storage to tweak some performance ... even though its not necessary
		 * (Log5F wasting a lot of it...)
		 */
		private const _loggers: Object = {};
		
		/**
		 * Sends the events to the as3commons logging framework.
		 * 
		 * @param event Event used by Log5F
		 */
		override protected function append(event:LogEvent):void {
			var name: String = event.category.name;
			var logger: ILogger = _loggers[name] || (_loggers[name] = getLogger(name, "log5f"));
			var message: * = layout.format(event);
			var level: int = event.level.toInt();
			switch (level) {
				case Level.ALL.toInt():
				case Level.INFO.toInt():
					logger.info(message);
					break;
				case Level.DEBUG.toInt():
					logger.debug(message);
					break;
				case Level.ERROR.toInt():
					logger.error(message);
					break;
				case Level.FATAL.toInt():
					logger.fatal(message);
					break;
				case Level.WARN.toInt():
					logger.warn(message);
					break;
			}
		}
	}
}
