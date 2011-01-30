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
	
	import org.as3commons.logging.LoggerFactory;
	import org.as3commons.logging.setup.ILogTarget;
	
	/**
	 * A <code>IFlushableLogTarget</code> describes a target that stores some
	 * log statements and that allows to flush those statements to a logger
	 * at a later statement.
	 * 
	 * @author Martin Heidegger
	 * @since 2.0
	 */
	public interface IFlushableLogTarget extends ILogTarget {
		
		/**
		 * Flushes the content of this target to the logger of the factory.
		 * 
		 * @param factory <code>LoggerFactory</code> to flush to.
		 *                <code>LOGGER_FACTORY</code> will be used if null is passed-in. 
		 */
		function flush(factory:LoggerFactory=null):void;
	}
}
