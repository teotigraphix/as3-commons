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
package org.as3commons.bytecode.emit {
	import flash.system.ApplicationDomain;

	/**
	 * Describes an object capable of creating classes, interfaces and package level variables and methods.
	 * @author Roland Zwaga
	 */
	public interface IPackageBuilder {
		/**
		 * The name of the current package. i.e. <code>com.myclasses.test</code>.
		 */
		function get packageName():String;
		/**
		 * Creates an <code>IClassBuilder</code> instance for the specified class name and super class name.
		 * @param name The name of the new class. I.e. <code>MyGeneratedClass</code>.
		 * @param superClassName The fully qualified super class name. I.e. <code>mx.events.FlexEvent</code>, defaults to <code>Object</code>.
		 * @return The specified <code>IClassBuilder</code> instance.
		 */
		function defineClass(name:String, superClassName:String = null):IClassBuilder;
		/**
		 * Creates an <code>IInterfaceBuilder</code> instance for the specified interface name and super interface name.
		 * @param name The name of the new interface. I.e. <code>IMyGeneratedInterface</code>.
		 * @param superInterfaceName The fully qualified super interface name. I.e. <code>mx.styles.IStyleClient</code>.
		 * @return The specified <code>IInterfaceBuilder</code> instance.
		 */
		function defineInterface(name:String, superInterfaceNames:Array = null):IInterfaceBuilder;
		/**
		 * Creates an <code>IMethodBuilder</code> instance for the specified method name.
		 * @param name The name of the method. I.e. <code>myMethodName</code>.
		 * @return The specified <code>IMethodBuilder</code> instance.
		 */
		function defineMethod(name:String):IMethodBuilder;
		/**
		 * Creates an <code>IPropertyBuilder</code> instance for the specified property name.
		 * @param name The name of the property. I.e. <code>myProperty</code>.
		 * @param type The fully qualified type of the property. I.e. <code>String</code> or <code>flash.utils.Dictionary</code>.
		 * @param initialValue The default value of the property. I.e. "My default value".
		 * @return The specified <code>IPropertyBuilder</code> instance.
		 */
		function defineProperty(name:String = null, type:String = null, initialValue:* = undefined):IPropertyBuilder;
		/**
		 * Internally used build method, this method should never be called by third parties.
		 * @param applicationDomain
		 * @return
		 */
		function build(applicationDomain:ApplicationDomain):Array;
	}
}