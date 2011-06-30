package org.as3commons.logging.util {
	import avmplus.getQualifiedClassName;
	import flash.net.registerClassAlias;
	import flexunit.framework.TestCase;

	/**
	 * @author mh
	 */
	public class ByteArrayCopyTest extends TestCase {
		
		public function ByteArrayCopyTest() {
			
		}
		
		public function testBasics(): void {
			var str: String = "Hello World";
			var n: * = null;
			var u: * = undefined;
			var no: Number = 1.15423;
			var i: int = -1;
			var ui: uint = 1;
			var b: Boolean = true;
			var f: Function = function( t: String ): void {};
			var ns: Namespace = new Namespace( "ho" );
			var qn: QName = new QName( ns, "hello" );
			var xml: XML = <xml/>;
			var simpleArray: Array = [str,n,u,no,i,ui,b,f,ns,qn];
			var simpleObject: Object = {str:str,n:n,u:u,no:no,i:i,ui:ui,b:b,f:f,ns:ns,qn:qn};
			var arrayWithObject: Array = [simpleObject,simpleArray,xml];
			var custom: CustomClass = new CustomClass("b",2);
			custom.child = new CustomClass("a",1);
			custom.child.child = custom;
			
			assertCopy( clone(str), str );
			assertCopy( clone(n), n );
			assertCopy( clone(u), u );
			assertCopy( clone(no), no );
			assertCopy( clone(i), i );
			assertCopy( clone(ui), ui );
			assertCopy( clone(b), b );
			assertCopy( clone(f), f );
			assertCopy( clone(ns), ns );
			assertCopy( clone(qn), qn );
			assertCopy( clone(xml), xml );
			assertCopy( clone(simpleArray), simpleArray );
			assertCopy( clone(simpleObject), simpleObject );
			assertCopy( clone(arrayWithObject), arrayWithObject );
			assertCopy( clone(custom), custom );
			
			
			registerClassAlias( getQualifiedClassName(CustomClass), CustomClass);
			assertCopy( clone(custom), custom );
		}
		
		
		private function assertCopy( a: *, b:* ):void {
			if( b is QName ) {
				if( b["localName"] != a["localName"] || a["uri"] != b["uri"] ) {
					fail("QNames not equals");
				}
			} else {
				assertObjectReallyEquals( a, b );
				if( !(a is String || a is Boolean || a is Number || a is XML || a == null || a is Function || a is Namespace) && a === b ) {
					fail( "Stil all the same" );
				}
			}
		}
	}
}
import avmplus.getQualifiedClassName;

import org.as3commons.logging.util.allProperties;
import org.flexunit.AssertionError;

import flash.utils.Dictionary;
class CustomClass {
	public var test: String;
	public var child: CustomClass;
	public var nu : Number;
	public function CustomClass( test: String=null, nu: Number=0 ) {
		this.test = test;
		this.nu = nu;
	}

}


function assertObjectReallyEquals( obj: *, objB: * ): void {
	var stack: Dictionary = new Dictionary(); 
	if( !objectEquals( obj, objB, stack ) ){
		throw new AssertionError("Something is not equal...");
	}
}

function objectEquals( obj: *, objB: *, stack: Dictionary ): Boolean {
	if( obj == null || obj is String || obj is Number || obj is Boolean || obj is XML || obj is Function ) {
		if( obj == objB ) {
			return true;
		} else {
			return false;
		}
	}
	if( obj is QName || objB is QName ) {
		try {
			return obj["uri"] == objB["uri"] && obj["localName"] == objB["localName"];
		} catch( e: Error ) {
			return false;
		}
	}
	if( obj === objB ) {
		return true;
	}
	var tried: Dictionary = stack[obj];
	if( !tried ) {
		tried = stack[obj] = new Dictionary();
	}
	if( tried[objB] ) {
		return true;
	} else {
		var triedB: Dictionary = stack[objB];
		if( !triedB ) {
			triedB = stack[objB] = new Dictionary();
		}
		tried[objB] = true;
		tried[obj] = true;
		var result: Boolean = true;
		if( obj is Array && obj is Array ) {
			var objAsArray: Array = obj;
			var l: int = objAsArray.length;
			if( l == (objB as Array).length ) {
				for( var i:int = 0; i<l;++i){
					if( !objectEquals( objAsArray[i], objB[i], stack ) ) {
						result = false;
						break;
					}
				}
			} else {
				result = false;
			}
		} else {
			var namesA: Array = allProperties( obj );
			var namesB: Array = allProperties( objB );
			if( objectEquals( namesA, namesB, stack ) ) {
				l = namesA.length;
				for( i = 0; i<l; ++i ) {
					var name: * = namesA[i];
					if( !objectEquals( obj[name], objB[name], stack ) ) {
						result = false;
						break;
					}
				}
			} else {
				result = false;
			}
		}
		return result;
	}
}
