/**
 * Copyright 2011 The original author or authors.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package org.as3commons.eventbus.impl.collection {
	import flash.utils.Dictionary;

	import org.as3commons.collections.framework.core.LinkedNode;

	public final class WeakLinkedNode extends LinkedNode {

		private var _useWeakReference:Boolean = false;

		override public function get item():* {
			if (!_useWeakReference) {
				return super.item;
			} else {
				for (var it:* in super.item) {
					return it;
				}
			}
		}

		public function WeakLinkedNode(theItem:*, useWeakReference:Boolean = false) {
			_useWeakReference = useWeakReference;
			if (useWeakReference) {
				var value:* = theItem;
				theItem = new Dictionary(true);
				theItem[value] = true;
			}
			super(theItem);
		}

	}
}