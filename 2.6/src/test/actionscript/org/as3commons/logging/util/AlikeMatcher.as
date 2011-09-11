package org.as3commons.logging.util {
	import org.mockito.api.Matcher;

	/**
	 * @author mh
	 */
	public class AlikeMatcher implements Matcher {
		
		private var _compare:*;
		
		public function AlikeMatcher( compare: * ) {
			_compare = compare;
		}
		
		public function matches( value:* ):Boolean {
			return match( value, _compare );
		}

		private function match(value:*, compare:*):Boolean {
			if( value == compare ) {
				return true;
			} else if( compare is Matcher ) {
				return Matcher( compare ).matches( value );
			} else if( value is IComparable ) {
				return IComparable( value ).equals( compare );
			} else if( compare is IComparable ) {
				return IComparable( compare ).equals( compare );
			} else {
				if( value is Array && compare is Array ) {
					var arrA: Array = value;
					var arrB: Array = compare;
					if( arrA.length == arrB.length ) {
						for( var i: int = 0; i<arrA.length; ++i ) {
							if( !match( arrA[i], arrB[i] ) ) {
								return false;
							}
						}
						return true;
					} else {
						return false;
					}
				} else {
					return false;
				}
			}
		}

		public function describe():String {
			return "alike("+_compare+")";
		}
	}
}
