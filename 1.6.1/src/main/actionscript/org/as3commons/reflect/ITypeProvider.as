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
import flash.system.ApplicationDomain;

/**
 * The ITypeProvider interface defines the methods that must be implemented
 * by any class that will generate instances of <code>Type</code> or one of
 * its subclasses.
 *  
 * @author Andrew Lewisohn
 * 
 * @see Type
 */
public interface ITypeProvider {
	
	//--------------------------------------------------------------------------
	//
	//  Methods
	//
	//--------------------------------------------------------------------------

	/**
	 * Remove all <code>Type</code>s from the type cache.
	 */
	function clearCache():void;
	
	/**
	 * Returns a <code>Type</code> object that describes the given class.
	 *
	 * @param cls the class from which to get a type description
	 * @param applicationDomain The <code>ApplicationDomain</code> in which to 
	 * 	look for the class definition.
	 */
	function getType(cls:Class, applicationDomain:ApplicationDomain):Type;
	
	/**
	 * Retrieve a reference to the type cache.
	 * 
	 * @return The instance of <code>TypeCache</code> being used by the 
	 * 	<code>ITypeProvider</code>.
	 */
	function getTypeCache():TypeCache;
}
}