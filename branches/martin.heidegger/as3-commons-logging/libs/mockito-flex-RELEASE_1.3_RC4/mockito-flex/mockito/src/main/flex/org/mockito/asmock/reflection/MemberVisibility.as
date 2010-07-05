package org.mockito.asmock.reflection
{
	import org.mockito.asmock.Enum;
	
	[ExcludeClass]
	public class MemberVisibility extends Enum
	{
		public static const PUBLIC : uint = 0x08;
		public static const PROTECTED : uint = 0x18;
		public static const PRIVATE : uint = 0x05;
	}
}