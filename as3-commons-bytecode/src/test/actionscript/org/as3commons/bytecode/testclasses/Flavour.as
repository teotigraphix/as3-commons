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
package org.as3commons.bytecode.testclasses {

	public class Flavour implements IFlavour {

		{
			Inline;
		}


		public function Flavour() {
		}

		private var _name:String;
		private var _ingredients:Array;
		private var _liked:Boolean;

		// read-only
		public function get name():String {
			return _name;
		}

		// read & write
		public function get ingredients():Array {
			return _ingredients;
		}

		public function set ingredients(value:Array):void {
			_ingredients = value;
		}

		// write-only
		public function set liked(value:Boolean):void {
			_liked = value;
		}

		// typed & rest
		// function combine(flavour:Flavour, ... otherFlavours):Flavour;
		public function combine(... rest):void {

		}

		public function add(flavour:IFlavour):void {

		}

		public function toString():String {
			return "Flavour{_name:\"" + _name + "\", _ingredients:[" + _ingredients + "], _liked:" + _liked + "}";
		}

	}
}