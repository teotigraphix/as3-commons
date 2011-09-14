package org.as3commons.rpc.impl
{
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	import flash.net.URLRequestMethod;
	
	import org.as3commons.rpc.IAuthenticator;
	import org.as3commons.rpc.ISerializer;
	
	public class SpringSecurityAuthenticator implements IAuthenticator
	{
		private static const AUTHORISATION_HEADER:String = "Authorization";
		private static const BASIC_AUTH:String = "Basic";
		private static const LOGIN_OPERATION:String = "login";
		private static const LOGOUT_OPERATION:String = "logout";
		
		/**
		 * @private
		 */
		public function SpringSecurityAuthenticator(service:HTTPService=null, base64Serializer:ISerializer=null)
		{
			this.service = service;
			this.base64Serializer = base64Serializer;
		}
		
		////////////////////////////////////////////////////////////////////////
		
		public var service:HTTPService;
		public var base64Serializer:ISerializer;
		
		////////////////////////////////////////////////////////////////////////
		// IAuthenticator impl
		
		public function login(username:String, password:String):void
		{
			var value:String = BASIC_AUTH + " " + base64Serializer.serialize(username + ":" + password);
			var authHeader:URLRequestHeader = new URLRequestHeader(AUTHORISATION_HEADER, value);
			var request:URLRequest = new URLRequest(service.baseURI);
			request.method = URLRequestMethod.POST;
			request.requestHeaders = [authHeader];
			service.load(request, LOGIN_OPERATION);
		}
		
		public function logout():void
		{
		}
	}
}