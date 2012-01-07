/*
* Copyright 2007-2012 the original author or authors.
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
package org.as3commons.async.command {
	import flash.events.IEventDispatcher;
	import flash.system.ApplicationDomain;
	import flash.system.SecurityDomain;

	import mx.core.IFlexModuleFactory;

	[Event(name="complete", type="flash.events.Event")]
	/**
	 * Describes an object that can load resources, styles and modules as part of the bootstrap logic of an application.
	 * @author Roland Zwaga
	 */
	public interface IApplicationBootstrapper extends IEventDispatcher {
		/**
		 *
		 * @param url
		 * @param name
		 * @param locale
		 * @return
		 */
		function addResourceBundle(url:String, name:String, locale:String):IApplicationBootstrapper;
		/**
		 *
		 * @param resourceModuleURL
		 * @param update
		 * @param applicationDomain
		 * @param securityDomain
		 * @return
		 */
		function addResourceModule(resourceModuleURL:String, update:Boolean=true, applicationDomain:ApplicationDomain=null, securityDomain:SecurityDomain=null):IApplicationBootstrapper;
		/**
		 *
		 * @param moduleURL
		 * @param applicationDomain
		 * @param securityDomain
		 * @return
		 */
		function addModule(moduleURL:String, applicationDomain:ApplicationDomain=null, securityDomain:SecurityDomain=null):IApplicationBootstrapper;
		/**
		 *
		 * @param styleModuleURL
		 * @param update
		 * @param applicationDomain
		 * @param securityDomain
		 * @param flexModuleFactory
		 * @return
		 */
		function addStyleModule(styleModuleURL:String, update:Boolean=true, applicationDomain:ApplicationDomain=null, securityDomain:SecurityDomain=null, flexModuleFactory:IFlexModuleFactory=null):IApplicationBootstrapper;
		/**
		 *
		 */
		function load():void;
	}
}
