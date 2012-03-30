package org.as3commons.swc {

	import org.as3commons.async.operation.IOperation;
	import org.as3commons.lang.Assert;
	import org.as3commons.lang.ClassUtils;

	public class SWC {

		public var libVersion:String = "";
		public var flexVersion:String = "";
		public var flexMinimumSupportedVersion:String = "";
		public var flexBuild:String = "";
		public var flashVersion:String = "";
		public var flashBuild:String = "";
		public var flashPlatform:String = "";

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

		private var _components:Vector.<SWCComponent> = new Vector.<SWCComponent>();

		public function get components():Vector.<SWCComponent> {
			return _components.concat();
		}

		// ----------------------------

		private var _libraries:Vector.<SWCLibrary> = new Vector.<SWCLibrary>();

		public function get libraries():Vector.<SWCLibrary> {
			return _libraries.concat();
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

			for (var i:int = 0; i < _libraries.length; i++) {
				var lib:SWCLibrary = _libraries[i];
				for (var j:int = 0; j < lib.classNames.length; j++) {
					result.push(lib.classNames[j]);
				}
			}

			return result;
		}

		// ---------------------------

		private var _loaded:Boolean = false;

		public function get loaded():Boolean {
			return _loaded;
		}

		public function set loaded(value:Boolean):void {
			_loaded = value;
		}

		// ----------------------------

		public function get numComponents():uint {
			return _components.length;
		}

		// ----------------------------

		public function get numLibraries():uint {
			return _libraries.length;
		}

		// --------------------------------------------------------------------
		//
		// Public Methods
		//
		// --------------------------------------------------------------------

		public function load():IOperation {
			Assert.hasText(_url, "The 'url' property must be set before loading the SWC.");
			return new LoadLibraryOperation(this);
		}

		public function getClass(name:String):Class {
			Assert.state(_loaded, "The SWC must be loaded before classes can be retrieved from it.");
			return ClassUtils.forName(name);
		}

		public function addComponent(component:SWCComponent):void {
			Assert.state(!_loaded, "Components cannot be added after the SWC has been loaded");
			_components.push(component);
		}

		public function addLibrary(library:SWCLibrary):void {
			Assert.state(!_loaded, "Libraries cannot be added after the SWC has been loaded");
			_libraries.push(library);
		}

	}
}

import flash.display.Loader;
import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.events.SecurityErrorEvent;
import flash.net.URLRequest;
import flash.system.LoaderContext;

import org.as3commons.async.operation.impl.AbstractOperation;
import org.as3commons.reflect.Type;
import org.as3commons.swc.SWC;
import org.as3commons.swc.catalog.CatalogReader;
import org.as3commons.zip.Zip;
import org.as3commons.zip.ZipErrorEvent;
import org.as3commons.zip.ZipFile;

class LoadLibraryOperation extends AbstractOperation {

	private static const LIBRARY_FILE_NAME:String = "library.swf";
	private static const CATALOG_FILE_NAME:String = "catalog.xml";

	private var _zip:Zip;
	private var _loader:Loader;
	private var _swc:SWC;

	/**
	 * Creates a new <code>LoadLibraryOperation</code> instance.
	 */
	public function LoadLibraryOperation(swc:SWC) {
		_swc = swc;
		load();
	}

	protected function loader_securityErrorHandler(event:SecurityErrorEvent):void {
		dispatchErrorEvent(event.text);
	}

	protected function ioErrorHandler(event:IOErrorEvent):void {
		dispatchErrorEvent(event.text);
		cleanupZip();
	}

	protected function loader_completeHandler(event:Event):void {
		_swc.loaded = true;
		cleanUpLoader();
		dispatchCompleteEvent(_swc);
	}

	private function cleanUpLoader():void {
		_loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, loader_completeHandler);
		_loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
		_loader.contentLoaderInfo.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, loader_securityErrorHandler);
		_loader = null;
	}

	protected function load():void {
		_zip = new Zip();
		_zip.addEventListener(Event.COMPLETE, unzipLibrary_completeHandler);
		_zip.addEventListener(ZipErrorEvent.PARSE_ERROR, unzip_parseErrorHandler);
		_zip.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
		_zip.load(new URLRequest(_swc.url));
	}

	protected function unzip_parseErrorHandler(event:ZipErrorEvent):void {
		dispatchErrorEvent(event.text);
		cleanupZip();
	}

	protected function unzipLibrary_completeHandler(event:Event):void {
		readCatalog();
		loadClasses();
		cleanupZip();
	}

	private function readCatalog():void {
		var catalogFile:ZipFile = _zip.getFileByName(CATALOG_FILE_NAME);
		var catalogData:String = catalogFile.getContentAsString(false);
		var reader:CatalogReader = new CatalogReader(_swc, catalogData);
		reader.read();
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