/*
 * Copyright 2007-2011 the original author or authors.
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
package org.as3commons.stageprocessing.impl.selector {
	import flash.system.ApplicationDomain;
	import org.as3commons.lang.Assert;
	import org.as3commons.lang.ClassUtils;
	import org.as3commons.stageprocessing.IObjectSelector;

	/**
	 * <code>IObjectSelector</code> approving or denying objects based on their type.
	 * (default behaviour approves objects whose type matches one of the types in the typeArray).
	 * @author Roland Zwaga
	 */
	public class TypeBasedObjectSelector implements IObjectSelector {

		/**
		 * Create a new <code>TypeBasedObjectSelector</code> instance.
		 * @param classNames
		 * @param classes
		 * @param approveOnMatch
		 */
		public function TypeBasedObjectSelector(classNames:Vector.<String>, classes:Vector.<Class>, approveOnMatch:Boolean=true, appDomain:ApplicationDomain=null) {
			super();
			_applicationDomain ||= ApplicationDomain.currentDomain;
			_classNames = classNames;
			_classes = classes;
			_approveOnMatch = approveOnMatch;
			validateClassNames(classNames);
		}

		private var _applicationDomain:ApplicationDomain;
		private var _approveOnMatch:Boolean = true;
		private var _classNames:Vector.<String>;
		private var _classes:Vector.<Class>;

		/**
		 *
		 */
		public function get applicationDomain():ApplicationDomain {
			return _applicationDomain;
		}

		/**
		 *
		 * @private
		 */
		public function set applicationDomain(value:ApplicationDomain):void {
			_applicationDomain = value;
		}

		/**
		 * When set to true the <code>approve()</code> method returns true when the specified object is of a type that
		 * is an item in the typeArray.
		 * @default true
		 */
		public function get approveOnMatch():Boolean {
			return _approveOnMatch;
		}

		/**
		 * @private
		 */
		public function set approveOnMatch(value:Boolean):void {
			_approveOnMatch = value;
		}

		public function get classes():Vector.<Class> {
			return _classes;
		}

		public function set classes(value:Vector.<Class>):void {
			_classes = value;
		}

		/**
		 * An array of <code>Class</code> instance, the specified object will be checked to see if
		 * it is of any of these types.
		 */
		public function get classNames():Vector.<String> {
			return _classNames;
		}

		/**
		 * @private
		 */
		public function set classNames(value:Vector.<String>):void {
			if (value !== _classNames) {
				validateClassNames(value);
				_classNames = value;
			}
		}

		/**
		 * <p>Returns true if the specified object is of a type in the typeArray and the approveOnMatch property is set to true.</p>
		 * @inheritDoc
		 */
		public function approve(object:Object):Boolean {
			var result:Boolean = _classes.some(function(item:Class, index:int, arr:Array):Boolean {
				return (object is item);
			});
			if (result) {
				return _approveOnMatch;
			} else {
				return !_approveOnMatch;
			}
		}

		/**
		 *
		 * @param classNames
		 */
		protected function validateClassNames(classNames:Vector.<String>):void {
			_classes ||= new Vector.<Class>();
			for each (var className:String in classNames) {
				_classes[_classes.length] = ClassUtils.forName(className, _applicationDomain);
			}
		}
	}
}
