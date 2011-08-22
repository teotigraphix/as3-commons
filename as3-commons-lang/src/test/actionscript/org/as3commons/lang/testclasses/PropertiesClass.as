package org.as3commons.lang.testclasses {
	/**
	 * @author mh
	 */
	public class PropertiesClass {
		
		namespace ns = "as3commons";
		
		public static const staticConst: String;
		public static var staticVar: int;
		public static function get staticGetter(): Object {
			return null;
		}
		public static function set staticSetter(value:Number):void {}
		public static function get staticSetterGetter():String {
			return null;
		}
		public static function set staticSetterGetter(value:String):void {}
		
		ns static const staticConst: int;
		ns static var staticVar:uint;
		ns static function get staticGetter():Array {
			return null;
		}
		ns static function set staticSetter(value:Array):void {}
		ns static function get staticSetterGetter():Object {
			return null;
		}
		ns static function set staticSetterGetter(value:Object):void {}
		
		public const publicConst: String;
		public var publicVar: String;
		public function get publicGetter(): String {
			return null;
		}
		public function set publicSetter(value:String):void {}
		public function get publicSetterGetter():String {
			return null;
		}
		public function set publicSetterGetter(value:String):void {}
		
		ns const publicConst: String;
		ns var publicVar:String;
		ns function get publicGetter(): String {
			return null;
		}
		ns function set publicSetter(value:String):void {}
		ns function get publicSetterGetter():String {
			return null;
		}
		ns function set publicSetterGetter(value:String):void {}
	}
}
