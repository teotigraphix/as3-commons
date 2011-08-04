/**
 * Copyright 2009 Maxim Cassian Porges
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package org.as3commons.bytecode.abc.enum {
	import org.as3commons.bytecode.abc.LNamespace;
	import org.as3commons.bytecode.abc.QualifiedName;

	/**
	 * Convenience class with references to the <code>QualifiedName</code>s for commonly-used classes. Note that these
	 * representations will not be appropriate for every use case in opcode blocks, since class references are called in
	 * different multinames based upon how they are being used.
	 *
	 * @see org.as3commons.bytecode.abc.QualifiedName
	 */
	public final class BuiltIns {

		/**
		 * <code>public:void</code>
		 */
		public static const VOID:QualifiedName = new QualifiedName("void", LNamespace.PUBLIC);

		/**
		 * <code>public:Boolean</code>
		 */
		public static const BOOLEAN:QualifiedName = new QualifiedName("Boolean", LNamespace.PUBLIC);

		/**
		 * <code>public:String</code>
		 */
		public static const STRING:QualifiedName = new QualifiedName("String", LNamespace.PUBLIC);

		/**
		 * <code>public:Function</code>
		 */
		public static const FUNCTION:QualifiedName = new QualifiedName("Function", LNamespace.PUBLIC);

		/**
		 * <code>public:Number</code>
		 */
		public static const NUMBER:QualifiedName = new QualifiedName("Number", LNamespace.PUBLIC);

		/**
		 * <code>ANY</code>
		 */
		public static const ANY:QualifiedName = new QualifiedName("*", LNamespace.ASTERISK);

		/**
		 * <code>public:Object</code>
		 */
		public static const OBJECT:QualifiedName = new QualifiedName("Object", LNamespace.PUBLIC);

		/**
		 * <code>flash.utils:Dictionary</code>
		 */
		public static const DICTIONARY:QualifiedName = new QualifiedName("Dictionary", LNamespace.FLASH_UTILS);

	}
}
