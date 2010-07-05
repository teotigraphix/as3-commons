package org.mockito.asmock.framework.constraints
{
	import org.mockito.asmock.util.*;
	
	public class OneOf extends AbstractConstraint
	{
		private var _items : Array;
		
		public function OneOf(items : Array)
		{
			if (items == null || items.length == 0)
			{
				throw new ArgumentError("items cannot be null or empty");
			}
			
			_items = items;
		}
		
		public override function eval(obj:Object):Boolean
		{
			for each(var item : Object in _items)
			{
				if (item == obj)
				{
					return true;
				}
			}
			
			return false;
		}
		
		public override function get message():String
		{
			var sb : StringBuilder = new StringBuilder();
			
			sb.append("one of [");
			
			for (var i:uint=0;i<_items.length;i++)
			{
				if (i>0)
				{
					sb.append(", ");
				}
				
				sb.append(_items[i]);
			}
			
			sb.append("]");
			
			return sb.toString();
		}
	}
}