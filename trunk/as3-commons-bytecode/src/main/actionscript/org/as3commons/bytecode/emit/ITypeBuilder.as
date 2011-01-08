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
package org.as3commons.bytecode.emit {
	import flash.system.ApplicationDomain;

	public interface ITypeBuilder extends IEmitObject, IMetadataContainer {

		/**
		 * If <code>true</code> the class that will be generated will be marked as final.
		 */
		function get isFinal():Boolean;

		/**
		 * @private
		 */
		function set isFinal(value:Boolean):void;

		/**
		 * If <code>true</code> the class that will be generated will be marked as internal.
		 * @default false
		 */
		function get isInternal():Boolean;

		/**
		 * @private
		 */
		function set isInternal(value:Boolean):void;
		/**
		 * Creates an <code>IMethodBuilder</code> instance for the specified method name.
		 * @param name The name of the method. I.e. <code>myMethodName</code>.
		 * @return The specified <code>IMethodBuilder</code> instance.
		 */
		function defineMethod(name:String = null, nameSpace:String = null):IMethodBuilder;
		/**
		 * Creates an <code>IAccessorBuilder</code> (getter/setter) instance for the specified accessor name.
		 * @param name The name of the accessor. I.e. <code>MyGetter</code>.
		 * @param type The fully qualified type of the property. I.e. <code>String</code> or <code>flash.utils.Dictionary</code>.
		 * @param initialValue The default value of the property. I.e. "My default value".
		 * @return The specified <code>IAccessorBuilder</code> instance.
		 */
		function defineAccessor(name:String = null, type:String = null, initialValue:* = undefined):IAccessorBuilder;

		function removeMethod(name:String, nameSpace:String = null):void;

		function removeAccessor(name:String, nameSpace:String = null):void;

		/**
		 * Internally used build method, this method should never be called by third parties.
		 * @param applicationDomain
		 * @return
		 */
		function build(applicationDomain:ApplicationDomain):Array;

	}
}