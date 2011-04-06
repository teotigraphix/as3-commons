package org.as3commons.codec.serialization.amf
{
	
	[RemoteClass(alias="be.idamf.media.domain.Album")]
	public class Album
	{
		[Id]
		public var albumId:int;
		
		public var title:String;
		
		[ManyToOne]
		public var artist:Artist;
		
		[ArrayElementType("org.as3commons.codec.serialization.amf.Track")]
		[OneToMany]
		public var tracks:Array;
		
		public function Album()
		{
		}
	}
}