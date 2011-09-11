/*
 * Copyright (c) 2008-2009 the original author or authors
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */
package org.as3commons.logging.integration {
	import org.flexunit.runner.notification.RunListener;
	import org.flexunit.runner.notification.IRunListener;
	import org.flexunit.reporting.FailureFormatter;
	import org.as3commons.logging.api.ILogger;
	import org.as3commons.logging.api.getLogger;
	import org.flexunit.runner.IDescription;
	import org.flexunit.runner.Result;
	import org.flexunit.runner.notification.Failure;
	
	/**
	 * This listener sends log statements produced by the FlexUnit framework
	 * to the as3commons logging system.
	 * 
	 * <listing>
	 *   LOGGER_FACTORY.setup = new SimpleTargetSetup( new TraceTarget( "{logLevel} {message}") );
	 *   
	 *   var core: FlexUnitCore = new FlexUnitCore();
	 *   core.addListener( new FlexUnitListener() );
	 * </listing>
	 * 
	 * <p>The implementation uses two loggers, one of the person "Status" and one
	 * of the person "Result".</p>
	 * 
	 * @author Martin Heidegger
	 * @since 2.5.2
	 * @see http://opensource.adobe.com/wiki/display/flexunit/FlexUnit
	 */
	public final class FlexUnitListener extends RunListener implements IRunListener {
		
		private static const statusLogger: ILogger = getLogger( FlexUnitListener, "Status" );
		private static const resultLogger: ILogger = getLogger( FlexUnitListener, "Result" );
		
		/**
		 * @inheritDoc
		 */
		override public function testRunFinished( result:Result ):void {
			var time: String = elapsedTimeAsString( result.runTime );
			if( result.successful ) {
				resultLogger.info( "Time: " + time );
				resultLogger.info( "OK (" + result.runCount + " test" + (result.runCount == 1 ? "" : "s") + ")" );
			} else {
				resultLogger.error( "Time: " + time );
				resultLogger.error( "FAILURES!!! Tests run: " + result.runCount + ", " + result.failureCount + " Failures." );
				printFailures( result );
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override public function testStarted( description:IDescription ):void {
			statusLogger.info( description.displayName + " started" );
		}
		
		/**
		 * @inheritDoc
		 */
		override public function testFailure( failure:Failure ):void {
			//Determine if the exception in the failure is considered an error
			if ( FailureFormatter.isError( failure.exception ) ) {
				statusLogger.fatal( failure.description.displayName + " throw an exception" );
			} else {
				statusLogger.error( failure.description.displayName + " assertion failed");
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override public function testIgnored( description:IDescription ):void {
			statusLogger.warn( description.displayName );
		}
		
		/*
		 * Internal methods
		 */
		
		/**
		 * Traces all failures that were received in the result
		 * 
		 * @param result The result that contains potential failures
		 */
		protected function printFailures( result:Result ):void {
			var failures:Array = result.failures;
			//Determine if there are any failures to print
			if (failures.length == 1)
				resultLogger.error( "There was 1 failure:" );
			else
				resultLogger.error( "There were " + failures.length + " failures:" );
			
			//Print each failure
			for ( var i:int=0; i<failures.length; i++ ) {
				printFailure( failures[ i ], String( i+1 ) );
			}
		}
		
		/**
		 * Traces a provided failure with a certain prefix
		 * 
		 * @param failure The provided failure
		 * @param prefix A String prefix for the failure
		 */
		protected function printFailure( failure:Failure, prefix:String ):void {
			trace( prefix + " " + failure.testHeader + " " + failure.stackTrace );
		}
		
		/**
		 * Returns the formatted string of the elapsed time. Duplicated from
		 * BaseTestRunner. Fix it.
		 */
		protected function elapsedTimeAsString( runTime:Number ):String {
			return String( runTime / 1000 );
		}
	}
}
