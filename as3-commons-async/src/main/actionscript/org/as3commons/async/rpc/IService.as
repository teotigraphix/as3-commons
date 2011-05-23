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
package org.springextensions.actionscript.rpc {

	import org.springextensions.actionscript.core.operation.IOperation;

	/**
	 * Defines a service that invokes asynchronous operation on (remote) objects.
	 * @author Christophe Herreman
	 * @docref the_operation_api.html#services
	 */
	public interface IService {

		/**
		 * Invokes a method with the given method name and parameters on a (remote) object.
		 *
		 * @param methodName the name of the method to invoke
		 * @param parameters the paramters passed to the invoked method
		 * @return an operation for the invoked method
		 */
		function call(methodName:String, ... parameters):IOperation;

	}

}