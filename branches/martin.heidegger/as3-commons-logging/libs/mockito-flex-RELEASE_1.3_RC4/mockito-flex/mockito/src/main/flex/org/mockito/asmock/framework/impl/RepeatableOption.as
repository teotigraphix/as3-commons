package org.mockito.asmock.framework.impl
{
	import org.mockito.asmock.Enum;
	
	[ExcludeClass]
	public class RepeatableOption extends Enum
	{
		public static const NORMAL : uint = 0x0;
		public static const NEVER : uint = 0x1;
		public static const ANY : uint = 0x2;
		public static const ORIGINAL_CALL : uint = 0x3;
		public static const ORIGINAL_CALL_BYPASSING_MOCKING : uint = 0x4;
		public static const PROPERTY_BEHAVIOR : uint = 0x5;
	}
}