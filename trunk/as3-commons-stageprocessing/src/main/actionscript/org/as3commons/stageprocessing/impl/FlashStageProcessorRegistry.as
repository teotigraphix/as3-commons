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
	import flash.errors.IllegalOperationError;
	import flash.events.Event;
	import flash.utils.Dictionary;

	import org.as3commons.lang.IDisposable;
	import org.as3commons.logging.ILogger;
	import org.as3commons.logging.LoggerFactory;
	import org.as3commons.stageprocessing.IObjectSelector;
	import org.as3commons.stageprocessing.IStageObjectDestroyer;
	import org.as3commons.stageprocessing.IStageObjectProcessor;
	import org.as3commons.stageprocessing.IStageObjectProcessorRegistry;

	public class FlashStageProcessorRegistry implements IStageObjectProcessorRegistry {

		// --------------------------------------------------------------------
		//
		// Private Static Constants
		//
		// --------------------------------------------------------------------

		private static const CANNOT_INSTANTIATE_ERROR:String = "Cannot instantiate FlashStageProcessorRegistry directly, invoke getInstance() instead";
		private static const NEW_STAGE_PROCESSOR_REGISTERED:String = "New stage processor '{0}' was registered with name '{1}' and existing {2}";
		private static const NEW_STAGE_PROCESSOR_AND_SELECTOR_REGISTERED:String = "New stage processor '{0}' was registered with name '{1}' and new {2}";
		private static const STAGE_PROCESSOR_UNREGISTERED:String = "Stage processor with name '{0}' and document '{1}' was unregistered";
		private static const FLASH_STAGE_PROCESSOR_REGISTRY_INITIALIZED:String = "FlashStageProcessorRegistry was initialized";
		protected static const STAGE_PROCESSOR_REGISTRY_CLEARED:String = "StageProcessorRegistry was cleared";
		protected static const STAGE_PROCESSING_STARTED:String = "Stage processing starting with component '{0}'";
		protected static const STAGE_PROCESSING_COMPLETED:String = "Stage processing completed";

		// --------------------------------------------------------------------
		//
		// Private Static Variables
		//
		// --------------------------------------------------------------------

		private static var LOGGER:ILogger = LoggerFactory.getClassLogger(FlashStageProcessorRegistry);

		private var _rootViews:Dictionary;

		// --------------------------------------------------------------------
		//
		// Public Static Methods
		//
		// --------------------------------------------------------------------

		public function FlashStageProcessorRegistry() {
			super();
			init();
		}

		protected function init():void {
			_enabled = false;
			_initialized = false;
			_rootViews = new Dictionary(true);
		}

		// --------------------------------------------------------------------
		//
		// Protected Variables
		//
		// --------------------------------------------------------------------

		private var _stage:Stage;

		/**
		 *
		 * @inheritDoc
		 *
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

		private var _enabled:Boolean;

		public function get enabled():Boolean {
			return _enabled;
		}

		public function set enabled(value:Boolean):void {
			_enabled = value;
		}

		private var _initialized:Boolean;

		public function get initialized():Boolean {
			return _initialized;
		}

		public function initialize():void {
			if ((!_initialized) && (_stage != null)) {
				setInitialized();
				processStage();
				addEventListeners(_stage);
				LOGGER.debug(FLASH_STAGE_PROCESSOR_REGISTRY_INITIALIZED);
			}
		}

		protected function addEventListeners(root:DisplayObject):void {
			if (root != null) {
				root.addEventListener(Event.ADDED_TO_STAGE, added_handler, true);
				root.addEventListener(Event.REMOVED_FROM_STAGE, removed_handler, true);
			}
		}

		protected function removeEventListeners(root:DisplayObject):void {
			if (root != null) {
				root.removeEventListener(Event.ADDED_TO_STAGE, added_handler, true);
				root.removeEventListener(Event.REMOVED_FROM_STAGE, removed_handler, true);
			}
		}

		protected function setInitialized():void {
			_initialized = true;
			_enabled = true;
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

		protected function removed_handler(event:Event):void {
			if (_enabled) {
				processDisplayObjectRemoval(event.target as DisplayObject);
			}
		}

		public function clear():void {
			_initialized = false;
			removeEventListeners(_stage);
			LOGGER.debug(STAGE_PROCESSOR_REGISTRY_CLEARED);
		}

		public function registerStageObjectProcessor(stageProcessor:IStageObjectProcessor, objectSelector:IObjectSelector, rootView:DisplayObject = null):void {
			rootView ||= _stage;
			var processors:Array = getProcessorArray(rootView, objectSelector);
			if (processors.indexOf(stageProcessor) < 0) {
				processors[processors.length] = stageProcessor;
			}
		}

		protected function getProcessorArray(rootView:DisplayObject, objectSelector:IObjectSelector, create:Boolean = true):Array {
			if ((_rootViews[rootView] == null) && (create)) {
				_rootViews[rootView] = new Dictionary();
			}
			var objectSelectors:Dictionary = _rootViews[rootView];
			if (objectSelectors == null) {
				return null;
			}
			if ((objectSelectors[objectSelector] == null) && (create)) {
				objectSelectors[objectSelector] = [];
			}
			return objectSelectors[objectSelector] as Array;
		}

		public function unregisterStageObjectProcessor(stageProcessor:IStageObjectProcessor, objectSelector:IObjectSelector, rootView:DisplayObject = null):void {
			rootView ||= _stage;
			var processors:Array = getProcessorArray(rootView, objectSelector);
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

		public function getAllRootViews():Vector.<DisplayObject> {
			var result:Vector.<DisplayObject> = new Vector.<DisplayObject>();
			for (var rootView:* in _rootViews) {
				result[result.length] = DisplayObject(rootView);
			}
			return result;
		}


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

		public function getAllStageObjectProcessors():Vector.<IStageObjectProcessor> {
			var result:Vector.<IStageObjectProcessor> = new Vector.<IStageObjectProcessor>();
			for (var rootView:* in _rootViews) {
				var selectors:Dictionary = _rootViews[rootView];
				for (var selector:* in selectors) {
					var processors:Array = selectors[selector];
					for each (var proc:IStageObjectProcessor in processors) {
						if (result.indexOf(proc) < 0) {
							result[result.length] = proc;
						}
					}
				}
			}
			return result;
		}

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

		public function getObjectSelectorsForStageProcessor(stageProcessor:IStageObjectProcessor):Vector.<IObjectSelector> {
			var result:Vector.<IObjectSelector> = new Vector.<IObjectSelector>();
			for (var view:* in _rootViews) {
				var selectors:Dictionary = _rootViews[view];
				for (var selector:* in selectors) {
					var processors:Vector.<IStageObjectProcessor> = selectors[selector];
					if (processors.indexOf(stageProcessor) > -1) {
						result[result.length] = IObjectSelector(selector);
					}
				}
			}
			return result;
		}

		public function getStageProcessorsByRootView(rootView:Object):Vector.<IStageObjectProcessor> {
			var result:Vector.<IStageObjectProcessor> = new Vector.<IStageObjectProcessor>();
			var selectors:Dictionary = _rootViews[rootView];
			if (selectors != null) {
				for (var selector:* in selectors) {
					result.concat(selectors[selector]);
				}
			}
			return result;
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
		 * Detects whether an object added to the stage is a candidate for processing through
		 * the list of <code>StageProcessorRegistration</code> instances, if any <code>IObjectSelector</code>
		 * approves of the object its associated <code>IStageObjectProcessor</code>'s <code>process()</code> method is invoked.
		 * @param displayObject a reference to the object that was added to the stage
		 * @see org.springextensions.actionscript.stage.StageProcessorRegistration StageProcessorRegistration
		 * @see org.springextensions.actionscript.stage.IStageObjectProcessor IStageObjectProcessor
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

		protected function approveDisplayObjectAfterAdding(displayObject:DisplayObject, objectSelector:IObjectSelector, processors:Vector.<IStageObjectProcessor>):void {
			if (objectSelector.approve(displayObject)) {
				for each (var processor:IStageObjectProcessor in processors) {
					processor.process(displayObject);
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

		protected function approveDisplayObjectAfterRemoving(displayObject:DisplayObject, objectSelector:IObjectSelector, processors:Vector.<IStageObjectProcessor>):void {
			if (objectSelector.approve(displayObject)) {
				for each (var processor:IStageObjectProcessor in processors) {
					if (processor is IStageObjectDestroyer) {
						IStageObjectDestroyer(processor).destroy(displayObject);
					}
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

			// recursively process this display object's children if it is a display object container
			if (displayObject is DisplayObjectContainer) {
				var displayObjectContainer:DisplayObjectContainer = DisplayObjectContainer(displayObject);
				var numChildren:int = displayObjectContainer.numChildren;

				for (var i:int = 0; i < numChildren; ++i) {
					var child:DisplayObject = displayObjectContainer.getChildAt(i);
					processDisplayObjectRecursively(child);
				}
			}
		}

	}
}