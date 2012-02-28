package {
	import org.as3commons.logging.util.SWFInfo;
	import org.as3commons.logging.api.getLogger;
	import org.as3commons.logging.api.ILogger;
	import org.as3commons.logging.setup.target.SOSTarget;
	import org.as3commons.logging.setup.SimpleTargetSetup;
	import org.as3commons.logging.api.LOGGER_FACTORY;
	import org.as3commons.logging.util.base64enc;
	import flash.utils.getTimer;
	import flash.utils.ByteArray;
	import mx.utils.Base64Encoder;
	import org.flexunit.internals.TraceListener;
	import org.flexunit.runner.FlexUnitCore;
	import org.as3commons.logging.util.Base64Test;
	import flash.display.Sprite;

	/**
	 * @author mh
	 */
	public class Base64 extends Sprite {
		public function Base64() {
			
			LOGGER_FACTORY.setup = new SimpleTargetSetup( new SOSTarget() );
			SWFInfo.init(stage);
			
			var logger: ILogger = getLogger("mope");
			
			var byte: ByteArray = new ByteArray();
			for( var i: int = 0; i< 1000000; ++i) {
				byte.writeFloat(Math.random());
			}
			
			var encoder: Base64Encoder = new Base64Encoder();
			
			var t: Number;
			t = getTimer();
			encoder.encodeBytes(byte);
			var s1: String = encoder.toString();
			logger.info( getTimer() - t);
			
			t = getTimer();
			var s2: String = base64enc(byte, 0, 0, false);
			logger.info( getTimer() - t);
			logger.info( "{0}, {1}", [s1 == s2, s1.length, s2.length] );
			
			var core: FlexUnitCore = new FlexUnitCore();
			core.addListener( new TraceListener() );
			core.run( [
				new Base64Test()
			]);
		}
	}
}
