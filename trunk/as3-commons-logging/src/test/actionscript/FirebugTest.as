package {
	import org.as3commons.logging.setup.target.AlconTarget;
	import org.as3commons.logging.setup.target.DConsoleTarget;
	import com.furusystems.dconsole2.DConsole;
	import com.demonsters.debugger.MonsterDebugger;
	import com.junkbyte.console.Cc;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import org.as3commons.logging.api.ILogger;
	import org.as3commons.logging.api.LOGGER_FACTORY;
	import org.as3commons.logging.api.getLogger;
	import org.as3commons.logging.setup.SimpleTargetSetup;
	import org.as3commons.logging.setup.target.ArthropodTarget;
	import org.as3commons.logging.setup.target.FirebugTarget;
	import org.as3commons.logging.setup.target.FlashConsoleTarget;
	import org.as3commons.logging.setup.target.MonsterDebugger3LogTarget;
	import org.as3commons.logging.setup.target.MonsterDebugger3TraceTarget;
	import org.as3commons.logging.setup.target.ThunderBoltTarget;
	import org.as3commons.logging.setup.target.mergeTargets;
	import org.as3commons.logging.util.captureUncaughtErrors;



	
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
			
			addChild( DConsole.view );
			DConsole.show();
			
			LOGGER_FACTORY.setup = new SimpleTargetSetup( mergeTargets(
				new FirebugTarget(), new MonsterDebugger3TraceTarget(),
				new MonsterDebugger3LogTarget(),
				new ArthropodTarget(), new FlashConsoleTarget(),
				new ThunderBoltTarget(), new DConsoleTarget(), new AlconTarget() )
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
			logger.info( {Hello: "World"} );
			logger.debug("My Text {0}ly is a {1}{2} and {1}{3}", [true, {nice:"andwarm"}, "house", 1.0] );
			
			//throw new Error("And here some uncaught exception\n");
		}

	}
}
