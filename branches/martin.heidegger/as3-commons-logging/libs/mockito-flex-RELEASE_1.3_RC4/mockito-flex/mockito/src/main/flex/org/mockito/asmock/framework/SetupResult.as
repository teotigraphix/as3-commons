package org.mockito.asmock.framework
{
	import flash.errors.IllegalOperationError;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	/**
	 * Enables method expectation options to be set on a call 
	 * without call count restrictions. 
	 * @author Richard
	 */	
	public class SetupResult
	{
		[Exclude]
		public function SetupResult()
		{
			throw new IllegalOperationError("This class is static");
		}
		
		/**
		 * Retrieves the method options for the call supplied 
		 * with no call count restrictions. It is functionally equivalent 
		 * to calling Expect.call(method()).repeat.any();
		 * @param ignored The expected accessor (property) or method should be called here
		 * @return The method options for the call
		 * @includeExample SetupResult_forCall.as
		 */
		public static function forCall(ignored : *) : IMethodOptions
		{
			return LastCall.getOptions().repeat.any();
		}
		
		/**
		 * Sets up a proxy EventDispatcher for a mock IEventDispatcher
		 * @param eventDispatcher The IEventDispatcher mock to handle IEventDispatcher methods for
		 * @includeExample SetupResult_forEventDispatcher.as
		 */
		[Deprecated(replacement="MockRepository.stubEvents")]		
		public static function forEventDispatcher(eventDispatcher : IEventDispatcher) : void
		{
			var dispatcherProxy : EventDispatcher = new EventDispatcher(eventDispatcher);
			
			forCall(eventDispatcher.addEventListener(null, null, false, 0, false))
				.ignoreArguments().doAction(function(type : String, listener : Function, useCapture : Boolean = false, priority : int = 0, useWeakReference : Boolean = false) : void    
			{
				dispatcherProxy.addEventListener(type, listener, useCapture, priority, useWeakReference);
			});
			
			forCall(eventDispatcher.removeEventListener(null, null, false))
				.ignoreArguments().doAction(function(type : String, listener : Function, useCapture : Boolean = false) : void    
			{
				dispatcherProxy.removeEventListener(type, listener, useCapture);
			});
			
			forCall(eventDispatcher.dispatchEvent(null))
				.ignoreArguments().doAction(function(event : Event) : Boolean    
			{
				return dispatcherProxy.dispatchEvent(event);
			});
			
			forCall(eventDispatcher.hasEventListener(null))
				.ignoreArguments().doAction(function(type : String) : Boolean    
			{
				return dispatcherProxy.hasEventListener(type);
			});
			
			forCall(eventDispatcher.willTrigger(null))
				.ignoreArguments().doAction(function(type : String) : Boolean    
			{
				return dispatcherProxy.willTrigger(type);
			});
		}
	}
}