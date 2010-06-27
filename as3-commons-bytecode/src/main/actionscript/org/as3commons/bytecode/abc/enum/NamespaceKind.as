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
package org.as3commons.bytecode.abc.enum
{
	import flash.utils.Dictionary;
	
    /**
     * Loom representation of possible values for the kinds of namespaces in the ABC file format.
     * 
     * @see http://www.adobe.com/devnet/actionscript/articles/avm2overview.pdf     "Namespace Kind" in the AVM Spec (page 22)
     */
    public class NamespaceKind
    {
    	private static var _TYPES : Dictionary = new Dictionary(); 
    	
    	private var _byteValue : uint;
    	private var _description : String;
    	
        public static const NAMESPACE : NamespaceKind = new NamespaceKind(0x08, "namespace");
        public static const PACKAGE_NAMESPACE : NamespaceKind = new NamespaceKind(0x16, "public");
        public static const PACKAGE_INTERNAL_NAMESPACE : NamespaceKind = new NamespaceKind(0x17, "packageInternalNamespace");
        public static const PROTECTED_NAMESPACE : NamespaceKind = new NamespaceKind(0x18, "protectedNamespace");
        public static const EXPLICIT_NAMESPACE : NamespaceKind = new NamespaceKind(0x19, "explicitNamespace");
        public static const STATIC_PROTECTED_NAMESPACE : NamespaceKind = new NamespaceKind(0x1A, "staticProtectedNamespace");
        public static const PRIVATE_NAMESPACE : NamespaceKind = new NamespaceKind(0x05, "private");
        
        public function NamespaceKind(byteValue : uint, description : String)
        {
        	_byteValue = byteValue;
        	_description = description;
        	
        	_TYPES[byteValue] = this;
        }
        
        public function get byteValue() : int
        {
        	return _byteValue;
        }

        public function get description() : String
        {
        	return _description;
        }
        
        public static function get types() : Array
        {
        	var typesArray : Array = [];
        	for (var typeKey : String in _TYPES)
        	{
        		typesArray.push(_TYPES[typeKey]);
        	}
        	
        	return typesArray;
        }
        
        public static function determineKind(kindByte : int) : NamespaceKind
        {
        	var kind : NamespaceKind = _TYPES[kindByte];
        	if (kind == null)
        	{
        		throw new Error("Unknown NamespaceKind: " + kindByte);
        	}

            return kind;
        }
    }
}