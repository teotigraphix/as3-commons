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
package org.as3commons.bytecode.emit.impl.event {
	import flash.events.Event;
	import flash.system.ApplicationDomain;

	public class ExtendedClassesNotFoundError extends Event {

		public static const EXTENDED_CLASSES_NOT_FOUND:String = "extendedClassesNotFound";

		private var _className:String;
		private var _applicationDomain:ApplicationDomain;

		public function get applicationDomain():ApplicationDomain {
			return _applicationDomain;
		}

		public function get className():String {
			return _className;
		}

		public var extendedClasses:Array = [];

		public function ExtendedClassesNotFoundError(className:String, applicationDomain:ApplicationDomain, bubbles:Boolean = false, cancelable:Boolean = false) {
			super(EXTENDED_CLASSES_NOT_FOUND, bubbles, cancelable);
			_className = className;
			_applicationDomain = applicationDomain;
		}

		override public function clone():Event {
			return new ExtendedClassesNotFoundError(_className, _applicationDomain, bubbles, cancelable);
		}

	}
}