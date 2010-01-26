package org.as3commons.logging {
	import org.as3commons.logging.util.TimesRange;
	import org.mockito.MockitoTestCase;

	/**
	 * @author Martin
	 */
	public class LoggerFactoryTest extends MockitoTestCase {

		public function LoggerFactoryTest() {
			super([ILogTargetFactory]);
		}

		[Test]

		public function testGettingMatchers():void {
			assertStrictlyEquals(LoggerFactory.getClassLogger(LoggerFactoryTest), LoggerFactory.getClassLogger(LoggerFactoryTest));
			
			assertFalse(LoggerFactory.getClassLogger(LoggerFactoryTest) ==  LoggerFactory.getClassLogger(LoggerFactory));
			
			assertStrictlyEquals(LoggerFactory.getLogger(""), LoggerFactory.getLogger(""));
			
			assertStrictlyEquals(LoggerFactory.getLogger("test.more"), LoggerFactory.getLogger("test.more"));
			
			assertStrictlyEquals(LoggerFactory.getLogger(null), LoggerFactory.getLogger(null));
			
			assertFalse( LoggerFactory.getLogger(null) == LoggerFactory.getLogger("null") );
			
			assertStrictlyEquals(LoggerFactory.getLogger(undefined), LoggerFactory.getLogger(undefined));
			
			assertFalse( LoggerFactory.getLogger(undefined) == LoggerFactory.getLogger("undefined") );
		}

		[Test]

		public function testTargetFactory():void {
			var factory:ILogTargetFactory = ILogTargetFactory(mock(ILogTargetFactory));
			LoggerFactory.loggerFactory = factory;
			verify(timesRange(1, int.MAX_VALUE)).that(factory.getLogTarget(any()));
		}

		private function timesRange(min:int,max:int):TimesRange {
			return new TimesRange(min, max);
		}
	}
}
