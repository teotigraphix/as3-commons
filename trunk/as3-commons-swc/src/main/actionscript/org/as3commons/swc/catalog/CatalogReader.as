package org.as3commons.swc.catalog {
	import org.as3commons.swc.SWC;
	import org.as3commons.swc.SWCComponent;
	import org.as3commons.swc.SWCLibrary;

	public class CatalogReader {

		private var _swc:SWC;
		private var _xml:XML;

		// --------------------------------------------------------------------
		//
		// Constructor
		//
		// --------------------------------------------------------------------

		public function CatalogReader(swc:SWC, data:String) {
			_swc = swc;
			_xml = new XML(data);
			default xml namespace = _xml.namespace();
		}

		// --------------------------------------------------------------------
		//
		// Public Methods
		//
		// --------------------------------------------------------------------

		public function read():void {
			readVersions();
			readFeatures();
			readComponents();
			readLibraries();
			readFiles();
		}

		// --------------------------------------------------------------------
		//
		// Protected Methods
		//
		// --------------------------------------------------------------------

		protected function readVersions():void {
			if (_xml.versions.length() == 1) {
				const versionsNode:XML = _xml.versions[0];
				for (var i:int = 0; i < versionsNode.children().length(); i++) {
					const node:XML = versionsNode.children()[i];
					const nodeName:String = node.localName();

					if (nodeName == "swc") {
						_swc.libVersion = node.@version.toString();
					} else if (nodeName == "flex") {
						_swc.flexVersion = node.@version.toString();
						_swc.flexMinimumSupportedVersion = node.@minimumSupportedVersion.toString();
						_swc.flexBuild = node.@build.toString();
					} else if (nodeName == "flash") {
						_swc.flashVersion = node.@version.toString();
						_swc.flashBuild = node.@build.toString();
						_swc.flashPlatform = node.@platform.toString();
					} else {
						trace("Unsupported version element '" + nodeName + "'");
					}
				}
			}
		}

		protected function readFiles():void {

		}

		protected function readLibraries():void {
			if (_xml.libraries.length() === 1) {
				var librariesXML:XML = _xml.libraries[0];
				for (var i:int = 0; i < librariesXML.children().length(); i++) {
					_swc.addLibrary(readLibrary(librariesXML.children()[i]));
				}
			}
		}

		private function readLibrary(xml:XML):SWCLibrary {
			var result:SWCLibrary = new SWCLibrary();
			result.path = xml.@path;
			for (var i:int = 0; i < xml.script.length(); i++) {
				var scriptXML:XML = xml.script[i];
				result.addClassName(scriptXML.def[0].@id.toString().replace(":", "."));
			}
			return result;
		}

		protected function readComponents():void {
			if (_xml.components.length() === 1) {
				var componentXML:XML = _xml.components[0];
				for (var i:int = 0; i < componentXML.children().length(); i++) {
					_swc.addComponent(readComponent(componentXML.children()[i]));
				}
			}
		}

		private function readComponent(xml:XML):SWCComponent {
			var className:String = xml.@className.toString().replace(":", ".");
			var name:String = xml.@name;
			var uri:String = xml.@uri;
			return new SWCComponent(className, name, uri);
		}

		protected function readFeatures():void {

		}

	}
}
