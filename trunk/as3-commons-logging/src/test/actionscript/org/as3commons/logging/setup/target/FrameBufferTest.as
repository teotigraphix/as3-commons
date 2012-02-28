package org.as3commons.logging.setup.target {
	import org.as3commons.logging.level.DEBUG;
	import org.as3commons.logging.api.ILogTarget;
	import org.as3commons.logging.util.verifyNothingCalled;
	import org.mockito.integrations.eq;
	import org.mockito.integrations.flexunit3.MockitoTestCase;
	import org.mockito.integrations.inOrder;
	import org.mockito.integrations.mock;

	import flash.display.Shape;
	import flash.events.Event;

	/**
	 * @author mh
	 */
	public class FrameBufferTest extends MockitoTestCase {
		
		private const _shape: Shape = new Shape;
		private var _async:Function;
		private var _targetMock:ILogTarget;
		private var _arr2:Array;
		
		public function FrameBufferTest() {
			super( [ILogTarget] );
		}
		
		public function testBuffer(): void {
			_targetMock = mock( ILogTarget );
			
			var buffer: FrameBufferTarget = new FrameBufferTarget(_targetMock, 2);
			
			var arr1: Array = [1,2,"a"];
			_arr2 = [];
			
			buffer.log( "name", "shortName", DEBUG, 12345, "Sample", arr1, null );
			buffer.log( "name2", "shortName", DEBUG, 12467, "Test", _arr2, null );
			buffer.log( "hose", "shortName", DEBUG, 12467, "Demo", _arr2, null );
			
			inOrder().verify().that( _targetMock.log( eq("name"), eq("shortName"), eq(DEBUG), eq(12345), eq("Sample"), eq(arr1), eq(null) ) );
			inOrder().verify().that( _targetMock.log( eq("name2"), eq("shortName"), eq(DEBUG), eq(12467), eq("Test"), eq(_arr2), eq(null) ) );
			
			verifyNothingCalled(_targetMock );
			
			_shape.addEventListener( Event.EXIT_FRAME, enterframe );
			
			_async = addAsync( function(e: Event): void{}, 60000 );
		}
		
		private function enterframe( e: Event ):void {
			_shape.removeEventListener( Event.EXIT_FRAME, enterframe );
			inOrder().verify().that( _targetMock.log( eq("name2"), eq("shortName"), eq(DEBUG), eq(12467), eq("Test"), eq(_arr2), eq(null) ) );
			_async( new Event( Event.ADDED ) );
		}
	}
}
