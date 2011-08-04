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
package org.as3commons.bytecode.emit.impl {
	import org.as3commons.bytecode.abc.QualifiedName;
	import org.as3commons.lang.StringUtils;

	/**
	 * Describes the way a member of a complex type will be instantiated in a generated class.
	 * @author Roland Zwaga
	 */
	public final class MemberInitialization {

		/**
		 * Creates a new <code>MemberInitialization</code> instance.
		 */
		public function MemberInitialization() {
			super();
		}

		/**
		 * Determines if the member class should be instantiated, returns true if the <code>factoryMethodName</code> property is <code>null</code>.
		 */
		public function get createNewClass():Boolean {
			return !StringUtils.hasText(factoryMethodName);
		}

		/**
		 * An optional <code>Array</code> of constructor arguments that will be passed to the <code>Class</code> constructor or factory method.
		 */
		public var constructorArguments:Array = [];

		/**
		 * A factory method that will be used to instantiate the class. The factory method is assumed to be part of the generated class, unless a fully qualified
		 * static method path is assigned. I.e. <code>com.myclasses.factories.MyFactory.createInstance</code>
		 */
		public var factoryMethodName:String;
	}
}