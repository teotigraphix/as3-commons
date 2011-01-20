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
package org.as3commons.logging {
	
	/**
	 * A <code>ILogger</code> defines the public access for any kind of logging
	 * request.
	 * 
	 * <p><code>ILogger</code> offers the common methods to log your traces like
	 * <code>debug</code>, <code>info</code>, <code>warning</code>, <code>error</code>,
	 * <code>fatal</code>. Each of these methods gets treatened seperatly by the
	 * logging framework.</p>
	 * 
	 * @author Christophe Herreman
	 * @author Martin Heidegger
	 * @see LoggerFactory
	 * @see #getLogger()
	 * @see #getNamedLogger()
	 */
	public interface ILogger {
		
		/**
		 * Getter for the name this 
		 * 
		 * @return name of the instance.
		 */
		function get name():String;
		
		/**
		 * Returns the short form of the name.
		 * 
		 * <p>The name of a <code>ILogger</code> is usually [package].[class]. The
		 * short name contains only the name of [class], in other words: the content
		 * after the last ".".</p>
		 * 
		 * @example If the name is <code>com.some.MyClass</code> then the short
		 *          name is <code>MyClass</code>.
		 * 
		 * @return short form of the name.
		 * @see #name 
		 */
		function get shortName():String
		
		/**
		 * Logs a message for debug purposes.
		 * 
		 * <p>Debug messages should be messages that are just necessary for
		 * the debugging of a application.</p>
		 * 
		 * @example 
		 * 
		 * @param message Message that should be logged.
		 * @param params List of parameters 
		 */
		function debug(message:*, ... params):void;
		
		/**
		 * Logs a message with a "info" level.
		 */
		function info(message:*, ... params):void;
		
		/**
		 * Logs a message with a "warn" level.
		 */
		function warn(message:*, ... params):void;
		
		/**
		 * Logs a message with a "error" level.
		 */
		function error(message:*, ... params):void;
		
		/**
		 * Logs a message with a "fatal" level.
		 */
		function fatal(message:*, ... params):void;
		
		/**
		 * @return <code>true</code> if <code>debug</code> actually does something.
		 * @see #debug
		 */
		function get debugEnabled():Boolean;
		
		/**
		 * @return <code>true</code> if <code>info</code> actually does something.
		 * @see #info
		 */
		function get infoEnabled():Boolean;
		
		/**
		 * @return <code>true</code> if <code>warn</code> actually does something.
		 * @see #warn
		 */
		function get warnEnabled():Boolean;
		
		/**
		 * @return <code>true</code> if <code>error</code> actually does something.
		 * @see #error
		 */
		function get errorEnabled():Boolean;
		
		/**
		 * @return <code>true</code> if <code>fatal</code> works.
		 * @see #fatal
		 */
		function get fatalEnabled():Boolean;
	}
}