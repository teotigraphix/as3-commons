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
package org.as3commons.logging.setup {
	import org.as3commons.logging.Logger;
	import org.as3commons.logging.ILogSetup;
	import org.as3commons.logging.setup.target.FlexLogTarget;

	/**
	 * Logger factory that creates a logger from the Flex mx.logging.* package.
	 *
	 * @author Christophe Herreman
	 * @author Martin Heidegger
	 * @version 2
	 */
	public class FlexSetup implements ILogSetup {
		
		public static const INSTANCE: FlexSetup = new FlexSetup();
		
		private const _cache: Object = {};
		
		public function FlexSetup() {}
		
		public function applyTo(logger:Logger):void {
			var name:String = logger.name;
			FlexLogTarget( _cache[name] || ( _cache[name] = new FlexLogTarget( name ) ) ).applyTo(logger);
		}
	}
}