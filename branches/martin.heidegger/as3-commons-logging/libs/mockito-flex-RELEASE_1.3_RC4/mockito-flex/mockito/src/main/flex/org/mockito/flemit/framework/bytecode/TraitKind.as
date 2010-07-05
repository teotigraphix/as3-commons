package org.mockito.flemit.framework.bytecode
{
	import org.mockito.asmock.Enum;
	
	[ExcludeClass]
	public class TraitKind extends Enum
	{
		public static const SLOT : int = 0x0;
		public static const METHOD : int = 0x1;
		public static const GETTER : int = 0x2;
		public static const SETTER : int = 0x3;
		public static const CLASS : int = 0x4;
		public static const FUNCTION : int = 0x5;
		public static const CONST : int = 0x6;
	}
}