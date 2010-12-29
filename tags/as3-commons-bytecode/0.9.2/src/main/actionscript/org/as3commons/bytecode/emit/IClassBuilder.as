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
	import flash.events.IEventDispatcher;
	import flash.system.ApplicationDomain;

	[Event(name="extendedClassesNotFound", type="org.as3commons.bytecode.emit.impl.event.ExtendedClassesNotFoundError")]
	/**
	 * Describes an object that can generate a class object to be added to an <code>AbcFile</code> which
	 * enables runtime class generation.
	 * @author Roland Zwaga
	 */
	public interface IClassBuilder extends ITypeBuilder, IEventDispatcher {
		/**
		 * The fully qualified superclass name for the class that will be generated. I.e. <code>mx.events.FlexEvent</code>.
		 */
		function get superClassName():String;

		/**
		 * @private
		 */
		function set superClassName(value:String):void;

		/**
		 * If <code>true</code> the class that will be generated will be marked as dynamic.
		 */
		function get isDynamic():Boolean;

		/**
		 * @private
		 */
		function set isDynamic(value:Boolean):void;

		/**
		 * Marks the generated class as an implementation of the specified fully qualified interface name.
		 * <p>This will NOT automatically add the methods defined in this interface.</p>
		 * @param name The specified fully qualifed interface name. I.e. <code>mx.styles.IStyleClient</code>.
		 */
		function implementInterface(name:String):void;

		/**
		 * Marks the generated class as an implementation of the specified list of fully qualified interface names.
		 * <p>This will NOT automatically add the methods defined in these interfaces.</p>
		 * @param names The specified fully qualifed interface names. I.e. <code>mx.styles.IStyleClient</code>.
		 */
		function implementInterfaces(names:Array):void;

		/**
		 * Creates an <code>ICtorBuilder</code> instance that is able to generate the constructor method for the
		 * class to be generated.
		 * @return The specified <code>ICtorBuilder</code>.
		 */
		function defineConstructor():ICtorBuilder;
		/**
		 * Creates an <code>IPropertyBuilder</code> instance for the specified property name.
		 * @param name The name of the property. I.e. <code>myProperty</code>.
		 * @param type The fully qualified type of the property. I.e. <code>String</code> or <code>flash.utils.Dictionary</code>.
		 * @param initialValue The default value of the property. I.e. "My default value".
		 * @return The specified <code>IPropertyBuilder</code> instance.
		 */
		function defineProperty(name:String = null, type:String = null, initialValue:* = undefined):IPropertyBuilder;

		function removeProperty(name:String, nameSpace:String = null):void;
	}
}