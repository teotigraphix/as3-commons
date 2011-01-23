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
package org.as3commons.logging.util {
	
	import org.as3commons.logging.LogLevel;
	
	/**
	 * A Formatter that formats a message string using a pattern.
	 *
	 * @author Christophe Herreman
	 * @author Martin Heidegger
	 */
	public final class LogMessageFormatter {
		
		private const STATIC_TYPE: int		= 0;
		private const MESSAGE_TYPE: int		= 1;
		private const MESSAGE_DQT_TYPE: int	= 2;
		private const TIME_TYPE: int		= 3;
		private const TIME_UTC_TYPE: int	= 4;
		private const LOG_TIME_TYPE: int	= 5;
		private const DATE_TYPE: int		= 6;
		private const DATE_UTC_TYPE: int	= 7;
		private const LOG_LEVEL_TYPE: int	= 8;
		private const SWF_TYPE: int			= 9;
		private const SHORT_SWF_TYPE: int	= 10;
		private const NAME_TYPE: int		= 11;
		private const SHORT_NAME_TYPE: int	= 12;
		
		private const _now: Date = new Date();
		private const _braceRegexp: RegExp = /{(?P<field>[a-zA-Z_]+)}/g;
		private var _firstNode: FormatNode;
		
		public function LogMessageFormatter( format:String ) {
			var pos: int = 0;
			var parseResult: Object;
			var lastNode: FormatNode;
			var strNode: FormatNode;
			var strBefore: String;
			var type: int;
			
			while( parseResult =  _braceRegexp.exec( format ) ) {
				
				var field: String = parseResult["field"];
				type = -1;
				
				     if( field == "message" )		type = MESSAGE_TYPE;
				else if( field == "message_dqt" )	type = MESSAGE_DQT_TYPE;
				else if( field == "time" )			type = TIME_TYPE;
				else if( field == "timeUTC" )		type = TIME_UTC_TYPE;
				else if( field == "logTime" )		type = LOG_TIME_TYPE;
				else if( field == "date" )			type = DATE_TYPE;
				else if( field == "dateUTC" )		type = DATE_UTC_TYPE;
				else if( field == "logLevel" )		type = LOG_LEVEL_TYPE;
				else if( field == "swf" )			type = SWF_TYPE;
				else if( field == "shortSWF" )		type = SHORT_SWF_TYPE;
				else if( field == "name" )			type = NAME_TYPE;
				else if( field == "shortName" )		type = SHORT_NAME_TYPE;
				
				if( type != -1 ) {
					
					if( pos != parseResult["index"] ) {
						
						strBefore = format.substring( pos, parseResult["index"] );
						strNode = new FormatNode();
						strNode.type = STATIC_TYPE;
						strNode.content = strBefore;
						
						if( lastNode )
							lastNode.next = strNode;
						else
							_firstNode = strNode;
						
						lastNode = strNode;
					}
					
					var contentNode: FormatNode = new FormatNode();
					contentNode.type = type;
					
					pos = parseResult["index"] + parseResult[0]["length"];
					
					if( lastNode )
						lastNode.next = contentNode;
					else
						_firstNode = contentNode;
					
					lastNode = contentNode;
				}
			}
			
			if( pos != format.length ) {
				strBefore = format.substring( pos );
				strNode = new FormatNode();
				strNode.type = STATIC_TYPE;
				strNode.content = strBefore;
				
				if( lastNode )
					lastNode.next = strNode;
				else
					_firstNode = strNode;
			}
		}
		
		/**
		 * Returns a string with the parameters replaced.
		 */
		public function format( name:String, shortName:String, level:LogLevel, timeMs:Number, message:String, params:Array ):String {
			
			var result: String = "";
			var node: FormatNode = _firstNode;
			
			if( message ) {
				// While it would be theoretically possible to preparse this
				// in order to have a faster statement. But if you would change
				// it to the a preparsed approach you might run into user problems"
				// log.debug( "a" + getTimer() ); would require new parsing for
				// every call - we would soon run into a memory problem which we
				// could only avoid with proper stacking, which costs time as well.
				const numParams:int = params ? params.length: 0;
				for (var i:int = 0; i < numParams; ++i) {
					var param: * = params[i];
					message = message.replace( "{"+i+"}", param );
				}
			}
			_now.time = isNaN( timeMs ) ? 0.0 : timeMs;
			
			while( node ) {
				
				var type: int = node.type;
				if( type < 6 ) {
					if( type < 3 ) {
						// 0
						if( type == STATIC_TYPE ) {
							result += node.content;
						}
						// 1
						else if( type == MESSAGE_TYPE ) {
							result += message;
						}
						// 2
						else { // Message DQT
							if( message ) {
								result += message.replace( "\"", "\\\"" ).replace( "\n", "\\n");
							} else {
								result += message;
							}
						}
					}
					// 3
					else if( type == TIME_TYPE ) {
						result += _now.hours + ":" + _now.minutes + ":" + _now.seconds + "." + _now.milliseconds;
					}
					// 4
					else if( type == TIME_UTC_TYPE ) {
						result += _now.hoursUTC + ":" + _now.minutesUTC + ":" + _now.secondsUTC + "." + _now.millisecondsUTC;
					}
					// 5
					else { // LOG_TIME_TYPE
						var hrs: String = _now.hoursUTC.toString();
						if( hrs.length == 1 ) {
							hrs = "0"+hrs;
						}
						var mins: String = _now.minutesUTC.toString();
						if( mins.length == 1 ) {
							mins = "0"+mins;
						}
						var secs: String = _now.secondsUTC.toString();
						if( secs.length == 1 ) {
							secs = "0"+secs;
						}
						var ms: String = _now.millisecondsUTC.toString();
						if( ms.length == 1 ) {
							ms = "00"+ms;
						} else if( ms.length == 2 ) {
							ms = "0"+ms;
						}
						result += hrs+":"+mins+":"+secs+"."+ms;
					}
				} else if( type < 12 ) {
					if( type < 9 ) {
						// 6
						if( type == DATE_TYPE ) {
							result += _now.fullYear + "/" + (_now.month+1) + "/" + _now.date;
						}
						// 7
						else if( type == DATE_UTC_TYPE ) {
							result += _now.fullYearUTC + "/" + (_now.monthUTC+1) + "/" + _now.dateUTC;
						}
						// 8
						else { // LEVEL_TYPE
							if( level ) result += level.name;
						}
					}
					// 9
					else if( type == SWF_TYPE ) {
						result += SWF_URL;
					}
					// 10
					else if( type == SHORT_SWF_TYPE ) {
						result += SWF_SHORT_URL;
					}
					// 11
					else { // NAME_TYPE
						result += name;
					}
				}
				// 12
				else { // SHORT_NAME_TYPE
					result += shortName;
				}
				node = node.next;
			}
			return result;
		}
	}
}

internal final class FormatNode {
	public var next: FormatNode;
	public var content: String;
	public var param: int;
	public var type: int;
	
	public function FormatNode() {}
}