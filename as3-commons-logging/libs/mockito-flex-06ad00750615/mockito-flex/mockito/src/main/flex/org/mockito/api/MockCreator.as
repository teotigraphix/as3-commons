/**
 * The MIT License
 *
 * Copyright (c) 2009 Mockito contributors
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy of this software 
 * and associated documentation files (the "Software"), to deal in the Software without restriction, 
 * including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, 
 * and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, 
 * subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, 
 * INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE 
 * AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, 
 * DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE. 
 */
package org.mockito.api
{
    import flash.events.IEventDispatcher;
    
    /**
     * An interface for entities capable of generating mock objects
     */
    public interface MockCreator
    {
        /**
         * Constructs mock object
         * @param clazz a class of the mock object
         * @param name a name used in various output
         * @param constructorArgs constructor arguments required to create mock instance
         * @return a mocked object
         */
        function mock(clazz:Class, name:String=null, constructorArgs:Array=null):*;
        
        /**
         * Prepares given classes for mocking
         * @param classes an array of Class instances that should be prepared for mocking
         * @param calledWhenClassesReady an arugumentless function invoked when (async or not) process of classes generation is over
         * @param calledWhenPreparingClassesFailed an argumentless function invoked when class preparation failed 
         */
        function prepareClasses(classes:Array, calledWhenClassesReady:Function, calledWhenPreparingClassesFailed:Function=null):void;
    }
}