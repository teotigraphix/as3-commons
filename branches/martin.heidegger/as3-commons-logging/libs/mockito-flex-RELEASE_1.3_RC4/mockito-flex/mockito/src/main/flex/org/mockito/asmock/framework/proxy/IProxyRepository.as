package org.mockito.asmock.framework.proxy
{
	import flash.events.IEventDispatcher;
	import flash.system.ApplicationDomain;
	
	/**
	 * Prepares and stores proxy implementations of classes and interfaces.
	 * 
	 */
	[ExcludeClass]
	public interface IProxyRepository
	{
		function create(cls : Class, args : Array, interceptor : IInterceptor) : Object;
		function prepare(types : Array, applicationDomain : ApplicationDomain = null) : IEventDispatcher;
	}
}