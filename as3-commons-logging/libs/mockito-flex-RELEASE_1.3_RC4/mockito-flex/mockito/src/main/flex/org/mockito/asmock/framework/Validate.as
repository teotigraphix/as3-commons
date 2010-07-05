package org.mockito.asmock.framework
{
	import mx.collections.ICollectionView;
	import mx.collections.IList;

	use namespace asmock_internal;

	[ExcludeClass]
	public class Validate
	{
		public static function argsEqual(expectedArgs : Array, actualArgs : Array) : Boolean 
		{
			return recursiveArrayEqual(expectedArgs, actualArgs);
		}
		
		public static function recursiveArrayEqual(expectedArgs : Array, actualArgs : Array) : Boolean
		{
			if ((expectedArgs == null) != (actualArgs == null))
			{
				return false;
			}
			
			if (expectedArgs != null)
			{
				if (expectedArgs.length != actualArgs.length)
				{
					return false;
				}
				
				for (var i:uint=0; i<expectedArgs.length; i++)
				{
					var expected : Object = expectedArgs[i];
					var actual : Object = actualArgs[i];
					
					if ((expected == null) != (actual == null))
					{
						return false;
					}
					
					if (expected != null)
					{
						if (expected is Array)
						{
							if (!recursiveArrayEqual(expected as Array, actual as Array))
							{
								return false;
							}
						}
						else if (expected is IList)
						{
							if (actual is IList)
							{
								if (!recursiveArrayEqual(IList(expected).toArray(), IList(actual).toArray()))
								{
									return false;
								}
							}
							else
							{
								return false;
							}
						}
						else if (expected != actual)
						{
							return false;
						}
					}				
				}
				
				return true;
			}
			else
			{
				return true;
			}
		}

	}
}