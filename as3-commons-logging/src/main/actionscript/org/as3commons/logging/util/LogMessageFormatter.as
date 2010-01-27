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
		
		private static const NAME: RegExp = /{name}/g;
		private static const SHORT_NAME: RegExp = /{shortName}/g;
		private static const TIME: RegExp = /{time}/g;
		private static const LOG_TIME: RegExp = /{logTime}/g;
		private static const MESSAGE: RegExp = /{message}/g;
		private static const MESSAGE_DOUBLE_QUOTE_ENCODED: RegExp = /{message_dqt}/g;
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
				replace( NAME, name ).
				replace( SHORT_NAME, shortName ).
				replace( LOG_LEVEL, level.name ).
				replace( SWF, LogManager.SWF_URL ).
				replace( SHORT_SWF, LogManager.SWF_SHORT_URL );
				
			if( format.match(MESSAGE_DOUBLE_QUOTE_ENCODED ) ) {
				result = result.replace( MESSAGE_DOUBLE_QUOTE_ENCODED, encodeDoubleQuote( message ) ); 
			}
			if( result.match( LOG_TIME ) ) {
				NOW.time = timeMs;
				var hrs: String = NOW.hoursUTC.toString();
				if( hrs.length == 1 ) {
					hrs = "0"+hrs;
				}
				var mins: String = NOW.minutesUTC.toString();
				if( mins.length == 1 ) {
					mins = "0"+mins;
				}
				var secs: String = NOW.secondsUTC.toString();
				if( secs.length == 1 ) {
					secs = "0"+secs;
				}
				result = result.replace( LOG_TIME, hrs+":"+mins+":"+secs+"."+int( NOW.millisecondsUTC / 100 ) );
			}
			if( result.match( DATE ) ) {
				NOW.time = timeMs;
				result = result.replace( DATE, NOW.toString() );
			}
			if( result.match( TIME ) ) {
				NOW.time = timeMs;
				result = result.replace( TIME, NOW.hoursUTC + ":" + NOW.minutesUTC + ":" + NOW.secondsUTC + "." + NOW.millisecondsUTC );
			}
			return result;
		}
		
		private static function encodeDoubleQuote(message: String): String {
			var split: Array = message.split("\"");
			var l: int = split.length-1;
			for( var i: int = 0; i<l; ++i ) {
				split[i] = split[i]+"\\";
			}
			return split.join("\"");
		}
	}
}