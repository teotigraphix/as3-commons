/*
 * Copyright (c) 2007-2009-2010 the original author or authors
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */
package org.as3commons.emit.util {

	import org.as3commons.lang.Assert;
	import org.as3commons.lang.IllegalArgumentError;

	/**
	 * This method creates a new instance of the supplied class using the supplied
	 * arguments. The current argument limit is 50.
	 *
	 * @param cls the class to create
	 * @param args the arguments to pass to the constructor
	 *
	 * @author Andrew Lewisohn
	 * @author Richard Szalay
	 */
	public function newInstance(cls:Class, args:Array):Object {
		Assert.notNull(cls, "cls argument must not be null");
		Assert.notNull(args, "args argument must not be null");
		if (args.length > ConstructorDelegateMap.MAX_ARG_COUNT) {
			throw new IllegalArgumentError("Argument count is greater than supported (" + ConstructorDelegateMap.MAX_ARG_COUNT + ")");
		}
		var func:Function = ConstructorDelegateMap.getConstructorDelegate(args.length);
		args.unshift(cls);
		return func.apply(null, args);
	}
}
import org.as3commons.lang.Assert;

////////////////////////////////////////////////////////////////////////////////
//
//  Helper class: ConstructorDelegateMap
//
////////////////////////////////////////////////////////////////////////////////

class ConstructorDelegateMap {

	//--------------------------------------------------------------------
	//
	// Class constants
	//
	//--------------------------------------------------------------------

	/**
	 * The maximum allowable number of constructor arguments.
	 */
	internal static const MAX_ARG_COUNT:uint = 50;

	//--------------------------------------------------------------------
	//
	// Class variables
	//
	//--------------------------------------------------------------------

	/**
	 * An array of constructor functions that take a varying number of
	 * constructor arguments.
	 */
	private static var constructorDelegates:Array = [createClass0, createClass1, createClass2, createClass3, createClass4, createClass5, createClass6, createClass7, createClass8, createClass9, createClass10, createClass11, createClass12, createClass13, createClass14, createClass15, createClass16, createClass17, createClass18, createClass19, createClass20, createClass21, createClass22, createClass23, createClass24, createClass25, createClass26, createClass27, createClass28, createClass29, createClass30, createClass31, createClass32, createClass33, createClass34, createClass35, createClass36, createClass37, createClass38, createClass39, createClass40, createClass41, createClass42, createClass43, createClass44, createClass45, createClass46, createClass47, createClass48, createClass49, createClass50];

	//--------------------------------------------------------------------
	//
	// Class methods
	//
	//--------------------------------------------------------------------

	/**
	 * Retrieve a constructor delegate with the correct number of constructor
	 * arguments.
	 *
	 * @param length the number of constructor arguments that are required
	 */
	internal static function getConstructorDelegate(length:int):Function {
		return constructorDelegates[length];
	}

	private static function createClass0(cls:Class):Object {
		Assert.notNull(cls, "cls argument must not be null");
		return new cls();
	}

	private static function createClass1(cls:Class, p1:*):Object {
		Assert.notNull(cls, "cls argument must not be null");
		return new cls(p1);
	}

	private static function createClass2(cls:Class, p1:*, p2:*):Object {
		Assert.notNull(cls, "cls argument must not be null");
		return new cls(p1, p2);
	}

	private static function createClass3(cls:Class, p1:*, p2:*, p3:*):Object {
		Assert.notNull(cls, "cls argument must not be null");
		return new cls(p1, p2, p3);
	}

	private static function createClass4(cls:Class, p1:*, p2:*, p3:*, p4:*):Object {
		Assert.notNull(cls, "cls argument must not be null");
		return new cls(p1, p2, p3, p4);
	}

	private static function createClass5(cls:Class, p1:*, p2:*, p3:*, p4:*, p5:*):Object {
		Assert.notNull(cls, "cls argument must not be null");
		return new cls(p1, p2, p3, p4, p5);
	}

	private static function createClass6(cls:Class, p1:*, p2:*, p3:*, p4:*, p5:*, p6:*):Object {
		Assert.notNull(cls, "cls argument must not be null");
		return new cls(p1, p2, p3, p4, p5, p6);
	}

	private static function createClass7(cls:Class, p1:*, p2:*, p3:*, p4:*, p5:*, p6:*, p7:*):Object {
		Assert.notNull(cls, "cls argument must not be null");
		return new cls(p1, p2, p3, p4, p5, p6, p7);
	}

	private static function createClass8(cls:Class, p1:*, p2:*, p3:*, p4:*, p5:*, p6:*, p7:*, p8:*):Object {
		Assert.notNull(cls, "cls argument must not be null");
		return new cls(p1, p2, p3, p4, p5, p6, p7, p8);
	}

	private static function createClass9(cls:Class, p1:*, p2:*, p3:*, p4:*, p5:*, p6:*, p7:*, p8:*, p9:*):Object {
		Assert.notNull(cls, "cls argument must not be null");
		return new cls(p1, p2, p3, p4, p5, p6, p7, p8, p9);
	}

	private static function createClass10(cls:Class, p1:*, p2:*, p3:*, p4:*, p5:*, p6:*, p7:*, p8:*, p9:*, p10:*):Object {
		Assert.notNull(cls, "cls argument must not be null");
		return new cls(p1, p2, p3, p4, p5, p6, p7, p8, p9, p10);
	}

	private static function createClass11(cls:Class, p1:*, p2:*, p3:*, p4:*, p5:*, p6:*, p7:*, p8:*, p9:*, p10:*, p11:*):Object {
		Assert.notNull(cls, "cls argument must not be null");
		return new cls(p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11);
	}

	private static function createClass12(cls:Class, p1:*, p2:*, p3:*, p4:*, p5:*, p6:*, p7:*, p8:*, p9:*, p10:*, p11:*, p12:*):Object {
		Assert.notNull(cls, "cls argument must not be null");
		return new cls(p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12);
	}

	private static function createClass13(cls:Class, p1:*, p2:*, p3:*, p4:*, p5:*, p6:*, p7:*, p8:*, p9:*, p10:*, p11:*, p12:*, p13:*):Object {
		Assert.notNull(cls, "cls argument must not be null");
		return new cls(p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13);
	}

	private static function createClass14(cls:Class, p1:*, p2:*, p3:*, p4:*, p5:*, p6:*, p7:*, p8:*, p9:*, p10:*, p11:*, p12:*, p13:*, p14:*):Object {
		Assert.notNull(cls, "cls argument must not be null");
		return new cls(p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14);
	}

	private static function createClass15(cls:Class, p1:*, p2:*, p3:*, p4:*, p5:*, p6:*, p7:*, p8:*, p9:*, p10:*, p11:*, p12:*, p13:*, p14:*, p15:*):Object {
		Assert.notNull(cls, "cls argument must not be null");
		return new cls(p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14, p15);
	}

	private static function createClass16(cls:Class, p1:*, p2:*, p3:*, p4:*, p5:*, p6:*, p7:*, p8:*, p9:*, p10:*, p11:*, p12:*, p13:*, p14:*, p15:*, p16:*):Object {
		Assert.notNull(cls, "cls argument must not be null");
		return new cls(p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14, p15, p16);
	}

	private static function createClass17(cls:Class, p1:*, p2:*, p3:*, p4:*, p5:*, p6:*, p7:*, p8:*, p9:*, p10:*, p11:*, p12:*, p13:*, p14:*, p15:*, p16:*, p17:*):Object {
		Assert.notNull(cls, "cls argument must not be null");
		return new cls(p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14, p15, p16, p17);
	}

	private static function createClass18(cls:Class, p1:*, p2:*, p3:*, p4:*, p5:*, p6:*, p7:*, p8:*, p9:*, p10:*, p11:*, p12:*, p13:*, p14:*, p15:*, p16:*, p17:*, p18:*):Object {
		Assert.notNull(cls, "cls argument must not be null");
		return new cls(p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14, p15, p16, p17, p18);
	}

	private static function createClass19(cls:Class, p1:*, p2:*, p3:*, p4:*, p5:*, p6:*, p7:*, p8:*, p9:*, p10:*, p11:*, p12:*, p13:*, p14:*, p15:*, p16:*, p17:*, p18:*, p19:*):Object {
		Assert.notNull(cls, "cls argument must not be null");
		return new cls(p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14, p15, p16, p17, p18, p19);
	}

	private static function createClass20(cls:Class, p1:*, p2:*, p3:*, p4:*, p5:*, p6:*, p7:*, p8:*, p9:*, p10:*, p11:*, p12:*, p13:*, p14:*, p15:*, p16:*, p17:*, p18:*, p19:*, p20:*):Object {
		Assert.notNull(cls, "cls argument must not be null");
		return new cls(p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14, p15, p16, p17, p18, p19, p20);
	}

	private static function createClass21(cls:Class, p1:*, p2:*, p3:*, p4:*, p5:*, p6:*, p7:*, p8:*, p9:*, p10:*, p11:*, p12:*, p13:*, p14:*, p15:*, p16:*, p17:*, p18:*, p19:*, p20:*, p21:*):Object {
		Assert.notNull(cls, "cls argument must not be null");
		return new cls(p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14, p15, p16, p17, p18, p19, p20, p21);
	}

	private static function createClass22(cls:Class, p1:*, p2:*, p3:*, p4:*, p5:*, p6:*, p7:*, p8:*, p9:*, p10:*, p11:*, p12:*, p13:*, p14:*, p15:*, p16:*, p17:*, p18:*, p19:*, p20:*, p21:*, p22:*):Object {
		Assert.notNull(cls, "cls argument must not be null");
		return new cls(p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14, p15, p16, p17, p18, p19, p20, p21, p22);
	}

	private static function createClass23(cls:Class, p1:*, p2:*, p3:*, p4:*, p5:*, p6:*, p7:*, p8:*, p9:*, p10:*, p11:*, p12:*, p13:*, p14:*, p15:*, p16:*, p17:*, p18:*, p19:*, p20:*, p21:*, p22:*, p23:*):Object {
		Assert.notNull(cls, "cls argument must not be null");
		return new cls(p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14, p15, p16, p17, p18, p19, p20, p21, p22, p23);
	}

	private static function createClass24(cls:Class, p1:*, p2:*, p3:*, p4:*, p5:*, p6:*, p7:*, p8:*, p9:*, p10:*, p11:*, p12:*, p13:*, p14:*, p15:*, p16:*, p17:*, p18:*, p19:*, p20:*, p21:*, p22:*, p23:*, p24:*):Object {
		Assert.notNull(cls, "cls argument must not be null");
		return new cls(p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14, p15, p16, p17, p18, p19, p20, p21, p22, p23, p24);
	}

	private static function createClass25(cls:Class, p1:*, p2:*, p3:*, p4:*, p5:*, p6:*, p7:*, p8:*, p9:*, p10:*, p11:*, p12:*, p13:*, p14:*, p15:*, p16:*, p17:*, p18:*, p19:*, p20:*, p21:*, p22:*, p23:*, p24:*, p25:*):Object {
		Assert.notNull(cls, "cls argument must not be null");
		return new cls(p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14, p15, p16, p17, p18, p19, p20, p21, p22, p23, p24, p25);
	}

	private static function createClass26(cls:Class, p1:*, p2:*, p3:*, p4:*, p5:*, p6:*, p7:*, p8:*, p9:*, p10:*, p11:*, p12:*, p13:*, p14:*, p15:*, p16:*, p17:*, p18:*, p19:*, p20:*, p21:*, p22:*, p23:*, p24:*, p25:*, p26:*):Object {
		Assert.notNull(cls, "cls argument must not be null");
		return new cls(p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14, p15, p16, p17, p18, p19, p20, p21, p22, p23, p24, p25, p26);
	}

	private static function createClass27(cls:Class, p1:*, p2:*, p3:*, p4:*, p5:*, p6:*, p7:*, p8:*, p9:*, p10:*, p11:*, p12:*, p13:*, p14:*, p15:*, p16:*, p17:*, p18:*, p19:*, p20:*, p21:*, p22:*, p23:*, p24:*, p25:*, p26:*, p27:*):Object {
		Assert.notNull(cls, "cls argument must not be null");
		return new cls(p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14, p15, p16, p17, p18, p19, p20, p21, p22, p23, p24, p25, p26, p27);
	}

	private static function createClass28(cls:Class, p1:*, p2:*, p3:*, p4:*, p5:*, p6:*, p7:*, p8:*, p9:*, p10:*, p11:*, p12:*, p13:*, p14:*, p15:*, p16:*, p17:*, p18:*, p19:*, p20:*, p21:*, p22:*, p23:*, p24:*, p25:*, p26:*, p27:*, p28:*):Object {
		Assert.notNull(cls, "cls argument must not be null");
		return new cls(p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14, p15, p16, p17, p18, p19, p20, p21, p22, p23, p24, p25, p26, p27, p28);
	}

	private static function createClass29(cls:Class, p1:*, p2:*, p3:*, p4:*, p5:*, p6:*, p7:*, p8:*, p9:*, p10:*, p11:*, p12:*, p13:*, p14:*, p15:*, p16:*, p17:*, p18:*, p19:*, p20:*, p21:*, p22:*, p23:*, p24:*, p25:*, p26:*, p27:*, p28:*, p29:*):Object {
		Assert.notNull(cls, "cls argument must not be null");
		return new cls(p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14, p15, p16, p17, p18, p19, p20, p21, p22, p23, p24, p25, p26, p27, p28, p29);
	}

	private static function createClass30(cls:Class, p1:*, p2:*, p3:*, p4:*, p5:*, p6:*, p7:*, p8:*, p9:*, p10:*, p11:*, p12:*, p13:*, p14:*, p15:*, p16:*, p17:*, p18:*, p19:*, p20:*, p21:*, p22:*, p23:*, p24:*, p25:*, p26:*, p27:*, p28:*, p29:*, p30:*):Object {
		Assert.notNull(cls, "cls argument must not be null");
		return new cls(p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14, p15, p16, p17, p18, p19, p20, p21, p22, p23, p24, p25, p26, p27, p28, p29, p30);
	}

	private static function createClass31(cls:Class, p1:*, p2:*, p3:*, p4:*, p5:*, p6:*, p7:*, p8:*, p9:*, p10:*, p11:*, p12:*, p13:*, p14:*, p15:*, p16:*, p17:*, p18:*, p19:*, p20:*, p21:*, p22:*, p23:*, p24:*, p25:*, p26:*, p27:*, p28:*, p29:*, p30:*, p31:*):Object {
		Assert.notNull(cls, "cls argument must not be null");
		return new cls(p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14, p15, p16, p17, p18, p19, p20, p21, p22, p23, p24, p25, p26, p27, p28, p29, p30, p31);
	}

	private static function createClass32(cls:Class, p1:*, p2:*, p3:*, p4:*, p5:*, p6:*, p7:*, p8:*, p9:*, p10:*, p11:*, p12:*, p13:*, p14:*, p15:*, p16:*, p17:*, p18:*, p19:*, p20:*, p21:*, p22:*, p23:*, p24:*, p25:*, p26:*, p27:*, p28:*, p29:*, p30:*, p31:*, p32:*):Object {
		Assert.notNull(cls, "cls argument must not be null");
		return new cls(p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14, p15, p16, p17, p18, p19, p20, p21, p22, p23, p24, p25, p26, p27, p28, p29, p30, p31, p32);
	}

	private static function createClass33(cls:Class, p1:*, p2:*, p3:*, p4:*, p5:*, p6:*, p7:*, p8:*, p9:*, p10:*, p11:*, p12:*, p13:*, p14:*, p15:*, p16:*, p17:*, p18:*, p19:*, p20:*, p21:*, p22:*, p23:*, p24:*, p25:*, p26:*, p27:*, p28:*, p29:*, p30:*, p31:*, p32:*, p33:*):Object {
		Assert.notNull(cls, "cls argument must not be null");
		return new cls(p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14, p15, p16, p17, p18, p19, p20, p21, p22, p23, p24, p25, p26, p27, p28, p29, p30, p31, p32, p33);
	}

	private static function createClass34(cls:Class, p1:*, p2:*, p3:*, p4:*, p5:*, p6:*, p7:*, p8:*, p9:*, p10:*, p11:*, p12:*, p13:*, p14:*, p15:*, p16:*, p17:*, p18:*, p19:*, p20:*, p21:*, p22:*, p23:*, p24:*, p25:*, p26:*, p27:*, p28:*, p29:*, p30:*, p31:*, p32:*, p33:*, p34:*):Object {
		Assert.notNull(cls, "cls argument must not be null");
		return new cls(p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14, p15, p16, p17, p18, p19, p20, p21, p22, p23, p24, p25, p26, p27, p28, p29, p30, p31, p32, p33, p34);
	}

	private static function createClass35(cls:Class, p1:*, p2:*, p3:*, p4:*, p5:*, p6:*, p7:*, p8:*, p9:*, p10:*, p11:*, p12:*, p13:*, p14:*, p15:*, p16:*, p17:*, p18:*, p19:*, p20:*, p21:*, p22:*, p23:*, p24:*, p25:*, p26:*, p27:*, p28:*, p29:*, p30:*, p31:*, p32:*, p33:*, p34:*, p35:*):Object {
		Assert.notNull(cls, "cls argument must not be null");
		return new cls(p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14, p15, p16, p17, p18, p19, p20, p21, p22, p23, p24, p25, p26, p27, p28, p29, p30, p31, p32, p33, p34, p35);
	}

	private static function createClass36(cls:Class, p1:*, p2:*, p3:*, p4:*, p5:*, p6:*, p7:*, p8:*, p9:*, p10:*, p11:*, p12:*, p13:*, p14:*, p15:*, p16:*, p17:*, p18:*, p19:*, p20:*, p21:*, p22:*, p23:*, p24:*, p25:*, p26:*, p27:*, p28:*, p29:*, p30:*, p31:*, p32:*, p33:*, p34:*, p35:*, p36:*):Object {
		Assert.notNull(cls, "cls argument must not be null");
		return new cls(p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14, p15, p16, p17, p18, p19, p20, p21, p22, p23, p24, p25, p26, p27, p28, p29, p30, p31, p32, p33, p34, p35, p36);
	}

	private static function createClass37(cls:Class, p1:*, p2:*, p3:*, p4:*, p5:*, p6:*, p7:*, p8:*, p9:*, p10:*, p11:*, p12:*, p13:*, p14:*, p15:*, p16:*, p17:*, p18:*, p19:*, p20:*, p21:*, p22:*, p23:*, p24:*, p25:*, p26:*, p27:*, p28:*, p29:*, p30:*, p31:*, p32:*, p33:*, p34:*, p35:*, p36:*, p37:*):Object {
		Assert.notNull(cls, "cls argument must not be null");
		return new cls(p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14, p15, p16, p17, p18, p19, p20, p21, p22, p23, p24, p25, p26, p27, p28, p29, p30, p31, p32, p33, p34, p35, p36, p37);
	}

	private static function createClass38(cls:Class, p1:*, p2:*, p3:*, p4:*, p5:*, p6:*, p7:*, p8:*, p9:*, p10:*, p11:*, p12:*, p13:*, p14:*, p15:*, p16:*, p17:*, p18:*, p19:*, p20:*, p21:*, p22:*, p23:*, p24:*, p25:*, p26:*, p27:*, p28:*, p29:*, p30:*, p31:*, p32:*, p33:*, p34:*, p35:*, p36:*, p37:*, p38:*):Object {
		Assert.notNull(cls, "cls argument must not be null");
		return new cls(p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14, p15, p16, p17, p18, p19, p20, p21, p22, p23, p24, p25, p26, p27, p28, p29, p30, p31, p32, p33, p34, p35, p36, p37, p38);
	}

	private static function createClass39(cls:Class, p1:*, p2:*, p3:*, p4:*, p5:*, p6:*, p7:*, p8:*, p9:*, p10:*, p11:*, p12:*, p13:*, p14:*, p15:*, p16:*, p17:*, p18:*, p19:*, p20:*, p21:*, p22:*, p23:*, p24:*, p25:*, p26:*, p27:*, p28:*, p29:*, p30:*, p31:*, p32:*, p33:*, p34:*, p35:*, p36:*, p37:*, p38:*, p39:*):Object {
		Assert.notNull(cls, "cls argument must not be null");
		return new cls(p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14, p15, p16, p17, p18, p19, p20, p21, p22, p23, p24, p25, p26, p27, p28, p29, p30, p31, p32, p33, p34, p35, p36, p37, p38, p39);
	}

	private static function createClass40(cls:Class, p1:*, p2:*, p3:*, p4:*, p5:*, p6:*, p7:*, p8:*, p9:*, p10:*, p11:*, p12:*, p13:*, p14:*, p15:*, p16:*, p17:*, p18:*, p19:*, p20:*, p21:*, p22:*, p23:*, p24:*, p25:*, p26:*, p27:*, p28:*, p29:*, p30:*, p31:*, p32:*, p33:*, p34:*, p35:*, p36:*, p37:*, p38:*, p39:*, p40:*):Object {
		Assert.notNull(cls, "cls argument must not be null");
		return new cls(p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14, p15, p16, p17, p18, p19, p20, p21, p22, p23, p24, p25, p26, p27, p28, p29, p30, p31, p32, p33, p34, p35, p36, p37, p38, p39, p40);
	}

	private static function createClass41(cls:Class, p1:*, p2:*, p3:*, p4:*, p5:*, p6:*, p7:*, p8:*, p9:*, p10:*, p11:*, p12:*, p13:*, p14:*, p15:*, p16:*, p17:*, p18:*, p19:*, p20:*, p21:*, p22:*, p23:*, p24:*, p25:*, p26:*, p27:*, p28:*, p29:*, p30:*, p31:*, p32:*, p33:*, p34:*, p35:*, p36:*, p37:*, p38:*, p39:*, p40:*, p41:*):Object {
		Assert.notNull(cls, "cls argument must not be null");
		return new cls(p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14, p15, p16, p17, p18, p19, p20, p21, p22, p23, p24, p25, p26, p27, p28, p29, p30, p31, p32, p33, p34, p35, p36, p37, p38, p39, p40, p41);
	}

	private static function createClass42(cls:Class, p1:*, p2:*, p3:*, p4:*, p5:*, p6:*, p7:*, p8:*, p9:*, p10:*, p11:*, p12:*, p13:*, p14:*, p15:*, p16:*, p17:*, p18:*, p19:*, p20:*, p21:*, p22:*, p23:*, p24:*, p25:*, p26:*, p27:*, p28:*, p29:*, p30:*, p31:*, p32:*, p33:*, p34:*, p35:*, p36:*, p37:*, p38:*, p39:*, p40:*, p41:*, p42:*):Object {
		Assert.notNull(cls, "cls argument must not be null");
		return new cls(p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14, p15, p16, p17, p18, p19, p20, p21, p22, p23, p24, p25, p26, p27, p28, p29, p30, p31, p32, p33, p34, p35, p36, p37, p38, p39, p40, p41, p42);
	}

	private static function createClass43(cls:Class, p1:*, p2:*, p3:*, p4:*, p5:*, p6:*, p7:*, p8:*, p9:*, p10:*, p11:*, p12:*, p13:*, p14:*, p15:*, p16:*, p17:*, p18:*, p19:*, p20:*, p21:*, p22:*, p23:*, p24:*, p25:*, p26:*, p27:*, p28:*, p29:*, p30:*, p31:*, p32:*, p33:*, p34:*, p35:*, p36:*, p37:*, p38:*, p39:*, p40:*, p41:*, p42:*, p43:*):Object {
		Assert.notNull(cls, "cls argument must not be null");
		return new cls(p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14, p15, p16, p17, p18, p19, p20, p21, p22, p23, p24, p25, p26, p27, p28, p29, p30, p31, p32, p33, p34, p35, p36, p37, p38, p39, p40, p41, p42, p43);
	}

	private static function createClass44(cls:Class, p1:*, p2:*, p3:*, p4:*, p5:*, p6:*, p7:*, p8:*, p9:*, p10:*, p11:*, p12:*, p13:*, p14:*, p15:*, p16:*, p17:*, p18:*, p19:*, p20:*, p21:*, p22:*, p23:*, p24:*, p25:*, p26:*, p27:*, p28:*, p29:*, p30:*, p31:*, p32:*, p33:*, p34:*, p35:*, p36:*, p37:*, p38:*, p39:*, p40:*, p41:*, p42:*, p43:*, p44:*):Object {
		Assert.notNull(cls, "cls argument must not be null");
		return new cls(p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14, p15, p16, p17, p18, p19, p20, p21, p22, p23, p24, p25, p26, p27, p28, p29, p30, p31, p32, p33, p34, p35, p36, p37, p38, p39, p40, p41, p42, p43, p44);
	}

	private static function createClass45(cls:Class, p1:*, p2:*, p3:*, p4:*, p5:*, p6:*, p7:*, p8:*, p9:*, p10:*, p11:*, p12:*, p13:*, p14:*, p15:*, p16:*, p17:*, p18:*, p19:*, p20:*, p21:*, p22:*, p23:*, p24:*, p25:*, p26:*, p27:*, p28:*, p29:*, p30:*, p31:*, p32:*, p33:*, p34:*, p35:*, p36:*, p37:*, p38:*, p39:*, p40:*, p41:*, p42:*, p43:*, p44:*, p45:*):Object {
		Assert.notNull(cls, "cls argument must not be null");
		return new cls(p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14, p15, p16, p17, p18, p19, p20, p21, p22, p23, p24, p25, p26, p27, p28, p29, p30, p31, p32, p33, p34, p35, p36, p37, p38, p39, p40, p41, p42, p43, p44, p45);
	}

	private static function createClass46(cls:Class, p1:*, p2:*, p3:*, p4:*, p5:*, p6:*, p7:*, p8:*, p9:*, p10:*, p11:*, p12:*, p13:*, p14:*, p15:*, p16:*, p17:*, p18:*, p19:*, p20:*, p21:*, p22:*, p23:*, p24:*, p25:*, p26:*, p27:*, p28:*, p29:*, p30:*, p31:*, p32:*, p33:*, p34:*, p35:*, p36:*, p37:*, p38:*, p39:*, p40:*, p41:*, p42:*, p43:*, p44:*, p45:*, p46:*):Object {
		Assert.notNull(cls, "cls argument must not be null");
		return new cls(p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14, p15, p16, p17, p18, p19, p20, p21, p22, p23, p24, p25, p26, p27, p28, p29, p30, p31, p32, p33, p34, p35, p36, p37, p38, p39, p40, p41, p42, p43, p44, p45, p46);
	}

	private static function createClass47(cls:Class, p1:*, p2:*, p3:*, p4:*, p5:*, p6:*, p7:*, p8:*, p9:*, p10:*, p11:*, p12:*, p13:*, p14:*, p15:*, p16:*, p17:*, p18:*, p19:*, p20:*, p21:*, p22:*, p23:*, p24:*, p25:*, p26:*, p27:*, p28:*, p29:*, p30:*, p31:*, p32:*, p33:*, p34:*, p35:*, p36:*, p37:*, p38:*, p39:*, p40:*, p41:*, p42:*, p43:*, p44:*, p45:*, p46:*, p47:*):Object {
		Assert.notNull(cls, "cls argument must not be null");
		return new cls(p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14, p15, p16, p17, p18, p19, p20, p21, p22, p23, p24, p25, p26, p27, p28, p29, p30, p31, p32, p33, p34, p35, p36, p37, p38, p39, p40, p41, p42, p43, p44, p45, p46, p47);
	}

	private static function createClass48(cls:Class, p1:*, p2:*, p3:*, p4:*, p5:*, p6:*, p7:*, p8:*, p9:*, p10:*, p11:*, p12:*, p13:*, p14:*, p15:*, p16:*, p17:*, p18:*, p19:*, p20:*, p21:*, p22:*, p23:*, p24:*, p25:*, p26:*, p27:*, p28:*, p29:*, p30:*, p31:*, p32:*, p33:*, p34:*, p35:*, p36:*, p37:*, p38:*, p39:*, p40:*, p41:*, p42:*, p43:*, p44:*, p45:*, p46:*, p47:*, p48:*):Object {
		Assert.notNull(cls, "cls argument must not be null");
		return new cls(p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14, p15, p16, p17, p18, p19, p20, p21, p22, p23, p24, p25, p26, p27, p28, p29, p30, p31, p32, p33, p34, p35, p36, p37, p38, p39, p40, p41, p42, p43, p44, p45, p46, p47, p48);
	}

	private static function createClass49(cls:Class, p1:*, p2:*, p3:*, p4:*, p5:*, p6:*, p7:*, p8:*, p9:*, p10:*, p11:*, p12:*, p13:*, p14:*, p15:*, p16:*, p17:*, p18:*, p19:*, p20:*, p21:*, p22:*, p23:*, p24:*, p25:*, p26:*, p27:*, p28:*, p29:*, p30:*, p31:*, p32:*, p33:*, p34:*, p35:*, p36:*, p37:*, p38:*, p39:*, p40:*, p41:*, p42:*, p43:*, p44:*, p45:*, p46:*, p47:*, p48:*, p49:*):Object {
		Assert.notNull(cls, "cls argument must not be null");
		return new cls(p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14, p15, p16, p17, p18, p19, p20, p21, p22, p23, p24, p25, p26, p27, p28, p29, p30, p31, p32, p33, p34, p35, p36, p37, p38, p39, p40, p41, p42, p43, p44, p45, p46, p47, p48, p49);
	}

	private static function createClass50(cls:Class, p1:*, p2:*, p3:*, p4:*, p5:*, p6:*, p7:*, p8:*, p9:*, p10:*, p11:*, p12:*, p13:*, p14:*, p15:*, p16:*, p17:*, p18:*, p19:*, p20:*, p21:*, p22:*, p23:*, p24:*, p25:*, p26:*, p27:*, p28:*, p29:*, p30:*, p31:*, p32:*, p33:*, p34:*, p35:*, p36:*, p37:*, p38:*, p39:*, p40:*, p41:*, p42:*, p43:*, p44:*, p45:*, p46:*, p47:*, p48:*, p49:*, p50:*):Object {
		Assert.notNull(cls, "cls argument must not be null");
		return new cls(p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14, p15, p16, p17, p18, p19, p20, p21, p22, p23, p24, p25, p26, p27, p28, p29, p30, p31, p32, p33, p34, p35, p36, p37, p38, p39, p40, p41, p42, p43, p44, p45, p46, p47, p48, p49, p50);
	}
}