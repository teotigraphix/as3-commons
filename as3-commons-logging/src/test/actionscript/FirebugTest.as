package {
	import org.as3commons.logging.setup.target.ThunderBoltTarget;
	import com.asfusion.mate.core.MateManager;
	import org.as3commons.logging.setup.target.MonsterDebugger3LogTarget;
	import com.demonsters.debugger.MonsterDebugger;
	import com.junkbyte.console.Cc;

	import org.as3commons.logging.ILogger;
	import org.as3commons.logging.LOGGER_FACTORY;
	import org.as3commons.logging.getLogger;
	import org.as3commons.logging.setup.SimpleTargetSetup;
	import org.as3commons.logging.setup.target.ArthropodTarget;
	import org.as3commons.logging.setup.target.FirebugTarget;
	import org.as3commons.logging.setup.target.FlashConsoleTarget;
	import org.as3commons.logging.setup.target.MonsterDebugger3TraceTarget;
	import org.as3commons.logging.setup.target.mergeTargets;
	import org.as3commons.logging.util.captureUncaughtErrors;

	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;

	
	public class FirebugTest extends Sprite {
		
		private const logger: ILogger = getLogger( FirebugTest );
		
		public function FirebugTest() {
			
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			MonsterDebugger.initialize( this );
			Cc.startOnStage( this );
			
			MonsterDebugger.logger = function(...rest):void {
				trace("hi");
			};
			
			LOGGER_FACTORY.setup = new SimpleTargetSetup( mergeTargets(
				new FirebugTarget(), new MonsterDebugger3TraceTarget(),
				new MonsterDebugger3LogTarget(),
				new ArthropodTarget(), new FlashConsoleTarget(),
				new ThunderBoltTarget())
			);
			
			captureUncaughtErrors( loaderInfo );
			
			logger.info(1);
			logger.warn(true);
			logger.error({
				my: {
					house: { isin: { the: { middle: "of the street" } } },
					where: { isyour: "house?" }
				}
			});
			logger.debug("My Text {0}ly is a {1}{2} and {1}{3}", true, {nice:"andwarm"}, "house", 1.0 );
			
			//throw new Error("And here some uncaught exception\n");
		}

	}
}
