package org.mockito.asmock.framework.impl
{
	import org.mockito.asmock.reflection.PropertyInfo;
	import org.mockito.asmock.reflection.MethodInfo;
	import org.mockito.asmock.framework.IMockedObject;

	[ExcludeClass]
	public class MockedObject implements IMockedObject
	{
		public function MockedObject()
		{
		}

		public function shouldCallOriginal(method:MethodInfo):Boolean
		{
			return false;
		}
		
		public function handleProperty(property:PropertyInfo, method:MethodInfo, args:Array):Object
		{
			return null;
		}
		
		public function isRegisteredProperty(property:PropertyInfo):Boolean
		{
			return false;
		}
		
	}
}