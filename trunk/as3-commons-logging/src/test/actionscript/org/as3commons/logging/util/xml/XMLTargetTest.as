package org.as3commons.logging.util.xml {
	import flash.utils.getQualifiedClassName;
	import flexunit.framework.TestCase;
	
	/**
	 * @author mh
	 */
	public class XMLTargetTest extends TestCase {

		private var targetTypes: Object = {
			test: TestTarget,
			maxArgs: MaxArgTarget,
			constArg: FixedConstArguments,
			noTarget: NoLogTarget,
			errorTarget: ErrorThrowingLogTarget,
			errorPropTarget: ErrorParameterLogTarget
		};

		public function XMLTargetTest() {
			super();
		}

		public function testTargetCreation():void {
			
			assertNull( xmlToTarget(<target xmlns='http://as3commons.org/logging/1' type='notavailable' />, targetTypes ) );
			
			var target: TestTarget = xmlToTarget( <target xmlns='http://as3commons.org/logging/1' type='test' />, targetTypes ) as TestTarget;
			assertTrue( target is TestTarget );
		}
		
		public function testManyArguments():void {
			// May not throw an error, even though we defined more arguments than we needed
			xmlToTarget( <target xmlns='http://as3commons.org/logging/1' type='test'>
				<arg value="hi"/>
				<arg value="hi"/>
				<arg value="hi"/>
			</target>, targetTypes );
			
			// May not throw an error even thought we have more than our limit
			var target: MaxArgTarget = xmlToTarget( <target xmlns='http://as3commons.org/logging/1' type='maxArgs'>
				<arg value="1"/>
				<arg value="2"/>
				<arg value="true"/>
				<arg value="4"/>
				<arg value="5"/>
				<arg value="6"/>
				<arg value="7"/>
				<arg value="8"/>
				<arg value="9"/>
				<arg value="10"/>
				<arg value="11"/>
				<arg value="12"/>
				<arg value="13"/>
				<arg value="14"/>
				<arg value="15"/>
			</target>, targetTypes ) as MaxArgTarget;
			
			assertStrictlyEquals("1", target.arg1);
			assertStrictlyEquals(2, target.arg2);
			assertStrictlyEquals(true, target.arg3);
			assertStrictlyEquals(4.0, target.arg4);
			assertEquals("5", target.arg5);
			assertEquals("6", target.arg6);
			assertEquals("7", target.arg7);
			assertEquals("8", target.arg8);
			assertEquals("9", target.arg9);
			assertEquals("10", target.arg10);
			assertEquals("11", target.arg11);
			assertEquals("12", target.arg12);
			assertEquals("13", target.arg13);
			assertEquals("14", target.arg14);
			assertNull(target.arg15);
		}
		
		public function testInvalidTargetTypes():void {
			assertNull( xmlToTarget( <target xmlns='http://as3commons.org/logging/1' type='noTarget'/>, targetTypes ));
			assertNull( xmlToTarget( <target xmlns='http://as3commons.org/logging/1' type='errorTarget'>
				<arg value="hi"/>
			</target>, targetTypes ));
		}
		
		public function testArgumentInjection():void {
			var target: TestTarget = xmlToTarget( <target xmlns='http://as3commons.org/logging/1' type='test'>
				<arg value="hi"/>
			</target>, targetTypes ) as TestTarget;
			assertEquals( target.arg1, "hi" );
			assertNull( target.arg2 );
			
			target = xmlToTarget( <target xmlns='http://as3commons.org/logging/1' type='test'>
				<arg value="hi"/>
				<arg value="ho"/>
			</target>, targetTypes ) as TestTarget;
			
			assertEquals( "hi", target.arg1 );
			assertEquals( "ho", target.arg2 );
			
			
			assertNotNull(xmlToTarget( <target xmlns='http://as3commons.org/logging/1' type='constArg'>
				<arg value="hi"/>
				<arg value="ho"/>
			</target>, targetTypes ) as FixedConstArguments);
		}
		
		public function testPropertyInjection():void {
			var target: TestTarget = xmlToTarget( <target xmlns='http://as3commons.org/logging/1' type='test'>
				<property name="arg1" value="hi"/>
			</target>, targetTypes ) as TestTarget;
			assertEquals( "hi", target.arg1 );
			assertNull( target.arg2 );
			
			target = xmlToTarget( <target xmlns='http://as3commons.org/logging/1' type='test'>
				<property name="arg1" value="hi"/>
				<property name="arg2" value="ho"/>
				<property name="arrProp" value="no-array!"/> 
			</target>, targetTypes ) as TestTarget;
			
			assertEquals( "hi", target.arg1 );
			assertEquals( "ho", target.arg2 );
			
			
			var errorPropTarget: ErrorParameterLogTarget = xmlToTarget( <target xmlns='http://as3commons.org/logging/1' type='errorPropTarget'>
				<property name="param1" value="hi"/>
				<property name="param2" value="ho"/>
				<property name="param3" value="ha"/>
			</target>, targetTypes ) as ErrorParameterLogTarget;
			
			assertEquals( "hi", errorPropTarget.param1 );
			assertEquals( "ha", errorPropTarget.param3 );
		}
		
		public function testComplexArgumentInjection(): void {
			var target: TestTarget = xmlToTarget( <target xmlns='http://as3commons.org/logging/1' type='test'>
				<arg/>
				<arg/>
				<arg>
					<target type="test" name="hi">
						<arg value="test"/>
					</target>
				</arg>
			</target>, targetTypes ) as TestTarget;
			assertNull( target.arg1 );
			assertNull( target.arg2 );
			assertNotNull( target.child1 );
			assertNull( target.child2 );
			assertEquals( "test", target.child1.arg1 );
			assertNull( target.child1.arg2 );
			assertNull( target.child1.arg2 );
			
			// Now without the property "name" !
			target = xmlToTarget( <target xmlns='http://as3commons.org/logging/1' type='test'>
				<arg/>
				<arg/>
				<arg>
					<target type="test">
						<arg value="test"/>
					</target>
				</arg>
			</target>, targetTypes ) as TestTarget;
			assertNull( target.arg1 );
			assertNull( target.arg2 );
			assertNotNull( target.child1 );
			assertNull( target.child2 );
			assertEquals( "test", target.child1.arg1 );
			assertNull( target.child1.arg2 );
			assertNull( target.child1.arg2 );
			
			// Referencing between the objects
			target = xmlToTarget( <target xmlns='http://as3commons.org/logging/1' type='test'>
				<arg/>
				<arg/>
				<arg>
					<target type="test" name="myname">
						<arg value="test"/>
					</target>
				</arg>
				<arg>
					<target-ref ref="myname"/>
				</arg>
			</target>, targetTypes ) as TestTarget;
			assertNull( target.arg1 );
			assertNull( target.arg2 );
			assertNotNull( target.child1 );
			assertStrictlyEquals( target.child1, target.child2 );
			assertEquals( "test", target.child1.arg1 );
			assertNull( target.child1.arg2 );
			assertNull( target.child1.arg2 );
			
			// Referencing to the parent
			target = xmlToTarget( <target xmlns='http://as3commons.org/logging/1' type='test' name="myname">
				<arg/>
				<arg/>
				<arg>
					<target-ref ref="myname"/>
				</arg>
			</target>, targetTypes ) as TestTarget;
			assertNull( target.arg1 );
			assertNull( target.arg2 );
			assertNull( target.child1 );
			assertNull( target.child2 );
			
			// Referencing to a entry in my custom list
			var customTarget: TestTarget = new TestTarget();
			target = xmlToTarget( <target xmlns='http://as3commons.org/logging/1' type='test' name="myname">
				<arg/>
				<arg/>
				<arg>
					<target-ref ref="myname"/>
				</arg>
			</target>, targetTypes, {
				myname: customTarget
			} ) as TestTarget;
			assertNull( target.arg1 );
			assertNull( target.arg2 );
			assertStrictlyEquals( customTarget, target.child1 );
			assertNull( target.child2 );
		}
		
		public function testComplexPropertyInjection(): void {
			var target: TestTarget = xmlToTarget( <target xmlns='http://as3commons.org/logging/1' type='test'>
				<property name="child1">
					<target type="test" name="hi">
						<arg value="test"/>
					</target>
				</property>
			</target>, targetTypes ) as TestTarget;
			assertNull( target.arg1 );
			assertNull( target.arg2 );
			assertNotNull( target.child1 );
			assertNull( target.child2 );
			assertEquals( "test", target.child1.arg1 );
			assertNull( target.child1.arg2 );
			assertNull( target.child1.arg2 );
			
			// Now without the property "name" !
			target = xmlToTarget( <target xmlns='http://as3commons.org/logging/1' type='test'>
				<property name="child1">
					<target type="test">
						<arg value="test"/>
					</target>
				</property>
			</target>, targetTypes ) as TestTarget;
			assertNull( target.arg1 );
			assertNull( target.arg2 );
			assertNotNull( target.child1 );
			assertNull( target.child2 );
			assertEquals( "test", target.child1.arg1 );
			assertNull( target.child1.arg2 );
			assertNull( target.child1.arg2 );
			
			// Referencing between the objects
			target = xmlToTarget( <target xmlns='http://as3commons.org/logging/1' type='test'>
				<property name="child1">
					<target type="test" name="myname">
						<arg value="test"/>
					</target>
				</property>
				<property name="child2">
					<target-ref ref="myname"/>
				</property>
			</target>, targetTypes ) as TestTarget;
			assertNull( target.arg1 );
			assertNull( target.arg2 );
			assertNotNull( target.child1 );
			assertStrictlyEquals( target.child1, target.child2 );
			assertEquals( "test", target.child1.arg1 );
			assertNull( target.child1.arg2 );
			assertNull( target.child1.arg2 );
			
			// Referencing to the parent
			target = xmlToTarget( <target xmlns='http://as3commons.org/logging/1' type='test' name="myname">
				<property name="child1">
					<target-ref ref="myname"/>
				</property>
			</target>, targetTypes ) as TestTarget;
			assertNull( target.arg1 );
			assertNull( target.arg2 );
			assertStrictlyEquals( target, target.child1 );
			assertNull( target.child2 );
			
			// Referencing to a entry in my custom list
			var customTarget: TestTarget = new TestTarget();
			target = xmlToTarget( <target xmlns='http://as3commons.org/logging/1' type='test' name="myname">
				<property name="child1">
					<target-ref ref="myname"/>
				</property>
			</target>, targetTypes, {
				myname: customTarget
			} ) as TestTarget;
			assertNull( target.arg1 );
			assertNull( target.arg2 );
			assertStrictlyEquals( customTarget, target.child1 );
			assertNull( target.child2 );
			
			// Referencing to oneself with another definition
			target = xmlToTarget( <target xmlns='http://as3commons.org/logging/1' type='test' name="myname">
				<arg/>
				<arg/>
				<arg>
					<target name="hi" type="test"/>
				</arg>
				<property name="child1">
					<target-ref ref="myname"/>
				</property>
			</target>, targetTypes ) as TestTarget;
			assertNull( target.arg1 );
			assertNull( target.arg2 );
			assertStrictlyEquals( target, target.child1 );
			assertNull( target.child2 );
		}
		
		// http://code.google.com/p/as3-commons/issues/detail?id=95
		public function testStringParameters(): void {
			assertParameter("{time} {logLevel} {shortName}{atPerson} - {message}", "{time} {logLevel} {shortName}{atPerson} - {message}");
		}
		
		public function testBooleanParameters():void {
			assertParameter(true, "True" );
			assertParameter(true, "TRUE" );
			assertParameter(true, "true" );
			assertParameter(true, "truE" );
			assertParameter(false, "False" );
			assertParameter(false, "FALSE" );
			assertParameter(false, "false" );
			assertParameter(false, "falsE" );
			assertParameter(" false", " false" );
			assertParameter("false ", "false " );
		}
		
		public function testNumberParameters():void {
			assertParameter( 1.0, "1.0", [ "1", "1.0", true] );
			assertParameter( 0.0, "0.0", [ "0", "0.0", false] );
			assertParameter( -1, "-1.0", [ "-1.0"] );
			assertParameter( -1.1, "-1.1", ["-1.1"] );
			assertParameter( 1.1, "1.1", ["1.1"] );
			assertParameter( 0.1, "0.1", ["0.1"] );
		}
		
		public function testIntParameters():void {
			assertParameter( 1, "1", ["1", "1.0", true] );
			assertParameter( 0, "0", ["0", "0.0", false] );
			assertParameter( -1, "-1", ["-1.0"] );
		}
		
		public function testInvalidParameters():void {
		}
		
		private function assertParameter( expected: *, given: String, not:Array = null ): void {
			assertTargetForParameter(<target xmlns='http://as3commons.org/logging/1' type="trace">
				<property name="input" value={given}/>
			</target>, expected, not);
			
			assertTargetForParameter(<target xmlns='http://as3commons.org/logging/1' type="trace">
				<arg value={given}/>
			</target>, expected, not);
		}
		
		private function assertTargetForParameter(targetXML:XML, expected: *, not: Array ):void {
			var target: ParameterTarget = xmlToTarget(targetXML, {trace: ParameterTarget}) as ParameterTarget;
			
			assertNotNull(target);
			assertStrictlyEquals(expected, target.input);
			if( not ) {
				for( var i: int = 0; i < not.length; ++i ){
					var notValue:* = not[i];
					if(    getQualifiedClassName(notValue) == getQualifiedClassName(target.input)
						&& notValue === target.input ) {
						fail("Expected output NOT to be "+notValue+ " ["+getQualifiedClassName(notValue)+"] at " + i);
					}
				}
			}
		}
	}
}
import org.as3commons.logging.api.ILogTarget;

class ParameterTarget implements ILogTarget {
	
	public var input: *;

	public function ParameterTarget( input: * = null ) {
		this.input = input;
	}
	
	public function log(name : String, shortName : String, level : int, timeStamp : Number, message : String, parameters: *, person: String, context:String, shortContext:String) : void {
	}
}

class NoLogTarget {
}

class ErrorThrowingLogTarget implements ILogTarget {
	public function ErrorThrowingLogTarget() {
		throw new Error("oh!");
	}
	
	public function log(name : String, shortName : String, level : int, timeStamp : Number, message : String, parameters: *, person: String, context:String, shortContext:String) : void {
	}
	
}

class ErrorParameterLogTarget implements ILogTarget {
	
	public var param1: String;
	
	public function set param2( test: String ):void {
		throw new Error("ah!");
	}
	
	public var param3: String;
	
	public function log(name : String, shortName : String, level : int, timeStamp : Number, message : String, parameters: *, person: String, context:String, shortContext:String) : void {
	}
	
}

class FixedConstArguments implements ILogTarget {
	
	public function FixedConstArguments(test:String) {
	}
	
	
	public function log(name : String, shortName : String, level : int, timeStamp : Number, message : String, parameters: *, person: String, context:String, shortContext:String) : void {
	}
}

class TestTarget implements ILogTarget  {
	public var arg1: String;
	public var arg2: String;
	public var arrProp: Array;
	public var child1: TestTarget;
	public var child2: TestTarget;
	
	public function TestTarget( arg1: String = null, arg2: String = null, child1: TestTarget = null, child2: TestTarget = null ) {
		this.arg1 = arg1;
		this.arg2 = arg2;
		this.child1 = child1;
		this.child2 = child2;
	}
	
	
	public function log(name : String, shortName : String, level : int, timeStamp : Number, message : String, parameters: *, person: String, context:String, shortContext:String) : void {
	}
}

class MaxArgTarget implements ILogTarget {
	public var arg1: String;
	public var arg2: int;
	public var arg3: Boolean;
	public var arg4: Number;
	public var arg5: String;
	public var arg6: String;
	public var arg7: String;
	public var arg8: String;
	public var arg9: String;
	public var arg10: String;
	public var arg11: String;
	public var arg12: String;
	public var arg13: String;
	public var arg14: String;
	public var arg15: String;
	public function MaxArgTarget(
		arg1: String = null,
		arg2: int = 0,
		arg3: Boolean = false,
		arg4: Number = .0,
		arg5: String = null,
		arg6: String = null,
		arg7: String = null,
		arg8: String = null,
		arg9: String = null,
		arg10: String = null,
		arg11: String = null,
		arg12: String = null,
		arg13: String = null,
		arg14: String = null,
		arg15: String = null
	) {
		this.arg1 = arg1;
		this.arg2 = arg2;
		this.arg3 = arg3;
		this.arg4 = arg4;
		this.arg5 = arg5;
		this.arg6 = arg6;
		this.arg7 = arg7;
		this.arg8 = arg8;
		this.arg9 = arg9;
		this.arg10 = arg10;
		this.arg11 = arg11;
		this.arg12 = arg12;
		this.arg13 = arg13;
		this.arg14 = arg14;
		this.arg15 = arg15;
	}

	
	public function log(name : String, shortName : String, level : int, timeStamp : Number, message : String, parameters : *, person : String, context: String, shortContext:String) : void {
	}

}