package {
	import org.as3commons.logging.integration.Log5FIntegration;
	import org.log5f.ILogger;
	import org.log5f.LoggerManager;
	import org.log5f.core.config.tags.ConfigurationTag;
	import org.log5f.core.config.tags.LoggerTag;
	import org.log5f.filters.LevelRangeFilter;
	import org.log5f.layouts.SimpleLayout;

	import flash.display.Sprite;
			
	/**
	 * @author mh
	 */
	public class Log5FTest extends Sprite {
		public function Log5FTest() {
			
			var tag: LoggerTag = new LoggerTag();
			tag.appenders = [new Log5FIntegration()];
			tag.level = "ALL";
			
			var setup: ConfigurationTag = new ConfigurationTag();
			setup.objects = [tag];
	 		
			LoggerManager.configure(setup);
			
			var logger: ILogger = LoggerManager.getLogger("com.hello.world");
			logger.debug("Hello World", "1", "2", "3");
		}
	}
}
