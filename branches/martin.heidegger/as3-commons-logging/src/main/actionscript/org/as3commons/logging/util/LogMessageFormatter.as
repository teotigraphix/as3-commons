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
package org.as3commons.logging.util 
{
	import org.as3commons.logging.LogLevel;
	import org.as3commons.logging.LogManager;

	
	/**
	 * Utilities for working with log messages.
	 *
	 * @author Christophe Herreman
	 * @author Martin Heidegger
	 */
	public class LogMessageFormatter {
		
		public static const DEFAULT_FORMAT: String = "{date} {logLevel} - {name} - {message}";
		
		private static const NAME: RegExp = /{name}/g;
		private static const SHORT_NAME: RegExp = /{shortName}/g;
		private static const TIME: RegExp = /{time}/g;
		private static const MESSAGE: RegExp = /{message}/g;
		private static const DATE: RegExp = /{date}/g;
		private static const LOG_LEVEL: RegExp = /{logLevel}/g;
		private static const SWF: RegExp = /{swf}/g;
		private static const SHORT_SWF: RegExp = /{shortSWF}/g;
		
		private static const NOW: Date = new Date();
		
		/**
		 * Returns a string with the parameters replaced.
		 */
		public static function format( format:String, name:String, shortName:String, level:LogLevel, timeMs:Number, message:String, params:Array ):String {
			var numParams:int = params.length;
			for (var i:int = 0; i < numParams; ++i) {
				var param: * = params[i];
				message = message.replace( "{"+i+"}", param );
			}
			var result: String = format.
				replace( MESSAGE, message ).
				replace( NAME, name ? name : "" ).
				replace( SHORT_NAME, shortName ? shortName : "" ).
				replace( LOG_LEVEL, level ? level.name : "" ).
				replace( SWF, LogManager.SWF_URL ).
				replace( SHORT_SWF, LogManager.SWF_SHORT_URL );
				
			if( timeMs != -1 && result.match( DATE ) ) {
				NOW.time = timeMs;
				result = result.replace( DATE, NOW.toString() );
			}
			if( timeMs != -1 && result.match( TIME ) ) {
				NOW.time = timeMs;
				result = result.replace( TIME, NOW.hoursUTC + ":" + fill( NOW.minutesUTC.toString(), 2 ) + "." + fill( NOW.millisecondsUTC.toString(), 3 ) );
			}
			return result;
		}

		private static function fill( value: String, length: int): String 
		{
			while( value.length < length )
			{
				value = "0"+value;
			}
			return value;
		}
	}
}