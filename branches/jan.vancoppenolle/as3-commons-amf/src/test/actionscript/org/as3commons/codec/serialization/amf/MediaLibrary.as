package org.as3commons.codec.serialization.amf
{
	public class MediaLibrary
	{
		public static function get data():Array
		{
			var array:Array = [];
			var album:Album;
			var artist:Artist;
			var track:Track;
			var tracks:Array;
			var title:String;
			var trackId:int = 0;
			var trackIndex:int;
			
			artist = new Artist();
			artist.name = "Joy Division";
			
			album = new Album();
			album.albumId = 1;
			album.artist = artist;
			album.title = "Unknown Pleasures";
			album.tracks = [];
			
			tracks = ["Disorder", "Day of the Lords", "Candidate", "Insight", "New Dawn Fades", "She's Lost Control", "Shadowplay", "Wilderness", "Interzone", "I Remember Nothing"];
			trackIndex = 0;
			
			for each (title in tracks)
			{
				track = new Track();
				track.album = album;
				track.artist = artist;
				track.trackId = trackId++;
				track.trackIndex = trackIndex++;
				track.title = title;
				album.tracks.push(track);
			}
			
			array.push(album);
			
			return array;
		}
		
		public function MediaLibrary()
		{
		}
	}
}