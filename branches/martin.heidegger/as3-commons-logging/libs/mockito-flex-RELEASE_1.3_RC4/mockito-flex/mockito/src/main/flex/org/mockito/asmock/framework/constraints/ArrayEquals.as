package org.mockito.asmock.framework.constraints
{
	import org.mockito.asmock.util.*;
	
	public class ArrayEquals extends AbstractConstraint
	{
		private var _values : Array;
		
		public function ArrayEquals(values : Array)
		{
			if (values == null)
			{
				throw new ArgumentError("values cannot be null");
			}
			
			_values = values;
		}
		
		public override function eval(obj:Object):Boolean	
		{
			var arr : Array = obj as Array;
			
			if (arr == null || arr.length != _values.length)
			{
				return false;
			}
			
			for (var i:uint=0;i<_values.length;i++)
			{
				if (arr[i] != _values[i])
				{
					return false;
				}
			}
			
			return true;
		}
		
		public override function get message():String
		{
			var sb : StringBuilder = new StringBuilder();
			
			sb.append("equal to array [");
			
			for (var i:uint=0;i<_values.length;i++)
			{
				if (i>0)
				{
					sb.append(", ");
				}
				
				sb.append(_values[i]);
			}
			
			sb.append("]");
			
			return sb.toString();
		}
	}
}