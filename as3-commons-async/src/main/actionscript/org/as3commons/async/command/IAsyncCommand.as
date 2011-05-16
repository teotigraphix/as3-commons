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
package org.as3commons.async.command {

	import org.as3commons.async.operation.IOperation;

	/**
	 * Describes an asynchronous command. In contrast to a synchronous command, an asynchronous command is not done
	 * executing directly after a call to the <code>execute()</code> method. Instead, a caller should register to the <code>OperationEvent.COMPLETE</code> or
	 * <code>OperationEvent.ERROR</code> event before calling <code>execute()</code> and handle the events.
	 * @author Christophe Herreman
	 */
	public interface IAsyncCommand extends ICommand, IOperation {

	}
}