/*
* Copyright 2007-2012 the original author or authors.
*
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
*      http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
*/
package org.as3commons.configuration.factory.impl {

	import flash.utils.ByteArray;
	
	import org.as3commons.configuration.IConfiguration;
	import org.as3commons.configuration.impl.Configuration;
	import org.as3commons.configuration.factory.IConfigurationFactory;

	/**
	 *
	 * @author Roland Zwaga
	 */
	public class PropertiesConfigurationFactory implements IConfigurationFactory {

		/** Character code for the WINDOWS line break. */
		public static const WIN_BREAK:String = String.fromCharCode(13) + String.fromCharCode(10);
		/** Character code for the APPLE line break. */
		public static const MAC_BREAK:String = String.fromCharCode(13);
		/** Character used internally for line breaks. */
		public static const NEWLINE_CHAR:String = "\n";
		
		/** Original content without standardized line breaks. */
		private var _original:String;
		
		/** Separation of all lines for the string. */
		private var _lines:Array;

		/**
		 * Creates a new <code>SettingsReader</code> instance.
		 */
		public function PropertiesConfigurationFactory() {
			super();
		}

		/**
		 * Returns the original used string (without line break standardisation).
		 *
		 * @return the original used string
		 */
		public function get originalString():String {
			return _original;
		}
		
		/**
		 * Returns a specific line within the <code>MultilineString</code>.
		 *
		 * <p>It will return <code>undefined</code> if the line does not exist.</p>
		 *
		 * <p>The line does not contain the line break.</p>
		 *
		 * <p>The counting of lines startes with <code>0</code>.</p>
		 *
		 * @param line number of the line to get the content of
		 * @return content of the line
		 */
		public function getLine(line:int):String {
			return _lines[line];
		}
		
		/**
		 * Returns the content as array that contains each line.
		 *
		 * @return content split into lines
		 */
		public function get lines():Array {
			return _lines.concat();
		}
		
		/**
		 * Returns the amount of lines in the content.
		 *
		 * @return amount of lines within the content
		 */
		public function get numLines():int {
			return _lines.length;
		}

		public function fromString(input:String):IConfiguration {
			var manager:IConfiguration = createSettingsManager();
			readLines(input, manager);
			return manager;
		}
		
		private function createSettingsManager():IConfiguration {
			var manager:IConfiguration = new Configuration();
			return manager;
		}
		
		public function fromByteArray(input:ByteArray):IConfiguration {
			var originalPosition:int = input.position;
			var manager:IConfiguration;
			try {
				input.position = 0;
				manager = fromString(input.readUTFBytes(input.length));
			} finally {
				input.position = originalPosition;
			}
			return manager;
		}
		
		private function readLines(fileContent:String, manager:IConfiguration):Array {
			_original = fileContent;
			_lines = fileContent.split(WIN_BREAK).join(NEWLINE_CHAR).split(MAC_BREAK).join(NEWLINE_CHAR).split(NEWLINE_CHAR);
			return _lines;
		}

		private function parse(manager:IConfiguration):void {
			for each (var line:String in _lines) {
				if (line.substr(0, 2) != '//' && line.substr(0, 1) != '#') {
					var parts:Array = line.split('=');
					if (parts.length > 1) {
						manager.setProperty(parts[0], parts[1]);
					}
				}
			}

		}
	}
}
