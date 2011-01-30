package org.as3commons.reflect.testclasses {

	[Autowired]
	public class FullTestClass implements Interface {

		public const DUMMY_NON_STATIC:String = "dummynonstatic";

		public static const DUMMY:String = "dummy";
		public static var DUMMY_VAR:String = "dummyvar";

		custom_namespace var custom:String = "yes";

		public var name:String;

		public function get number():int {
			return 0;
		}

		[Autowired]
		public function get getset():Boolean {
			return true;
		}

		public function set getset(value:Boolean):void {
		}

		public static function get staticGetset():Boolean {
			return true;
		}

		public static function set staticGetset(value:Boolean):void {
		}

		public function FullTestClass(name:String, number:int) {
			super();
		}

		public function someMethod():String {
			return "";
		}

		public function someMethodWithParam(str:String):String {
			return str;
		}

		public function someMethodWithRestParams(... rest):String {
			return "";
		}

		public static function someStaticMethodWithParam(str:String):String {
			return str;
		}


		public function method1():void {
			//TODO Auto-generated method stub
		}

		public function method2(p1:int, p2:String):Boolean {
			//TODO Auto-generated method stub
			return false;
		}

		public function method3(p1:Number, ... rest):Object {
			//TODO Auto-generated method stub
			return null;
		}

		public function method4(p1:uint, p2:Class):* {
			//TODO Auto-generated method stub
			return null;
		}


	}
}