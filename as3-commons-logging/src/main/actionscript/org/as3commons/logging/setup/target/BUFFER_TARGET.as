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
	
	/**
	 * The <code>BUFFER_TARGET</code> stores statements sent to in order to be 
	 * sent to the output later when (for example) the setup configuration is available.
	 * 
	 * <p>If you want to store log statements because you need to load some files
	 * you can use this target to store statements that get logged meanwhile and
	 * pass them later to the real system.</p>
	 * 
	 * <p>Example: Buffering statements during a loading process.</p>
	 * <listing>
	 *     LOGGER_FACTORY.setup = new SimpleTargetSetup( BUFFER_TARGET );
	 *     
	 *     // load files and create a new setup
	 *     LOGGER_FACTORY.setup = loadedSetup;
	 *     
	 *     // Flushing all former statements to the new setup.
	 *     BUFFER_TARGET.flush();
	 * </listing>
	 * 
	 * @author Martin Heidegger
	 * @since 2.0
	 */
	public const BUFFER_TARGET:IFlushableLogTarget = new BufferTarget();
}

import org.as3commons.logging.LOGGER_FACTORY;
import org.as3commons.logging.LoggerFactory;
import org.as3commons.logging.Logger;
import org.as3commons.logging.LogLevel;
import org.as3commons.logging.level.*;
import org.as3commons.logging.setup.ILogTarget;
import org.as3commons.logging.setup.target.IFlushableLogTarget;
import org.as3commons.logging.setup.target.LogStatement;
	
internal final class BufferTarget implements IFlushableLogTarget {
	
	private const _logStatements:Array /* LogStatement */ = new Array();
	
	public function BufferTarget() {}
	
	/**
	 * @inheritDoc
	 */
	public function log(name:String, shortName:String, level:LogLevel,
						timeStamp:Number, message:*, params:Array): void {
		_logStatements.push(
			new LogStatement( name, shortName, level, timeStamp, message, params )
		);
	}
	
	/**
	 * @inheritDoc
	 */
	public function flush(factory:LoggerFactory=null):void {
		factory = factory||LOGGER_FACTORY;
		var i: int = _logStatements.length;
		while(--i-(-1)) {
			var statement: LogStatement = LogStatement(_logStatements.shift());
			var logger: Logger = factory.getNamedLogger(statement.name) as Logger;
			
			var logTarget: ILogTarget;
			if(statement.level == DEBUG) {
				logTarget = logger.debugTarget;
			} else if(statement.level == INFO) {
				logTarget = logger.infoTarget;
			} else if(statement.level == WARN) {
				logTarget = logger.warnTarget;
			} else if(statement.level == ERROR) {
				logTarget = logger.errorTarget;
			} else if(statement.level == FATAL) {
				logTarget = logger.fatalTarget;
			}
			
			if(logTarget) {
				logTarget.log(
					statement.name, statement.shortName, statement.level,
					statement.timeStamp, statement.message, statement.parameters
				);
			}
		}
	}
}
