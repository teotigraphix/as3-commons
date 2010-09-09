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
package org.as3commons.bytecode.abc {
	import flash.utils.Dictionary;

	import org.as3commons.bytecode.abc.enum.ConstantKind;
	import org.as3commons.bytecode.as3commons_bytecode;
	import org.as3commons.bytecode.util.Assertions;
	import org.as3commons.lang.StringUtils;

	/**
	 * Wrapper to babysit the Constant Pool.
	 *
	 * <p>
	 * Whenever an item is added to the pool using one of the <code>addXXX()</code> methods, the pool scans
	 * itself to see if it already has a reference to the item being added. If it doesn't, the item is added,
	 * and if it does, then the item is ignored since all entries in to the constant pool should be unique to
	 * maintain a smaller file size (although technically duplicate entries would not cause validate errors).
	 * In either case, the item's index in the appropriate sub-pool is returned to the caller.
	 * </p>
	 *
	 * <p>
	 * There are also convenience <code>getXXX()</code> methods to fetch the indices of items in the pool and
	 * to get handles to the underlying array structures in the pool, but the direct references should only be
	 * used if you know exactly what you are doing. Don't ever use a direct pool array reference on the left
	 * side of an assignment statement; use an <code>addXXX()</code> method instead.
	 * </p>
	 *
	 * @see http://www.adobe.com/devnet/actionscript/articles/avm2overview.pdf "Constant Pool" the in AVM Spec (page 20)
	 */
	//TODO: There are a lot of opportunities for fast-lookup optimizations here, such as using dictionaries instead of looping over collections
	public class ConstantPool {
		private static const NAMESPACE_SET_PROPERTYNAME:String = "namespaceSet";
		private static const NAME_PROPERTYNAME:String = "name";
		private var _integerPool:Array;
		private var _uintPool:Array;
		private var _doublePool:Array;
		private var _stringPool:Array;
		private var _namespacePool:Array;
		private var _namespaceSetPool:Array;
		private var _multinamePool:Array;

		private var _lookup:Dictionary;

		/**
		 * Constructs and initializes a fresh <code>ConstantPool</code> instance. All the pools
		 * are created and the zero/default entries are placed in to the pool. These values
		 * are obviated from the AVM file since they are constants, but need to be accounted
		 * for during serialization routines.
		 */
		public function ConstantPool() {
			super();
			initConstantPool();
		}

		protected function initConstantPool():void {
			_integerPool = [0];
			_uintPool = [0];
			_doublePool = [0];
			_stringPool = [LNamespace.ASTERISK.name];

			_namespacePool = [];
			addNamespace(LNamespace.ASTERISK);

			_namespaceSetPool = [];
			addNamespaceSet(new NamespaceSet([LNamespace.ASTERISK]));

			_multinamePool = [];
			addMultiname(new QualifiedName(LNamespace.ASTERISK.name, LNamespace.ASTERISK));

			_lookup = new Dictionary();
			_lookup[ConstantKind.INT] = _integerPool;
			_lookup[ConstantKind.UINT] = _uintPool;
			_lookup[ConstantKind.DOUBLE] = _doublePool;
			_lookup[ConstantKind.UTF8] = _stringPool;
			_lookup[ConstantKind.NAMESPACE] = _namespacePool;
			_lookup[ConstantKind.PACKAGE_NAMESPACE] = _namespacePool;
			_lookup[ConstantKind.PACKAGE_INTERNAL_NAMESPACE] = _namespacePool;
			_lookup[ConstantKind.PROTECTED_NAMESPACE] = _namespacePool;
			_lookup[ConstantKind.EXPLICIT_NAMESPACE] = _namespacePool;
			_lookup[ConstantKind.STATIC_PROTECTED_NAMESPACE] = _namespacePool;
			_lookup[ConstantKind.PRIVATE_NAMESPACE] = _namespacePool;
			_lookup[ConstantKind.TRUE] = true;
			_lookup[ConstantKind.FALSE] = false;
			_lookup[ConstantKind.NULL] = null;
			_lookup[ConstantKind.UNDEFINED] = undefined;
		}

		public function getConstantPoolItem(constantKindValue:uint, poolIndex:uint):* {
			var constantKind:ConstantKind = ConstantKind.determineKind(constantKindValue);
			var retVal:* = _lookup[constantKind];
			return (retVal is Array) ? retVal[poolIndex] : retVal;
		}

		public function getConstantPoolItemIndex(constantKindValue:ConstantKind, item:*):int {
			var retVal:* = _lookup[constantKindValue];
			return (retVal is Array) ? (retVal as Array).indexOf(item) : -1;
		}

		/**
		 * Gets a direct reference to the underlying integer pool. NEVER USE THIS FOR ASSIGNMENTS - use <code>addInt()</code> instead.
		 *
		 * @see #addInt()
		 */
		public function get integerPool():Array {
			return _integerPool;
		}

		as3commons_bytecode function setIntegerPool(value:Array):void {
			_integerPool = value;
		}

		/**
		 * Gets a direct reference to the underlying uint pool. NEVER USE THIS FOR ASSIGNMENTS - use <code>addUint()</code> instead.
		 *
		 * @see #addUint()
		 */
		public function get uintPool():Array {
			return _uintPool;
		}

		as3commons_bytecode function setUintPool(value:Array):void {
			_uintPool = value;
		}

		/**
		 * Gets a direct reference to the underlying double pool. NEVER USE THIS FOR ASSIGNMENTS - use <code>addDouble()</code> instead.
		 *
		 * @see #addDouble()
		 */
		public function get doublePool():Array {
			return _doublePool;
		}

		as3commons_bytecode function setDoublePool(value:Array):void {
			_doublePool = value;
		}

		/**
		 * Gets a direct reference to the underlying <code>String</code> pool. NEVER USE THIS FOR ASSIGNMENTS - use <code>addString()</code> instead.
		 *
		 * @see #addString()
		 */
		public function get stringPool():Array {
			return _stringPool;
		}

		as3commons_bytecode function setStringPool(value:Array):void {
			_stringPool = value;
		}

		/**
		 * Gets a direct reference to the underlying <code>LNamespace</code> pool. NEVER USE THIS FOR ASSIGNMENTS - use <code>addNamespace()</code> instead.
		 *
		 * @see #addNamespace()
		 * @see LNamespace
		 */
		public function get namespacePool():Array {
			return _namespacePool;
		}

		as3commons_bytecode function setNamespacePool(value:Array):void {
			_namespacePool = value;
		}

		/**
		 * Gets a direct reference to the underlying <code>NamespaceSet</code> pool. NEVER USE THIS FOR ASSIGNMENTS - use <code>addNamespaceSet()</code> instead.
		 *
		 * @see #addNamespaceSet()
		 * @see NamespaceSet
		 */
		public function get namespaceSetPool():Array {
			return _namespaceSetPool;
		}

		as3commons_bytecode function setNamespaceSetPool(value:Array):void {
			_namespaceSetPool = value;
		}

		/**
		 * Gets a direct reference to the underlying <code>BaseMultiname</code> pool. NEVER USE THIS FOR ASSIGNMENTS - use <code>addMultiname()</code> instead.
		 *
		 * @see #addMultiname()
		 * @see BaseMultiname
		 */
		public function get multinamePool():Array {
			return _multinamePool;
		}

		as3commons_bytecode function setMultinamePool(value:Array):void {
			_multinamePool = value;
		}

		/**
		 * Adds a <code>BaseMultiname</code> to the multiname pool. If a <code>NamedMultiname</code> is given as the parameter, this method will add the name of the multiname
		 * to the <code>String</code> pool as a convenience.
		 *
		 * @param multiname   The multiname to add to the multiname pool.
		 * @return    The position of the multiname in the pool.
		 *
		 * @see   BaseMultiname
		 * @see   NamedMultiname
		 */
		public function addMultiname(multiname:BaseMultiname):int {
			if (multiname is NamedMultiname) {
				addString(NamedMultiname(multiname).name);
			}

			if (multiname.hasOwnProperty(NAMESPACE_SET_PROPERTYNAME)) {
				addNamespaceSet(multiname[NAMESPACE_SET_PROPERTYNAME]);
			}

			var multinameIndex:int = -1;
			_multinamePool.every(function(element:BaseMultiname, index:int, array:Array):Boolean {
				if (element.equals(multiname)) {
					multinameIndex = index;
					return false;
				} else {
					return true;
				}
			});

			if (multinameIndex == -1) {
				multinameIndex = _multinamePool.push(multiname);
			}

			return multinameIndex;
		}

		/**
		 * Used to add objects with explicitly defined equals() methods to a pool.
		 */
		//TODO: Make an interface for these types?
		private function addObject(pool:Array, object:Object):int {
			if (object.hasOwnProperty(NAME_PROPERTYNAME)) {
				addString(object.name);
			}

			var matchingIndex:int = -1;
			pool.every(function(element:Object, index:int, array:Array):Boolean {
				if (element.equals(object)) {
					matchingIndex = index;
					return false;
				} else {
					return true;
				}
			});

			if (matchingIndex == -1) {
				matchingIndex = pool.push(object) - 1;
			}

			return matchingIndex;
		}

		public function getStringPosition(string:String):int {
			return _stringPool.indexOf(string);
		}

		public function getIntPosition(intValue:int):int {
			return _integerPool.indexOf(intValue);
		}

		public function getUintPosition(uintValue:uint):int {
			return _uintPool.indexOf(uintValue);
		}

		public function getDoublePosition(doubleValue:Number):int {
			return _doublePool.indexOf(doubleValue);
		}

		public function getNamespacePosition(namespaze:LNamespace):int {
			var index:int = -1;
			for (var i:int = 0; i < _namespacePool.length; ++i) {
				if (_namespacePool[i].equals(namespaze)) {
					index = i;
					break;
				}
			}

			return index;
		}

		//TODO: Clean up all these replicated lookup functions with an interface spec 
		public function getNamespaceSetPosition(namespaceSet:NamespaceSet):int {
			var index:int = -1;
			for (var i:int = 0; i < _namespaceSetPool.length; ++i) {
				if (_namespaceSetPool[i].equals(namespaceSet)) {
					index = i;
					break;
				}
			}

			return index;
		}

		public function getMultinamePosition(multiname:BaseMultiname):int {
			var index:int = -1;
			for (var i:int = 0; i < _multinamePool.length; ++i) {
				if (_multinamePool[i].equals(multiname)) {
					index = i;
					break;
				}
			}
			return index;
		}

		public function getMultinamePositionByName(multinameName:String):int {
			var multinameIndex:int = -1;
			for (var i:int = 0; i < _multinamePool.length; ++i) {
				var multiname:BaseMultiname = _multinamePool[i];
				if (multiname is NamedMultiname) {
					if (NamedMultiname(multiname).name == multinameName) {
						multinameIndex = i;
						break;
					}
				}
			}

			return multinameIndex;
		}

		/**
		 * Adds a <code>String</code> to the string pool.
		 *
		 * @param string   The string to add to the string pool.
		 * @return    The position of the string in the pool.
		 */
		public function addString(string:String):int {
			return addToPool(_stringPool, string);
		}

		/**
		 * Adds an <code>int</code> to the integer pool.
		 *
		 * @param integer   The <code>int</code> to add to the integer pool.
		 * @return    The position of the <code>int</code> in the pool.
		 */
		public function addInt(integer:int):int {
			return addToPool(_integerPool, integer);
		}

		/**
		 * Adds an <code>uint</code> to the unsigned integer pool.
		 *
		 * @param uinteger   The <code>uint</code> to add to the unsigned integer pool.
		 * @return    The position of the <code>uint</code> in the pool.
		 */
		public function addUint(uinteger:uint):int {
			return addToPool(_uintPool, uinteger);
		}

		/**
		 * Adds a <code>Number</code> to the double pool.
		 *
		 * @param double   The <code>Number</code> to add to the double pool.
		 * @return    The position of the <code>Number</code> in the pool.
		 */
		public function addDouble(double:Number):int {
			return addToPool(_doublePool, double);
		}

		/**
		 * Adds a <code>LNamespace</code> to the namespace pool.
		 *
		 * @param namespaceValue   The <code>LNamespace</code> to add to the namespace pool.
		 * @return    The position of the <code>LNamespace</code> in the pool.
		 */
		public function addNamespace(namespaceValue:LNamespace):int {
//			if (namespaceValue == null)
//			{
//				trace(namespaceValue);
//			}

			addString(namespaceValue.name);
			return addObject(_namespacePool, namespaceValue);
		}

		/**
		 * Adds a <code>NamespaceSet</code> to the namespace pool. Also iterates the set and adds every LNamespace in the set
		 * to the namespace pool using <code>addNamespace()</code> as a convenience.
		 *
		 * @param namespaceSet   The <code>NamespaceSet</code> to add to the namespace set pool.
		 * @return    The position of the <code>NamespaceSet</code> in the pool.
		 * @see    LNamespace
		 */
		public function addNamespaceSet(namespaceSet:NamespaceSet):int {
			for each (var namespaze:LNamespace in namespaceSet.namespaces) {
				addNamespace(namespaze);
			}

			return addObject(_namespaceSetPool, namespaceSet);
		}

		/**
		 * Adds items without explicit <code>equals()</code> methods to the specified pool.
		 *
		 * @param pool    The pool to add the item to.
		 * @param item    The item to add to the pool.
		 */
		public function addToPool(pool:Array, item:Object):int {
			var index:int = pool.indexOf(item);
			if (index == -1) {
				index = pool.push(item) - 1;
			}

			return index;
		}

		/**
		 * Performs a deep inspection of all the items in every pool in the constant pool, comparing them to the equivalent
		 * pool in the given constant pool. Values are compared based upon value and not object instance, so two different
		 * objects with identical semantic meaning are considered the same.
		 *
		 * @param constantPool    The constant pool to compare this constant pool instance against.
		 * @return    True if the pools match, false otherwise.
		 */
		public function equals(constantPool:ConstantPool):Boolean {
			return Assertions.assertArrayContentsEqual(this._integerPool, constantPool._integerPool) && Assertions.assertArrayContentsEqual(this._uintPool, constantPool._uintPool) && Assertions.assertArrayContentsEqual(this._doublePool, constantPool._doublePool) && Assertions.assertArrayContentsEqual(this._stringPool, constantPool._stringPool) && Assertions.assertArrayContentsEqual(this._namespacePool, constantPool._namespacePool) && Assertions.assertArrayContentsEqual(this._namespaceSetPool, constantPool._namespaceSetPool) && Assertions.assertArrayContentsEqual(this._multinamePool, constantPool._multinamePool);
		}

		/**
		 * Creates a printable representation of this object instance.
		 *
		 * @return    This constant pool instance represented as a <code>String</code>.
		 */
		public function toString():String {
			return StringUtils.substitute("Integer Pool: {0}\n" + "Uint Pool: {1}\n" + "Double Pool: {2}\n" + "String Pool:\n\t{3}" + "\nNamespace Pool:\n\t{4}" + "\nNamespace Set Pool:\n\t{5}" + "\nMultiname Pool:\n\t{6}", _integerPool.join(), _uintPool.join(), _doublePool.join(), _stringPool.join("\n\t"), _namespacePool.join("\n\t"), _namespaceSetPool.join("\n\t"), _multinamePool.join("\n\t"));
		}
	}
}