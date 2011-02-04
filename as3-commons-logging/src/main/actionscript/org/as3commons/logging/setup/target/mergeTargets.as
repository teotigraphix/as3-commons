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
	
	import flash.utils.Dictionary;
	
	import org.as3commons.logging.setup.ILogTarget;
	
	/**
	 * Merges a list of <code>ILogTarget</code> instances to one instance.
	 * 
	 * <p>This method is pretty useful if you want use more than one target for
	 * to be triggered from the same logger. The resulting <code>ILogTarget</code>
	 * of this method will log to all the targets passed in.</p>
	 * 
	 * @example <listing>
	 *   LOGGER_FACTORY.setup = new SimpleTargetSetup(
	 *     mergeTargets( TRACE_TARGET, new SOSTarget, new TextFieldTarget )
	 *   );
	 *   // now all log statements go to all three targets!
	 * </listing>
	 *
	 * @param targets All the targets that should be merged.
	 * @return A target that will log to all the passed-in targets.
	 * @author Martin Heidegger
	 * @since 2
	 */
	public function mergeTargets( ...targets ):ILogTarget {
		var contains: Dictionary = new Dictionary();
		var target: ILogTarget = null;
		while( targets.length > 0 ) {
			var current: ILogTarget = targets.shift() as ILogTarget;
			if( current && !contains[current] ) {
				contains[current] = true;
				if( target ) {
					target = new MergedTarget( target, current );
				} else {
					target = current;
				}
			}
		}
		return target;
	}
}
