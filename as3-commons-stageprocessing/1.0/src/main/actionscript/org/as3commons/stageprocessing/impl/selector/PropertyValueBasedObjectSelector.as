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
package org.as3commons.stageprocessing.impl.selector {

	import org.as3commons.lang.StringUtils;
	import org.as3commons.stageprocessing.IObjectSelector;

	/**
	 * <code>IObjectSelector</code> that only approves objects that have a specified
	 * property whose value is not empty.
	 * @author Roland Zwaga
	 */
	public class PropertyValueBasedObjectSelector implements IObjectSelector {

		/**
		 * Creates a new <code>LocalizationObjectSelector</code> instance.
		 */
		public function PropertyValueBasedObjectSelector() {
			super();
		}

		private var _propertyName:String = "id";

		/**
		 * The name of the property whose value will be evaluated by the current <code>LocalizationObjectSelector</code>
		 * @default id
		 */
		public function get propertyName():String {
			return _propertyName;
		}

		/**
		 * @private
		 */
		public function set propertyName(value:String):void {
			_propertyName = value;
		}

		/**
		 * <p>First checks if the specified <code>object</code> has a property with the name specified by the <code>propertyName</code> property,
		 * if so, it approves the object if the value of the specified property is non-empty.</p>
		 * @inheritDoc
		 */
		public function approve(object:Object):Boolean {
			if (object.hasOwnProperty(propertyName)) {
				var value:String = (object[propertyName] as String);
				return StringUtils.hasText(value);
			} else {
				return false;
			}
		}

	}
}
