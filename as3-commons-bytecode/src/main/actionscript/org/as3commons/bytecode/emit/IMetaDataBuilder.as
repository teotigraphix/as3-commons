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
package org.as3commons.bytecode.emit {
	import org.as3commons.bytecode.emit.impl.MetaDataArgument;
	import org.as3commons.bytecode.typeinfo.Metadata;

	/**
	 * Describes an object that can generate a metadata entry for use in an <code>AbcFile</code>.
	 * @author Roland Zwaga
	 */
	public interface IMetaDataBuilder {
		/**
		 * The name of the metadata entry. I.e. <code>[Event]</code>.
		 */
		function get name():String;
		/**
		 * @private
		 */
		function set name(value:String):void;
		/**
		 * An array of key value pairs that describe the metadata arguments. I.e. <code>[Event(name="complete",type="flash.events.Event")]</code>.
		 */
		function get arguments():Array;
		/**
		 * @private
		 */
		function set arguments(value:Array):void;
		/**
		 * Defines an argument for the current <code>IMetaDataBuilder</code>.
		 */
		function defineArgument():MetaDataArgument;
		/**
		 * Internally used build method, this method should never be called by third parties.
		 * @param applicationDomain
		 * @return
		 */
		function build():Metadata;
	}
}