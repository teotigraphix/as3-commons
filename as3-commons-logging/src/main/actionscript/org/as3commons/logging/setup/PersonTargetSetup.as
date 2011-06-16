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
	
	import org.as3commons.logging.ILogSetup;
	import org.as3commons.logging.Logger;
	
	/**
	 * <code>PersonTargetSetup</code> is a rather simple implementation that
	 * allows to only log statements filed by certain persons.
	 * 
	 * <p>It does nothing more but redirecting the <code>ILogTarget</code> to all
	 * levels of all loggers.</p>
	 * 
	 * <listing>
	 *   // Logstatements by Martin or Christophe will be redirected, others not
	 *   LOGGER_FACTORY.setup = new PersonTargetSetup( /^(Martin|Christophe)$/, new SOSTarget );
	 * </listing>
	 * 
	 * @author Martin Heidegger
	 * @since 2.1
	 * @see org.as3commons.logging.LoggerFactory;
	 */
	public class PersonTargetSetup implements ILogSetup {
		
		/** Persons that are accepted */
		private var _persons: RegExp;
		
		/** Target that should be used */
		private var _target: ILogTarget;
		
		/**
		 * Creates a new <code>PersonTargetSetup</code> that 
		 * 
		 * @param persons Persons that should be accepted by this setup
		 * @param target Target that should be used in that case
		 */
		public function PersonTargetSetup( persons:RegExp, target:ILogTarget ) {
			_persons = persons;
			_target = target;
		}
		
		/**
		 * @inheritDoc
		 */
		public function applyTo( logger:Logger ): void {
			if( _persons.test(logger.person) ) {
				logger.allTargets = _target;
			}
		}
	}
}
