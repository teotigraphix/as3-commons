/*
 * Copyright (c) 2007-2009-2010 the original author or authors
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */
package org.as3commons.reflect {
	import flash.system.ApplicationDomain;

	import org.as3commons.lang.HashArray;

	/**
	 * Provides information about a single method of a class or interface.
	 *
	 * @author Christophe Herreman
	 * @author Andrew Lewisohn
	 */
	public class Method extends MetadataContainer implements INamespaceOwner {

		// -------------------------------------------------------------------------
		//
		//  Variables
		//
		// -------------------------------------------------------------------------

		protected var applicationDomain:ApplicationDomain;

		/**
		 * If <code>true</code>, the value of fullName should be regenerated.
		 */
		private var updateFullName:Boolean = true;

		// -------------------------------------------------------------------------
		//
		//  Constructor
		//
		// -------------------------------------------------------------------------

		/**
		 * Creates a new <code>Method</code> instance.
		 */
		public function Method(declaringType:String, name:String, isStatic:Boolean, parameters:Array, returnType:String, applicationDomain:ApplicationDomain, metadata:HashArray=null) {
			super(metadata);
			declaringTypeName = declaringType;
			_name = name;
			_isStatic = isStatic;
			_parameters = parameters;
			_returnTypeName = returnType;
			this.applicationDomain = applicationDomain;
		}

		// -------------------------------------------------------------------------
		//
		//  Properties
		//
		// -------------------------------------------------------------------------

		// ----------------------------
		// declaringType
		// ----------------------------

		protected var declaringTypeName:String;

		public function get declaringType():Type {
			return Type.forName(declaringTypeName, applicationDomain);
		}

		// ----------------------------
		// fullName
		// ----------------------------

		private var _fullName:String;

		public function get fullName():String {
			if (updateFullName) {
				_fullName = "public ";
				if (isStatic)
					_fullName += "static ";
				_fullName += name + "(";
				for (var i:int = 0; i < parameters.length; i++) {
					var p:Parameter = parameters[i] as Parameter;
					_fullName += p.type.name;
					_fullName += (i < (parameters.length - 1)) ? ", " : "";
				}
				_fullName += "):" + returnType.name;
				updateFullName = false;
			}
			return _fullName;
		}

		// ----------------------------
		// isStatic
		// ----------------------------

		private var _isStatic:Boolean;

		public function get isStatic():Boolean {
			return _isStatic;
		}

		// ----------------------------
		// name
		// ----------------------------

		private var _name:String;

		public function get name():String {
			return _name;
		}

		// ----------------------------
		// qName
		// ----------------------------

		private var _qName:QName;

		public function get qName():QName {
			return new QName(_namespaceURI, _name);
		}

		// ----------------------------
		// namespaceURI
		// ----------------------------

		private var _namespaceURI:String;

		public function get namespaceURI():String {
			return _namespaceURI;
		}

		// ----------------------------
		// parameters
		// ----------------------------

		protected var _parameters:Array;

		public function get parameters():Array {
			var result:Array = [];
			var len:int = _parameters.length;
			for (var i:int = 0; i < len; ++i) {
				var param:BaseParameter = _parameters[i];
				result[result.length] = new Parameter(param, i);
			}
			return result;
		}

		// ----------------------------
		// returnType
		// ----------------------------

		private var _returnTypeName:String;

		public function get returnType():Type {
			return Type.forName(_returnTypeName, applicationDomain);
		}

		as3commons_reflect function get returnTypeName():String {
			return _returnTypeName;
		}

		// -------------------------------------------------------------------------
		//
		//  Methods
		//
		// -------------------------------------------------------------------------

		/**
		 * Invokes (calls) the method represented by this <code>Method</code>
		 * instance of the given <code>target</code> object with the passed in
		 * arguments.
		 *
		 * @param target the object on which to invoke the method
		 * @param args the arguments that will be passed along the method call
		 * @return the result of the method invocation, if any
		 */
		public function invoke(target:*, args:Array):* {
			var invoker:MethodInvoker = new MethodInvoker();
			invoker.target = target;
			invoker.method = name;
			invoker.arguments = args;
			return invoker.invoke();
		}

		public function toString():String {
			return "[Method(name:'" + name + "', isStatic:" + isStatic + ")]";
		}

		// -------------------------------------------------------------------------
		//
		//  Methods: AS3Commons Reflect Internal Use
		//
		// -------------------------------------------------------------------------

		as3commons_reflect function setDeclaringType(value:String):void {
			declaringTypeName = value;
		}

		as3commons_reflect function setFullName(value:String):void {
			_fullName = value;
			updateFullName = false;
		}

		as3commons_reflect function setIsStatic(value:Boolean):void {
			_isStatic = value;
		}

		as3commons_reflect function setName(value:String):void {
			_name = value;
			updateFullName = true;
		}

		as3commons_reflect function setNamespaceURI(value:String):void {
			_namespaceURI = value;
		}

		as3commons_reflect function setParameters(value:Array):void {
			_parameters = value;
			updateFullName = true;
		}

		as3commons_reflect function setReturnType(value:String):void {
			_returnTypeName = value;
			updateFullName = true;
		}

	}
}
