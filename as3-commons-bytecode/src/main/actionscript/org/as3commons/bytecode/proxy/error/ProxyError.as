/*
* Copyright 2007-2010 the original author or authors.
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
package org.as3commons.bytecode.proxy.error {
	import flash.utils.Dictionary;

	import org.as3commons.lang.StringUtils;

	public class ProxyError extends Error {

		public static const FINAL_CLASS_ERROR:uint = 0x01;
		public static const FINAL_METHOD_ERROR:uint = 0x02;
		public static const FINAL_ACCESSOR_ERROR:uint = 0x03;

		private static const messages:Dictionary = new Dictionary();
		{
			messages[FINAL_CLASS_ERROR] = "Proxied class {0} is marked as final, cannot create a subclass";
			messages[FINAL_METHOD_ERROR] = "Method {0} is marked as final, cannot override in the subclass";
			messages[FINAL_ACCESSOR_ERROR] = "Accessor {0} is marked as final, cannot override in the subclass";
		}

		public function ProxyError(id:uint, className:String = "") {
			var message:String = StringUtils.substitute(String(messages[id]), className);
			super(message, id);
		}
	}
}