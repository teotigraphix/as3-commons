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
	import org.as3commons.logging.level.levelToName;
	
	/**
	 * A Formatter that formats a message string using a pattern.
	 * 
	 * <table>
	 *   <tr><th>Field</th>
	 *       <th>Description</th></tr>
	 * 
	 *   <tr><td>{date}</td>
	 *       <td>The date in the format <code>YYYY/MM/DD</code></td></tr>
	 * 
	 *   <tr><td>{dateUTC}</td>
	 *       <td>The UTC date in the format <code>YYYY/MM/DD</code></td></tr>
	 * 
	 *   <tr><td>{gmt}</td>
	 *       <td>The time offset of the statement to the Greenwich mean time in the format <code>GMT+9999</code></td></tr>
	 
	 *   <tr><td>{logLevel}</td>
	 *       <td>The level of the log statement (example: <code>DEBUG</code> )</td></tr>
	 * 
	 *   <tr><td>{logTime}</td>
	 *       <td>The UTC time in the format <code>HH:MM:SS.0MS</code></td></tr>
	 * 
	 *   <tr><td>{message}</td>
	 *       <td>The message of the logger</td></tr>
	 * 
	 *   <tr><td>{message_dqt}</td>
	 *       <td>The message of the logger, double quote escaped.</td></tr>
	 * 
	 *   <tr><td>{name}</td>
	 *       <td>The name of the logger</td></tr>
	 * 
	 *   <tr><td>{time}</td>
	 *       <td>The time in the format <code>H:M:S.MS</code></td></tr>
	 *   
	 *   <tr><td>{timeUTC}</td>
	 *       <td>The UTC time in the format <code>H:M:S.MS</code></td></tr>
	 *   
	 *   <tr><td>{shortName}</td>
	 *       <td>The short name of the logger</td></tr>
	 *   
	 *   <tr><td>{shortSWF}</td>
	 *       <td>The SWF file name</td></tr>
	 *   
	 *   <tr><td>{swf}</td>
	 *       <td>The full SWF path</td></tr>
	 *   
	 *   <tr><td>{person}</td>
	 *       <td>The Person that wrote this statement</td></tr>
	 *   
	 *   <tr><td>{atPerson}</td>
	 *       <td>The Person that wrote this statement with the "@" prefix</td></tr>
	 * </table>
	 *
	 * @author Christophe Herreman
	 * @author Martin Heidegger
	 * @since 2.0
	 * @see org.as3commons.logging.setup.target.IFormattingLogTarget
	 */
	public final class LogMessageFormatter {
		
		private const STATIC_TYPE: int		= 1;
		private const MESSAGE_TYPE: int		= 2;
		private const MESSAGE_DQT_TYPE: int	= 3;
		private const TIME_TYPE: int		= 4;
		private const TIME_UTC_TYPE: int	= 5;
		private const LOG_TIME_TYPE: int	= 6;
		private const DATE_TYPE: int		= 7;
		private const DATE_UTC_TYPE: int	= 8;
		private const LOG_LEVEL_TYPE: int	= 9;
		private const SWF_TYPE: int			= 10;
		private const SHORT_SWF_TYPE: int	= 11;
		private const NAME_TYPE: int		= 12;
		private const SHORT_NAME_TYPE: int	= 13;
		private const GMT_OFFSET_TYPE: int	= 14;
		private const PERSON_TYPE: int		= 15;
		private const AT_PERSON_TYPE: int	= 16;
		
		private const TYPES: Object			= {
			message:		MESSAGE_TYPE,
			message_dqt:	MESSAGE_DQT_TYPE,
			time:			TIME_TYPE,
			timeUTC:		TIME_UTC_TYPE,
			logTime:		LOG_TIME_TYPE,
			date:			DATE_TYPE,
			dateUTC:		DATE_UTC_TYPE,
			logLevel:		LOG_LEVEL_TYPE,
			swf:			SWF_TYPE,
			shortSWF:		SHORT_SWF_TYPE,
			name:			NAME_TYPE,
			shortName:		SHORT_NAME_TYPE,
			gmt:			GMT_OFFSET_TYPE,
			person:			PERSON_TYPE,
			atPerson:		AT_PERSON_TYPE
		};
		
		private const _now: Date = new Date();
		private const _braceRegexp: RegExp = /{(?P<field>[a-zA-Z_]+)}/g;
		private const _gmt: String = calculateGMT();
		
		/** First no in the generated set */
		private var _firstNode: FormatNode;
		
		/**
		 * Constructs a new <code>LogMessageFormatter</code> instance.
		 * 
		 * @param format Format pattern used to format a log statement
		 */
		public function LogMessageFormatter(format:String) {
			var pos: int = 0;
			var parseResult: Object;
			var lastNode: FormatNode;
			var strNode: FormatNode;
			var strBefore: String;
			var type: int;
			
			while( parseResult =  _braceRegexp.exec( format ) ) {
				
				if( ( type = TYPES[parseResult["field"]] ) ) {
					
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
		 * 
		 * @param name Name of the logger that initiated that log statement.
		 * @param shortName Short name of the logger that initiated that log statement.
		 * @param level Level of which the output happened.
		 * @param timeMs Time in ms since 1970, passed to the log target.
		 * @param message Message that should be logged.
		 * @param params Parameter that should be filled in the message.
		 * @param person Information about the person that filed this log statement.
		 * 
		 * @see org.as3commons.logging.Logger
		 */
		public function format(name:String, shortName:String, level:int, timeMs:Number,
								message:String, params:Array, person:String=null):String {
			
			var result: String = "";
			var node: FormatNode = _firstNode;
			
			if( message ) {
				// It would be theoretically possible to preparse this
				// in order to have a faster statement, but if you would change
				// it to the a preparsed approach you might run into user problems.
				// Log statements like <code>log.debug( "a" + getTimer() );</code>
				// would require new parsing at every call (leading to a higher performance loss)
				// Sure: that might not be a reasonable case. But users don't read
				// documentation and in order to prevent a huge performance problem
				// for them I didnt implement it the high performing way ...
				const numParams:int = params ? params.length: 0;
				for (var i:int = 0; i < numParams; ++i) {
					var param: * = params[i];
					message = message.split( "{"+i+"}" ).join( param );
				}
			}
			_now.time = isNaN( timeMs ) ? 0.0 : timeMs;
			
			while( node ) {
				
				var type: int = node.type;
				if( type < 7 ) {
					if( type < 4 ) {
						// 1
						if( type == STATIC_TYPE ) {
							result += node.content;
						}
						// 2
						else if( type == MESSAGE_TYPE ) {
							result += message;
						}
						// 3
						else { // Message DQT
							if( message ) {
								result += message.replace( "\"", "\\\"" ).replace( "\n", "\\n");
							} else {
								result += message;
							}
						}
					}
					// 4
					else if( type == TIME_TYPE ) {
						result += _now.hours + ":" + _now.minutes + ":" + _now.seconds + "." + _now.milliseconds;
					}
					// 5
					else if( type == TIME_UTC_TYPE ) {
						result += _now.hoursUTC + ":" + _now.minutesUTC + ":" + _now.secondsUTC + "." + _now.millisecondsUTC;
					}
					// 6
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
				} else if( type < 13 ) {
					if( type < 10 ) {
						// 7
						if( type == DATE_TYPE ) {
							result += _now.fullYear + "/" + (_now.month+1) + "/" + _now.date;
						}
						// 8
						else if( type == DATE_UTC_TYPE ) {
							result += _now.fullYearUTC + "/" + (_now.monthUTC+1) + "/" + _now.dateUTC;
						}
						// 9
						else { // LEVEL_TYPE
							if( level ) result += levelToName(level);
						}
					}
					// 10
					else if( type == SWF_TYPE ) {
						result += SWF_URL;
					}
					// 11
					else if( type == SHORT_SWF_TYPE ) {
						result += SWF_SHORT_URL;
					}
					// 12
					else { // NAME_TYPE
						result += name;
					}
				}
				// 13
				else if( type == SHORT_NAME_TYPE ) {
					result += shortName;
				}
				// 14
				else if( type == GMT_OFFSET_TYPE ) {
					result += _gmt;
				}
				// 15
				else if( type == PERSON_TYPE ) {
					if(person) {
						result += person;
					}
				}
				// 16
				else {
					if(person) {
						result += "@"+person;
					}
				}
				node = node.next;
			}
			return result;
		}
		
		/**
		 * Calculates the GMT of the running swf
		 */
		private function calculateGMT():String {
			var date: Date = new Date();
			var mins: int = date.timezoneOffset;
			var hours: int = mins / 60;
			var pre: String;
			
			if( mins <= 0 ) {
				pre = "+";
				mins = mins * -1;
				hours = hours * -1;
			} else {
				pre = "-";
			}
			
			hours = Math.floor(hours);
			mins = mins - (hours * 60);
			return "GMT"+pre+(( hours < 10 ) ? "0"+hours : hours)+(( mins < 10 ) ? "0"+mins : mins);
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