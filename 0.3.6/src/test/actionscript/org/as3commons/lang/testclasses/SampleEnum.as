package org.as3commons.lang.testclasses {
	import org.as3commons.lang.Enum;

	/**
	 * @author mh
	 */
	public class SampleEnum extends Enum {
		
		namespace ns = "as3commons";
		
		public static const A: SampleEnum = new SampleEnum;
		public static const B: SampleEnum = new SampleEnum("X");
		private static const _E: SampleEnum = new SampleEnum;
		public static var F: SampleEnum = new SampleEnum("F");
		ns static const G: SampleEnum = new SampleEnum;
		
		public static function get E() : SampleEnum {
			return _E;
		}

		public static const X1 : Number = 1;
		public var X2 : Number = 2;
		public var X3 : SampleEnum;

		public function get X4() : SampleEnum {
			return X3;
		}
	
		public function SampleEnum(name:String="") {
			super(name);
		}
	}
}
