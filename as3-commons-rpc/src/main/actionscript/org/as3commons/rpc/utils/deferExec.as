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
package org.as3commons.rpc.utils {
	/**
	 * Defers method execution to the next frame.
	 *
	 * @author Jan Van Coppenolle
	 */
	public function deferExec(functionReference:Function, ... args):void {
		new DeferredExecution(functionReference, args);
	}
}

import flash.display.Sprite;
import flash.events.Event;
import flash.utils.Dictionary;

internal class DeferredExecution {
	private static const EXECUTIONER:Sprite = new Sprite();
	private static const REFERENCED:Dictionary = new Dictionary();

	public var functionReference:Function;
	public var args:Array;

	public function DeferredExecution(functionReference:Function, args:Array) {
		if (REFERENCED[functionReference]) {
			return;
		}

		this.functionReference = functionReference;
		this.args = args;

		EXECUTIONER.addEventListener(Event.ENTER_FRAME, executionHandler);
		REFERENCED[functionReference] = true;
	}

	public function executionHandler(event:Event):void {
		EXECUTIONER.removeEventListener(Event.ENTER_FRAME, executionHandler);
		delete REFERENCED[functionReference];
		functionReference.apply(null, args);
	}
}
