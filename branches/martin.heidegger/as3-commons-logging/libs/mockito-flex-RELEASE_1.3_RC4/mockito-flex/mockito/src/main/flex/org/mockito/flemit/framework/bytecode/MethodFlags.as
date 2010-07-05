package org.mockito.flemit.framework.bytecode
{
	[ExcludeClass]
	public class MethodFlags
	{
		public static var NEED_ARGUMENTS : uint = 0x01;
		public static var NEED_ACTIVATION : uint = 0x02;
		public static var NEED_REST : uint = 0x04;
		public static var HAS_OPTIONAL : uint = 0x08;
		public static var SET_DXNS : uint = 0x40;
		public static var HAS_PARAM_NAMES : uint = 0x80;
	}
}