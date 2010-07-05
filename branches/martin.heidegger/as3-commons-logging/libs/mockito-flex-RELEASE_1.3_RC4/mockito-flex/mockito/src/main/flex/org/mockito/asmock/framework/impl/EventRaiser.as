package org.mockito.asmock.framework.impl
{
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	
	[ExcludeClass]
	public class EventRaiser implements IEventRaiser
	{
		private var _eventDispatcher : IEventDispatcher;
		private var _event : String;
		
		public function EventRaiser(eventDispatcher : IEventDispatcher, event : String)
		{
			_eventDispatcher = eventDispatcher;
			_event = event;
		}
		
		public function raise(event : Event) : void
		{
			if (event.type != _event)
			{
				throw new ArgumentError("Cannot raise the " + event.type + " event when EventRaiser was created after " + _event);
			}
			
			_eventDispatcher.dispatchEvent(event);
		}

	}
}