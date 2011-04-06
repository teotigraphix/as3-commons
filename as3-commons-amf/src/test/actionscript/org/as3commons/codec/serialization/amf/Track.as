package org.as3commons.codec.serialization.amf
{
	
	[RemoteClass(alias="be.idamf.media.domain.Track")]
	public class Track
	{
		[Id]
		public var trackId:int;
		
		public var trackIndex:int;
		
		public var title:String;
		
		[ManyToOne]
		public var artist:Artist;
		
		[ManyToOne]
		public var album:Album;
		
		public function Track()
		{
		}
	}
}