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
package org.as3commons.lang {

	/**
	 * Interface that can be implemented by objects that should be orderable, for example in a Collection.
	 * <p>The actual order can be interpreted as prioritization, with the first object (with the lowest order value) having the highest priority.</p>
	 * @author Christophe Herreman
	 */
	public interface IOrdered {

		/**
		 * Return the order value of this object, with a higher value meaning greater in terms of sorting.
		 * <p>Normally starting with 0 or 1. Same order values will result in arbitrary positions for the affected objects.</p>
		 * <p>Higher value can be interpreted as lower priority, consequently the first object has highest priority.</p>
		 * <p>Note that order values below 0 are reserved for framework purposes. Application-specified values should always be 0 or greater, with only framework components (internal or third-party) supposed to use lower values.</p>
		 */
		function get order():int;

		/**
		 * @private
		 */
		function set order(value:int):void;

	}
}
