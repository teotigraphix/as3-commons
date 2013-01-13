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
package org.as3commons.eventbus {
	import org.as3commons.reflect.MethodInvoker;

	public interface IEventListenerInterceptor extends IEventBusAware {
		function get blockListener():Boolean;
		function set blockListener(value:Boolean):void;
		function interceptListener(listener:Function, eventType:String=null, eventClass:Class=null, topic:Object=null):void;
		function interceptListenerProxy(proxy:MethodInvoker, eventType:String=null, eventClass:Class=null, topic:Object=null):void;
	}
}
