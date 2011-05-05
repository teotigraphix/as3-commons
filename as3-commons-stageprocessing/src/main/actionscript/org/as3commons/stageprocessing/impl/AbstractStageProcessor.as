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
package org.as3commons.stageprocessing.impl {

	import flash.errors.IllegalOperationError;

	import org.as3commons.lang.IDisposable;
	import org.as3commons.stageprocessing.IObjectSelector;
	import org.as3commons.stageprocessing.IObjectSelectorAware;
	import org.as3commons.stageprocessing.IStageObjectProcessor;

	/**
	 * Abstract base class for <code>IStageProcessor</code> implementations.
	 * @author Roland Zwaga
	 * @sampleref stagewiring
	 * @docref container-documentation.html#the_istageprocessor_interface
	 */
	public class AbstractStageProcessor implements IStageObjectProcessor, IDisposable {

		// --------------------------------------------------------------------
		//
		// Constructor
		//
		// --------------------------------------------------------------------

		/**
		 * Abstract constructor
		 * @throws flash.errors.IllegalOperationError When called directly
		 */
		public function AbstractStageProcessor(self:AbstractStageProcessor) {
			super();
			abstractStageProcessorInit(self);
		}

		protected function abstractStageProcessorInit(self:AbstractStageProcessor):void {
			if (self != this) {
				throw new IllegalOperationError("AbstractStageProcessor is abstract");
			}
		}

		// --------------------------------------------------------------------
		//
		// Public Properties
		//
		// --------------------------------------------------------------------

		// ----------------------------
		// isDisposed
		// ----------------------------

		private var _isDisposed:Boolean = false;

		public function get isDisposed():Boolean {
			return _isDisposed;
		}

		// --------------------------------------------------------------------
		//
		// Public Methods
		//
		// --------------------------------------------------------------------

		/**
		 * @throws flash.errors.IllegalOperationError When called directly
		 * @inheritDoc
		 */
		public function process(object:Object):Object {
			throw new IllegalOperationError("Not implemented in abstract base class");
		}

		public function dispose():void {
			_isDisposed = true;
		}

	}
}