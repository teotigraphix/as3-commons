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
	import org.as3commons.bytecode.abc.QualifiedName;
	import org.as3commons.bytecode.abc.TraitInfo;
	import org.as3commons.bytecode.emit.enum.MemberVisibility;

	/**
	 * Describes a base object that is present in an AbcFile.
	 * @author Roland Zwaga
	 */
	public interface IEmitObject {
		/**
		 * The fully qualified package name for the current <code>IEmitObject</code>. I.e. <code>com.myclasses.generated</code>.
		 */
		function get packageName():String;
		/**
		 * @private
		 */
		function set packageName(value:String):void;
		/**
		 * The name of the current <code>IEmitObject</code>.
		 */
		function get name():String;
		/**
		 * @private
		 */
		function set name(value:String):void;
		/**
		 * The visibility of the current <code>IEmitObject</code> within the package.
		 */
		function get visibility():MemberVisibility;
		/**
		 * @private
		 */
		function set visibility(value:MemberVisibility):void;
		/**
		 * The namespace URL that the current <code>IEmitObject</code> belongs to.
		 */
		function get namespaceURI():String;
		/**
		 * @private
		 */
		function set namespaceURI(value:String):void;
		/**
		 * The namespace name that the current <code>IEmitObject</code> belongs to.
		 */
		function get namespaceName():String;
		/**
		 * @private
		 */
		function set namespaceName(value:String):void;
		/**
		 * The <code>TraitInfo</code> that is associated with the current <code>IEmitObject</code>, this is
		 * usually generated automatically and needs not to be set.
		 */
		function get trait():TraitInfo;
		/**
		 * @private
		 */
		function set trait(value:TraitInfo):void;
	}
}