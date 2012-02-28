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
	 *       <td>The Person that wrote this statement with the 'at' prefix</td></tr>
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
		
		private const FILL_2: Array = ["", "0",""];
		private const FILL_3: Array = ["", "00","0",""];
		
		private const _now: Date = new Date();
		private const _braceRegexp: RegExp = /{(?P<field>[A-Z_]+)}/ig;
		private const _fieldRegexp: RegExp = /{(.*)}/ig;
		
		private const _parts: Array = [];
		
		/** First no in the generated set */
		private var _firstNode: FormatNode;
		private var _params: *;
		
		private var _hasMessageNode: Boolean = false;
		private var _hasTimeNode: Boolean = false;
		
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
			var i: int = 0;
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
					if( type == MESSAGE_TYPE || type == MESSAGE_DQT_TYPE ) {
						_hasMessageNode = true;
					} else if( type == TIME_TYPE || type == TIME_UTC_TYPE ||
							   type == DATE_TYPE || type == DATE_UTC_TYPE ||
							   type == LOG_TIME_TYPE ) {
						_hasTimeNode = true;
					}
					
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
			
			var node: FormatNode = _firstNode;
			var c:int = -1;
			while( node ) {
				
				type = node.type;
				if( type < 7 ) {
					if( type < 4 ) {
						// 1
						if( type == STATIC_TYPE ) {
							_parts[++c] = node.content;
						}
						// 2
						else if( type == MESSAGE_TYPE ) {
							++c;
						}
						// 3
						else { // Message DQT
							++c;
						}
					}
					// 6
					else if( type == 6 ) {
						++c;
						++c;
						_parts[++c] = ":";
						++c;
						++c;
						_parts[++c] = ":";
						++c;
						++c;
						_parts[++c] = ".";
						++c;
						++c;
					}
					// 4 || 5
					else {
						++c;
						_parts[++c] = ":";
						++c;
						_parts[++c] = ":";
						++c;
						_parts[++c] = ".";
						++c;
					}
				} else if( type < 13 ) {
					if( type < 10 ) {
						// 7 || 8
						if( type == DATE_TYPE || type == DATE_UTC_TYPE ) {
							++c;
							_parts[++c] = "/";
							++c;
							_parts[++c] = "/";
							++c;
						}
						// 9
						else { // LEVEL_TYPE
							++c;
						}
					}
					// 10
					else if( type == SWF_TYPE ) {
						++c;
					}
					// 11
					else if( type == SHORT_SWF_TYPE ) {
						++c;
					}
					// 12
					else { // NAME_TYPE
						++c;
					}
				}
				// 13
				else if( type == SHORT_NAME_TYPE ) {
					++c;
				}
				// 14
				else if( type == GMT_OFFSET_TYPE ) {
					_parts[++c] = GMT;
				}
				// 15
				else if( type == PERSON_TYPE ) {
					++c;
				}
				// 16
				else {
					c+=2;
				}
				node = node.next;
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
		public function format(name:String, shortName:String, level:int,
							   timeMs:Number, message:String, params:*,
							   person:String):String {
			
			var node: FormatNode = _firstNode;
			
			if( _hasMessageNode && message ) {
				// It would be theoretically possible to preparse this
				// in order to have a faster statement, but if you would change
				// it to the a preparsed approach you might run into user problems.
				// Log statements like <code>log.debug( "a" + getTimer() );</code>
				// would require new parsing at every call (leading to a higher performance loss)
				// Sure: that might not be a reasonable case. But users don't read
				// documentation and in order to prevent a huge performance problem
				// for them I didn't implement it the high performing way ...
				
				// Keeping the parameters in a instance variable so the replaceFields function can access it
				_params = params;
				message = message.replace(_fieldRegexp, replaceFields);
				_params = null;
			}

			if( _hasTimeNode ) {
				_now.time = isNaN( timeMs ) ? 0.0 : START_TIME+timeMs;
			}
			
			var c:int = -1;
			while( node ) {
				
				var type: int = node.type;
				if( type < 7 ) {
					if( type < 4 ) {
						// 1
						if( type == STATIC_TYPE ) {
							++c; // Already filled in
						}
						// 2
						else if( type == MESSAGE_TYPE ) {
							_parts[++c] = message||"null";
						}
						// 3
						else { // Message DQT
							if( message ) {
								_parts[++c] = message.split("\"").join("\\\"").split("\n").join("\\n");
							} else {
								_parts[++c] = "null";
							}
						}
					}
					// 4
					else if( type == TIME_TYPE ) {
						_parts[++c] = _now.hours.toString();
						++c;
						_parts[++c] = _now.minutes.toString();
						++c;
						_parts[++c] = _now.seconds.toString();
						++c;
						_parts[++c] = _now.milliseconds.toString();
					}
					// 5
					else if( type == TIME_UTC_TYPE ) {
						_parts[++c] = _now.hoursUTC.toString();
						++c;
						_parts[++c] = _now.minutesUTC.toString();
						++c;
						_parts[++c] = _now.secondsUTC.toString();
						++c;
						_parts[++c] = _now.millisecondsUTC.toString();
					}
					// 6
					else { // LOG_TIME_TYPE
						var hrs: String = _now.hoursUTC.toString();
						var mins: String = _now.minutesUTC.toString();
						var secs: String = _now.secondsUTC.toString();
						var ms: String = _now.millisecondsUTC.toString();
						_parts[++c] = FILL_2[hrs.length];
						_parts[++c] = hrs;
						++c;
						_parts[++c] = FILL_2[mins.length];
						_parts[++c] = mins;
						++c;
						_parts[++c] = FILL_2[secs.length];
						_parts[++c] = secs;
						++c;
						_parts[++c] = FILL_3[ms.length];
						_parts[++c] = ms;
					}
				} else if( type < 13 ) {
					if( type < 10 ) {
						// 7
						if( type == DATE_TYPE ) {
							_parts[++c] = _now.fullYear.toString();
							++c;
							_parts[++c] = (_now.month+1).toString();
							++c;
							_parts[++c] = _now.date.toString();
						}
						// 8
						else if( type == DATE_UTC_TYPE ) {
							_parts[++c] = _now.fullYearUTC.toString();
							++c;
							_parts[++c] = (_now.monthUTC+1).toString();
							++c;
							_parts[++c] = _now.dateUTC.toString();
						}
						// 9
						else { // LEVEL_TYPE
							_parts[++c] = LEVEL_NAMES[level];
						}
					}
					// 10
					else if( type == SWF_TYPE ) {
						_parts[++c] = SWF_URL;
					}
					// 11
					else if( type == SHORT_SWF_TYPE ) {
						_parts[++c] = SWF_SHORT_URL;
					}
					// 12
					else { // NAME_TYPE
						_parts[++c] = name || "null";
					}
				}
				// 13
				else if( type == SHORT_NAME_TYPE ) {
					_parts[++c] = shortName || "null";
				}
				// 14
				else if( type == GMT_OFFSET_TYPE ) {
					++c;
				}
				// 15
				else if( type == PERSON_TYPE ) {
					_parts[++c] = person || "";
				}
				// 16
				else {
					if(person) {
						_parts[++c] = "@";
						_parts[++c] = person;
					} else {
						_parts[++c] = "";
						_parts[++c] = "";
					}
				}
				node = node.next;
			}
			return _parts.join("");
		}
		
		private function replaceFields(field: String, no: int, len: int, intext: String):String {
			field = field.substring(1, field.length-1);
			var value: * = _params;
			if( field != "") {
				var d: String = field;
				var start: int = 0;
				var end: int;
				while( value != null ) {
					end = field.indexOf(".", start);
					if( end == -1 ) {
						d = field.substr(start);
						if( d != "" ) {
							try {
								value = value[d];
							} catch(e: *) {
								value = "["+e+"]";
							}
						} else {
							value = null;
						}
						break;
					} else {
						d = field.substring(start, end);
						start = end+1;
						if( d != "" ) {
							try {
								value = value[d];
							} catch( e: * ) {
								value = "["+e+"]";
								break;
							}
						} else {
							value = null;
							break;
						}
					}
				}
			}
			if( value != null ) {
				return value.toString();
			} else {
				return "null";
			}
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