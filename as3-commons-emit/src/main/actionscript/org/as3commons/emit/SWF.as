/*
* Copyright 2009-2010 the original author or authors.
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
public class SWF {
	
	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Constructor.
	 * 
	 * @param header an instance of <code>SWFHeader</code>
	 * @param tags an array of ABC tags
	 */
	public function SWF(header:SWFHeader, tags:Array) {
		_header = header;
		_tags = tags;
	}
	
	//--------------------------------------------------------------------------
	//
	//  Properties
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	//  header
	//----------------------------------
	
	private var _header:SWFHeader;
	
	public function get header():SWFHeader {
		return _header;
	}
	
	//----------------------------------
	//  tags
	//----------------------------------
	
	private var _tags:Array;
	
	public function get tags():Array {
		return _tags;
	}
}
}