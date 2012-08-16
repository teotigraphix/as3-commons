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
package org.as3commons.reflect {

	import flash.system.ApplicationDomain;

	public class AbstractTypeProvider implements ITypeProvider {

		public function AbstractTypeProvider() {
			super();
			typeCache ||= new TypeCache();
		}

		protected var typeCache:TypeCache;

		public function getTypeCache():TypeCache {
			return typeCache;
		}

		public function clearCache():void {
			typeCache.clear();
		}

		public function getType(cls:Class, applicationDomain:ApplicationDomain):Type {
			throw new Error("Not implemented in abstract base class");
		}

	}
}
