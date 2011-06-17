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
	
	import com.demonsters.debugger.MonsterDebugger;
	import org.as3commons.logging.level.DEBUG;
	import org.as3commons.logging.level.ERROR;
	import org.as3commons.logging.level.FATAL;
	import org.as3commons.logging.level.INFO;
	import org.as3commons.logging.level.WARN;
	import org.as3commons.logging.setup.target.IFormattingLogTarget;
	import org.as3commons.logging.util.LogMessageFormatter;

	/**
	 * <code>MonsterDebugger3TraceTarget</code> traces directly to the Monster Debugger 3 console.
	 * 
	 * <p>The Monster Debugger is an alternative way to display your logging statements.</p>
	 * 
	 * @author Tim Keir
	 * @author Martin Heidegger
	 * @see http://demonsterdebugger.com/asdoc/com/demonsters/debugger/MonsterDebugger.html#trace()
	 * @since 2.1
	 */
	public final class MonsterDebugger3TraceTarget extends Object implements IFormattingLogTarget
	{
		/** Default output format used to stringify log statements via MonsterDebugger.trace(). */
		public static const DEFAULT_FORMAT:String = "{message}";

		/** Default colors used to color the output statements. */
		public static const DEFAULT_COLORS:Object = {};
		{
			DEFAULT_COLORS[DEBUG] = 0x0030AA;
			DEFAULT_COLORS[FATAL] = 0xAA0000;
			DEFAULT_COLORS[ERROR] = 0xFF0000;
			DEFAULT_COLORS[INFO] = 0x666666;
			DEFAULT_COLORS[WARN] = 0xff7700;
		}
		
		
		/** Colors used to display the messages. */
		private var _colors:Object;
		
		/** Formatter that renders the log statements via MonsterDebugger.trace(). */
		private var _formatter:LogMessageFormatter;
		
		/** Depth  */
		private var _depth: int; 
		
		/**
		 * Constructs a new <code>MonsterDebugger3Target</code>
		 * 
		 * @param format Default format used to render log statements.
		 * @param colors Default colors used to color log statements.
		 * @param depth Depth used to 
		 */
		public function MonsterDebugger3TraceTarget(format:String=null,
													colors:Object=null,
													depth:int=5) {
			this.format = format;
			this.colors = colors;
			this.depth = depth;
		}

		/**
		 * The colors used to to send the log statement.
		 * 
		 * <p>Monster Debugger supports custom colors for log statements. These
		 * can be changed dynamically if you pass here a Dictionary with Colors (numbers)
		 * used for all levels:</p>
		 * 
		 * @example <listing version="3.0">
		 *     import org.as3commons.logging.level.*;
		 *     
		 *     var colors: Dictionary = new Dictionary();
		 *     colors[DEBUG] = 0x00FF00;
		 *     colors[INFO] = 0x00FFFF;
		 *     colors[WARN] = 0xFF0000;
		 *     colors[ERROR] = 0x0000FF;
		 *     colors[FATAL] = 0xFFFF00; 
		 *     MONSTER_DEBUGGER_V3_TARGET.colors = colors;
		 * </listing>
		 */
		public function get colors():Object {
			return _colors;
		}
		
		public function set colors(colors:Object):void {
			_colors = colors||DEFAULT_COLORS;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set format(format:String):void {
			_formatter = new LogMessageFormatter(format||DEFAULT_FORMAT);
		}
		
		/**
		 * Depth used to introspect objects.
		 */
		public function set depth(depth:int):void {
			_depth = depth;
		}
		
		public function get depth():int {
			return _depth;
		}
		
		/**
		 * @inheritDoc
		 */
		public function log(name:String, shortName:String, level:int,
							timeStamp:Number, message:*, parameters:Array,
							person:String=null):void {
			if( message is String ) {
				message = _formatter.format( name, shortName, level, timeStamp,
											 message, parameters, person );
			}
			
			MonsterDebugger.trace( name, message, person, ""/* Label is not supported */,
								   _colors[level], _depth );
		}
	}
}
