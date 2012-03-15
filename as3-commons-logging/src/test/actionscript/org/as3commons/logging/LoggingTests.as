package org.as3commons.logging {
	import org.as3commons.logging.api.LoggerTest;
	import org.as3commons.logging.integration.ASAPIntegrationTest;
	import org.as3commons.logging.integration.FlexIntegrationTest;
	import org.as3commons.logging.integration.Log5FIntegrationTest;
	import org.as3commons.logging.integration.LogMeisterIntegrationTest;
	import org.as3commons.logging.integration.MaashaackIntegrationTest;
	import org.as3commons.logging.integration.MateIntegrationTest;
	import org.as3commons.logging.integration.OSMFIntegrationTest;
	import org.as3commons.logging.integration.Progression4IntegrationTest;
	import org.as3commons.logging.integration.PushButtonIntegrationTest;
	import org.as3commons.logging.integration.SLF4ASIntegrationTest;
	import org.as3commons.logging.integration.SpiceLibIntegrationTest;
	import org.as3commons.logging.integration.SwizIntegrationTest;
	import org.as3commons.logging.integration.YUIIntegrationTest;
	import org.as3commons.logging.setup.ComplexSetupTest;
	import org.as3commons.logging.setup.FlexSetupTest;
	import org.as3commons.logging.setup.HierarchicalSetupTest;
	import org.as3commons.logging.setup.LeveledTargetSetupTest;
	import org.as3commons.logging.setup.LogSetupTest;
	import org.as3commons.logging.setup.LogTargetLevelTest;
	import org.as3commons.logging.setup.MergedSetupTest;
	import org.as3commons.logging.setup.SimpleTargetSetupTest;
	import org.as3commons.logging.setup.log4j.Log4JPropertiesTest;
	import org.as3commons.logging.setup.log4j.Log4JSetupTest;
	import org.as3commons.logging.setup.target.AirTargetTest;
	import org.as3commons.logging.setup.target.BufferTest;
	import org.as3commons.logging.setup.target.FrameBufferTest;
	import org.as3commons.logging.setup.target.MergedTest;
	import org.as3commons.logging.setup.target.SWFInfoTest;
	import org.as3commons.logging.setup.target.TextFieldTest;
	import org.as3commons.logging.simple.SimpleLoggingTest;
	import org.as3commons.logging.util.ByteArrayCopyTest;
	import org.as3commons.logging.util.HereTest;
	import org.as3commons.logging.util.JsonXifyTest;
	import org.as3commons.logging.util.LogMessageFormatterTest;
	import org.as3commons.logging.util.xml.XMLRuleTest;
	import org.as3commons.logging.util.xml.XMLSetupTest;
	import org.as3commons.logging.util.xml.XMLTargetTest;
	
	/**
	 * <code>TestSuite</code>
	 *
	 * @author Martin Heidegger mh@leichtgewicht.at
	 * @since
	 */
	[Suite]
	[RunWith("org.flexunit.runners.Suite")]
	public class LoggingTests {
		public var l0: LogMessageFormatterTest;
		public var l1: Log4JPropertiesTest;
		public var l2: HierarchicalSetupTest;
		public var l3: LoggerTest;
		public var l4: Log4JSetupTest;
		public var l5: MaashaackIntegrationTest;
		public var l6: XMLSetupTest;
		public var l7: XMLTargetTest;
		public var l8: XMLRuleTest;
		public var l9: Log5FIntegrationTest;
		public var l10: SimpleLoggingTest;
		public var l11: MergedSetupTest;
		public var l12: MergedTest;
		public var l13: ComplexSetupTest;
		public var l14: JsonXifyTest;
		public var l15: HereTest;
		public var l16: ByteArrayCopyTest;
		//public var l17: YUIIntegrationTest;
		public var l18: MateIntegrationTest;
		public var l19: SwizIntegrationTest;
		public var l20: SLF4ASIntegrationTest;
		public var l21: PushButtonIntegrationTest;
		public var l22: ASAPIntegrationTest;
		public var l23: SpiceLibIntegrationTest;
		public var l24: Progression4IntegrationTest;
		public var l25: LogLevelTest;
		public var l26: LogTargetLevelTest;
		public var l27: LogSetupTest;
		public var l28: SWFInfoTest;
		public var l29: FlexIntegrationTest;
		public var l30: SimpleTargetSetupTest;
		public var l31: LeveledTargetSetupTest;
		public var l32: FlexSetupTest;
		public var l33: FrameBufferTest;
		public var l34: BufferTest;
		public var l35: TextFieldTest;
		public var l36: AirTargetTest;
		public var l37: OSMFIntegrationTest;
		public var l38: LogMeisterIntegrationTest;
	}
}
