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
package org.as3commons.configuration.factory {
	import flash.utils.ByteArray;
	
	import org.as3commons.configuration.IConfiguration;

	/**
	 *
	 * @author Roland Zwaga
	 */
	public interface IConfigurationFactory {
		function get lines():Array;
		function get numLines():int;
		function get originalString():String;

		function fromByteArray(input:ByteArray):IConfiguration;
		function fromString(input:String):IConfiguration;
		function getLine(line:int):String;
	}
}
