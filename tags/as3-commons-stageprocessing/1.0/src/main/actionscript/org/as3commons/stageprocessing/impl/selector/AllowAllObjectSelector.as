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
	 * <code>IObjectSelector</code> implementation that returns <code>true</code> for every instance that is passed into its <code>approve()</code> method.
	 * @author Roland Zwaga
	 */
	public class AllowAllObjectSelector implements IObjectSelector {

		/**
		 * Creates a new <code>AllowAllObjectSelector</code> instance.
		 */
		public function AllowAllObjectSelector() {
			super();
		}

		/**
		 * Always returns <code>true</code>.
		 * @param object This parameter is completely ignored.
		 * @return <code>true</code>
		 */
		public function approve(object:Object):Boolean {
			return true;
		}
	}
}
