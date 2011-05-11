package org.as3commons.codec.serialization.amf
{
	/**
	 * AMF0 data type constants.
	 * 
	 * @author Jan Van Coppenolle
	 */
	public final class AMF0Type
	{
		public static var UNKNOWN:int = -1;
		public static var NUMBER:int = 0;
		public static var BOOLEAN:int = 1;
		public static var STRING:int = 2;
		public static var OBJECT:int = 3;
		public static var MOVIECLIP:int = 4;
		public static var NULL:int = 5;
		public static var UNDEFINED:int = 6;
		public static var REFERENCE:int = 7;
		public static var ECMA_ARRAY:int = 8;
		public static var OBJECT_END:int = 9;
		public static var STRICT_ARRAY:int = 10;
		public static var DATE:int = 11;
		public static var LONG_STRING:int = 12;
		public static var UNSUPPORTED:int = 13;
		public static var RECORDSET:int = 14;
		public static var XML_OBJECT:int = 15;
		public static var TYPED_OBJECT:int = 16;
		public static var AMF3_OBJECT:int = 17;
		
		/**
		 * @private
		 */
		public function AMF0Type()
		{
			throw new Error("Static Class");
		}
	}
}