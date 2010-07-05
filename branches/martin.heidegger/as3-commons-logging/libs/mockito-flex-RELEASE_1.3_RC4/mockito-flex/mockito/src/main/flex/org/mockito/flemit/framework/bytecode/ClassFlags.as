package org.mockito.flemit.framework.bytecode
{
	import org.mockito.asmock.*;
	
	[ExcludeClass]
	public class ClassFlags extends Enum
	{
		public static const SEALED : uint = 0x01;
		public static const FINAL : uint = 0x02;
		public static const INTERFACE : uint = 0x04;
		public static const PROTECTED_NAMESPACE : uint = 0x08;		
	}
}