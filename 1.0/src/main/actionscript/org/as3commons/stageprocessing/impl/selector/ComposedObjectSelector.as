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

	import org.as3commons.stageprocessing.IObjectSelector;

	/**
	 * <code>IObjectSelector</code> approving objects if all composing objects are
	 * approving the passed object. It will deny it if there is at least one denying it.
	 *
	 * <p>
	 * Use <code>approveIfUnanimous</code> property to decide whether to "OR" or "AND"
	 * composing object selectors (default is "AND" that is the object will be approved
	 * just if all object selectors approve it).
	 * </p>
	 * @author Martino Piccinato
	 */
	public class ComposedObjectSelector implements IObjectSelector {

		private var _objectSelectors:Array;

		private var _approveIfUnanimous:Boolean;

		/**
		 * Creates a new ComposedObjectSelector.
		 *
		 * @param objectSelectos <code>Array</code> containing all
		 * <code>IObjectSelector</code> that will be iterated to
		 * approve or deny the passed object.
		 * @param approveOnFirst if <code>true</code> it will approve the object on first
		 * approval.
		 */
		public function ComposedObjectSelector(objectSelectors:Array = null, approveIfUnanimous:Boolean = true) {
			super();
			this._objectSelectors = objectSelectors;
			this._approveIfUnanimous = approveIfUnanimous;
		}

		/**
		 *
		 * @inheritDoc
		 *
		 */
		public function approve(object:Object):Boolean {

			if (this._objectSelectors == null)
				return true;

			var objectSelector:IObjectSelector;

			if (this._approveIfUnanimous) { // AND
				for each (objectSelector in this._objectSelectors) {
					if (!objectSelector.approve(object)) {
						return false; // An object selector did not approve the object
					}
				}
				// All object selector approved the object
				return true;

			} else { // OR
				for each (objectSelector in this._objectSelectors) {
					if (objectSelector.approve(object)) {
						return true; // at least on object selector approved the object
					}
				}

				return false; // No object selector approved the object				
			}
		}

		/**
		 * @param objectSelectors <code>Array</code> containing all
		 * <code>IObjectSelector</code> that will be iterated to
		 * approve or deny the passed object.
		 */
		public function set objectSelectors(objectSelectors:Array):void {
			this._objectSelectors = objectSelectors;
		}

		/**
		 * @param value if <code>true</code> it will approve the object just if
		 * all composing <code>IObjectSelector</code> approve it (AND), if
		 * <code>false</code> it will approve the object if at least one approve it (OR).
		 * @default <code>true</code>
		 */
		public function set approveIfUnanimous(value:Boolean):void {
			this._approveIfUnanimous = value;
		}

	}

}
