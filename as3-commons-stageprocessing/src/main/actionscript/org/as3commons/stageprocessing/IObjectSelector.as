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
package org.as3commons.stageprocessing {

	/**
	 * Objects implementing this interface are used to approve (or deny)
	 * the selection of an object for some action/purpose.
	 *
	 * <p>
	 * <b>Author:</b> Martino Piccinato<br/>
	 * <b>Version:</b> $Revision:$, $Date:$, $Author:$<br/>
	 * <b>Since:</b> 0.8
	 * </p>
	 *
	 * @see org.springextensions.actionscript.context.support.FlexXMLApplicationContext
	 * @docref container-documentation.html#how_to_determine_which_stage_components_are_eligeble_for_configuration
	 * @sampleref stagewiring
	 */
	public interface IObjectSelector {

		/**
		 * @param object The object to be approved (or not) for selection.
		 *
		 * @return <code>true</code> if the object is selected, <code>false</code>
		 * otherwise.
		 */
		function approve(object:Object):Boolean;

	}
}