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
	 * <code>ILogSetup</code> defines the setup mechanism or <code>Logger</code>
	 * instances created by <code>LoggerFactory</code>.
	 *
	 * <p>By implementing <code>ILogSetup</code> its possible to augment all loggers
	 * </p> 
	 * 
	 * @author Martin Heidegger
	 * @since 2.0
	 */
	public interface ILogSetup {
		
		/**
		 * Sets all targets of the passed-in <code>Logger</code> to the target
		 * defined by the setup.
		 * 
		 * @param logger <code>Logger</code> to be augmented by the setup
		 */
		function applyTo(logger:Logger):void;
	}
}
