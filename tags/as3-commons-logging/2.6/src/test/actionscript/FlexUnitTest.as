package {
	import flexunit.ErrorTest;
	import flexunit.IgnoredTest;
	import flexunit.NormalTest;

	import org.as3commons.logging.api.LOGGER_FACTORY;
	import org.as3commons.logging.integration.FlexUnitListener;
	import org.as3commons.logging.setup.SimpleTargetSetup;
	import org.as3commons.logging.setup.target.TraceTarget;
	import org.flexunit.runner.FlexUnitCore;

	import flash.display.Sprite;
	/**
	 * @author mh
	 */
	public class FlexUnitTest extends Sprite {
		
		public function FlexUnitTest() {
			
			LOGGER_FACTORY.setup = new SimpleTargetSetup( new TraceTarget( "{logLevel} {message}") );
			
			var core: FlexUnitCore = new FlexUnitCore();
			core.addListener( new FlexUnitListener() );
			core.addListener( next( function( listener:*): void {
				core.removeListener( listener );
				core.run( [NormalTest] );
			}));
			core.run( [
				ErrorTest,
				NormalTest,
				IgnoredTest
			]);
			
		}
		
		private function next( fnc: Function ): NextListener {
			return new NextListener(fnc);
		}
	}
}
import org.flexunit.runner.notification.Failure;
import org.flexunit.runner.IDescription;
import org.flexunit.runner.Result;
import org.flexunit.runner.notification.IRunListener;

class NextListener implements IRunListener {
	private var _fnc: Function;
	
	public function NextListener( fnc: Function ) {
		_fnc = fnc;
	}

	public function testAssumptionFailure(failure : Failure) : void {
	}

	public function testFailure(failure : Failure) : void {
	}

	public function testFinished(description : IDescription) : void {
	}

	public function testIgnored(description : IDescription) : void {
	}

	public function testRunFinished(result : Result) : void {
		_fnc(this);
	}

	public function testRunStarted(description : IDescription) : void {
	}

	public function testStarted(description : IDescription) : void {
	}
	
}