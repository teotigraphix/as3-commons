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
package org.as3commons.logging.setup {
	import org.as3commons.logging.ILogSetup;
	import org.as3commons.logging.LogTargetLevel;
	import org.as3commons.logging.setup.target.FlexLogTarget;

	import mx.logging.ILogger;
	import mx.logging.Log;
	import mx.logging.LogEventLevel;

	/**
	 * Logger factory that creates a logger from the Flex mx.logging.* package.
	 *
	 * @author Christophe Herreman
	 */
	public class FlexSetup implements ILogSetup {
		
		public static const INSTANCE: FlexSetup = new FlexSetup();
		
		private const _cache: Object = {};
		
		public function getTarget(name:String):ILogTarget {
			return _cache[name] || ( _cache[name] = new FlexLogTarget( Log.getLogger(name) ) );
		}
		
		public function getLevel(name:String):LogTargetLevel {
			var target: ILogger = Log.getLogger(name);
			try {
				return fromFlexLevel( target["level"] );
			} catch( error: Error ) {
			}
			// It might be possible to guess the logLevel with Log. methods
			// but this doesn't apply to the ILogger instance.
			return LogTargetLevel.ALL;
		}
		
		private function fromFlexLevel(flexLevel:int):LogTargetLevel {
			var result: LogTargetLevel = LogTargetLevel.NONE;
			if( flexLevel & LogEventLevel.DEBUG == LogEventLevel.DEBUG ) {
				result = result.or( LogTargetLevel.DEBUG );
			}
			if( flexLevel & LogEventLevel.INFO == LogEventLevel.INFO ) {
				result = result.or( LogTargetLevel.INFO );
			}
			if( flexLevel & LogEventLevel.WARN == LogEventLevel.WARN ) {
				result = result.or( LogTargetLevel.WARN );
			}
			if( flexLevel & LogEventLevel.ERROR == LogEventLevel.ERROR ) {
				result = result.or( LogTargetLevel.ERROR );
			}
			if( flexLevel & LogEventLevel.FATAL == LogEventLevel.FATAL ) {
				result = result.or( LogTargetLevel.FATAL );
			}
			return result;
		}
	}
}