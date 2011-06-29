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
package org.as3commons.stageprocessing.impl {

	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.utils.Dictionary;
	import org.as3commons.lang.IOrdered;
	import org.as3commons.logging.ILogger;
	import org.as3commons.stageprocessing.IObjectSelector;
	import org.as3commons.stageprocessing.IStageObjectDestroyer;
	import org.as3commons.stageprocessing.IStageObjectProcessor;
	import org.as3commons.stageprocessing.IStageObjectProcessorRegistry;

	/**
	 * Pure actionscript implementation of the <code>IStageObjectProcessorRegistry</code> interface.
	 * @author Roland Zwaga
	 */
	public class FlashStageObjectProcessorRegistry implements IStageObjectProcessorRegistry {

		protected static const STAGE_PROCESSING_COMPLETED:String = "Stage processing completed";
		protected static const STAGE_PROCESSING_STARTED:String = "Stage processing starting with component '{0}'";
		protected static const STAGE_PROCESSOR_REGISTRY_CLEARED:String = "StageProcessorRegistry was cleared";

		private static const CANNOT_INSTANTIATE_ERROR:String = "Cannot instantiate FlashStageProcessorRegistry directly, invoke getInstance() instead";
		private static const FLASH_STAGE_PROCESSOR_REGISTRY_INITIALIZED:String = "FlashStageProcessorRegistry was initialized";
		private static const LOGGER:ILogger = org.as3commons.logging.getClassLogger(FlashStageObjectProcessorRegistry);
		private static const NEW_STAGE_PROCESSOR_AND_SELECTOR_REGISTERED:String = "New stage processor '{0}' was registered with name '{1}' and new {2}";
		private static const NEW_STAGE_PROCESSOR_REGISTERED:String = "New stage processor '{0}' was registered with name '{1}' and existing {2}";
		private static const ORDERED_PROPERTYNAME:String = "order";
		private static const STAGE_PROCESSOR_UNREGISTERED:String = "Stage processor with name '{0}' and document '{1}' was unregistered";

		/**
		 * Sorts a vector of <code>IStageObjectProcessor</code> that may or may not contain <code>IOrdered</code> implementations.
		 * First all the <code>IOrdered</code> implementations are sorted and then any left over instances are added at the end of the
		 * <code>Vector.&lt,IStageObjectProcessor&gt;</code>
		 * @param source
		 */
		protected static function sortOrderedVector(source:Vector.<IStageObjectProcessor>):void {
			if (source.length < 2) {
				return;
			}
			var ordered:Array = [];
			var unordered:Array = [];
			for each (var obj:IStageObjectProcessor in source) {
				if (obj is IOrdered) {
					ordered[ordered.length] = obj;
				} else {
					unordered[unordered.length] = obj;
				}
			}
			ordered.sortOn(ORDERED_PROPERTYNAME, Array.NUMERIC);
			ordered = ordered.concat(unordered);
			source.length = 0;
			for each (var proc:IStageObjectProcessor in ordered) {
				source[source.length] = proc;
			}
		}

		/**
		 * Creates a new <code>FlashStageObjectProcessorRegistry</code> instance.
		 */
		public function FlashStageObjectProcessorRegistry() {
			super();
			init();
		}

		private var _enabled:Boolean;
		private var _initialized:Boolean;
		private var _rootViews:Dictionary;
		private var _stage:Stage;
		private var _useStageDestroyers:Boolean = true;

		/**
		 * @inheritDoc
		 */
		public function clear():void {
			_initialized = false;
			removeEventListeners(_stage);
			LOGGER.debug(STAGE_PROCESSOR_REGISTRY_CLEARED);
		}

		/**
		 * @inheritDoc
		 */
		public function get enabled():Boolean {
			return _enabled;
		}

		/**
		 * @private
		 */
		public function set enabled(value:Boolean):void {
			_enabled = value;
		}

		/**
		 * @inheritDoc
		 */
		public function getAllObjectSelectors():Vector.<IObjectSelector> {
			var result:Vector.<IObjectSelector> = new Vector.<IObjectSelector>();
			for (var rootView:* in _rootViews) {
				var selectors:Dictionary = _rootViews[rootView];
				for (var selector:* in selectors) {
					result[result.length] = IObjectSelector(selector);
				}
			}
			return result;
		}

		/**
		 * @inheritDoc
		 */
		public function getAllRootViews():Vector.<DisplayObject> {
			var result:Vector.<DisplayObject> = new Vector.<DisplayObject>();
			for (var rootView:* in _rootViews) {
				result[result.length] = DisplayObject(rootView);
			}
			return result;
		}

		/**
		 * @inheritDoc
		 */
		public function getAllStageObjectProcessors():Vector.<IStageObjectProcessor> {
			var result:Vector.<IStageObjectProcessor> = new Vector.<IStageObjectProcessor>();
			for (var rootView:* in _rootViews) {
				var selectors:Dictionary = _rootViews[rootView];
				for (var selector:* in selectors) {
					var processors:Vector.<IStageObjectProcessor> = selectors[selector];
					for each (var proc:IStageObjectProcessor in processors) {
						if (result.indexOf(proc) < 0) {
							result[result.length] = proc;
						}
					}
				}
			}
			return result;
		}

		/**
		 * @inheritDoc
		 */
		public function getObjectSelectorsForStageProcessor(stageProcessor:IStageObjectProcessor):Vector.<IObjectSelector> {
			var result:Vector.<IObjectSelector> = new Vector.<IObjectSelector>();
			for (var view:* in _rootViews) {
				var selectors:Dictionary = _rootViews[view];
				for (var selector:* in selectors) {
					var processors:Vector.<IStageObjectProcessor> = selectors[selector];
					if (processors.indexOf(stageProcessor) > -1) {
						if (result.indexOf(selector) < 0) {
							result[result.length] = IObjectSelector(selector);
						}
					}
				}
			}
			return result;
		}

		/**
		 * @inheritDoc
		 */
		public function getProcessorVector(rootView:DisplayObject, objectSelector:IObjectSelector, create:Boolean = true):Vector.<IStageObjectProcessor> {
			if ((_rootViews[rootView] == null) && (create)) {
				_rootViews[rootView] = new Dictionary();
			}
			var objectSelectors:Dictionary = _rootViews[rootView];
			if (objectSelectors == null) {
				return null;
			}
			if ((objectSelectors[objectSelector] == null) && (create)) {
				objectSelectors[objectSelector] = new Vector.<IStageObjectProcessor>();
			}
			return objectSelectors[objectSelector] as Vector.<IStageObjectProcessor>;
		}

		/**
		 * @inheritDoc
		 */
		public function getStageObjectProcessorsByType(type:Class):Vector.<IStageObjectProcessor> {
			var result:Vector.<IStageObjectProcessor> = new Vector.<IStageObjectProcessor>();
			var processors:Vector.<IStageObjectProcessor> = getAllStageObjectProcessors();
			for each (var proc:IStageObjectProcessor in processors) {
				if (proc is type) {
					result[result.length] = proc;
				}
			}
			return result;
		}

		/**
		 * @inheritDoc
		 */
		public function getStageProcessorsByRootView(rootView:Object):Vector.<IStageObjectProcessor> {
			var result:Vector.<IStageObjectProcessor> = new Vector.<IStageObjectProcessor>();
			var selectors:Dictionary = _rootViews[rootView];
			if (selectors != null) {
				for (var selector:* in selectors) {
					result = result.concat(selectors[selector]);
				}
			}
			return result;
		}

		/**
		 * @inheritDoc
		 */
		public function initialize():void {
			if ((!_initialized) && (_stage != null)) {
				setInitialized();
				processStage();
				addEventListeners(_stage);
				LOGGER.debug(FLASH_STAGE_PROCESSOR_REGISTRY_INITIALIZED);
			}
		}

		/**
		 * @inheritDoc
		 */
		public function get initialized():Boolean {
			return _initialized;
		}

		/**
		 * @inheritDoc
		 */
		public function processStage(startComponent:DisplayObject = null):void {
			if (_stage == null) {
				return;
			}

			startComponent ||= _stage.root;

			LOGGER.debug(STAGE_PROCESSING_STARTED, startComponent);
			processDisplayObjectRecursively(startComponent);
			LOGGER.debug(STAGE_PROCESSING_COMPLETED);
		}

		/**
		 * @inheritDoc
		 */
		public function registerStageObjectProcessor(stageProcessor:IStageObjectProcessor, objectSelector:IObjectSelector, rootView:DisplayObject = null):void {
			rootView ||= _stage;
			var processors:Vector.<IStageObjectProcessor> = getProcessorVector(rootView, objectSelector);
			if (processors.indexOf(stageProcessor) < 0) {
				processors[processors.length] = stageProcessor;
				sortOrderedVector(processors);
			}
		}

		/**
		 * @inheritDoc
		 */
		public function get stage():Stage {
			return _stage;
		}

		/**
		 *
		 * @private
		 *
		 */
		public function set stage(value:Stage):void {
			_stage = value;
		}

		/**
		 * @inheritDoc
		 */
		public function unregisterStageObjectProcessor(stageProcessor:IStageObjectProcessor, objectSelector:IObjectSelector, rootView:DisplayObject = null):void {
			rootView ||= _stage;
			var processors:Vector.<IStageObjectProcessor> = getProcessorVector(rootView, objectSelector);
			if (processors != null) {
				var idx:int = processors.indexOf(stageProcessor);
				if (idx > -1) {
					processors.splice(idx, 1);
				}
				if (processors.length == 0) {
					var objectSelectors:Dictionary = _rootViews[rootView];
					delete objectSelectors[objectSelector];
				}
			}
		}

		/**
		 * @inheritDoc
		 */
		public function get useStageDestroyers():Boolean {
			return _useStageDestroyers;
		}

		/**
		 * @private
		 */
		public function set useStageDestroyers(value:Boolean):void {
			_useStageDestroyers = value;
		}

		protected function addEventListeners(root:DisplayObject):void {
			if (root != null) {
				root.addEventListener(Event.ADDED_TO_STAGE, added_handler, true);
				if (_useStageDestroyers) {
					root.addEventListener(Event.REMOVED_FROM_STAGE, removed_handler, true);
				}
			}
		}

		/**
		 * If <code>enabled</code> is <code>true</code> this event handler passes the <code>event.target</code> to the
		 * <code>processStageComponent()</code> method.
		 * @param event The <code>Event.ADDED_TO_STAGE</code> instance.
		 */
		protected function added_handler(event:Event):void {
			if (_enabled) {
				processDisplayObject(event.target as DisplayObject);
			}
		}

		protected function approveDisplayObjectAfterAdding(displayObject:DisplayObject, objectSelector:IObjectSelector, processors:Vector.<IStageObjectProcessor>):void {
			if (objectSelector.approve(displayObject)) {
				for each (var processor:IStageObjectProcessor in processors) {
					processor.process(displayObject);
				}
			}
		}

		protected function approveDisplayObjectAfterRemoving(displayObject:DisplayObject, objectSelector:IObjectSelector, processors:Vector.<IStageObjectProcessor>):void {
			if (objectSelector.approve(displayObject)) {
				for each (var processor:IStageObjectProcessor in processors) {
					if (processor is IStageObjectDestroyer) {
						IStageObjectDestroyer(processor).destroy(displayObject);
					}
				}
			}
		}

		protected function getAssociatedObjectSelectors(displayObject:DisplayObject):Dictionary {
			var selectors:Dictionary = _rootViews[displayObject];
			if (selectors != null) {
				return selectors;
			} else if (displayObject.parent != null) {
				return getAssociatedObjectSelectors(displayObject.parent);
			} else {
				return null;
			}
		}

		protected function init():void {
			_enabled = false;
			_initialized = false;
			_rootViews = new Dictionary(true);
		}

		/**
		 * @param displayObject a reference to the object that was added to the stage
		 * @see org.as3commons.stageprocessing.IStageObjectProcessor IStageObjectProcessor
		 */
		protected function processDisplayObject(displayObject:DisplayObject):void {
			if (!displayObject || !_enabled) {
				return;
			}
			var selectors:Dictionary = getAssociatedObjectSelectors(displayObject);
			if (selectors != null) {
				for (var selector:* in selectors) {
					approveDisplayObjectAfterAdding(displayObject, IObjectSelector(selector), selectors[selector]);
				}
			}
		}

		/**
		 * Sends the specified <code>DisplayObject</code> instance to the <code>processStageComponent()</code> method,
		 * then loops through its children and recursively sends those to the <code>processStageComponent()</code> method.
		 * @param displayObject The specified <code>DisplayObject</code> instance
		 */
		protected function processDisplayObjectRecursively(displayObject:DisplayObject):void {
			processDisplayObject(displayObject);
			if (displayObject is DisplayObjectContainer) {
				var displayObjectContainer:DisplayObjectContainer = DisplayObjectContainer(displayObject);
				var numChildren:int = displayObjectContainer.numChildren;

				for (var i:int = 0; i < numChildren; ++i) {
					var child:DisplayObject = displayObjectContainer.getChildAt(i);
					processDisplayObjectRecursively(child);
				}
			}
		}

		protected function processDisplayObjectRemoval(displayObject:DisplayObject):void {
			if (!displayObject || !_enabled) {
				return;
			}
			var selectors:Dictionary = getAssociatedObjectSelectors(displayObject);
			if (selectors != null) {
				for (var selector:* in selectors) {
					approveDisplayObjectAfterRemoving(displayObject, IObjectSelector(selector), selectors[selector]);
				}
			}
		}

		protected function removeEventListeners(root:DisplayObject):void {
			if (root != null) {
				root.removeEventListener(Event.ADDED_TO_STAGE, added_handler, true);
				root.removeEventListener(Event.REMOVED_FROM_STAGE, removed_handler, true);
			}
		}

		protected function removed_handler(event:Event):void {
			if (_enabled) {
				processDisplayObjectRemoval(event.target as DisplayObject);
			}
		}

		protected function setInitialized():void {
			_initialized = true;
			_enabled = true;
		}
	}
}
