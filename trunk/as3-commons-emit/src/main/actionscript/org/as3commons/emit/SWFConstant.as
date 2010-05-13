/*
 * Copyright 2007-2010 the original author or authors.
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
package org.as3commons.emit {

	public final class SWFConstant {
		public static const PRE_HEADER_SIZE:int = 8; // FWS[VERSION][FILESIZE]
		public static const COMPRESSED_SWF_IDENTIFIER:String = 'C';
		public static const UNCOMPRESSED_SWF_IDENTIFIER:String = 'F';
		public static const ASTERISK:String = '*';
		public static const OBJECT_TYPE_NAME:String = "Object";
		public static const DOUBLE_COLON:String = "::";
		public static const PERIOD:String = ".";
		public static const CONSTRUCTOR_IDENTIFIER:String = "ctor";
		public static const EMPTY_STRING:String = "";
		public static const COLON:String = ':';
		public static const FORWARD_SLASH:String = '/';
		public static const SQUARE_BRACKET_OPEN:String = '[';
		public static const SQUARE_BRACKET_CLOSE:String = ']';
		public static const COMMA:String = ',';
		public static const VOID_IDENTIFIER:String = "void";
		public static const PARAMS_IDENTIFIER:String = "...";
	}
}