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
package org.as3commons.stageprocessing {
	import flash.display.DisplayObject;
	import flash.display.Stage;
	import flash.utils.Dictionary;

	/**
	 * Describes an object that manages a collection of <code>IStageObjectProcessor</code> instances and their associated <code>IObjectSelectors</code>.
	 * @author Roland Zwaga
	 */
	public interface IStageObjectProcessorRegistry {

		/**
		 * The <code>IObjectSelector</code> that will be used when no instance is passed into the <code>registerStageObjectProcessor()</code> and <code>unregisterStageObjectProcessor()</code>
		 * methods are invoked.
		 */
		function get defaultSelector():IObjectSelector;
		/**
		 * @private
		 */
		function set defaultSelector(value:IObjectSelector):void;

		/**
		 * The <code>Class</code> of the <code>IObjectSelector</code> that will be used when no instance is passed into the <code>registerStageObjectProcessor()</code> and <code>unregisterStageObjectProcessor()</code>
		 * methods are invoked.
		 */
		function get defaultSelectorClass():Class;
		/**
		 * @private
		 */
		function set defaultSelectorClass(value:Class):void;

		/**
		 * Determines if the current <code>IStageProcessorRegistry</code> is enabled.
		 */
		function get enabled():Boolean;

		/**
		 * @private
		 */
		function set enabled(value:Boolean):void;

		/**
		 * True if the current <code>IStageProcessorRegistry</code> has been initialized.
		 */
		function get initialized():Boolean;

		/**
		 * A reference to the Flash stage that is used to add the event listeners to. This property is requried to be s et to a valid reference, otherwise
		 * the <code>IStageObjectProcessorRegistry</code> will not be able to perform its logic.
		 */
		function get stage():Stage;

		/**
		 * Determines whether the current <code>IStageObjectProcessorRegistry</code> will listen for the <code>REMOVED_FROM_STAGE</code> event and
		 * use any registered <code>IStageDestroyers</code>.
		 * @default true
		 */
		function get useStageDestroyers():Boolean;
		/**
		 * @private
		 */
		function set useStageDestroyers(value:Boolean):void;

		/**
		 *
		 * @param displayObject
		 * @param objectSelector
		 * @param processors
		 *
		 */
		function approveDisplayObjectAfterAdding(displayObject:DisplayObject, objectSelector:IObjectSelector, processors:Vector.<IStageObjectProcessor>):void;

		/**
		 * Clears the all processor and context registrations in the current <code>IStageProcessorRegistry</code>
		 */
		function clear():void;

		/**
		 * Retrieves a list of all the <code>IObjectSelectors</code> that have been registered with the current <code>IStageProcessorRegistry</code>.
		 * @return A <code>Vector.&lt;IObjectSelector&gt;</code>.
		 * @see org.as3commons.stageprocessing.IObjectSelector IObjectSelector
		 */
		function getAllObjectSelectors():Vector.<IObjectSelector>;

		/**
		 * Returns a <code>Vector</code> of <code>DisplayObjects</code> that represent all of the root views that have been registered.
		 * @return
		 */
		function getAllRootViews():Vector.<DisplayObject>;

		/**
		 * Retrieves a list of all the <code>IStageProcessors</code> that have been registered with the current <code>IStageProcessorRegistry</code>.
		 * @return A <code>Vector.&lt;IStageProcessor&gt;</code>.
		 * @see org.as3commons.stageprocessing.IStageProcessor IStageProcessor
		 */
		function getAllStageObjectProcessors():Vector.<IStageObjectProcessor>;

		/**
		 *
		 * @param displayObject
		 * @return
		 */
		function getAssociatedObjectSelectors(displayObject:DisplayObject):Dictionary;

		/**
		 * Retrieves the <code>IObjectSelector</code> instances that are associated with the specified <code>IStageProcessor</code> instance.
		 * @param stageProcessor The specified <code>IStageProcessor</code>.
		 * @return The <code>IObjectSelector</code> instances that are associated with the specified <code>IStageProcessor</code>.
		 */
		function getObjectSelectorsForStageProcessor(stageProcessor:IStageObjectProcessor):Vector.<IObjectSelector>;

		/**
		 * Retrieves a list of all the <code>IStageProcessors</code> of the specified <code>Class</code>.
		 * @param type the specified <code>Class</code>.
		 * @return An <code>Vector.&lt;IStageProcessor&gt;</code>.
		 */
		function getStageObjectProcessorsByType(type:Class):Vector.<IStageObjectProcessor>;

		/**
		 * Retrieves a list of all the <code>IStageProcessors</code> that are associated with the specified rootView.
		 * @param rootView The specified rootView
		 * @return a list of <code>IStageProcessors</code> that are associated with the specified rootView.
		 */
		function getStageProcessorsByRootView(rootView:Object):Vector.<IStageObjectProcessor>;

		/**
		 * Performs initialization of the <code>IStageProcessorRegistry</code>.
		 */
		function initialize():void;

		/**
		 *
		 * @param displayObject
		 */
		function processDisplayObject(displayObject:DisplayObject):void;

		/**
		 * Recursively loops through the stage displaylist and processes every object therein.
		 * @param startComponent Optionally a start component can be specified that will be used as the root for recursion.
		 */
		function processStage(startComponent:DisplayObject=null):void;

		/**
		 * Adds the specified <code>IStageProcessor</code> instance to the collection.
		 * @param stageProcessor The specified <code>IStageProcessor</code> instance.
		 * @param objectSelector The specified <code>IObjectSelector</code> instance.
		 */
		function registerStageObjectProcessor(stageProcessor:IStageObjectProcessor, objectSelector:IObjectSelector=null, rootView:DisplayObject=null):void;

		/**
		 * Removes the specified <code>IStageProcessor</code> that is associated with the specified <code>IObjectSelector</code>.
		 * @param name The name of the <code>IStageProcessor</code> that will be removed
		 */
		function unregisterStageObjectProcessor(stageProcessor:IStageObjectProcessor, objectSelector:IObjectSelector=null, rootView:DisplayObject=null):void;

		function unregisterExtraStage(extraStage:Stage):void;
	}
}
