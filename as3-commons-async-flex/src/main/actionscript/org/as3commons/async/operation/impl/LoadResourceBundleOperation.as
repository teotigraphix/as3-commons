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
package org.as3commons.async.operation.impl {

	import mx.resources.IResourceBundle;
	import mx.resources.ResourceBundle;
	import mx.resources.ResourceManager;

	import org.as3commons.async.operation.IOperation;
	import org.as3commons.async.operation.event.OperationEvent;
	import org.as3commons.lang.Assert;
	import org.as3commons.lang.StringUtils;
	import org.as3commons.logging.api.ILogger;
	import org.as3commons.logging.api.getClassLogger;

	/**
	 * Asynchronous operation that loads a properties file with key/value pairs of a resource bundle and
	 * registers a new ResourceBundle in the ResourceManager.
	 *
	 * @author Christophe Herreman
	 */
	public class LoadResourceBundleOperation extends AbstractOperation {

		private static var logger:ILogger = getClassLogger(LoadResourceBundleOperation);

		private var _url:String;
		private var _name:String;
		private var _locale:String;
		private var _loadOperation:IOperation;

		// --------------------------------------------------------------------
		//
		// Constructor
		//
		// --------------------------------------------------------------------

		/**
		 * Creates a new <code>LoadResourceBundleOperation</code> instance.
		 */
		public function LoadResourceBundleOperation(url:String, name:String, locale:String) {
			Assert.hasText(url, "The 'url' argument must not be null");
			Assert.hasText(name, "The 'name' argument must not be null");
			Assert.hasText(locale, "The 'locale' argument must not be null");

			_url = url;
			_name = name;
			_locale = locale;

			load();
		}

		// --------------------------------------------------------------------
		//
		// Private Methods
		//
		// --------------------------------------------------------------------

		private function load():void {
			_loadOperation = new LoadURLOperation(_url);
			_loadOperation.addCompleteListener(load_completeHandler);
			_loadOperation.addErrorListener(load_errorHandler);
			logger.debug("Loading resources for bundle '{0}' and locale '{1}' from location '{2}'", [_name, _locale, _url]);
		}

		private function load_completeHandler(event:OperationEvent):void {
			logger.debug("Loaded resources for bundle '{0}' and locale '{1}' from location '{2}'", [_name, _locale, _url]);

			// create a new resource bundle and add it to the resource manager
			var resourceBundle:IResourceBundle = new ResourceBundle(_locale, _name);
			var properties:Object = StringUtils.parseProperties(event.result);
			var i:int = 0;

			for (var key:String in properties) {
				resourceBundle.content[key] = properties[key];
				logger.debug("Adding property: {0}={1}", [key, properties[key]]);
				i++;
			}

			ResourceManager.getInstance().addResourceBundle(resourceBundle);
			ResourceManager.getInstance().update();
			logger.debug("Added '{0}' resources to bundle '{1}' for locale '{2}'", [i, _name, _locale]);

			dispatchCompleteEvent(resourceBundle);
		}

		private function load_errorHandler(event:OperationEvent):void {
			var message:String = "Could not load resources for bundle '" + _name + "' and locale '" + _locale + "' from location '" + _url + "'";
			logger.error(message);
			dispatchErrorEvent(message);
		}

	}
}
