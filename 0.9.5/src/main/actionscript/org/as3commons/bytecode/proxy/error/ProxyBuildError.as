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
package org.as3commons.bytecode.proxy.error {
	import flash.utils.Dictionary;

	import org.as3commons.lang.StringUtils;

	/**
	 * Thrown when certain errors are encountered during proxy generation.
	 * @author Roland Zwaga
	 */
	public class ProxyBuildError extends Error {

		/**
		 * Thrown when a class that is marked as final is trying to be proxied.
		 */
		public static const FINAL_CLASS_ERROR:uint = 0x01;
		/**
		 * Thrown when a method that is marked as final is trying to be proxied.
		 */
		public static const FINAL_METHOD_ERROR:uint = 0x02;
		/**
		 * Thrown when an accessor that is marked as final is trying to be proxied.
		 */
		public static const FINAL_ACCESSOR_ERROR:uint = 0x03;
		/**
		 * Thrown when a non-existent method is trying to be proxied.
		 */
		public static const METHOD_NOT_EXISTS:uint = 0x04;
		/**
		 * Thrown when a non-existent accessor is trying to be proxied.
		 */
		public static const ACCESSOR_NOT_EXISTS:uint = 0x05;
		/**
		 * Thrown when the <code>ProxyFactoryBuildEvent.methodBuilder</code> property has been set to null in an event handler.
		 */
		public static const METHOD_BUILDER_IS_NULL:uint = 0x06;

		public static const INTRODUCED_CLASS_NOT_FOUND:uint = 0x07;

		private static const messages:Dictionary = new Dictionary();
		{
			messages[FINAL_CLASS_ERROR] = "Proxied class {0} is marked as final, cannot create a subclass";
			messages[FINAL_METHOD_ERROR] = "Method {0} is marked as final, cannot override in the subclass";
			messages[FINAL_ACCESSOR_ERROR] = "Accessor {0} is marked as final, cannot override in the subclass";
			messages[METHOD_NOT_EXISTS] = "Method {1} was not found on proxied class {0}";
			messages[ACCESSOR_NOT_EXISTS] = "Accessor {1} was not found on proxied class {0}";
			messages[METHOD_BUILDER_IS_NULL] = "IMethodBuilder returned by the {0}.methodBuilder instance was null";
			messages[INTRODUCED_CLASS_NOT_FOUND] = "Class {0} could not be found by ByteCodeType.forName(), unable to introduce";
		}

		/**
		 * Creates a new <code>ProxyBuildError</code> instance.
		 * @param id
		 * @param className
		 * @param memberName
		 */
		public function ProxyBuildError(id:uint, className:String = "", memberName:String = null) {
			var message:String;
			if (memberName == null) {
				message = StringUtils.substitute(String(messages[id]), className);
			} else {
				message = StringUtils.substitute(String(messages[id]), className, memberName);
			}
			super(message, id);
		}
	}
}