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
package org.as3commons.bytecode.emit {
	import flash.events.IEventDispatcher;
	import flash.system.ApplicationDomain;

	import org.as3commons.bytecode.abc.AbcFile;

	/**
	 * Dispatched when the class loader has finished loading the SWF/ABC bytecode in the Flash Player/AVM.
	 */
	[Event(name="complete", type="flash.events.Event")]
	/**
	 * Dispatched when the class loader has encountered an IO related error.
	 */
	[Event(name="ioError", type="flash.events.IOErrorEvent")]
	/**
	 * Dispatched when the class loader has encountered a SWF verification error.
	 */
	[Event(name="verifyError", type="flash.events.IOErrorEvent")]
	public interface IAbcBuilder extends IEventDispatcher {
		/**
		 *
		 * @param name
		 * @return
		 *
		 */
		function definePackage(name:String):IPackageBuilder;
		function build(applicationDomain:ApplicationDomain = null):AbcFile;
		function buildAndLoad(applicationDomain:ApplicationDomain = null, newApplicationDomain:ApplicationDomain = null):AbcFile;
	}
}