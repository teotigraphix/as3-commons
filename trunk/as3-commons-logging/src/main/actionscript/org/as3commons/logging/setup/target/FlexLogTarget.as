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
package org.as3commons.logging.setup.target {
	
	import org.as3commons.logging.level.DEBUG;
	import org.as3commons.logging.level.ERROR;
	import org.as3commons.logging.level.FATAL;
	import org.as3commons.logging.level.INFO;
	import org.as3commons.logging.level.WARN;
	import org.as3commons.logging.setup.ILogTarget;
	
	import mx.logging.ILogger;
	import mx.logging.Log;
	
	/**
	 * Target that sends the targets to the <code>mx.logging</code> log system from Flex.
	 * 
	 * @author Christophe Herreman
	 * @author Martin Heidegger
	 * @version 2.0
	 */
	public class FlexLogTarget implements ILogTarget {
		
		/** All the Flex loggers requested for that logger */
		private const _loggers:Object = {};
		
		public function FlexLogTarget() {}
		
		/**
		 * @inheritDoc
		 */
		public function log(name:String, shortName:String, level:int,
							timeStamp:Number, message:*, parameters:Array, person:String=null):void {
			var target:ILogger = _loggers[name]||(_loggers[name]=Log.getLogger(name));
			var args: Array = parameters.concat();
			args.unshift( message ? message["toString"]() : null );
			switch( level ) {
				case DEBUG:
					target.debug.apply( null, args );
					break;
				case INFO:
					target.info.apply( null, args );
					break;
				case WARN:
					target.warn.apply( null, args );
					break;
				case ERROR:
					target.error.apply( null, args );
					break;
				case FATAL:
					target.fatal.apply( null, args );
					break;
			}
		}
	}
}
