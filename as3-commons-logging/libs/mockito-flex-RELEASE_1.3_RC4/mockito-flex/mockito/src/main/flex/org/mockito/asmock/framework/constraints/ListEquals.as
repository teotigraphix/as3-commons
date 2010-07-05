package org.mockito.asmock.framework.constraints
{
	import mx.collections.IList;
	import org.mockito.asmock.util.*;
	
	public class ListEquals extends AbstractConstraint
	{
		private var _values : IList;
		
		public function ListEquals(values : IList)
		{
			if (values == null)
			{
				throw new ArgumentError("values cannot be null");
			}
			
			_values = values;
		}
		
		public override function eval(obj:Object):Boolean	
		{
			var lst : IList = obj as IList;
			
			if (lst == null || lst.length != _values.length)
			{
				return false;
			}
			
			for (var i:uint=0;i<_values.length;i++)
			{
				if (lst.getItemAt(i) != _values.getItemAt(i))
				{
					return false;
				}
			}
			
			return true;
		}
		
		public override function get message():String
		{
			var sb : StringBuilder = new StringBuilder();
			
			sb.append("equal to list [");
			
			for (var i:uint=0;i<_values.length;i++)
			{
				if (i>0)
				{
					sb.append(", ");
				}
				
				sb.append(_values.getItemAt(i).toString());
			}
			
			sb.append("]");
			
			return sb.toString();
		}
	}
}