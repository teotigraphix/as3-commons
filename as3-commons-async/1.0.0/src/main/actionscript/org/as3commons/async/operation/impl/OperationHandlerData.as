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
package org.as3commons.async.operation.impl {

	[ExcludeClass]
	/**
	 * Internal data structure used by the <code>OperationHandler</code> class.
	 * @author Roland Zwaga
	 */
	internal class OperationHandlerData {

		private var _resultPropertyName:String;
		private var _resultTargetObject:Object;


		public function get errorMethod():Function {
			return _errorMethod;
		}

		public function get resultPropertyName():String {
			return _resultPropertyName;
		}

		public function get resultTargetObject():Object {
			return _resultTargetObject;
		}

		public function get resultMethod():Function {
			return _resultMethod;
		}

		private var _resultMethod:Function;
		private var _errorMethod:Function;

		/**
		 * Creates a new <code>OperationHandlerData</code> instance.
		 * @param resultPropertyName
		 * @param resultTargetObject
		 * @param resultMethod
		 * @param errorMethod
		 */
		public function OperationHandlerData(resultPropertyName:String=null, resultTargetObject:Object=null, resultMethod:Function=null, errorMethod:Function=null) {
			super();
			initOperationHandler(resultPropertyName, resultTargetObject, resultMethod, errorMethod);
		}

		protected function initOperationHandler(resultPropertyName:String, resultTargetObject:Object, resultMethod:Function, errorMethod:Function):void {
			_resultPropertyName = resultPropertyName;
			_resultTargetObject = resultTargetObject;
			_resultMethod = resultMethod;
			_errorMethod = errorMethod;
		}


	}
}
