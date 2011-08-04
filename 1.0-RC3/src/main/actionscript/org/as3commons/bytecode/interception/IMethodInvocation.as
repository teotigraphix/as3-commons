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
package org.as3commons.bytecode.interception {
	import org.as3commons.bytecode.interception.impl.InvocationKind;

	/**
	 * Contains all the necessary information for a method interception.
	 * @author Roland Zwaga
	 */
	public interface IMethodInvocation {
		/**
		 * Determines which kind of invocation was intercepted.
		 */
		function get kind():InvocationKind;
		/**
		 * The instance whose member invocation is being intercepted.
		 */
		function get targetInstance():Object;
		/**
		 * The <code>QName</code> that determines the member invocation being intercepted
		 */
		function get targetMember():QName;
		/**
		 * A reference to the method that is being intercepted. This value is only set when the <code>kind</code> property is set to <code>InvocationKind.METHOD</code>.
		 */
		function get targetMethod():Function;
		/**
		 * An <code>Array</code> of values representing the arguments, if any, for the method that is being intercepted.
		 */
		function get arguments():Array;
		/**
		 * Determines if the original method will be invoked. Set this property to <code>false</code> when the return value
		 * of the intercepted value needs to be changed.
		 */
		function get proceed():Boolean;
		/**
		 * @private
		 */
		function set proceed(value:Boolean):void;
		/**
		 * The return value for the intercepted value.
		 */
		function get returnValue():*;
		/**
		 * @private
		 */
		function set returnValue(value:*):void;
	}
}