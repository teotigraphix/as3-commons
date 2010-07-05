package org.mockito.flemit.framework
{
	[ExcludeClass]
	public class Rectangle
	{
		public function Rectangle(xMin : int, xMax : int, yMin : int, yMax : int)
		{
			this.xMin = xMin;
			this.xMax = xMax;
			this.yMin = yMin;
			this.yMax = yMax;
		}
		
		public var xMin : int = 0;
		public var xMax : int = 0;
		public var yMin : int = 0;
		public var yMax : int = 0;
	}
}