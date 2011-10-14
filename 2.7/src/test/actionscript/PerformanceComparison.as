package {
	import flash.text.TextField;
	import flash.display.StageScaleMode;
	import flash.display.StageAlign;
	import perf.PBEPerformance;
	import perf.MatePerformance;
	import perf.SpiceLibPerformance;
	import perf.Progression4Performance;
	import perf.AsapPerformance;
	import perf.As3CommonsPeformance;
	import perf.FlexPerformance;
	import perf.IPerformance;
	import perf.SwizPerformance;

	import flash.display.Sprite;
	import flash.utils.getQualifiedClassName;
	import flash.utils.setTimeout;
	/**
	 * @author mh
	 */
	public class PerformanceComparison extends Sprite {
		
		public static const name: String = getQualifiedClassName(PerformanceComparison);
		private var _trace: TextField;
		
		public function PerformanceComparison() {
			
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			addChild( _trace = new TextField() );
			_trace.width = stage.stageWidth;
			_trace.height = stage.stageHeight;
			
			setTimeout( startup, 500 );
		}
		
		private function startup() : void {
			var targets: Array = [
				new As3CommonsPeformance(),
				new SwizPerformance(),
				new FlexPerformance(),
				new AsapPerformance(),
				new SpiceLibPerformance(),
				new MatePerformance(),
				new PBEPerformance(),
				new Progression4Performance()
			];
			const count: int = 100000;
			for each( var target: IPerformance in targets ) {
				var simple: Number = target.simple( count );
				var nil: Number = target.nullLogger( count ) - simple;
				trace( target.name + "," + simple + "," + nil );
			}
		}
		
		private function trace(msg: String):void {
			_trace.appendText(msg+"\n");
		}
	}
}
