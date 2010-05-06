package org.as3commons.emit.tags
{
	import org.as3commons.emit.ISWFOutput;
	
	
	public class ScriptLimitsTag extends AbstractTag
	{
		public static const TAG_ID : int = 0x41;
		
		private var _maxRecursionDepth : int = 1000;
		private var _scriptTimeoutSeconds : int = 60;
		
		public function ScriptLimitsTag()
		{
			super(TAG_ID);
		}
		
		public override function writeData(output:ISWFOutput):void		
		{
			output.writeUI16(_maxRecursionDepth);
			output.writeUI16(_scriptTimeoutSeconds);
		}
		
		public function get maxRecursionDepth() : uint { return _maxRecursionDepth; }
		public function set maxRecursionDepth(value : uint) : void { _maxRecursionDepth = value; }
		
		public function get scriptTimeoutSeconds() : uint { return _scriptTimeoutSeconds; }
		public function set scriptTimeoutSeconds(value : uint) : void { _scriptTimeoutSeconds = value; }
	}
}