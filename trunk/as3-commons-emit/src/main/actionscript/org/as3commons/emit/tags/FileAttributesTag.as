package org.as3commons.emit.tags
{
	import org.as3commons.emit.ISWFOutput;
	
	
	public class FileAttributesTag extends AbstractTag
	{
		public static const TAG_ID : int = 0x45; 
		
		private var _useDirectBlit : Boolean = false;
		private var _useGPU : Boolean = false;
		private var _hasMetadata : Boolean = false;
		private var _actionScript3 : Boolean = true;
		private var _useNetwork : Boolean = true;
		
		private var _outputOrder : Array = [
			"reserved", "useDirectBlit", "useGPU", "hasMetadata", 
			"actionScript3", "reserved", "useNetwork", "reserved", 
			"reserved", "reserved", "reserved", "reserved", 
			"reserved", "reserved", "reserved", "reserved", 
			"reserved", "reserved", "reserved", "reserved",
			"reserved", "reserved", "reserved", "reserved", 
			"reserved", "reserved", "reserved", "reserved", 
			"reserved", "reserved", "reserved"
			];
		
		public function FileAttributesTag()
		{
			super(TAG_ID);
		}
		
		public override function writeData(output:ISWFOutput):void		
		{
			for each(var prop : String in _outputOrder) 
				output.writeBit(this[prop] as Boolean);
				
			output.align();
		}
		
		public function get useDirectBlit() : Boolean { return _useDirectBlit; }
		public function set useDirectBlit(value : Boolean) : void { _useDirectBlit = value; }
		
		public function get useGPU() : Boolean { return _useGPU; }
		public function set useGPU(value : Boolean) : void { _useGPU = value; }
		
		public function get hasMetadata() : Boolean { return _hasMetadata; }
		public function set hasMetadata(value : Boolean) : void { _hasMetadata = value; }
		
		public function get actionScript3() : Boolean { return _actionScript3; }
		public function set actionScript3(value : Boolean) : void { _actionScript3 = value; }
		
		public function get useNetwork() : Boolean { return _useNetwork; }
		public function set useNetwork(value : Boolean) : void { _useNetwork = value; }
		
		private function get reserved() : Boolean { return false; }
		
		public static function create(useDirectBlit : Boolean, useGPU : Boolean, hasMetadata : Boolean, actionScript3 : Boolean, useNetwork : Boolean) : FileAttributesTag
		{
			var tag : FileAttributesTag = new FileAttributesTag();
			
			tag.useDirectBlit = useDirectBlit;
			tag.useGPU = useDirectBlit;
			tag.hasMetadata = hasMetadata;
			tag.actionScript3 = actionScript3;
			tag.useNetwork = useNetwork;
			
			return tag;
		}
	}
}