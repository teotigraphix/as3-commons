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
package org.as3commons.swc.catalog.reader.impl {
	import org.as3commons.swc.SWCComponent;
	import org.as3commons.swc.SWCFile;
	import org.as3commons.swc.SWCLibrary;
	import org.as3commons.swc.SWCScript;
	import org.as3commons.swc.SWCScriptDependency;
	import org.as3commons.swc.SWCVersions;
	import org.as3commons.swc.catalog.SWCCatalog;
	import org.as3commons.swc.catalog.reader.ICatalogReader;

	public class XMLCatalogReader implements ICatalogReader {

		private var _xml:XML;

		// --------------------------------------------------------------------
		//
		// Constructor
		//
		// --------------------------------------------------------------------

		public function XMLCatalogReader(data:String) {
			_xml = new XML(data);
			default xml namespace = _xml.namespace();
		}

		// --------------------------------------------------------------------
		//
		// Public Methods
		//
		// --------------------------------------------------------------------

		public function read():SWCCatalog {
			return new SWCCatalog(readVersions(), readComponents(), readLibraries(), readFiles());
		}

		// --------------------------------------------------------------------
		//
		// Protected Methods
		//
		// --------------------------------------------------------------------

		protected function readVersions():SWCVersions {
			var libVersion:String = "";
			var flexVersion:String = "";
			var flexMinimumSupportedVersion:String = "";
			var flexBuild:String = "";
			var flashVersion:String = "";
			var flashBuild:String = "";
			var flashPlatform:String = "";

			if (_xml.versions.length() == 1) {
				const versionsNode:XML = _xml.versions[0];
				for (var i:int = 0; i < versionsNode.children().length(); i++) {
					const node:XML = versionsNode.children()[i];
					const nodeName:String = node.localName();

					if (nodeName == "swc") {
						libVersion = node.@version.toString();
					} else if (nodeName == "flex") {
						flexVersion = node.@version.toString();
						flexMinimumSupportedVersion = node.@minimumSupportedVersion.toString();
						flexBuild = node.@build.toString();
					} else if (nodeName == "flash") {
						flashVersion = node.@version.toString();
						flashBuild = node.@build.toString();
						flashPlatform = node.@platform.toString();
					} else {
						trace("Unsupported version element '" + nodeName + "'");
					}
				}
			}
			return new SWCVersions(libVersion, flexVersion, flexMinimumSupportedVersion, flexBuild, flashVersion, flashBuild, flashPlatform);
		}

		protected function readFiles():Vector.<SWCFile> {
			var result:Vector.<SWCFile> = new Vector.<SWCFile>();
			if (_xml.files.length() === 1) {
				var filesXML:XML = _xml.files[0];
				for (var i:int = 0; i < filesXML.children().length(); i++) {
					result[i] = readFile(filesXML.children()[i]);
				}
			}
			return result;
		}

		private function readFile(xml:XML):SWCFile {
			return new SWCFile(xml.@path, xml.@mod);
		}

		protected function readLibraries():Vector.<SWCLibrary> {
			var result:Vector.<SWCLibrary> = new Vector.<SWCLibrary>();
			if (_xml.libraries.length() === 1) {
				var librariesXML:XML = _xml.libraries[0];
				for (var i:int = 0; i < librariesXML.children().length(); i++) {
					result[i] = readLibrary(librariesXML.children()[i]);
				}
			}
			return result;
		}

		private function readLibrary(xml:XML):SWCLibrary {
			return new SWCLibrary(xml.@path, readScripts(xml.script), readMetadata(xml.child("keep-as3-metadata")));
		}

		private function readMetadata(keepAS3MetadataXMLList:XMLList):Vector.<String> {
			var result:Vector.<String> = new Vector.<String>();
			if (keepAS3MetadataXMLList.length() === 1) {
				var metadataXMLList:XMLList = keepAS3MetadataXMLList[0].metadata;
				var numMetadata:int = metadataXMLList.length();
				for (var i:int = 0; i < numMetadata; i++) {
					result[i] = metadataXMLList[i].@name;
				}
			}
			return result;
		}

		private function readScripts(scriptXMLList:XMLList):Vector.<SWCScript> {
			var result:Vector.<SWCScript> = new Vector.<SWCScript>();
			var numScripts:int = scriptXMLList.length();
			for (var i:int = 0; i < numScripts; i++) {
				result[i] = readScript(scriptXMLList[i]);
			}
			return result;
		}

		private function readScript(scriptXML:XML):SWCScript {
			var name:String = scriptXML.@name.toString().split("/").join(".");
			var mode:Number = scriptXML.@mod;
			var signatureChecksum:Number = scriptXML.@signatureChecksum;
			return new SWCScript(name, mode, signatureChecksum, readScriptDependencies(scriptXML));
		}

		private function readScriptDependencies(scriptXML:XML):Vector.<SWCScriptDependency> {
			var result:Vector.<SWCScriptDependency> = new Vector.<SWCScriptDependency>();
			var numDependencies:int = scriptXML.dep.length();
			for (var i:int = 0; i < numDependencies; i++) {
				result[i] = readScriptDependency(scriptXML.dep[i]);
			}
			return result;
		}

		private function readScriptDependency(scriptDependencyXML:XML):SWCScriptDependency {
			return new SWCScriptDependency(scriptDependencyXML.@id.toString().replace(":", "."), scriptDependencyXML.@type);
		}

		protected function readComponents():Vector.<SWCComponent> {
			var result:Vector.<SWCComponent> = new Vector.<SWCComponent>();
			if (_xml.components.length() === 1) {
				var componentXML:XML = _xml.components[0];
				for (var i:int = 0; i < componentXML.children().length(); i++) {
					result[i] = readComponent(componentXML.children()[i]);
				}
			}
			return result;
		}

		private function readComponent(xml:XML):SWCComponent {
			var className:String = xml.@className.toString().replace(":", ".");
			var name:String = xml.@name;
			var uri:String = xml.@uri;
			return new SWCComponent(className, name, uri);
		}

	}
}
