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
package org.as3commons.async.command.impl {
	import flash.events.Event;
	import flash.system.ApplicationDomain;
	import flash.system.SecurityDomain;

	import mx.core.IFlexModuleFactory;

	import org.as3commons.async.command.CompositeCommandKind;
	import org.as3commons.async.command.IApplicationBootstrapper;
	import org.as3commons.async.command.ICommand;
	import org.as3commons.async.command.event.CompositeCommandEvent;
	import org.as3commons.async.operation.impl.LoadModuleOperation;
	import org.as3commons.async.operation.impl.LoadResourceModuleOperation;
	import org.as3commons.async.operation.impl.LoadStyleModuleOperation;

	[Event(name="complete", type="flash.events.Event")]
	/**
	 * Default implementation for the <code>IApplicationBootstrapper</code> interface.
	 * @author Roland Zwaga
	 */
	public class DefaultApplicationBootstrapper extends CompositeCommand implements IApplicationBootstrapper {

		/**
		 * Creates a new <code>DefaultApplicationBootstrapper</code> instance.
		 */
		public function DefaultApplicationBootstrapper() {
			super(CompositeCommandKind.SEQUENCE);
		}

		private var _moduleCommands:Vector.<GenericOperationCommand>;
		private var _resourceBundleCommands:Vector.<GenericOperationCommand>;
		private var _resourceModuleCommands:Vector.<GenericOperationCommand>;
		private var _styleModuleCommands:Vector.<GenericOperationCommand>;

		public function addModule(moduleURL:String, applicationDomain:ApplicationDomain=null, securityDomain:SecurityDomain=null):IApplicationBootstrapper {
			(_moduleCommands ||= Vector.<GenericOperationCommand>())[_moduleCommands.length] = new GenericOperationCommand(LoadModuleOperation, moduleURL, applicationDomain, securityDomain);
			return this;
		}

		public function addResourceBundle(url:String, name:String, locale:String):IApplicationBootstrapper {
			(_resourceBundleCommands ||= Vector.<GenericOperationCommand>())[_resourceBundleCommands.length] = new GenericOperationCommand(LoadModuleOperation, url, name, locale);
			return this;
		}

		public function addResourceModule(resourceModuleURL:String, update:Boolean=true, applicationDomain:ApplicationDomain=null, securityDomain:SecurityDomain=null):IApplicationBootstrapper {
			(_resourceModuleCommands ||= Vector.<GenericOperationCommand>())[_resourceModuleCommands.length] = new GenericOperationCommand(LoadResourceModuleOperation, resourceModuleURL, update, applicationDomain, securityDomain);
			return this;
		}

		public function addStyleModule(styleModuleURL:String, update:Boolean=true, applicationDomain:ApplicationDomain=null, securityDomain:SecurityDomain=null, flexModuleFactory:IFlexModuleFactory=null):IApplicationBootstrapper {
			(_styleModuleCommands ||= Vector.<GenericOperationCommand>())[_styleModuleCommands.length] = new GenericOperationCommand(LoadStyleModuleOperation, styleModuleURL, update, applicationDomain, securityDomain, flexModuleFactory);
			return this;
		}

		public function load():void {
			addCommands(_resourceBundleCommands);
			addCommands(_resourceModuleCommands);
			addCommands(_styleModuleCommands);
			addCommands(_moduleCommands);
			this.addEventListener(CompositeCommandEvent.COMPLETE, onCompositeCommandComplete);
			load();
		}

		private function onCompositeCommandComplete(event:CompositeCommandEvent):void {
			this.removeEventListener(CompositeCommandEvent.COMPLETE, onCompositeCommandComplete);
			dispatchEvent(new Event(Event.COMPLETE));
		}

		private function addCommands(commands:Vector.<GenericOperationCommand>):void {
			for each (var command:ICommand in commands) {
				addCommand(command);
			}
		}

	}
}
