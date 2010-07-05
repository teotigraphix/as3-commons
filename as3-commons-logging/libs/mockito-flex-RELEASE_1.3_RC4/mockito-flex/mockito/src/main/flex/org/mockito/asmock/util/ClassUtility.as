package org.mockito.asmock.util
{
	import flash.errors.IllegalOperationError;
	import flash.utils.getQualifiedClassName;
	
	[ExcludeClass]
	public class ClassUtility
	{
		public static function assertAbstract(instance : Object, cls : Class) : void
		{
			var instanceName : String = getQualifiedClassName(instance);
			var className : String = getQualifiedClassName(cls); 
			
			if (instanceName == className)
			{
				throw new IllegalOperationError("Cannot create instance of abstract class '" + className + "'");
			}
		}
		
		public static function isMatch(packageString : String, cls : *) : Boolean
		{
			var classString : String = null;
			
			if (cls is String)
				classString = cls as String;
			else
				classString = getQualifiedClassName(cls);
				
			classString = classString.replace('::','.');
				
			
			var packageParts : Array = packageString.split('.');
			var classParts : Array = classString.split('.');
			
			for (var i:uint=0; i<packageParts.length && i<classParts.length; i++)
			{
				if (packageParts[i] == '*')
					return true;
				
				if (packageParts[i] != classParts[i])
					return false;
			}
			
			return (packageParts.length == classParts.length);
		}
		
		public static function createClass(cls : Class, args : Array) : Object
		{
			var delegateArgs : Array = [cls].concat(args); // clone
			
			if (args.length > MAX_CREATECLASS_ARG_COUNT)
			{
				throw new ArgumentError("Argument count greater than supported (10)");
			}
			
			var delegate : Function = _createClassDelegates[args.length];
			
			return delegate.apply(null, delegateArgs);
		}
		
		private static function createClass0(cls : Class) : Object { return new cls(); }
		private static function createClass1(cls : Class, p1 : *) : Object { return new cls(p1); }
		private static function createClass2(cls : Class, p1 : *, p2 : *) : Object { return new cls(p1, p2); }
		private static function createClass3(cls : Class, p1 : *, p2 : *, p3 : *) : Object { return new cls(p1, p2, p3); }
		private static function createClass4(cls : Class, p1 : *, p2 : *, p3 : *, p4 : *) : Object { return new cls(p1, p2, p3, p4); }
		private static function createClass5(cls : Class, p1 : *, p2 : *, p3 : *, p4 : *, p5 : *) : Object { return new cls(p1, p2, p3, p4, p5); }
		private static function createClass6(cls : Class, p1 : *, p2 : *, p3 : *, p4 : *, p5 : *, p6 : *) : Object { return new cls(p1, p2, p3, p4, p5, p6); }
		private static function createClass7(cls : Class, p1 : *, p2 : *, p3 : *, p4 : *, p5 : *, p6 : *, p7 : *) : Object { return new cls(p1, p2, p3, p4, p5, p6, p7); }
		private static function createClass8(cls : Class, p1 : *, p2 : *, p3 : *, p4 : *, p5 : *, p6 : *, p7 : *, p8 : *) : Object { return new cls(p1, p2, p3, p4, p5, p6, p7, p8); }
		private static function createClass9(cls : Class, p1 : *, p2 : *, p3 : *, p4 : *, p5 : *, p6 : *, p7 : *, p8 : *, p9 : *) : Object { return new cls(p1, p2, p3, p4, p5, p6, p7, p8, p9); }
		private static function createClass10(cls : Class, p1 : *, p2 : *, p3 : *, p4 : *, p5 : *, p6 : *, p7 : *, p8 : *, p9 : *, p10 : *) : Object { return new cls(p1, p2, p3, p4, p5, p6, p7, p8, p9, p10); }
		private static function createClass11(cls : Class, p1 : *, p2 : *, p3 : *, p4 : *, p5 : *, p6 : *, p7 : *, p8 : *, p9 : *, p10 : *, p11 : *) : Object { return new cls(p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11); }
		private static function createClass12(cls : Class, p1 : *, p2 : *, p3 : *, p4 : *, p5 : *, p6 : *, p7 : *, p8 : *, p9 : *, p10 : *, p11 : *, p12 : *) : Object { return new cls(p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12); }
		private static function createClass13(cls : Class, p1 : *, p2 : *, p3 : *, p4 : *, p5 : *, p6 : *, p7 : *, p8 : *, p9 : *, p10 : *, p11 : *, p12 : *, p13 : *) : Object { return new cls(p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13); }
		private static function createClass14(cls : Class, p1 : *, p2 : *, p3 : *, p4 : *, p5 : *, p6 : *, p7 : *, p8 : *, p9 : *, p10 : *, p11 : *, p12 : *, p13 : *, p14 : *) : Object { return new cls(p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14); }
		private static function createClass15(cls : Class, p1 : *, p2 : *, p3 : *, p4 : *, p5 : *, p6 : *, p7 : *, p8 : *, p9 : *, p10 : *, p11 : *, p12 : *, p13 : *, p14 : *, p15 : *) : Object { return new cls(p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14, p15); }
		private static function createClass16(cls : Class, p1 : *, p2 : *, p3 : *, p4 : *, p5 : *, p6 : *, p7 : *, p8 : *, p9 : *, p10 : *, p11 : *, p12 : *, p13 : *, p14 : *, p15 : *, p16 : *) : Object { return new cls(p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14, p15, p16); }
		private static function createClass17(cls : Class, p1 : *, p2 : *, p3 : *, p4 : *, p5 : *, p6 : *, p7 : *, p8 : *, p9 : *, p10 : *, p11 : *, p12 : *, p13 : *, p14 : *, p15 : *, p16 : *, p17 : *) : Object { return new cls(p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14, p15, p16, p17); }
		private static function createClass18(cls : Class, p1 : *, p2 : *, p3 : *, p4 : *, p5 : *, p6 : *, p7 : *, p8 : *, p9 : *, p10 : *, p11 : *, p12 : *, p13 : *, p14 : *, p15 : *, p16 : *, p17 : *, p18 : *) : Object { return new cls(p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14, p15, p16, p17, p18); }
		private static function createClass19(cls : Class, p1 : *, p2 : *, p3 : *, p4 : *, p5 : *, p6 : *, p7 : *, p8 : *, p9 : *, p10 : *, p11 : *, p12 : *, p13 : *, p14 : *, p15 : *, p16 : *, p17 : *, p18 : *, p19 : *) : Object { return new cls(p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14, p15, p16, p17, p18, p19); }
		private static function createClass20(cls : Class, p1 : *, p2 : *, p3 : *, p4 : *, p5 : *, p6 : *, p7 : *, p8 : *, p9 : *, p10 : *, p11 : *, p12 : *, p13 : *, p14 : *, p15 : *, p16 : *, p17 : *, p18 : *, p19 : *, p20 : *) : Object { return new cls(p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14, p15, p16, p17, p18, p19, p20); }
		private static function createClass21(cls : Class, p1 : *, p2 : *, p3 : *, p4 : *, p5 : *, p6 : *, p7 : *, p8 : *, p9 : *, p10 : *, p11 : *, p12 : *, p13 : *, p14 : *, p15 : *, p16 : *, p17 : *, p18 : *, p19 : *, p20 : *, p21 : *) : Object { return new cls(p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14, p15, p16, p17, p18, p19, p20, p21); }
		private static function createClass22(cls : Class, p1 : *, p2 : *, p3 : *, p4 : *, p5 : *, p6 : *, p7 : *, p8 : *, p9 : *, p10 : *, p11 : *, p12 : *, p13 : *, p14 : *, p15 : *, p16 : *, p17 : *, p18 : *, p19 : *, p20 : *, p21 : *, p22 : *) : Object { return new cls(p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14, p15, p16, p17, p18, p19, p20, p21, p22); }
		private static function createClass23(cls : Class, p1 : *, p2 : *, p3 : *, p4 : *, p5 : *, p6 : *, p7 : *, p8 : *, p9 : *, p10 : *, p11 : *, p12 : *, p13 : *, p14 : *, p15 : *, p16 : *, p17 : *, p18 : *, p19 : *, p20 : *, p21 : *, p22 : *, p23 : *) : Object { return new cls(p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14, p15, p16, p17, p18, p19, p20, p21, p22, p23); }
		private static function createClass24(cls : Class, p1 : *, p2 : *, p3 : *, p4 : *, p5 : *, p6 : *, p7 : *, p8 : *, p9 : *, p10 : *, p11 : *, p12 : *, p13 : *, p14 : *, p15 : *, p16 : *, p17 : *, p18 : *, p19 : *, p20 : *, p21 : *, p22 : *, p23 : *, p24 : *) : Object { return new cls(p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14, p15, p16, p17, p18, p19, p20, p21, p22, p23, p24); }
		private static function createClass25(cls : Class, p1 : *, p2 : *, p3 : *, p4 : *, p5 : *, p6 : *, p7 : *, p8 : *, p9 : *, p10 : *, p11 : *, p12 : *, p13 : *, p14 : *, p15 : *, p16 : *, p17 : *, p18 : *, p19 : *, p20 : *, p21 : *, p22 : *, p23 : *, p24 : *, p25 : *) : Object { return new cls(p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14, p15, p16, p17, p18, p19, p20, p21, p22, p23, p24, p25); }
		private static function createClass26(cls : Class, p1 : *, p2 : *, p3 : *, p4 : *, p5 : *, p6 : *, p7 : *, p8 : *, p9 : *, p10 : *, p11 : *, p12 : *, p13 : *, p14 : *, p15 : *, p16 : *, p17 : *, p18 : *, p19 : *, p20 : *, p21 : *, p22 : *, p23 : *, p24 : *, p25 : *, p26 : *) : Object { return new cls(p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14, p15, p16, p17, p18, p19, p20, p21, p22, p23, p24, p25, p26); }
		private static function createClass27(cls : Class, p1 : *, p2 : *, p3 : *, p4 : *, p5 : *, p6 : *, p7 : *, p8 : *, p9 : *, p10 : *, p11 : *, p12 : *, p13 : *, p14 : *, p15 : *, p16 : *, p17 : *, p18 : *, p19 : *, p20 : *, p21 : *, p22 : *, p23 : *, p24 : *, p25 : *, p26 : *, p27 : *) : Object { return new cls(p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14, p15, p16, p17, p18, p19, p20, p21, p22, p23, p24, p25, p26, p27); }
		private static function createClass28(cls : Class, p1 : *, p2 : *, p3 : *, p4 : *, p5 : *, p6 : *, p7 : *, p8 : *, p9 : *, p10 : *, p11 : *, p12 : *, p13 : *, p14 : *, p15 : *, p16 : *, p17 : *, p18 : *, p19 : *, p20 : *, p21 : *, p22 : *, p23 : *, p24 : *, p25 : *, p26 : *, p27 : *, p28 : *) : Object { return new cls(p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14, p15, p16, p17, p18, p19, p20, p21, p22, p23, p24, p25, p26, p27, p28); }
		private static function createClass29(cls : Class, p1 : *, p2 : *, p3 : *, p4 : *, p5 : *, p6 : *, p7 : *, p8 : *, p9 : *, p10 : *, p11 : *, p12 : *, p13 : *, p14 : *, p15 : *, p16 : *, p17 : *, p18 : *, p19 : *, p20 : *, p21 : *, p22 : *, p23 : *, p24 : *, p25 : *, p26 : *, p27 : *, p28 : *, p29 : *) : Object { return new cls(p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14, p15, p16, p17, p18, p19, p20, p21, p22, p23, p24, p25, p26, p27, p28, p29); }
		private static function createClass30(cls : Class, p1 : *, p2 : *, p3 : *, p4 : *, p5 : *, p6 : *, p7 : *, p8 : *, p9 : *, p10 : *, p11 : *, p12 : *, p13 : *, p14 : *, p15 : *, p16 : *, p17 : *, p18 : *, p19 : *, p20 : *, p21 : *, p22 : *, p23 : *, p24 : *, p25 : *, p26 : *, p27 : *, p28 : *, p29 : *, p30 : *) : Object { return new cls(p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14, p15, p16, p17, p18, p19, p20, p21, p22, p23, p24, p25, p26, p27, p28, p29, p30); }
		private static function createClass31(cls : Class, p1 : *, p2 : *, p3 : *, p4 : *, p5 : *, p6 : *, p7 : *, p8 : *, p9 : *, p10 : *, p11 : *, p12 : *, p13 : *, p14 : *, p15 : *, p16 : *, p17 : *, p18 : *, p19 : *, p20 : *, p21 : *, p22 : *, p23 : *, p24 : *, p25 : *, p26 : *, p27 : *, p28 : *, p29 : *, p30 : *, p31 : *) : Object { return new cls(p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14, p15, p16, p17, p18, p19, p20, p21, p22, p23, p24, p25, p26, p27, p28, p29, p30, p31); }
		private static function createClass32(cls : Class, p1 : *, p2 : *, p3 : *, p4 : *, p5 : *, p6 : *, p7 : *, p8 : *, p9 : *, p10 : *, p11 : *, p12 : *, p13 : *, p14 : *, p15 : *, p16 : *, p17 : *, p18 : *, p19 : *, p20 : *, p21 : *, p22 : *, p23 : *, p24 : *, p25 : *, p26 : *, p27 : *, p28 : *, p29 : *, p30 : *, p31 : *, p32 : *) : Object { return new cls(p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14, p15, p16, p17, p18, p19, p20, p21, p22, p23, p24, p25, p26, p27, p28, p29, p30, p31, p32); }
		private static function createClass33(cls : Class, p1 : *, p2 : *, p3 : *, p4 : *, p5 : *, p6 : *, p7 : *, p8 : *, p9 : *, p10 : *, p11 : *, p12 : *, p13 : *, p14 : *, p15 : *, p16 : *, p17 : *, p18 : *, p19 : *, p20 : *, p21 : *, p22 : *, p23 : *, p24 : *, p25 : *, p26 : *, p27 : *, p28 : *, p29 : *, p30 : *, p31 : *, p32 : *, p33 : *) : Object { return new cls(p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14, p15, p16, p17, p18, p19, p20, p21, p22, p23, p24, p25, p26, p27, p28, p29, p30, p31, p32, p33); }
		private static function createClass34(cls : Class, p1 : *, p2 : *, p3 : *, p4 : *, p5 : *, p6 : *, p7 : *, p8 : *, p9 : *, p10 : *, p11 : *, p12 : *, p13 : *, p14 : *, p15 : *, p16 : *, p17 : *, p18 : *, p19 : *, p20 : *, p21 : *, p22 : *, p23 : *, p24 : *, p25 : *, p26 : *, p27 : *, p28 : *, p29 : *, p30 : *, p31 : *, p32 : *, p33 : *, p34 : *) : Object { return new cls(p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14, p15, p16, p17, p18, p19, p20, p21, p22, p23, p24, p25, p26, p27, p28, p29, p30, p31, p32, p33, p34); }
		private static function createClass35(cls : Class, p1 : *, p2 : *, p3 : *, p4 : *, p5 : *, p6 : *, p7 : *, p8 : *, p9 : *, p10 : *, p11 : *, p12 : *, p13 : *, p14 : *, p15 : *, p16 : *, p17 : *, p18 : *, p19 : *, p20 : *, p21 : *, p22 : *, p23 : *, p24 : *, p25 : *, p26 : *, p27 : *, p28 : *, p29 : *, p30 : *, p31 : *, p32 : *, p33 : *, p34 : *, p35 : *) : Object { return new cls(p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14, p15, p16, p17, p18, p19, p20, p21, p22, p23, p24, p25, p26, p27, p28, p29, p30, p31, p32, p33, p34, p35); }
		private static function createClass36(cls : Class, p1 : *, p2 : *, p3 : *, p4 : *, p5 : *, p6 : *, p7 : *, p8 : *, p9 : *, p10 : *, p11 : *, p12 : *, p13 : *, p14 : *, p15 : *, p16 : *, p17 : *, p18 : *, p19 : *, p20 : *, p21 : *, p22 : *, p23 : *, p24 : *, p25 : *, p26 : *, p27 : *, p28 : *, p29 : *, p30 : *, p31 : *, p32 : *, p33 : *, p34 : *, p35 : *, p36 : *) : Object { return new cls(p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14, p15, p16, p17, p18, p19, p20, p21, p22, p23, p24, p25, p26, p27, p28, p29, p30, p31, p32, p33, p34, p35, p36); }
		private static function createClass37(cls : Class, p1 : *, p2 : *, p3 : *, p4 : *, p5 : *, p6 : *, p7 : *, p8 : *, p9 : *, p10 : *, p11 : *, p12 : *, p13 : *, p14 : *, p15 : *, p16 : *, p17 : *, p18 : *, p19 : *, p20 : *, p21 : *, p22 : *, p23 : *, p24 : *, p25 : *, p26 : *, p27 : *, p28 : *, p29 : *, p30 : *, p31 : *, p32 : *, p33 : *, p34 : *, p35 : *, p36 : *, p37 : *) : Object { return new cls(p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14, p15, p16, p17, p18, p19, p20, p21, p22, p23, p24, p25, p26, p27, p28, p29, p30, p31, p32, p33, p34, p35, p36, p37); }
		private static function createClass38(cls : Class, p1 : *, p2 : *, p3 : *, p4 : *, p5 : *, p6 : *, p7 : *, p8 : *, p9 : *, p10 : *, p11 : *, p12 : *, p13 : *, p14 : *, p15 : *, p16 : *, p17 : *, p18 : *, p19 : *, p20 : *, p21 : *, p22 : *, p23 : *, p24 : *, p25 : *, p26 : *, p27 : *, p28 : *, p29 : *, p30 : *, p31 : *, p32 : *, p33 : *, p34 : *, p35 : *, p36 : *, p37 : *, p38 : *) : Object { return new cls(p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14, p15, p16, p17, p18, p19, p20, p21, p22, p23, p24, p25, p26, p27, p28, p29, p30, p31, p32, p33, p34, p35, p36, p37, p38); }
		private static function createClass39(cls : Class, p1 : *, p2 : *, p3 : *, p4 : *, p5 : *, p6 : *, p7 : *, p8 : *, p9 : *, p10 : *, p11 : *, p12 : *, p13 : *, p14 : *, p15 : *, p16 : *, p17 : *, p18 : *, p19 : *, p20 : *, p21 : *, p22 : *, p23 : *, p24 : *, p25 : *, p26 : *, p27 : *, p28 : *, p29 : *, p30 : *, p31 : *, p32 : *, p33 : *, p34 : *, p35 : *, p36 : *, p37 : *, p38 : *, p39 : *) : Object { return new cls(p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14, p15, p16, p17, p18, p19, p20, p21, p22, p23, p24, p25, p26, p27, p28, p29, p30, p31, p32, p33, p34, p35, p36, p37, p38, p39); }
		private static function createClass40(cls : Class, p1 : *, p2 : *, p3 : *, p4 : *, p5 : *, p6 : *, p7 : *, p8 : *, p9 : *, p10 : *, p11 : *, p12 : *, p13 : *, p14 : *, p15 : *, p16 : *, p17 : *, p18 : *, p19 : *, p20 : *, p21 : *, p22 : *, p23 : *, p24 : *, p25 : *, p26 : *, p27 : *, p28 : *, p29 : *, p30 : *, p31 : *, p32 : *, p33 : *, p34 : *, p35 : *, p36 : *, p37 : *, p38 : *, p39 : *, p40 : *) : Object { return new cls(p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14, p15, p16, p17, p18, p19, p20, p21, p22, p23, p24, p25, p26, p27, p28, p29, p30, p31, p32, p33, p34, p35, p36, p37, p38, p39, p40); }
		private static function createClass41(cls : Class, p1 : *, p2 : *, p3 : *, p4 : *, p5 : *, p6 : *, p7 : *, p8 : *, p9 : *, p10 : *, p11 : *, p12 : *, p13 : *, p14 : *, p15 : *, p16 : *, p17 : *, p18 : *, p19 : *, p20 : *, p21 : *, p22 : *, p23 : *, p24 : *, p25 : *, p26 : *, p27 : *, p28 : *, p29 : *, p30 : *, p31 : *, p32 : *, p33 : *, p34 : *, p35 : *, p36 : *, p37 : *, p38 : *, p39 : *, p40 : *, p41 : *) : Object { return new cls(p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14, p15, p16, p17, p18, p19, p20, p21, p22, p23, p24, p25, p26, p27, p28, p29, p30, p31, p32, p33, p34, p35, p36, p37, p38, p39, p40, p41); }
		private static function createClass42(cls : Class, p1 : *, p2 : *, p3 : *, p4 : *, p5 : *, p6 : *, p7 : *, p8 : *, p9 : *, p10 : *, p11 : *, p12 : *, p13 : *, p14 : *, p15 : *, p16 : *, p17 : *, p18 : *, p19 : *, p20 : *, p21 : *, p22 : *, p23 : *, p24 : *, p25 : *, p26 : *, p27 : *, p28 : *, p29 : *, p30 : *, p31 : *, p32 : *, p33 : *, p34 : *, p35 : *, p36 : *, p37 : *, p38 : *, p39 : *, p40 : *, p41 : *, p42 : *) : Object { return new cls(p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14, p15, p16, p17, p18, p19, p20, p21, p22, p23, p24, p25, p26, p27, p28, p29, p30, p31, p32, p33, p34, p35, p36, p37, p38, p39, p40, p41, p42); }
		private static function createClass43(cls : Class, p1 : *, p2 : *, p3 : *, p4 : *, p5 : *, p6 : *, p7 : *, p8 : *, p9 : *, p10 : *, p11 : *, p12 : *, p13 : *, p14 : *, p15 : *, p16 : *, p17 : *, p18 : *, p19 : *, p20 : *, p21 : *, p22 : *, p23 : *, p24 : *, p25 : *, p26 : *, p27 : *, p28 : *, p29 : *, p30 : *, p31 : *, p32 : *, p33 : *, p34 : *, p35 : *, p36 : *, p37 : *, p38 : *, p39 : *, p40 : *, p41 : *, p42 : *, p43 : *) : Object { return new cls(p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14, p15, p16, p17, p18, p19, p20, p21, p22, p23, p24, p25, p26, p27, p28, p29, p30, p31, p32, p33, p34, p35, p36, p37, p38, p39, p40, p41, p42, p43); }
		private static function createClass44(cls : Class, p1 : *, p2 : *, p3 : *, p4 : *, p5 : *, p6 : *, p7 : *, p8 : *, p9 : *, p10 : *, p11 : *, p12 : *, p13 : *, p14 : *, p15 : *, p16 : *, p17 : *, p18 : *, p19 : *, p20 : *, p21 : *, p22 : *, p23 : *, p24 : *, p25 : *, p26 : *, p27 : *, p28 : *, p29 : *, p30 : *, p31 : *, p32 : *, p33 : *, p34 : *, p35 : *, p36 : *, p37 : *, p38 : *, p39 : *, p40 : *, p41 : *, p42 : *, p43 : *, p44 : *) : Object { return new cls(p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14, p15, p16, p17, p18, p19, p20, p21, p22, p23, p24, p25, p26, p27, p28, p29, p30, p31, p32, p33, p34, p35, p36, p37, p38, p39, p40, p41, p42, p43, p44); }
		private static function createClass45(cls : Class, p1 : *, p2 : *, p3 : *, p4 : *, p5 : *, p6 : *, p7 : *, p8 : *, p9 : *, p10 : *, p11 : *, p12 : *, p13 : *, p14 : *, p15 : *, p16 : *, p17 : *, p18 : *, p19 : *, p20 : *, p21 : *, p22 : *, p23 : *, p24 : *, p25 : *, p26 : *, p27 : *, p28 : *, p29 : *, p30 : *, p31 : *, p32 : *, p33 : *, p34 : *, p35 : *, p36 : *, p37 : *, p38 : *, p39 : *, p40 : *, p41 : *, p42 : *, p43 : *, p44 : *, p45 : *) : Object { return new cls(p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14, p15, p16, p17, p18, p19, p20, p21, p22, p23, p24, p25, p26, p27, p28, p29, p30, p31, p32, p33, p34, p35, p36, p37, p38, p39, p40, p41, p42, p43, p44, p45); }
		private static function createClass46(cls : Class, p1 : *, p2 : *, p3 : *, p4 : *, p5 : *, p6 : *, p7 : *, p8 : *, p9 : *, p10 : *, p11 : *, p12 : *, p13 : *, p14 : *, p15 : *, p16 : *, p17 : *, p18 : *, p19 : *, p20 : *, p21 : *, p22 : *, p23 : *, p24 : *, p25 : *, p26 : *, p27 : *, p28 : *, p29 : *, p30 : *, p31 : *, p32 : *, p33 : *, p34 : *, p35 : *, p36 : *, p37 : *, p38 : *, p39 : *, p40 : *, p41 : *, p42 : *, p43 : *, p44 : *, p45 : *, p46 : *) : Object { return new cls(p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14, p15, p16, p17, p18, p19, p20, p21, p22, p23, p24, p25, p26, p27, p28, p29, p30, p31, p32, p33, p34, p35, p36, p37, p38, p39, p40, p41, p42, p43, p44, p45, p46); }
		private static function createClass47(cls : Class, p1 : *, p2 : *, p3 : *, p4 : *, p5 : *, p6 : *, p7 : *, p8 : *, p9 : *, p10 : *, p11 : *, p12 : *, p13 : *, p14 : *, p15 : *, p16 : *, p17 : *, p18 : *, p19 : *, p20 : *, p21 : *, p22 : *, p23 : *, p24 : *, p25 : *, p26 : *, p27 : *, p28 : *, p29 : *, p30 : *, p31 : *, p32 : *, p33 : *, p34 : *, p35 : *, p36 : *, p37 : *, p38 : *, p39 : *, p40 : *, p41 : *, p42 : *, p43 : *, p44 : *, p45 : *, p46 : *, p47 : *) : Object { return new cls(p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14, p15, p16, p17, p18, p19, p20, p21, p22, p23, p24, p25, p26, p27, p28, p29, p30, p31, p32, p33, p34, p35, p36, p37, p38, p39, p40, p41, p42, p43, p44, p45, p46, p47); }
		private static function createClass48(cls : Class, p1 : *, p2 : *, p3 : *, p4 : *, p5 : *, p6 : *, p7 : *, p8 : *, p9 : *, p10 : *, p11 : *, p12 : *, p13 : *, p14 : *, p15 : *, p16 : *, p17 : *, p18 : *, p19 : *, p20 : *, p21 : *, p22 : *, p23 : *, p24 : *, p25 : *, p26 : *, p27 : *, p28 : *, p29 : *, p30 : *, p31 : *, p32 : *, p33 : *, p34 : *, p35 : *, p36 : *, p37 : *, p38 : *, p39 : *, p40 : *, p41 : *, p42 : *, p43 : *, p44 : *, p45 : *, p46 : *, p47 : *, p48 : *) : Object { return new cls(p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14, p15, p16, p17, p18, p19, p20, p21, p22, p23, p24, p25, p26, p27, p28, p29, p30, p31, p32, p33, p34, p35, p36, p37, p38, p39, p40, p41, p42, p43, p44, p45, p46, p47, p48); }
		private static function createClass49(cls : Class, p1 : *, p2 : *, p3 : *, p4 : *, p5 : *, p6 : *, p7 : *, p8 : *, p9 : *, p10 : *, p11 : *, p12 : *, p13 : *, p14 : *, p15 : *, p16 : *, p17 : *, p18 : *, p19 : *, p20 : *, p21 : *, p22 : *, p23 : *, p24 : *, p25 : *, p26 : *, p27 : *, p28 : *, p29 : *, p30 : *, p31 : *, p32 : *, p33 : *, p34 : *, p35 : *, p36 : *, p37 : *, p38 : *, p39 : *, p40 : *, p41 : *, p42 : *, p43 : *, p44 : *, p45 : *, p46 : *, p47 : *, p48 : *, p49 : *) : Object { return new cls(p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14, p15, p16, p17, p18, p19, p20, p21, p22, p23, p24, p25, p26, p27, p28, p29, p30, p31, p32, p33, p34, p35, p36, p37, p38, p39, p40, p41, p42, p43, p44, p45, p46, p47, p48, p49); }
		private static function createClass50(cls : Class, p1 : *, p2 : *, p3 : *, p4 : *, p5 : *, p6 : *, p7 : *, p8 : *, p9 : *, p10 : *, p11 : *, p12 : *, p13 : *, p14 : *, p15 : *, p16 : *, p17 : *, p18 : *, p19 : *, p20 : *, p21 : *, p22 : *, p23 : *, p24 : *, p25 : *, p26 : *, p27 : *, p28 : *, p29 : *, p30 : *, p31 : *, p32 : *, p33 : *, p34 : *, p35 : *, p36 : *, p37 : *, p38 : *, p39 : *, p40 : *, p41 : *, p42 : *, p43 : *, p44 : *, p45 : *, p46 : *, p47 : *, p48 : *, p49 : *, p50 : *) : Object { return new cls(p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14, p15, p16, p17, p18, p19, p20, p21, p22, p23, p24, p25, p26, p27, p28, p29, p30, p31, p32, p33, p34, p35, p36, p37, p38, p39, p40, p41, p42, p43, p44, p45, p46, p47, p48, p49, p50); }

		public static const MAX_CREATECLASS_ARG_COUNT : uint = 50;
		
		private static var _createClassDelegates : Array = [
			createClass0, createClass1, createClass2, createClass3, createClass4, 
			createClass5, createClass6, createClass7, createClass8, createClass9, 
			createClass10, createClass11, createClass12, createClass13, createClass14, 
			createClass15, createClass16, createClass17, createClass18, createClass19, 
			createClass20, createClass21, createClass22, createClass23, createClass24, 
			createClass25, createClass26, createClass27, createClass28, createClass29, 
			createClass30, createClass31, createClass32, createClass33, createClass34, 
			createClass35, createClass36, createClass37, createClass38, createClass39, 
			createClass40, createClass41, createClass42, createClass43, createClass44, 
			createClass45, createClass46, createClass47, createClass48, createClass49, 
			createClass50
			];

	}
}