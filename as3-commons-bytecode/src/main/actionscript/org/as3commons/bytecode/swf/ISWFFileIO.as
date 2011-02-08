/*
* Copyright 2007-2011 the original author or authors.
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
package org.as3commons.bytecode.swf {
	import flash.utils.ByteArray;

	/**
	 *
	 * @author Roland Zwaga
	 */
	public interface ISWFFileIO {

		/**
		 * Reads a <code>SWFFile</code> instance from the specified <code>ByteArray</code>.
		 * @param input The specified <code>ByteArray</code>.
		 * @param isLoaderBytes True if the specified <code>ByteArray</code> is the bytes property from a <code>LoaderInfo</code> instance.
		 * @return A new <code>SWFFile</code> instance.
		 */
		function read(input:ByteArray, isLoaderBytes:Boolean = false):SWFFile;

		/**
		 *
		 * @param output
		 * @param swf
		 */
		function write(output:ByteArray, swf:SWFFile):void;

	}
}