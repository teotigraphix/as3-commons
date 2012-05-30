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
package org.as3commons.swc {

	import org.as3commons.async.operation.IOperation;
	import org.as3commons.lang.Assert;
	import org.as3commons.lang.ClassUtils;
	import org.as3commons.swc.catalog.SWCCatalog;
	import org.as3commons.zip.Zip;

	public class SWC {

		private var _catalog:SWCCatalog;

		// --------------------------------------------------------------------
		//
		// Constructor
		//
		// --------------------------------------------------------------------

		public function SWC(url:String = null) {
			_url = url;
		}

		// --------------------------------------------------------------------
		//
		// Properties
		//
		// --------------------------------------------------------------------

		// ----------------------------

		private var _url:String;

		public function get url():String {
			return _url;
		}

		public function set url(value:String):void {
			_url = value;
		}

		// ----------------------------

		public function get components():Vector.<SWCComponent> {
			return _catalog.components;
		}

		// ----------------------------

		public function get libraries():Vector.<SWCLibrary> {
			return _catalog.libraries;
		}

		// ----------------------------

		public function get files():Vector.<SWCFile> {
			return _catalog.files;
		}

		// ----------------------------

		private var _scripts:Vector.<SWCScript>;

		public function get scripts():Vector.<SWCScript> {
			if (!_scripts) {
				_scripts = getScripts();
			}
			return _scripts;
		}

		private function getScripts():Vector.<SWCScript> {
			var result:Vector.<SWCScript> = new Vector.<SWCScript>();
			var libraries:Vector.<SWCLibrary> = _catalog.libraries;

			for (var i:int = 0; i < libraries.length; i++) {
				var lib:SWCLibrary = libraries[i];
				for (var j:int = 0; j < lib.scripts.length; j++) {
					result.push(lib.scripts[j]);
				}
			}

			return result;
		}

		// ----------------------------

		private var _classNames:Vector.<String>;

		public function get classNames():Vector.<String> {
			if (!_classNames) {
				_classNames = getClassNames();
			}
			return _classNames;
		}

		private function getClassNames():Vector.<String> {
			var result:Vector.<String> = new Vector.<String>();
			var numScripts:uint = scripts.length;

			for (var i:int = 0; i < scripts.length; i++) {
				result[i] = scripts[i].name;
			}

			return result;
		}

		// ---------------------------

		private var _loaded:Boolean = false;

		public function get loaded():Boolean {
			return _loaded;
		}

		as3commons_swc function set loaded(value:Boolean):void {
			_loaded = value;
		}

		// ----------------------------

		public function get numComponents():uint {
			return components.length;
		}

		// ----------------------------

		public function get numLibraries():uint {
			return libraries.length;
		}

		// ----------------------------

		public function get numFiles():uint {
			return files.length;
		}

		// ----------------------------

		as3commons_swc function set catalog(value:SWCCatalog):void {
			Assert.state(_catalog == null, "The catalog can only be set once.");
			_catalog = value;
		}

		// ----------------------------

		private var _zip:Zip;

		as3commons_swc function get zip():Zip {
			return _zip;
		}

		as3commons_swc function set zip(value:Zip):void {
			_zip = value;
		}

		// --------------------------------------------------------------------
		//
		// Public Methods
		//
		// --------------------------------------------------------------------

		public function load():IOperation {
			Assert.state(!_loaded, "The SWC can only be loaded once.");
			Assert.hasText(_url, "The 'url' property must be set before loading the SWC.");
			return new LoadLibraryOperation(this);
		}

		public function getClass(name:String):Class {
			Assert.state(_loaded, "The SWC must be loaded before classes can be retrieved from it.");
			return ClassUtils.forName(name);
		}

	}
}

import flash.display.Loader;
import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.events.SecurityErrorEvent;
import flash.net.URLRequest;
import flash.net.registerClassAlias;
import flash.system.LoaderContext;

import org.as3commons.async.operation.impl.AbstractOperation;
import org.as3commons.logging.api.ILogger;
import org.as3commons.logging.api.getClassLogger;
import org.as3commons.reflect.Metadata;
import org.as3commons.reflect.MetadataArgument;
import org.as3commons.reflect.Type;
import org.as3commons.swc.SWC;
import org.as3commons.swc.SWCFile;
import org.as3commons.swc.SWCScript;
import org.as3commons.swc.SWCScriptDependency;
import org.as3commons.swc.as3commons_swc;
import org.as3commons.swc.catalog.SWCCatalog;
import org.as3commons.swc.catalog.reader.impl.XMLCatalogReader;
import org.as3commons.zip.Zip;
import org.as3commons.zip.ZipErrorEvent;
import org.as3commons.zip.ZipFile;

class LoadLibraryOperation extends AbstractOperation {

	private static const LIBRARY_FILE_NAME:String = "library.swf";
	private static const CATALOG_FILE_NAME:String = "catalog.xml";

	private static const logger:ILogger = getClassLogger(LoadLibraryOperation);

	private var _zip:Zip;
	private var _loader:Loader;
	private var _swc:SWC;

	use namespace as3commons_swc;

	// --------------------------------------------------------------------
	//
	// Constructor
	//
	// --------------------------------------------------------------------

	public function LoadLibraryOperation(swc:SWC) {
		_swc = swc;
		load();
	}

	// --------------------------------------------------------------------
	//
	// Private Methods
	//
	// --------------------------------------------------------------------

	private function loader_securityErrorHandler(event:SecurityErrorEvent):void {
		dispatchErrorEvent(event.text);
	}

	private function ioErrorHandler(event:IOErrorEvent):void {
		dispatchErrorEvent(event.text);
		cleanupZip();
	}

	private function loader_completeHandler(event:Event):void {
		_swc.as3commons_swc::loaded = true;
		cleanUpLoader();
		registerClassAliases();
		dispatchCompleteEvent(_swc);
	}

	private function registerClassAliases():void {
		for each(var script:SWCScript in _swc.scripts) {
			var className:String = script.name;

			try {
				var type:Type = Type.forName(className);

				if (type) {
					for each(var metaData:Metadata in type.getMetadata("RemoteClass")) {
						var metadataArgument:MetadataArgument = metaData.getArgument("alias");
						logger.info("Registering class alias '{0}' for class '{1}'", [metadataArgument.value, className]);
						registerClassAlias(metadataArgument.value, type.clazz);
					}
				} else {
					logger.error("Type for name '" + className + "' is null");
				}
			} catch (e:Error) {
				logger.error("Cannot get type for name '" + className + "'. Error: '" + e.message + "'. Trying to resolve types of script dependencies.");

				for each (var dependency:SWCScriptDependency in script.dependencies) {
					try {
						Type.forName(dependency.name);
					}
					catch (e:Error) {
						logger.error("Cannot get type for script dependency with name '" + dependency.name + "'");
					}
				}
			}
		}
	}

	private function cleanUpLoader():void {
		_loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, loader_completeHandler);
		_loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
		_loader.contentLoaderInfo.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, loader_securityErrorHandler);
		_loader = null;
	}

	private function load():void {
		_zip = new Zip();
		_zip.addEventListener(Event.COMPLETE, unzipLibrary_completeHandler);
		_zip.addEventListener(ZipErrorEvent.PARSE_ERROR, unzip_parseErrorHandler);
		_zip.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
		_zip.load(new URLRequest(_swc.url));
		_swc.as3commons_swc::zip = _zip;
	}

	private function unzip_parseErrorHandler(event:ZipErrorEvent):void {
		dispatchErrorEvent(event.text);
		cleanupZip();
	}

	private function unzipLibrary_completeHandler(event:Event):void {
		readCatalog();
		loadClasses();
		cleanupZip();
	}

	private function readCatalog():void {
		var catalogFile:ZipFile = _zip.getFileByName(CATALOG_FILE_NAME);
		var catalogData:String = catalogFile.getContentAsString(false);
		var reader:XMLCatalogReader = new XMLCatalogReader(catalogData);
		var catalog:SWCCatalog = reader.read();
		_swc.as3commons_swc::catalog = catalog;
		addFileContent(catalog);
	}

	private function addFileContent(catalog:SWCCatalog):void {
		for each (var file:SWCFile in catalog.files) {
			file.as3commons_swc::zipFile = _zip.getFileByName(file.path);
		}
	}

	private function loadClasses():void {
		var swfFile:ZipFile = _zip.getFileByName(LIBRARY_FILE_NAME);
		var context:LoaderContext = new LoaderContext();
		context.allowCodeImport = true;
		context.applicationDomain = Type.currentApplicationDomain;
		_loader = new Loader();
		_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loader_completeHandler);
		_loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
		_loader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, loader_securityErrorHandler);
		_loader.loadBytes(swfFile.content, context);
	}

	private function cleanupZip():void {
		_zip.removeEventListener(Event.COMPLETE, unzipLibrary_completeHandler);
		_zip.removeEventListener(ZipErrorEvent.PARSE_ERROR, unzip_parseErrorHandler);
		_zip.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
	}

}