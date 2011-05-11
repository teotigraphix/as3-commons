package org.as3commons.codec.serialization.amf
{
	/**
	 * AMF3 data type constants.
	 * 
	 * @author Jan Van Coppenolle
	 */
	public final class AMF3Type
	{
		public static const UNDEFINED:int = 0;
		public static const NULL:int = 1;
		public static const FALSE:int = 2;
		public static const TRUE:int = 3;
		public static const INTEGER:int = 4;
		public static const NUMBER:int = 5;
		public static const STRING:int = 6;
		public static const XML:int = 7;
		public static const DATE:int = 8;
		public static const ARRAY:int = 9;
		public static const OBJECT:int = 10;
		public static const XMLSTRING:int = 11;
		public static const BYTEARRAY:int = 12;
		
		/**
		 * @private
		 */
		public function AMF3Type()
		{
			throw new Error("Static Class");
		}
	}
}