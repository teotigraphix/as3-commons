package org.as3commons.codec.serialization.amf
{
	
	[RemoteClass(alias="be.idamf.media.domain.Artist")]
	public class Artist
	{
		[Id]
		public var artistId:int;
		
		public var name:String;
		
		public function Artist()
		{
		}
	}
}