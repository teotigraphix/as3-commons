package org.as3commons.logging.setup.target {
	import flash.events.Event;
	import org.as3commons.logging.LogLevel;
	import org.as3commons.logging.setup.ILogTarget;

	import flash.display.Shape;

	/**
	 * @author mh
	 */
	public class FrameBufferTarget implements ILogTarget {
		
		private static const _buffers: Array = [];
		
		private static function clearBuffers( event: Event ): void {
			for( var index: int = _buffers.length-1; index > -1; --index ) {
				if( FrameBufferTarget( _buffers[index] ).clear() ) {
					_buffers.splice( index, 1 );
				}
			}
		}
		
		private static const _shape: Shape = new Shape();
		{
			_shape.addEventListener( Event.ENTER_FRAME, clearBuffers );
		}
		
		private const _bufferedStatements:Array = [];
		
		private var _target:ILogTarget;
		private var _statementsPerFrame:int;
		private var _statementsThisFrame:int = 0;
		private var _isRegistered:Boolean;
		
		public function FrameBufferTarget( target: ILogTarget, statementsPerFrame: int ) {
			_target = target;
			_statementsPerFrame = statementsPerFrame;
		}
		
		public function log(name:String, shortName:String, level:LogLevel, timeStamp:Number, message:*, parameters:Array):void {
			if( _statementsThisFrame < _statementsPerFrame && _bufferedStatements.length == 0 ) {
				_target.log(name, shortName, level, timeStamp, message, parameters);
				++_statementsThisFrame;
			} else {
				_bufferedStatements.push( new BufferStatement(name, shortName, level, timeStamp, message, parameters));
			}
			
			if( !_isRegistered ) {
				// Even if the buffer ain't full, it has to set 
				_isRegistered = true;
				_buffers.push( this );
			}
		}
		
		private function clear(): Boolean {
			for( var i: int = _statementsPerFrame-1; i>-1; --i ) {
				var statement: BufferStatement = _bufferedStatements.shift();
				if( statement ) {
					_target.log( statement.name, statement.shortName, statement.level, statement.timeStamp, statement.message, statement.parameters);
				} else {
					break;
				}
			}
			if( _bufferedStatements.length == 0 ) {
				_statementsThisFrame = 0;
				_isRegistered = false;
				return true;
			} else {
				return false;
			}
		}
	}
}
