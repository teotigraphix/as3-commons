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
	
	import com.pblabs.engine.debug.LogEntry;
	import org.as3commons.logging.getNamedLogger;
	import org.as3commons.logging.ILogger;
	import com.pblabs.engine.debug.ILogAppender;
	
	/**
	 * 
	 * 
	 * @author Martin Heidegger
	 * @since 2.1
	 * @see http://pushbuttonengine.com
	 */
	public class PushButtonIntegration implements ILogAppender {
		
		private static const _cache: Object = {};
		
		public function addLogMessage(level:String, loggerName:String, message:String):void {
			var logger: ILogger = _cache[ loggerName ] || ( _cache[ loggerName ] = getNamedLogger( loggerName.replace("::", "."), "pushbutton" ) );
			switch( level ) {
				case LogEntry.DEBUG:
					logger.debug(message);
					break;
				case LogEntry.INFO:
					logger.info(message);
					break;
				case LogEntry.WARNING:
					logger.warn(message);
					break;
				case LogEntry.ERROR:
					logger.error(message);
					break;
				default:
					logger.debug(message);
					break;
			}
		}
	}
}
