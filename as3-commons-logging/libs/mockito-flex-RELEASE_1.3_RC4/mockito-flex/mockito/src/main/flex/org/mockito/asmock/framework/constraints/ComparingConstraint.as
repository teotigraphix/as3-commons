package org.mockito.asmock.framework.constraints
{
	import org.mockito.asmock.util.StringBuilder;
	
	public class ComparingConstraint extends AbstractConstraint
	{
		private var _value : Object;
		private var _greater : Boolean;
		private var _andEqual : Boolean;
		
		public function ComparingConstraint(value : Object, greater : Boolean, andEqual : Boolean)
		{
			_value = value;
			_greater = greater;
			_andEqual = andEqual;			
		}
		
		public override function eval(obj:Object):Boolean
		{
			if (_andEqual && obj == _value) 
			{
				return true;
			}
			
			if (_greater && obj > _value)
			{
				return true;
			}
			
			return (!_greater) && (obj < _value);
		}
		
		public override function get message():String
		{
			var sb : StringBuilder = new StringBuilder();
			
			if (_greater)
			{
				sb.append("greater than ");
			}			
			else
			{
				sb.append("less than ");
			}
			
			if (_andEqual)
			{
				sb.append("or equal to ");
			}
			
			sb.append(_value.toString());
			
			return sb.toString();
		}

	}
}