/*
 * Copyright (c) 2007-2009-2010 the original author or authors
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
package org.as3commons.reflect {

/**
 * Provides information of a parameter passed to a method.
 *
 * @author Christophe Herreman
 * @author Andrew Lewisohn
 */
public class Parameter {

	// -------------------------------------------------------------------------
	//
	//  Constructor
	//
	// -------------------------------------------------------------------------
	
	/**
	 * Creates a new <code>Parameter</code> object.
	 *
	 * @param index the index of the parameter
	 * @param type the class type of the parameter
	 * @param isOptional whether the parameter is optional or not
	 */
	public function Parameter(index:int, type:Type, isOptional:Boolean = false) {
		_index = index;
		_type = type;
		_isOptional = isOptional;
	}
	
	// -------------------------------------------------------------------------
	//
	//  Properties
	//
	// -------------------------------------------------------------------------
	
	// ----------------------------
	// index
	// ----------------------------
	
	private var _index:int;
	
	public function get index():int {
		return _index;
	}
	
	// ----------------------------
	// isOptional
	// ----------------------------
	
	private var _isOptional:Boolean;
	
	public function get isOptional():Boolean {
		return _isOptional;
	}
	
	// ----------------------------
	// type
	// ----------------------------
	
	private var _type:Type;
	
	public function get type():Type {
		return _type;
	}
	
	// -------------------------------------------------------------------------
	//
	//  Methods: AS3Commons Reflect Internal Use
	//
	// -------------------------------------------------------------------------
	
	as3commons_reflect function setIndex(value:int):void {
		_index = value;
	}
	
	as3commons_reflect function setIsOptional(value:Boolean):void {
		_isOptional = value;
	}
	
	as3commons_reflect function setType(value:Type):void {
		_type = value;
	}
}
}
