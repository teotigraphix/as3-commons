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
package org.as3commons.logging.api {
	
	/**
	 * A <code>ILogger</code> defines the public access for any kind of logging
	 * request.
	 * 
	 * <p><code>ILogger</code> offers the common methods to log your traces like
	 * <code>debug</code>, <code>info</code>, <code>warning</code>, <code>error</code>,
	 * <code>fatal</code>. Each of these methods gets treated separately by the
	 * logging framework.</p>
	 * 
	 * <p><b>Performance Note:</b> If you have a log statement that does intense
	 * processing or intense stringification it will be executed no matter if a log
	 * target is actually in place.</p>
	 * 
	 * <listing>
	 *   // This will call the complexStringifcation no matter if it will do actually
	 *   // something.
	 *   logger.info( complexStringification() );
	 *   
	 *   if( logger.infoEnabled ) {
	 *      // will just call the stringification in case the info is enabled
	 *      logger.info( complexStringification() );
	 *   }
	 * </listing>
	 * 
	 * @author Christophe Herreman
	 * @author Martin Heidegger
	 * @version 2
	 * @see LoggerFactory
	 * @see org.as3commons.logging.api#getLogger()
	 * @see org.as3commons.logging.api#getNamedLogger()
	 */
	public interface ILogger {
		
		/**
		 * Getter for the name this instance. 
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
		 * Returns the person that this logger created.
		 * 
		 * <p>For person based log statements loggers contain a optional information
		 * that can be used to filter for persons that created the logggers</p>
		 * 
		 * @return Person of the logger.
		 */
		function get person():String;
		
		/**
		 * Logs a message for debug purposes.
		 * 
		 * <p>Debug messages should be messages that are additional output used
		 * to ease the debugging of an application.</p>
		 * 
		 * <p>A message can contain place holders that are filled with the additional
		 * parameters. The <code>ILogTarget</code> implementation may treat the 
		 * options as they want.</p>
		 * 
		 * <p>Example for a message with parameters:</p>
		 * <listing>
		 *   logger.debug("A: {0} is B: {1}", "Hello", "World");
		 *   // A: Hello is B: World
		 * </listing>
		 * 
		 * @param message Message that should be logged.
		 * @param parameters List of parameters.
		 */
		function debug(message:*, parameters:Array=null):void;
		
		/**
		 * Logs a message for notification purposes.
		 * 
		 * <p>Notification messages should be messages that highlight interesting
		 * informations about what happens in the the application.</p>
		 * 
		 * <p>A message can contain place holders that are filled with the additional
		 * parameters. The <code>ILogTarget</code> implementation may treat the 
		 * options as they want.</p>
		 * 
		 * <p>Example for a message with parameters:</p>
		 * <listing>
		 *   logger.info("A: {0} is B: {1}", "Hello", "World");
		 *   // A: Hello is B: World
		 * </listing>
		 * 
		 * @param message Message that should be logged.
		 * @param parameters List of parameters.
		 */
		function info(message:*, parameters:Array=null):void;
		
		/**
		 * Logs a message for warning about a undesirable application state.
		 * 
		 * <p>Warnings are designated to be used in case code got executed that
		 * is not desirable for performance, memory or clarity reasons but didn't
		 * result in any error.</p>
		 * 
		 * <p>A message can contain place holders that are filled with the additional
		 * parameters. The <code>ILogTarget</code> implementation may treat the 
		 * options as they want.</p>
		 * 
		 * <p>Example for a message with parameters:</p>
		 * <listing>
		 *   logger.warn("A: {0} is B: {1}", "Hello", "World");
		 *   // A: Hello is B: World
		 * </listing>
		 * 
		 * @param message Message that should be logged.
		 * @param parameters List of parameters.
		 */
		function warn(message:*, parameters:Array=null):void;
		
		/**
		 * Logs a message to notify about an error that was dodged by the application.
		 * 
		 * <p>The Error level is designated to be used in case an error occurred
		 * and the error could be dodged. It should contain hints about why
		 * that error occurs and if there is a common case where this error occurs.</p>
		 * 
		 * <p>A message can contain place holders that are filled with the additional
		 * parameters. The <code>ILogTarget</code> implementation may treat the 
		 * options as they want.</p>
		 * 
		 * <p>Example for a message with parameters:</p>
		 * <listing>
		 *   logger.error("A: {0} is B: {1}", "Hello", "World");
		 *   // A: Hello is B: World
		 * </listing>
		 * 
		 * @param message Message that should be logged.
		 * @param parameters List of parameters.
		 */
		function error(message:*, parameters:Array=null):void;
		
		/**
		 * Logs a message to notify about an error that broke the application and
		 * couldn't be fixed automatically.
		 * 
		 * <p>The Fatal level is designated to be used in case an error occurred
		 * that couldn't be stopped. A fatal error usually results in a inconsistent
		 * or inperceivable application state.</p>
		 * 
		 * <p>A message can contain place holders that are filled with the additional
		 * parameters. The <code>ILogTarget</code> implementation may treat the 
		 * options as they want.</p>
		 * 
		 * <p>Example for a message with parameters:</p>
		 * <listing>
		 *   logger.fatal("A: {0} is B: {1}", "Hello", "World");
		 *   // A: Hello is B: World
		 * </listing>
		 * 
		 * @param message Message that should be logged.
		 * @param parameters List of parameters.
		 */
		function fatal(message:*, parameters:Array=null):void;
		
		/**
		 * <code>true</code> if <code>debug</code> actually does something.
		 * @see #debug()
		 */
		function get debugEnabled():Boolean;
		
		/**
		 * <code>true</code> if <code>info</code> actually does something.
		 * @see #info()
		 */
		function get infoEnabled():Boolean;
		
		/**
		 * <code>true</code> if <code>warn</code> actually does something.
		 * @see #warn()
		 */
		function get warnEnabled():Boolean;
		
		/**
		 * <code>true</code> if <code>error</code> actually does something.
		 * @see #error()
		 */
		function get errorEnabled():Boolean;
		
		/**
		 * <code>true</code> if <code>fatal</code> works.
		 * @see #fatal()
		 */
		function get fatalEnabled():Boolean;
	}
}