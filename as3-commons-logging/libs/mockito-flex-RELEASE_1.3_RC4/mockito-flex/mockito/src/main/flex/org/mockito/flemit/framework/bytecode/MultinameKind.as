package org.mockito.flemit.framework.bytecode
{
	import org.mockito.asmock.Enum;
	
	[ExcludeClass]
	public class MultinameKind extends Enum
	{
		public static const QUALIFIED_NAME : uint = 0x07;
        public static const QUALIFIED_NAME_ATTRIBUTE : uint = 0x0D;
        public static const RUNTIME_QUALIFIED_NAME : uint = 0x0F;
        public static const RUNTIME_QUALIFIED_NAME_ATTRIBUTE : uint = 0x10;
        public static const RUNTIME_QUALIFIED_NAME_LATE : uint = 0x11;
        public static const RUNTIME_QUALIFIED_NAME_LATE_ATTRIBUTE : uint = 0x12;
        public static const MULTINAME : uint = 0x09;
        public static const MULTINAME_ATTRIBUTE : uint = 0x0E;
        public static const MULTINAME_LATE : uint = 0x1B;
        public static const MULTINAME_LATE_ATTRIBUTE : uint = 0x1C;
        public static const GENERIC : uint = 0x1D;

	}
}