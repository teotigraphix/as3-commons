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
package org.as3commons.async.test {
	import org.as3commons.async.command.CompositeCommandKindTest;
	import org.as3commons.async.command.CompositeCommandTest;
	import org.as3commons.async.command.GenericOperationCommandTest;
	import org.as3commons.async.operation.OperationHandlerTest;
	import org.as3commons.async.operation.OperationQueueTest;
	import org.as3commons.async.task.command.FunctionCommandTest;
	import org.as3commons.async.task.command.FunctionProxyCommandTest;
	import org.as3commons.async.task.command.PauseCommandTest;
	import org.as3commons.async.task.command.TaskCommandTest;

	[Suite]
	[RunWith("org.flexunit.runners.Suite")]
	public class AsyncTestSuite {
		/*public var t1:CompositeCommandTest;
		public var t2:CompositeCommandKindTest;
		public var t3:GenericOperationCommandTest;
		public var t4:OperationHandlerTest;
		public var t5:OperationQueueTest;
		public var t6:FunctionCommandTest;
		public var t7:FunctionProxyCommandTest;
		public var t8:PauseCommandTest;*/
		public var t9:TaskCommandTest;
	}
}
