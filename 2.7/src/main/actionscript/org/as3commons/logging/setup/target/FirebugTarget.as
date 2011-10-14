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
	import org.as3commons.logging.api.ILogger;
	import org.as3commons.logging.api.getLogger;
	import org.as3commons.logging.util.objectify;
	import org.as3commons.logging.level.DEBUG;
	import org.as3commons.logging.level.INFO;
	import org.as3commons.logging.level.WARN;
	import org.as3commons.logging.util.LogMessageFormatter;
	
	import flash.external.ExternalInterface;
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;
	
	/**
	 * <code>FirebugTarget</code> sends the output to the Firebug console. Also
	 * works with Google Chrome and others.
	 * 
	 * <p>The <code>FirebugTarget</code> will send a warning to the logging system in case
	 * logging to a console is not available.</p>
	 * 
	 * @see http://getfirebug.com/
	 * @author Martin Heidegger
	 * @version 1.5
	 * @since 2.5
	 */
	public final class FirebugTarget implements IFormattingLogTarget {
		
		/** Default format used if non is passed in */
		public static const DEFAULT_FORMAT: String = "{time} {shortName}{atPerson} {message}";
		
		/** Logger used to notify if Firebug doesn't work */
		private static const LOGGER: ILogger = getLogger(FirebugTarget);
		
		/** True if the external interface was inited */
		private static var _inited: Boolean = false;
		
		/** True if the console is available */
		private static var _available: Boolean = true;
		
		/**
		 * Inits the External Interface
		 */
		private static function init(): void {
			_inited = true;
			if( _available = ExternalInterface.available ) {
				try {
					if( !ExternalInterface.call('function(){ return console ? true : false; }') ) {
						LOGGER.warn("No native console found in this browser.");
						_available = false;
					}
				} catch( e:Error ) {
					LOGGER.warn("Could not setup FirebugTarget, exception while setup {0}", [e]);
					_available = false;
				}
			} else {
				LOGGER.warn("Could not setup FirebugTarget, because ExternalInterface wasn't available");
			}
		}
		
		/** Formatter used to format the message */
		private var _formatter: LogMessageFormatter;
		
		/** Regular expression used to transform the value */
		private static const PARAMS: RegExp = /{([0-9]+)}/g;
		
		/** Depth of the introspection for objects */
		private var _depth: uint = 5;
		
		/**
		 * Parametes to be used for the regexp replacing
		 */
		private var _newParams: Array;
		private var _params: Array;
		private var _types: Dictionary;
		
		/**
		 * Creates new <code>FirebugTarget</code>
		 * 
		 * @param format Format to be used 
		 */
		public function FirebugTarget( format:String=null ) {
			this.format = format;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set format( format:String ): void {
			_formatter = new LogMessageFormatter( format||DEFAULT_FORMAT );
		}
		
		/**
		 * Maximum depth of introspection for objects to be rendered (default=5)
		 */
		public function set depth( depth:uint ): void {
			_depth = depth;
		}
		
		public function get depth():uint {
			return _depth;
		}
		
		/**
		 * @inheritDoc
		 */
		public function log(name:String, shortName:String, level:int,
							timeStamp:Number, message:*, params:Array,
							person:String):void {
			if( !_inited ) {
				init();
			}
			if( _available ) {
				// Select the matching method
				var method: String;
				if( level == DEBUG ) method = "debug";
				else if( level == WARN ) method = "warn";
				else if( level == INFO ) method = "info";
				else method = "error";
				
				if( message is Function || message is Class ) {
					message = getQualifiedClassName( message );
				}
				if( message is String ) {
					// Modify the input to pass it properly to firefox
					//   
					//   as3commons pattern:  "some text {0} other text {1} and {0}", a, b
					//   firebug pattern: "some text %o other text %o and %o", a, b, a
					//   
					_newParams = [];
					_params = params;
					message = String( message ).replace( PARAMS, replaceMessageEntries );
					params = _newParams;
					_types = null;
					_newParams = null;
				} else if( message is uint || message is int ) {
					// Other objects need to get a formatting string.
					params = [message];
					message = "%i";
				} else if( message is Number ) {
					params = [message];
					message = "%f";
				} else {
					try {
						params = [objectify( message, new Dictionary(), _depth )];
					} catch( e: Error ) {
						params = [objectify( e )];
					}
					message = "%o";
				}
				params.unshift(
					_formatter.format( name, shortName, level, timeStamp, message, null, person ).split("\\").join("\\\\")
				);
				params.unshift( "console." + method );
				
				try {
					// Send it out!
					ExternalInterface.call.apply( ExternalInterface, params );
				} catch( e: Error ) {}
			}
		}
		
		/**
		 * Replaces the messages in the string and fills the new Array with the necessary
		 * new parameters.
		 */
		private function replaceMessageEntries( ...rest: Array):String {
			var result: String = "?";
			if( rest.length >= 2 ){
				var no: int = parseInt( rest[1] );
				var value: * = _params[no];
				if( value is uint ) {
					result = "%i";
				} else if( value is Number ) {
					result = "%f";
				} else if( value is String ) {
					result = "%s";
					value = String( value ).split("\\").join("\\\\");
				} else if( value is Object ) {
					result = "%o";
					try {
						value = objectify( value, _types || (_types = new Dictionary()), _depth );
					} catch( e: Error ) {
						value = objectify( e );
					}
				}
				// use question marks for null values
				if( result != "?" ) {
					_newParams[ _newParams.length ] = value;
				}
			}
			return result;
		}
	}
}