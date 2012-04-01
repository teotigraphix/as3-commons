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
	import flash.errors.IllegalOperationError;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;

	import org.as3commons.bytecode.abc.enum.ConstantKind;
	import org.as3commons.bytecode.as3commons_bytecode;
	import org.as3commons.bytecode.util.Assertions;
	import org.as3commons.bytecode.util.StringLookup;
	import org.as3commons.lang.Assert;
	import org.as3commons.lang.IEquals;
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
	public final class ConstantPool implements IEquals, IConstantPool {

		private static const NAMESPACE_SET_PROPERTYNAME:String = "namespaceSet";
		private static const NAME_PROPERTYNAME:String = "name";
		private static const LOCKED_CONSTANTPOOL_ERROR:String = "Constantpool is locked";

		private var _dupeCheck:Boolean = true;
		private var _integerPool:Vector.<int>;
		private var _integerLookup:Dictionary;
		private var _uintPool:Vector.<uint>;
		private var _uintLookup:Dictionary;
		private var _doublePool:Vector.<Number>;
		private var _doubleLookup:Dictionary;
		private var _stringPool:Vector.<String>;
		private var _stringLookup:StringLookup;
		private var _namespacePool:Vector.<LNamespace>;
		private var _namespaceLookup:Dictionary;
		private var _namespaceSetPool:Vector.<NamespaceSet>;
		private var _namespaceSetLookup:Dictionary;
		private var _multinamePool:Vector.<BaseMultiname>;
		private var _classInfo:Vector.<ClassInfo>;
		private var _multinameLookup:Dictionary;
		private var _lookup:Dictionary;
		private var _locked:Boolean = false;
		private var _rawConstantPool:ByteArray;

		/**
		 * Constructs and initializes a fresh <code>ConstantPool</code> instance. All the pools
		 * are created and the zero/default entries are placed in to the pool. These values
		 * are obviated from the AVM file since they are constants, but need to be accounted
		 * for during serialization routines.
		 */
		public function ConstantPool() {
			super();
			reset();
		}

		public function get locked():Boolean {
			return _locked;
		}

		public function set locked(value:Boolean):void {
			_locked = value;
		}

		public function get dupeCheck():Boolean {
			return _dupeCheck;
		}

		public function set dupeCheck(value:Boolean):void {
			_dupeCheck = value;
		}

		public function reset():void {
			_integerLookup = new Dictionary();
			_uintLookup = new Dictionary();
			_doubleLookup = new Dictionary();
			_stringLookup = new StringLookup();
			_namespaceLookup = new Dictionary();
			_namespaceSetLookup = new Dictionary();
			_multinameLookup = new Dictionary();

			_integerPool = new <int>[0];
			_uintPool = new <uint>[0];
			_doublePool = new <Number>[NaN];
			_classInfo = new Vector.<ClassInfo>;
			_stringPool = new <String>[LNamespace.ASTERISK.name];

			_integerLookup[0] = 0;
			_uintLookup[0] = 0;
			_doubleLookup[NaN] = 0;
			_stringLookup.set(LNamespace.ASTERISK.name, 0);

			_namespacePool = new <LNamespace>[LNamespace.ASTERISK];
			_namespaceLookup[LNamespace.ASTERISK.toString()] = 0;

			_namespaceSetPool = new <NamespaceSet>[new NamespaceSet([LNamespace.ASTERISK])];
			_namespaceSetLookup[_namespaceSetPool[0].toString()] = 0;

			_multinamePool = new <BaseMultiname>[new QualifiedName(LNamespace.ASTERISK.name, LNamespace.ASTERISK)];
			_multinameLookup[_multinamePool[0].toString()] = 0;

			_lookup = new Dictionary();
			_lookup[ConstantKind.INT] = [_integerPool, _integerLookup];
			_lookup[ConstantKind.UINT] = [_uintPool, _uintLookup];
			_lookup[ConstantKind.DOUBLE] = [_doublePool, _doubleLookup];
			_lookup[ConstantKind.UTF8] = [_stringPool, _stringLookup];
			_lookup[ConstantKind.NAMESPACE] = [_namespacePool, _namespaceLookup];
			_lookup[ConstantKind.PACKAGE_NAMESPACE] = [_namespacePool, _namespaceLookup];
			_lookup[ConstantKind.PACKAGE_INTERNAL_NAMESPACE] = [_namespacePool, _namespaceLookup];
			_lookup[ConstantKind.PROTECTED_NAMESPACE] = [_namespacePool, _namespaceLookup];
			_lookup[ConstantKind.EXPLICIT_NAMESPACE] = [_namespacePool, _namespaceLookup];
			_lookup[ConstantKind.STATIC_PROTECTED_NAMESPACE] = [_namespacePool, _namespaceLookup];
			_lookup[ConstantKind.PRIVATE_NAMESPACE] = [_namespacePool, _namespaceLookup];
			_lookup[ConstantKind.TRUE] = true;
			_lookup[ConstantKind.FALSE] = false;
			_lookup[ConstantKind.NULL] = null;
			_lookup[ConstantKind.UNDEFINED] = undefined;
		}

		public function getConstantPoolItem(constantKindValue:uint, poolIndex:uint):* {
			var constantKind:ConstantKind = ConstantKind.determineKind(constantKindValue);
			var retVal:* = _lookup[constantKind];
			return (retVal is Array) ? retVal[0][poolIndex] : retVal;
		}

		public function getConstantPoolItemIndex(constantKind:ConstantKind, item:*):int {
			var retVal:* = _lookup[constantKind];
			return (retVal is Array) ? (retVal[1] is Dictionary) ? retVal[1][item] : retVal[1].get(item) : -1;
		}

		public function addItemToPool(constantKindValue:ConstantKind, item:*):int {
			var pool:* = _lookup[constantKindValue];
			if (pool is Array) {
				return addToPool(pool[0], pool[1], item);
			} else {
				return 1;
			}
		}

		/**
		 * Gets a direct reference to the underlying integer pool. NEVER USE THIS FOR ASSIGNMENTS - use <code>addInt()</code> instead.
		 *
		 * @see #addInt()
		 */
		public function get integerPool():Vector.<int> {
			return _integerPool;
		}

		as3commons_bytecode function setIntegerPool(value:Vector.<int>):void {
			_integerPool = value;
		}

		/**
		 * Gets a direct reference to the underlying uint pool. NEVER USE THIS FOR ASSIGNMENTS - use <code>addUint()</code> instead.
		 *
		 * @see #addUint()
		 */
		public function get uintPool():Vector.<uint> {
			return _uintPool;
		}

		as3commons_bytecode function setUintPool(value:Vector.<uint>):void {
			_uintPool = value;
		}

		/**
		 * Gets a direct reference to the underlying double pool. NEVER USE THIS FOR ASSIGNMENTS - use <code>addDouble()</code> instead.
		 *
		 * @see #addDouble()
		 */
		public function get doublePool():Vector.<Number> {
			return _doublePool;
		}

		as3commons_bytecode function setDoublePool(value:Vector.<Number>):void {
			_doublePool = value;
		}

		/**
		 * Gets a direct reference to the underlying <code>String</code> pool. NEVER USE THIS FOR ASSIGNMENTS - use <code>addString()</code> instead.
		 *
		 * @see #addString()
		 */
		public function get stringPool():Vector.<String> {
			return _stringPool;
		}

		as3commons_bytecode function setStringPool(value:Vector.<String>):void {
			_stringPool = value;
		}

		/**
		 * Gets a direct reference to the underlying <code>LNamespace</code> pool. NEVER USE THIS FOR ASSIGNMENTS - use <code>addNamespace()</code> instead.
		 *
		 * @see #addNamespace()
		 * @see LNamespace
		 */
		public function get namespacePool():Vector.<LNamespace> {
			return _namespacePool;
		}

		as3commons_bytecode function setNamespacePool(value:Vector.<LNamespace>):void {
			_namespacePool = value;
		}

		/**
		 * Gets a direct reference to the underlying <code>NamespaceSet</code> pool. NEVER USE THIS FOR ASSIGNMENTS - use <code>addNamespaceSet()</code> instead.
		 *
		 * @see #addNamespaceSet()
		 * @see NamespaceSet
		 */
		public function get namespaceSetPool():Vector.<NamespaceSet> {
			return _namespaceSetPool;
		}

		as3commons_bytecode function setNamespaceSetPool(value:Vector.<NamespaceSet>):void {
			_namespaceSetPool = value;
		}

		/**
		 * Gets a direct reference to the underlying <code>BaseMultiname</code> pool. NEVER USE THIS FOR ASSIGNMENTS - use <code>addMultiname()</code> instead.
		 *
		 * @see #addMultiname()
		 * @see BaseMultiname
		 */
		public function get multinamePool():Vector.<BaseMultiname> {
			return _multinamePool;
		}

		as3commons_bytecode function setMultinamePool(value:Vector.<BaseMultiname>):void {
			_multinamePool = value;
		}

		public function get classInfo():Vector.<ClassInfo> {
			return _classInfo;
		}

		as3commons_bytecode function setClassInfo(value:Vector.<ClassInfo>):void {
			_classInfo = value;
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
			//validateMultiname(multiname);
			if (multiname is NamedMultiname) {
				addString(NamedMultiname(multiname).name);
			}

			if (multiname.hasOwnProperty(NAMESPACE_SET_PROPERTYNAME)) {
				addNamespaceSet(multiname[NAMESPACE_SET_PROPERTYNAME]);
			}

			if (multiname is QualifiedName) {
				addNamespace(QualifiedName(multiname).nameSpace);
			}

			if (multiname is MultinameG) {
				var mg:MultinameG = multiname as MultinameG;
				addMultiname(mg.qualifiedName);
				for each (var qn:BaseMultiname in mg.parameters) {
					addMultiname(qn);
				}
			}

			var multinameIndex:int = -1;
			if (_dupeCheck) {
				multinameIndex = addObject(_multinamePool, _multinameLookup, multiname);
			}

			if (multinameIndex == -1) {
				if (!locked) {
					multinameIndex = _multinamePool.push(multiname) - 1;
					multiname.poolIndex = multinameIndex;
				} else {
					throw new Error(LOCKED_CONSTANTPOOL_ERROR);
				}
			}

			return multinameIndex;
		}

		protected function validateMultiname(multiname:BaseMultiname):void {
			if (multiname.kind == null) {
				throw new IllegalOperationError("Illegal multiname: " + multiname.toString());
			}
			switch (true) {
				case (multiname is QualifiedName):
					var qName:QualifiedName = QualifiedName(multiname);
					if (qName.name == null) {
						throw new IllegalOperationError("Illegal QualifiedName: " + qName.toString());
					}
					if (qName.nameSpace == null) {
						throw new IllegalOperationError("Illegal QualifiedName: " + qName.toString());
					}
					if (!validateNamespace(qName.nameSpace)) {
						throw new IllegalOperationError("Illegal QualifiedName: " + qName.toString());
					}
					break;
			}
		}

		protected function validateNamespace(namesp:LNamespace):Boolean {
			return !(namesp.name == null);
		}

		/**
		 * Used to add objects with explicitly defined equals() methods to a pool.
		 */
		//TODO: Make an interface for these types?
		private function addObject(pool:*, lookup:Dictionary, object:Object):int {
			if (object.hasOwnProperty(NAME_PROPERTYNAME)) {
				addString(object.name);
			}

			var key:String = null;
			var matchingIndex:int = -1;
			if (_dupeCheck) {
				key = object.toString();
				var n:* = lookup[key];
				matchingIndex = (n != null) ? n : -1;
			}

			if (matchingIndex == -1) {
				if (!locked) {
					matchingIndex = pool.push(object) - 1;
					key ||= object.toString();
					lookup[key] = matchingIndex;
				} else {
					throw new Error(LOCKED_CONSTANTPOOL_ERROR);
				}
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
			var len:uint = _namespacePool.length;
			for (var i:int = 0; i < len; ++i) {
				if (IEquals(_namespacePool[i]).equals(namespaze)) {
					index = i;
					break;
				}
			}

			return index;
		}

		//TODO: Clean up all these replicated lookup functions with an interface spec 
		public function getNamespaceSetPosition(namespaceSet:NamespaceSet):int {
			var index:int = -1;
			var len:uint = _namespaceSetPool.length;
			for (var i:int = 0; i < len; ++i) {
				if (IEquals(_namespaceSetPool[i]).equals(namespaceSet)) {
					index = i;
					break;
				}
			}

			return index;
		}

		public function getMultinamePosition(multiname:BaseMultiname):int {
			var index:int = -1;
			var len:uint = _multinamePool.length;
			for (var i:int = 0; i < len; ++i) {
				if (IEquals(_multinamePool[i]).equals(multiname)) {
					index = i;
					break;
				}
			}
			return index;
		}

		public function getMultinamePositionByName(multinameName:String):int {
			var multinameIndex:int = -1;
			var len:uint = _multinamePool.length;
			for (var i:int = 0; i < len; ++i) {
				var multiname:NamedMultiname = _multinamePool[i] as NamedMultiname;
				if (multiname != null) {
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
			return addToPool(_stringPool, _stringLookup, string);
		}

		/**
		 * Adds an <code>int</code> to the integer pool.
		 *
		 * @param integer   The <code>int</code> to add to the integer pool.
		 * @return    The position of the <code>int</code> in the pool.
		 */
		public function addInt(integer:int):int {
			return addToPool(_integerPool, _integerLookup, integer);
		}

		/**
		 * Adds an <code>uint</code> to the unsigned integer pool.
		 *
		 * @param uinteger   The <code>uint</code> to add to the unsigned integer pool.
		 * @return    The position of the <code>uint</code> in the pool.
		 */
		public function addUint(uinteger:uint):int {
			return addToPool(_uintPool, _uintLookup, uinteger);
		}

		/**
		 * Adds a <code>Number</code> to the double pool.
		 *
		 * @param double   The <code>Number</code> to add to the double pool.
		 * @return    The position of the <code>Number</code> in the pool.
		 */
		public function addDouble(double:Number):int {
			return addToPool(_doublePool, _doubleLookup, double);
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
			return addObject(_namespacePool, _namespaceLookup, namespaceValue);
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

			return addObject(_namespaceSetPool, _namespaceSetLookup, namespaceSet);
		}

		public function initializeLookups():void {
			var idx:int = 0;
			for each (var i:int in _integerPool) {
				_integerLookup[i] = idx++;
			}
			idx = 0;
			for each (var u:uint in _uintPool) {
				_uintLookup[u] = idx++;
			}
			idx = 0;
			for each (var n:Number in _doublePool) {
				_doubleLookup[n] = idx++;
			}
			idx = 0;
			for each (var s:String in _stringPool) {
				_stringLookup.set(s, idx++);
			}
			idx = 0;
			for each (var mn:BaseMultiname in _multinamePool) {
				_multinameLookup[mn.toString()] = idx++;
			}
			idx = 0;
			for each (var ns:LNamespace in _namespacePool) {
				_namespaceLookup[ns.toString()] = idx++;
			}
			idx = 0;
			for each (var nss:NamespaceSet in _namespaceSetPool) {
				_namespaceSetLookup[nss.toString()] = idx++;
			}
		}

		/**
		 * Adds items without explicit <code>equals()</code> methods to the specified pool.
		 *
		 * @param pool    The pool to add the item to.
		 * @param lookup    The item to index Dictionary.
		 * @param item    The item to add to the pool.
		 */
		public function addToPool(pool:*, lookup:*, item:Object):int {
			CONFIG::debug {
				Assert.notNull(pool, "pool instance cannot be null");
				Assert.notNull(lookup, "lookup instance cannot be null");
				Assert.notNull(item, "constant pool item cannot be null");
			}

			var n:* = (lookup is Dictionary) ? lookup[item] : lookup.get(item);
			var index:int = (n != null) ? n : -1;
			if (index > -1) {
				return index;
			}

			if (!locked) {
				index = pool.push(item) - 1;
			} else {
				throw new Error(LOCKED_CONSTANTPOOL_ERROR);
			}

			if (lookup is Dictionary) {
				lookup[item] = index;
			} else {
				lookup.set(item, index);
			}

			return index;
		}

		/**
		 * Performs a deep inspection of all the items in every pool in the constant pool, comparing them to the equivalent
		 * pool in the given constant pool. Values are compared based upon value and not object instance, so two different
		 * objects with identical semantic meaning are considered the same.
		 *
		 * @param other The constant pool to compare this constant pool instance against.
		 * @return True if the pools match, false otherwise.
		 */
		public function equals(other:Object):Boolean {
			var constantPool:ConstantPool = ConstantPool(other);
			return Assertions.assertArrayContentsEqual(this._integerPool, constantPool._integerPool) && Assertions.assertArrayContentsEqual(this._uintPool, constantPool._uintPool) && Assertions.assertArrayContentsEqual(this._doublePool, constantPool._doublePool) && Assertions.assertArrayContentsEqual(this._stringPool, constantPool._stringPool) && Assertions.assertArrayContentsEqual(this._namespacePool, constantPool._namespacePool) && Assertions.assertArrayContentsEqual(this._namespaceSetPool, constantPool._namespaceSetPool) && Assertions.assertVectorContentsEqual(this._multinamePool, constantPool._multinamePool);
		}

		/**
		 * Creates a printable representation of this object instance.
		 * @return This constant pool instance represented as a <code>String</code>.
		 */
		public function toString():String {
			return StringUtils.substitute("Integer Pool: {0}\n" + "Uint Pool: {1}\n" + "Double Pool: {2}\n" + "String Pool:\n\t{3}" + "\nNamespace Pool:\n\t{4}" + "\nNamespace Set Pool:\n\t{5}" + "\nMultiname Pool:\n\t{6}", _integerPool.join(), _uintPool.join(), _doublePool.join(), _stringPool.join("\n\t"), _namespacePool.join("\n\t"), _namespaceSetPool.join("\n\t"), _multinamePool.join("\n\t"));
		}

		public function get rawConstantPool():ByteArray {
			return _rawConstantPool;
		}

		public function set rawConstantPool(value:ByteArray):void {
			_rawConstantPool = value;
		}
	}
}
