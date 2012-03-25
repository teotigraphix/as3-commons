/*
* Copyright (c) 2007-2009-2010 the original author or authors
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in
* all copies or substantial portions of the Software.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
* OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
* THE SOFTWARE.
*/
package org.as3commons.reflect {
	import flash.system.Capabilities;
	import flash.system.System;
	import flash.utils.describeType;

	import org.as3commons.lang.ClassUtils;

	/**
	 * Static methods for returning information about Types.
	 *
	 * @author Christophe Herreman
	 * @author Andrew Lewisohn
	 */
	public final class ReflectionUtils {

		private static var _version:String;
		private static var _isOldPlayer:Boolean = true;

		//--------------------------------------------------------------------
		//
		// Class methods
		//
		//--------------------------------------------------------------------

		/**
		 * Adds metadata from from interfaces to concrete implementations.
		 */
		public static function concatTypeMetadata(type:Type, metadataContainers:Array, propertyName:String):void {
			if (!metadataContainers) {
				return;
			}
			var i:int;
			var len:int = metadataContainers.length;
			var container:IMetadataContainer;
			var metadataList:Array;
			var numMetadata:int;
			var j:int;
			for (i = 0; i < len; ++i) {
				container = metadataContainers[i];
				type[propertyName].some(function(item:Object, index:int, arr:Array):Boolean {
					if (item.name == Object(container).name) {
						metadataList = container.metadata;
						numMetadata = metadataList.length;
						for (j = 0; j < numMetadata; ++j) {
							item.addMetadata(metadataList[j]);
						}
						return true;
					}
					return false;
				});
			}
		}

		/**
		 * Get XML clazz description as given by flash.utils.describeType
		 * using a workaround for bug http://bugs.adobe.com/jira/browse/FP-183
		 * that in certain cases do not allow to retrieve complete constructor
		 * description.
		 */
		public static function getTypeDescription(clazz:Class):XML {
			var description:XML = describeType(clazz);

			// Workaround for bug http://bugs.adobe.com/jira/browse/FP-183
			var constructorXML:XMLList = description.factory.constructor;

			if (constructorXML && constructorXML.length() > 0) {
				var parametersXML:XMLList = constructorXML[0].parameter;
				var len:int = parametersXML.length();
				if (parametersXML && len > 0) {
					// Instantiate class with all null arguments.
					var args:Array = [];
					var n:int;
					for (n = 0; n < len; ++n) {
						args.push(null);
					}

					if (playerHasConstructorBug()) {
						try {
							// As the constructor may throw Errors on null arguments arguments 
							// surround it with a try/catch block
							org.as3commons.lang.ClassUtils.newInstance(clazz, args);
						} catch (e:Error) {
							// Logging is set to debug level as any Error ocurring here shouldn't 
							// cause any problem to the application
							// CH: not sure if we should log this as it seems be causing confusion to users, disabling for now
							/*logger.debug("Error while instantiating class {0} with null arguments in order to retrieve constructor argument types: {1}, {2}" +
							"\nMessage: {3}" + "\nStack trace: {4}", clazz, e.name, e.errorID, e.message, e.getStackTrace());*/
						}
					}

					description = describeType(clazz);
				}
			}

			return description;
		}

		public static function playerHasConstructorBug():Boolean {
			if (_version == null) {
				_version = Capabilities.version.split(' ')[1];
				var arr:Array = _version.split(',');
				var major:int = parseInt(arr[0]);
				var minor:int = ((arr.length > 1) && (String(arr[1]).length > 0)) ? parseInt(arr[1]) : 0;
				if (major < 10) {
					_isOldPlayer = true;
				} else {
					_isOldPlayer = (major == 10) ? (minor < 1) : false;
				}
			}
			return _isOldPlayer;
		}
	}
}
