package org.as3commons.rpc
{
	public interface IAuthenticator {
		function login(username:String, password:String):void;
		function logout():void;
	}
}