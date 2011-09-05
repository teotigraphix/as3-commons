package org.as3commons.logging.setup {
	import org.as3commons.logging.api.ILogSetup;
	import org.as3commons.logging.api.LOGGER_FACTORY;
	import org.as3commons.logging.setup.target.AirFileTarget;
	import org.as3commons.logging.setup.target.MonsterDebugger3TraceTarget;
	import org.as3commons.logging.setup.target.SOSTarget;
	import org.as3commons.logging.setup.target.TraceTarget;
	import org.as3commons.logging.util.xml.xmlToSetup;
	import org.mockito.MockitoTestCase;
	

	/**
	 * @author mh
	 */
	public class XMLSetupTest extends MockitoTestCase {
		public function XMLSetupTest() {
			super([]);
		}
		
		public function testSetupNode(): void {
			var setup: ILogSetup = xmlToSetup(
				<setup xmlns="as3commons.org/logging/1">
					<target name="trace" type="trace"/>
					<rule name="^org\\.as3commons\\.">
						<target ref="trace" />
					</rule>
				</setup>, {
					"trace": TraceTarget,
					"sos": SOSTarget,
					"monster": MonsterDebugger3TraceTarget,
					"air": AirFileTarget
				}
			);
			
			LOGGER_FACTORY.setup = setup;
			
			
		}
	}
}
