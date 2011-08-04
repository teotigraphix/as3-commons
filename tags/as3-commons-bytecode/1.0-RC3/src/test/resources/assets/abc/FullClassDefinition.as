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
// Compile me with the following to include the metadata and interface info: asc -md -import Interface.abc -import custom_namespace.abc FullClassDefinition.as
//TODO: Override a method
//TODO: Add error info
//TODO: Param names
package assets.abc
{
	import flash.utils.Dictionary;
	import assets.abc.custom_namespace;
	
	use namespace custom_namespace;
	
	[ClassMetadata(classKey1="classValue1", classKey2="classValue2", classKey3="classValue3")]
	[ValueOnlyMetadata("valueOnlyValue")]
	[ValuelessMetadata]
	public class FullClassDefinition implements Interface 
	{
		public static const PUBLIC_STATIC_CONSTANT : String = "PUBLIC_STATIC_CONSTANT";
		private static const SOME_STATIC_CONSTANT : String = "SOME_STATIC_CONSTANT";
		private static var SOME_STATIC_VAR : String;
		{
			SOME_STATIC_VAR = "SOME_STATIC_VAR";
		}
		
    	[FieldMetadata(fieldKey1="fieldValue1", fieldKey2="fieldValue2")]
        private var dictionary : Dictionary;
        private var _internalValue : String;
        
        //NOTE: There is no such thing as constructor metadata
		public function FullClassDefinition()
		{
			dictionary = new Dictionary();
			trace("Constructor");
		}

        [MethodMetadata(methodKey1="methodValue1", methodKey2="methodValue2")]
		public function methodWithNoArguments() : void
		{
			trace("methodWithNoArguments");
		}

		public function methodWithTwoArguments(stringArgument : String, intArgument : int) : void
		{
			trace("methodWithTwoArguments");
		}

        public function methodWithOptionalArguments(requiredArgument : String, optionalStringArgument : String = null, optionalIntArgument : int = 10) : void
        {
			trace("methodWithOptionalArguments");
        }

        public function methodWithRestArguments(requiredArgument : String, ... rest) : void
        {
			trace("methodWithRestArguments");
        }
        
        public static function staticMethod() : void
        {
        	trace("staticMethod");
        }
        
        public function implementMeOrDie() : void
        {
        	trace("I don't want to die.");
        }

        public function set setterForInternalValue(value : String) : void
        {
            _internalValue = value;
        }

        public function get getterForInternalValue() : String
        {
            return _internalValue;
        }
        
        custom_namespace function customNamespaceFunction() : void
        {
        	trace("customNamespaceFunction");
        }
	}
}