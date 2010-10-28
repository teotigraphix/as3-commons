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
	import org.as3commons.bytecode.abc.MethodInfo;
	import org.as3commons.reflect.AccessorAccess;

	/**
	 * Describes an object that can generate an accessor (getter/setter) method for a generated class.
	 * @author Roland Zwaga
	 */
	public interface IAccessorBuilder extends IPropertyBuilder {

		/**
		 * Determines the access to the generated accessor, or, in other words whether
		 * it will generate a getter, a setter, or both.
		 */
		function get access():AccessorAccess;
		/**
		 * @private
		 */
		function set access(value:AccessorAccess):void;

		/**
		 * Determines the property that is exposed by the generated accessor.
		 * <p>When not explicitly set, this will default to a private member with the same
		 * type as the accessor.</p>
		 */
		function get property():IPropertyBuilder;
		/**
		 * @private
		 */
		function set property(value:IPropertyBuilder):void;

	}
}