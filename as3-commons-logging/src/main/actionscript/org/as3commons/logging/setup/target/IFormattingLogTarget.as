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
	
	import org.as3commons.logging.setup.ILogTarget;
	
	/**
	 * A <code>IFormattingLogTarget</code> is a <code>ILogTarget</code> that formats
	 * the input to a string.
	 * 
	 * @author Martin Heidegger
	 * @since 2
	 * @see org.as3commons.logging.util.LogMessageFormatter
	 */
	public interface IFormattingLogTarget extends ILogTarget {
		
		/**
		 * Defines the format used by the target to transform the log statement
		 * to a string.
		 * 
		 * <p>The format passed in can use any of the the following definitions:</p>
		 * <dl>
		 *   <dt>{date}</dt>
		 *   <dd>The date in the format <code>YYYY.MM.DD</code></dd>
		 *   <dt>{dateUTC}</dt>
		 *   <dd>The UTC date in the format <code>YYYY.MM.DD</code></dd>
		 *   <dt>{logLevel}</dt>
		 *   <dd>The level of the log statement (example: <code>DEBUG</code> )</dd>
		 *   <dt>{logTime}</dt>
		 *   <dd>The UTC time in the format <code>HH:MM:SS.0MS</code></dd>
		 *   <dt>{message}</dt>
		 *   <dd>The message of the logger</dd>
		 *   <dt>{message_dqt}</dt>
		 *   <dd>The message of the logger, double quote escaped.</dd>
		 *   <dt>{name}</dt>
		 *   <dd>The name of the logger</dd>
		 *   <dt>{time}</dt>
		 *   <dd>The time in the format <code>H:M:S.MS</code></dd>
		 *   <dt>{timeUTC}</dt>
		 *   <dd>The UTC time in the format <code>H:M:S.MS</code></dd>
		 *   <dt>{shortName}</dt>
		 *   <dd>The short name of the logger</dd>
		 *   <dt>{shortSWF}</dt>
		 *   <dd>The SWF file name</dd>
		 *   <dt>{swf}</dt>
		 *   <dd>The full SWF path</dd>
		 * </dl>
		 * 
		 * @example <listing>
		 *    formattingLogTarget.format = "{shortName} - {logLevel) - {message}";
		 *    logger = getLogger(mypackage.MyClass);
		 *    logger.debug('Hello World');
		 *    // example output: 'MyClass - DEBUG - Hello World';
		 * </listing>
		 * 
		 * @param format Format which the target should use to stringify the log
		 *        statements.
		 * @see org.as3commons.logging.util.LogMessageFormatter
		 * @see org.as3commons.logging.util#SWF_URL
		 * @see org.as3commons.logging.util#SWF_SHORT_URL
		 */
		function set format(format:String):void;
	}
}
