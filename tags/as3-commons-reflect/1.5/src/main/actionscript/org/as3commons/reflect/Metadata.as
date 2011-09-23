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
	import org.as3commons.lang.IEquals;

	/**
	 * A Metadata object contains information about a metadata element placed above a member of a class or instance.
	 *
	 * @author Christophe Herreman
	 */
	public class Metadata implements IEquals {

		public static const TRANSIENT:String = "Transient";
		public static const BINDABLE:String = "Bindable";

		private static const _cache:Object = {};

		// --------------------------------------------------------------------
		//
		// Class Methods
		//
		// --------------------------------------------------------------------

		public static function newInstance(name:String, arguments:Array = null):Metadata {
			var cacheKey:String = getCacheKeyByNameAndArgs(name, arguments);
			if (!_cache[cacheKey]) {
				_cache[cacheKey] = new Metadata(name, arguments);
			}
			return _cache[cacheKey];
		}

		public static function getCacheKey(metadata:Metadata):String {
			return getCacheKeyByNameAndArgs(metadata.name, metadata.arguments);
		}

		private static function getCacheKeyByNameAndArgs(key:String, metadataArgs:Array):String {
			var result:String = key + ";";

			if (metadataArgs) {
				var numArgs:int = metadataArgs.length;
				for (var i:int = 0; i < numArgs; i++) {
					result += MetadataArgument.getCacheKey(metadataArgs[i]);
					result += ";";
				}
			}

			return result;
		}

		// --------------------------------------------------------------------
		//
		// Constructor
		//
		// --------------------------------------------------------------------

		/**
		 * Creates a new Metadata object.
		 *
		 * @param name the name of the metadata
		 * @param arguments an array of MetadataArgument object that describe this metadata object
		 */
		public function Metadata(name:String, arguments:Array = null) {
			super();
			initMetadata(name, arguments);
		}

		protected function initMetadata(name:String, arguments:Array):void {
			_name = name;
			_arguments = (arguments == null) ? [] : arguments;
		}

		// --------------------------------------------------------------------
		//
		// Properties
		//
		// --------------------------------------------------------------------

		// ----------------------------

		private var _name:String;

		/**
		 * Returns the name of this metadata.
		 */
		public function get name():String {
			return _name;
		}

		// ----------------------------

		private var _arguments:Array;

		/**
		 * Returns the MetadataArgument objects that describe this metadata.
		 */
		public function get arguments():Array {
			return _arguments;
		}

		// --------------------------------------------------------------------
		//
		// Instance Methods
		//
		// --------------------------------------------------------------------

		/**
		 * Returns whether this metadata contains a MetadataArgument with the given key as its name.
		 *
		 * @return true if a MetadataArgument was found; false otherwise
		 */
		public function hasArgumentWithKey(key:String):Boolean {
			return (getArgument(key) != null);
		}

		/**
		 * Returns the MetadataArgument for the given key. If none was found, null is returned.
		 */
		public function getArgument(key:String):MetadataArgument {
			for each (var arg:MetadataArgument in _arguments) {
				if (arg.key === key) {
					return arg;
				}
			}
			return null;
		}

		public function equals(other:Object):Boolean {
			if (this === other) {
				return true;
			}

			if (!(other is Metadata)) {
				return false;
			}

			var that:Metadata = Metadata(other);
			return ((that._name === _name) && argumentsAreEqual(that._arguments));
		}

		public function toString():String {
			return "[Metadata(" + name + ", " + _arguments + ")]";
		}

		private function argumentsAreEqual(metadataArgs:Array):Boolean {
			if (metadataArgs.length !== _arguments.length) {
				return false;
			}

			for each (var otherArg:MetadataArgument in metadataArgs) {
				var arg:MetadataArgument = getArgument(otherArg.key);
				if (!otherArg.equals(arg)) {
					return false;
				}
			}

			return true;
		}

		as3commons_reflect function setName(value:String):void {
			_name = value;
		}

	}
}
