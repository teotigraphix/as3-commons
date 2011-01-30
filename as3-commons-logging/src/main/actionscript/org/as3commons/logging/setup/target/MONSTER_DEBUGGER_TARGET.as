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
	 * Target that logs directly to the monster debugger.
	 * 
	 * <p>The Monster Debugger is an alternative way to display your logging statements.
	 * This target is pretty straightforward about sending it to the Monster Debugger.</p>
	 * 
	 * @author Martin Heidegger
	 * @since 2
	 * @see http://demonsterdebugger.com
	 */
	public const MONSTER_DEBUGGER_TARGET: IFormattingLogTarget = new MonsterDebuggerTarget();
}

import flash.utils.Dictionary;
import nl.demonsters.debugger.MonsterDebugger;

import org.as3commons.logging.LogLevel;
import org.as3commons.logging.level.DEBUG;
import org.as3commons.logging.level.ERROR;
import org.as3commons.logging.level.FATAL;
import org.as3commons.logging.level.INFO;
import org.as3commons.logging.level.WARN;
import org.as3commons.logging.util.LogMessageFormatter;
import org.as3commons.logging.setup.target.IFormattingLogTarget;

internal final class MonsterDebuggerTarget implements IFormattingLogTarget {
	
	/** Default output format used to stringify the log statements. */
	private const DEFAULT_FORMAT: String = "{time} {shortName} - {message}";
	
	/** Default colors used to color the output statements. */
	private const DEFAULT_COLORS: Dictionary = new Dictionary();
	
	private var _colors:Dictionary;
	private var _formatter:LogMessageFormatter;
	
	public function MonsterDebuggerTarget() {
		DEFAULT_COLORS[DEBUG] = MonsterDebugger.COLOR_NORMAL;
		DEFAULT_COLORS[FATAL] = MonsterDebugger.COLOR_ERROR;
		DEFAULT_COLORS[ERROR] = MonsterDebugger.COLOR_ERROR;
		DEFAULT_COLORS[INFO] = MonsterDebugger.COLOR_NORMAL;
		DEFAULT_COLORS[WARN] = MonsterDebugger.COLOR_WARNING;
		this.format = DEFAULT_FORMAT;
		this.colors = DEFAULT_COLORS;
	}
	
	/**
	 *
	 */
	public function set colors(colors:Dictionary):void {
		_colors = colors||DEFAULT_COLORS;
	}
	
	/**
	 * @inheritDoc
	 */
	public function set format(format:String):void {
		_formatter = new LogMessageFormatter(format||DEFAULT_FORMAT);
	}
	
	/**
	 * @inheritDoc
	 */
	public function log(name: String, shortName: String, level: LogLevel, timeStamp: Number, message: *, parameters: Array): void {
		if( message is String ) {
			MonsterDebugger.trace( name, _formatter.format( name, shortName, level, timeStamp, message, parameters), _colors[ level ] );
		} else {
			MonsterDebugger.trace( name, message, _colors[ level ] );
		}
	}
}