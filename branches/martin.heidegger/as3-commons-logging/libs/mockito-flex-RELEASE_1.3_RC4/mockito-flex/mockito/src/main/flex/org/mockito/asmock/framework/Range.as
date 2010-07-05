package org.mockito.asmock.framework
{
	[ExcludeClass]
	public class Range
	{
		private var _min : int;
		private var _max : int;
		
		public function Range(min : int, max : int)
		{
			_min = min;
			_max = max;
		}
		
		public function get min() : int { return _min; }
		public function get max() : int { return _max; }

		public function toString() : String
		{
			return (_min == _max)
				? _min.toString()
				: _min.toString().concat(" - ", _max.toString());
		}
	}
}