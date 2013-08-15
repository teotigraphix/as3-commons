package org.as3commons.async.test {
	import flash.utils.setTimeout;
	
	import org.as3commons.async.operation.ICancelableOperation;
	import org.as3commons.async.operation.event.CancelableOperationEvent;
	import org.as3commons.async.operation.impl.MockOperation;

	public class MockCanceleableOperation extends MockOperation implements ICancelableOperation {
		public function MockCanceleableOperation(resultData:*, delay:int=1000, returnError:Boolean=false, func:Function=null, useRandomDelay:Boolean=true) {
			super(resultData, delay, returnError, func, useRandomDelay);
		}

		public function addCancelListener(listener:Function, useCapture:Boolean=false, priority:int=0, useWeakReference:Boolean=false):void {
			addEventListener(CancelableOperationEvent.CANCELED, listener, useCapture, priority, useWeakReference);
		}

		public function removeCancelListener(listener:Function, useCapture:Boolean=false):void {
			removeEventListener(CancelableOperationEvent.CANCELED, listener, useCapture);
		}

		public function cancel():void {
			dispatchEvent(new CancelableOperationEvent(CancelableOperationEvent.CANCELED, this));
		}
		
		override protected function initMockOperation(resultData:*, delay:int, returnError:Boolean, func:Function, useRandomDelay:Boolean):void {
			setTimeout(function():void {
				if (func != null) {
					func();
				}
				cancel();
			}, delay);
		}
	}
}
