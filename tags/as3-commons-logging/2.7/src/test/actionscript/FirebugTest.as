package {
	import org.as3commons.logging.setup.target.mergeTargets;
	import org.log5f.Level;
	import org.log5f.core.Category;
	import org.log5f.events.LogEvent;
	import org.log5f.layouts.Log4JLayout;
	import org.log5f.filters.Filter;
	import org.log5f.appenders.XMLSocketAppender;
	import flash.events.Event;
	import org.log5f.Log5F;
	import org.as3commons.logging.setup.target.ChainsawTarget;
	import org.as3commons.logging.setup.target.SOSTarget;
	import org.as3commons.logging.util.SWFInfo;
	import com.furusystems.dconsole2.DConsole;
	import com.demonsters.debugger.MonsterDebugger;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import org.as3commons.logging.api.ILogger;
	import org.as3commons.logging.api.LOGGER_FACTORY;
	import org.as3commons.logging.api.getLogger;
	import org.as3commons.logging.setup.SimpleTargetSetup;
	import org.as3commons.logging.util.captureUncaughtErrors;



	
	public class FirebugTest extends Sprite {
		
		private const logger: ILogger = getLogger( FirebugTest );
		
		public function FirebugTest() {
			
			SWFInfo.init(stage);
			
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			MonsterDebugger.initialize( this );
			
			MonsterDebugger.logger = function(...rest):void {
				trace("hi");
			};
			
			addChild( DConsole.view );
			DConsole.show();
			
			LOGGER_FACTORY.setup = new SimpleTargetSetup(
				mergeTargets(
					new SOSTarget(),
					new ChainsawTarget()
				)
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
			
			
			addEventListener( Event.ENTER_FRAME, function(e:Event):void {
				logger.info("hi");
			});
		}

	}
}
