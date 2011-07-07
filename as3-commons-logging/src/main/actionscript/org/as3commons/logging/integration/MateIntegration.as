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
	
	import mx.logging.ILogger;
	import com.asfusion.mate.core.MateManager;
	
	import mx.logging.ILoggingTarget;
	import mx.logging.LogEvent;
	
	/*FDT_IGNORE*/
	import com.asfusion.mate.events.MateLogEvent;
	import com.asfusion.mate.utils.debug.IMateLogger;
	import org.as3commons.logging.api.getLogger;
	import mx.logging.LogEventLevel;
	/*FDT_IGNORE*/
	
	/**
	 * Once instanciated it will add itself as debugger to the <code>MateManager</code>
	 * and redirect all Mate log statements to as3commons.
	 * 
	 * <listing>
	 *    new MateIntegration(); // Mate metapher, those guys like it like that.
	 *    
	 *    // And works!
	 * </listing>
	 * 
	 * @author Martin Heidegger
	 * @since 2.5
	 * @see http://mate.asfusion.com
	 * @see org.as3commons.logging.setup.target.MateTarget
	 */
	public final class MateIntegration implements ILoggingTarget {
		
		/*FDT_IGNORE*/
		private const _cache: Object = {};
		/*FDT_IGNORE*/
		
		private var _filters: Array;
		private var _level: int;
		
		/**
		 * Constructs and registers the MateIntegration.
		 */
		public function MateIntegration() {
			// Same like MateLogger, just to have fun :)
			MateManager.instance.debugger = this;
		}
		
		/**
		 * 
		 */
		public function get filters() : Array {
			return _filters;
		}
		
		public function set filters( value:Array ):void {
			_filters = value;
		}
		
		public function get level():int {
			return _level;
		}
		
		public function set level( value:int ):void {
			_level = value;
		}
		
		/**
		 *  Sets up this target with the specified logger.
		 *  This allows this target to receive log events from the specified logger.
		 *
		 *  @param logger The ILogger that this target should listen to.
		 */
		public function addLogger(logger:ILogger):void {
			if(logger) {
				logger.addEventListener( LogEvent.LOG, logHandler,false,0,true);
			}
		}
		
		/**
		 *  Stops this target from receiving events from the specified logger.
		 *
		 *  @param logger The ILogger that this target should ignore.
		 */		
		public function removeLogger( logger:ILogger ):void {
			if(logger) {
				logger.addEventListener( LogEvent.LOG, logHandler,false,0,true);
			}
		}
		
		/**
		 * Sends the logevent to as3commons.
		 * 
		 * @param event event that should be sent.
		 */
		private function logHandler( event:LogEvent ):void {
			/*FDT_IGNORE*/
			var category: String = IMateLogger( event.target ).category;
			var e: MateLogEvent = MateLogEvent( event );
			var logger: org.as3commons.logging.api.ILogger = _cache[ category ] || (_cache[ category ] = getLogger( category, "mate" ) );
			switch( event.level ) {
				case LogEventLevel.DEBUG:
					logger.debug( event.message, e.parameters );
					break;
				case LogEventLevel.INFO:
					logger.info( event.message, e.parameters );
					break;
				case LogEventLevel.WARN:
					logger.warn( event.message, e.parameters );
					break;
				case LogEventLevel.ERROR:
					logger.error( event.message, e.parameters );
					break;
				case LogEventLevel.FATAL:
					logger.fatal( event.message, e.parameters );
					break;
			}
			/*FDT_IGNORE*/
		}
	}
}
