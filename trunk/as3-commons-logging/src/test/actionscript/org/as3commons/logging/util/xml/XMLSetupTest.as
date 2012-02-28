package org.as3commons.logging.util.xml {
	import org.as3commons.logging.setup.MergedSetup;
	import org.as3commons.logging.api.ILogger;
	import org.as3commons.logging.api.getLogger;
	import org.as3commons.logging.api.LOGGER_FACTORY;
	import org.as3commons.logging.setup.SimpleTargetSetup;
	import flexunit.framework.TestCase;
	

	/**
	 * @author mh
	 */
	public class XMLSetupTest extends TestCase {
		
		private static const logger: ILogger = getLogger(XMLSetupTest);
		
		public function XMLSetupTest() {}
		
		
		override public function setUp():void {
			stack = [];
		}
		
		public function testSetup():void {
			
			assertNull(
				xmlToSetup(
					<setup xmlns="http://as3commons.org/logging/1" />,
					{}
				)
			);
			
			var target: SimpleTargetSetup = xmlToSetup(
					<setup xmlns="http://as3commons.org/logging/1">
						<rule>
							<target type="test" />
						</rule>
					</setup>,
					{test: TestTarget}
				) as SimpleTargetSetup;
			assertNotNull(target);
			LOGGER_FACTORY.setup = target;
			logger.info("hi");
			assertEquals("hi",stack.pop());
			
			target = xmlToSetup(
					<setup xmlns="http://as3commons.org/logging/1">
						<target name="myname" type="test" />
						<rule>
							<target-ref ref="myname" />
						</rule>
					</setup>,
					{test: TestTarget}) as SimpleTargetSetup;
			assertNotNull(target);
			LOGGER_FACTORY.setup = target;
			logger.info("ho");
			assertEquals("ho",stack.pop());
			
			var mergedSetup: MergedSetup = xmlToSetup(
					<setup xmlns="http://as3commons.org/logging/1">
						<rule>
							<target type="test">
								<arg value="a"/>
							</target>
						</rule>
						<rule>
							<target type="test">
								<arg value="b"/>
							</target>
						</rule>
					</setup>,
					{test: TestTarget}
			) as MergedSetup;
			assertNotNull(mergedSetup);
			LOGGER_FACTORY.setup = mergedSetup;
			logger.info("ho");
			assertEquals("bho",stack.shift());
			
			assertEquals( 0, stack.length );
		}
	}
}
import org.as3commons.logging.api.ILogTarget;

var stack: Array = [];

class TestTarget implements ILogTarget {
	
	private var _id: String;
	
	public function TestTarget(id: String= "") {
		_id = id;
	}
	
	public function log(name : String, shortName : String, level : int, timeStamp : Number, message : String, parameters : *=null, person : String=null) : void {
		stack.push(_id+message);
	}
	
}
