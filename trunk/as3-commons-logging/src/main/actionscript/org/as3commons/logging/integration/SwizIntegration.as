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
	
	import org.as3commons.logging.ILogger;
	import org.as3commons.logging.getLogger;
	import org.swizframework.utils.logging.AbstractSwizLoggingTarget;
	import org.swizframework.utils.logging.SwizLogEvent;
	import org.swizframework.utils.logging.SwizLogEventLevel;
	import org.swizframework.utils.logging.SwizLogger;
	
	/**
	 * @author mh
	 */
	public class SwizIntegration extends AbstractSwizLoggingTarget {
		
		private const _cache: Object = {};
		
		override protected function logEvent( event:SwizLogEvent ):void {
			var category: String = SwizLogger( event.target ).category.replace("::", ".");
			var logger: ILogger = _cache[ category ] || (_cache[ category ] = getLogger( category, "swiz" ) );
			switch( event.level ) {
				case SwizLogEventLevel.DEBUG:
					logger.debug( event.message );
					break;
				case SwizLogEventLevel.INFO:
					logger.info( event.message );
					break;
				case SwizLogEventLevel.WARN:
					logger.warn( event.message );
					break;
				case SwizLogEventLevel.ERROR:
					logger.error( event.message );
					break;
				case SwizLogEventLevel.FATAL:
					logger.fatal( event.message );
					break;
			}
		}
	}
}
