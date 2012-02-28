/**
 * Created by IntelliJ IDEA.
 * User: mini
 * Date: 11/12/24
 * Time: 23:49
 * To change this template use File | Settings | File Templates.
 */
package {
	import org.as3commons.logging.api.ILogger;
	import org.as3commons.logging.api.LOGGER_FACTORY;
	import org.as3commons.logging.api.getLogger;
	import org.as3commons.logging.setup.SimpleTargetSetup;
	import org.as3commons.logging.setup.target.LSHttpTarget;
	import org.as3commons.logging.setup.target.TraceTarget;
	import org.as3commons.logging.setup.target.mergeTargets;
	import org.as3commons.logging.util.extractPaths;

	import flash.display.Sprite;
	import flash.events.Event;

	public class LSTest extends Sprite {
		
		private static const logger:ILogger = getLogger(LSTest);
		private var count:int = 0;
		
		public function LSTest() {
			var ls:LSHttpTarget = new LSHttpTarget("LSTest", "swf-1", "http://127.0.0.1/log/exec", 250);
			LOGGER_FACTORY.setup = new SimpleTargetSetup(mergeTargets(ls,new TraceTarget()));
			addEventListener(Event.ENTER_FRAME, logPerFrame);
			var paths:Object = extractPaths("Test for logging: {msg} {my1.msg.ma.sg} {0} {2} {1}");
			trace("hi");
		}
		
		private function logPerFrame(event:Event):void {
			for( var i:int = 0; i < 2; ++i) {
				logger.info("Test for logging: {msg} {my1.msg.ma.sg} {0} {2} {1}", {0:0, 1:1, 2:"fun", msg:"hello", my1:{msg:{ma:{sg:"world"}}}});
			}
			if( (count++) > 40 ) {
				removeEventListener(Event.ENTER_FRAME, logPerFrame);
			}
		}
	}
}
