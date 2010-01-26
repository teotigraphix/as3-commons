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
package org.as3commons.logging.util {
	import org.as3commons.logging.LogLevel;

	/**
	 * Utilities for working with log messages.
	 *
	 * @author Christophe Herreman
	 * @author Martin Heidegger
	 */
	public class MessageUtil {
		
		public static const DEFAULT_FORMAT: String = "{date} {logLevel} - {name} - {message}";
		
		private static const PARAMETER_REGEXP: Array /* RegExp */ = [];
		private static const NAME: RegExp = /{name}/g;
		private static const MESSAGE: RegExp = /{message}/g;
		private static const DATE: RegExp = /{date}/g;
		private static const LOG_LEVEL: RegExp = /{logLevel}/g;
		
		private static const DATE_INSTANCE: Date = new Date();
		
		/**
		 * Returns a string with the parameters replaced.
		 */
		public static function toString( format: String, name: String, level: LogLevel, timeMs: Number, message:String, params:Array ):String {
			var numParams:int = params.length;
			while( PARAMETER_REGEXP.length < numParams ) {
				PARAMETER_REGEXP.push( new RegExp("\\{" + PARAMETER_REGEXP.length + "\\}", "g") );
			}
			for (var i:int = 0; i < numParams; ++i) {
				message = message.replace( PARAMETER_REGEXP[i], params[i] );
			}
			DATE_INSTANCE.time = timeMs;
			return format.
				replace( MESSAGE, message ).
				replace( NAME, name ).
				replace( DATE, DATE_INSTANCE.toString() ).
				replace( LOG_LEVEL, level.name );
		}
	}
}