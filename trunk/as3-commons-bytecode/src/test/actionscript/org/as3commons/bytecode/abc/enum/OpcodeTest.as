/**
 * Copyright 2009 Maxim Cassian Porges
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package org.as3commons.bytecode.abc.enum {

	import flash.utils.ByteArray;

	import org.as3commons.bytecode.abc.AbcFile;
	import org.as3commons.bytecode.abc.BaseMultiname;
	import org.as3commons.bytecode.abc.ClassInfo;
	import org.as3commons.bytecode.abc.ExceptionInfo;
	import org.as3commons.bytecode.abc.LNamespace;
	import org.as3commons.bytecode.abc.MethodBody;
	import org.as3commons.bytecode.abc.Op;
	import org.as3commons.bytecode.util.OpcodeIO;
	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.assertStrictlyEquals;
	import org.flexunit.asserts.assertTrue;

	public class OpcodeTest {

		public function OpcodeTest() {
			super();
		}

		[Test]
		public function testParseAdd():void {
			doTestParse(Opcode.add, []);
		}

		[Test]
		public function testParseAdd_d():void {
			doTestParse(Opcode.add_d, []);
		}

		[Test]
		public function testParseAdd_i():void {
			doTestParse(Opcode.add_i, []);
		}

		[Test]
		public function testapplytype():void {
			doTestParse(Opcode.applytype, [1]);
		}

		[Test]
		public function testastype():void {
			doTestParse(Opcode.astype, [new BaseMultiname(MultinameKind.QNAME)]);
		}

		[Test]
		public function testastypelate():void {
			doTestParse(Opcode.astypelate, []);
		}

		[Test]
		public function testbitand():void {
			doTestParse(Opcode.bitand, []);
		}

		[Test]
		public function testbitnot():void {
			doTestParse(Opcode.bitnot, []);
		}

		[Test]
		public function testbitor():void {
			doTestParse(Opcode.bitor, []);
		}

		[Test]
		public function testbitxor():void {
			doTestParse(Opcode.bitxor, []);
		}

		[Test]
		public function testbkpt():void {
			doTestParse(Opcode.bkpt, []);
		}

		[Test]
		public function testbkptline():void {
			doTestParse(Opcode.bkptline, [1]);
		}

		[Test]
		public function testcall():void {
			doTestParse(Opcode.call, [1]);
		}

		[Test]
		public function testcallinterface():void {
			doTestParse(Opcode.callinterface, [new BaseMultiname(MultinameKind.QNAME), 1]);
		}

		[Test]
		public function testcallmethod():void {
			doTestParse(Opcode.callmethod, [1, 1]);
		}

		[Test]
		public function testcallproperty():void {
			doTestParse(Opcode.callproperty, [new BaseMultiname(MultinameKind.QNAME), 1]);
		}

		[Test]
		public function testcallproplex():void {
			doTestParse(Opcode.callproplex, [new BaseMultiname(MultinameKind.QNAME), 1]);
		}

		[Test]
		public function testcallpropvoid():void {
			doTestParse(Opcode.callpropvoid, [new BaseMultiname(MultinameKind.QNAME), 1]);
		}

		[Test]
		public function testcallstatic():void {
			doTestParse(Opcode.callstatic, [1, 1]);
		}

		[Test]
		public function testcallsuper():void {
			doTestParse(Opcode.callsuper, [new BaseMultiname(MultinameKind.QNAME), 1]);
		}

		[Test]
		public function testcallsuperid():void {
			doTestParse(Opcode.callsuperid, []);
		}

		[Test]
		public function testcallsupervoid():void {
			doTestParse(Opcode.callsupervoid, [new BaseMultiname(MultinameKind.QNAME), 1]);
		}

		[Test]
		public function testcheckfilter():void {
			doTestParse(Opcode.checkfilter, []);
		}

		[Test]
		public function testcoerce():void {
			doTestParse(Opcode.coerce, [new BaseMultiname(MultinameKind.QNAME)]);
		}

		[Test]
		public function testcoerce_a():void {
			doTestParse(Opcode.coerce_a, []);
		}

		[Test]
		public function testcoerce_b():void {
			doTestParse(Opcode.coerce_b, []);
		}

		[Test]
		public function testcoerce_d():void {
			doTestParse(Opcode.coerce_d, []);
		}

		[Test]
		public function testcoerce_i():void {
			doTestParse(Opcode.coerce_i, []);
		}

		[Test]
		public function testcoerce_o():void {
			doTestParse(Opcode.coerce_o, []);
		}

		[Test]
		public function testcoerce_s():void {
			doTestParse(Opcode.coerce_s, []);
		}

		[Test]
		public function testcoerce_u():void {
			doTestParse(Opcode.coerce_u, []);
		}

		[Test]
		public function testconcat():void {
			doTestParse(Opcode.concat, []);
		}

		[Test]
		public function testconstruct():void {
			doTestParse(Opcode.construct, [1]);
		}

		[Test]
		public function testconstructprop():void {
			doTestParse(Opcode.constructprop, [new BaseMultiname(MultinameKind.QNAME), 1]);
		}

		[Test]
		public function testconstructsuper():void {
			doTestParse(Opcode.constructsuper, [1]);
		}

		[Test]
		public function testconvert_b():void {
			doTestParse(Opcode.convert_b, []);
		}

		[Test]
		public function testconvert_d():void {
			doTestParse(Opcode.convert_d, []);
		}

		[Test]
		public function testconvert_i():void {
			doTestParse(Opcode.convert_i, []);
		}

		[Test]
		public function testconvert_o():void {
			doTestParse(Opcode.convert_o, []);
		}

		[Test]
		public function testconvert_s():void {
			doTestParse(Opcode.convert_s, []);
		}

		[Test]
		public function testconvert_u():void {
			doTestParse(Opcode.convert_u, []);
		}

		[Test]
		public function testdebug():void {
			doTestParse(Opcode.debug, [1, 1, 1, 1]);
		}

		[Test]
		public function testdebugfile():void {
			doTestParse(Opcode.debugfile, ["testfile.as"]);
		}

		[Test]
		public function testdebugline():void {
			doTestParse(Opcode.debugline, [1]);
		}

		[Test]
		public function testdeclocal():void {
			doTestParse(Opcode.declocal, [1]);
		}

		[Test]
		public function testdeclocal_i():void {
			doTestParse(Opcode.declocal_i, [1]);
		}

		[Test]
		public function testdecrement():void {
			doTestParse(Opcode.decrement, []);
		}

		[Test]
		public function testdecrement_i():void {
			doTestParse(Opcode.decrement_i, []);
		}

		[Test]
		public function testdeleteproperty():void {
			doTestParse(Opcode.deleteproperty, [new BaseMultiname(MultinameKind.QNAME)]);
		}

		[Test]
		public function testdeletepropertylate():void {
			doTestParse(Opcode.deletepropertylate, []);
		}

		[Test]
		public function testdivide():void {
			doTestParse(Opcode.divide, []);
		}

		[Test]
		public function testdup():void {
			doTestParse(Opcode.dup, []);
		}

		[Test]
		public function testdxns():void {
			doTestParse(Opcode.dxns, ["test_namespacename"]);
		}

		[Test]
		public function testdxnslate():void {
			doTestParse(Opcode.dxnslate, []);
		}

		[Test]
		public function testequals():void {
			doTestParse(Opcode.equals, []);
		}

		[Test]
		public function testesc_xattr():void {
			doTestParse(Opcode.esc_xattr, []);
		}

		[Test]
		public function testesc_xelem():void {
			doTestParse(Opcode.esc_xelem, []);
		}

		[Test]
		public function testfinddef():void {
			doTestParse(Opcode.finddef, [new BaseMultiname(MultinameKind.QNAME)]);
		}

		[Test]
		public function testfindpropglobalstrict():void {
			doTestParse(Opcode.findpropglobalstrict, [new BaseMultiname(MultinameKind.QNAME)]);
		}

		[Test]
		public function testfindpropglobal():void {
			doTestParse(Opcode.findpropglobal, [new BaseMultiname(MultinameKind.QNAME)]);
		}

		[Test]
		public function testfindproperty():void {
			doTestParse(Opcode.findproperty, [new BaseMultiname(MultinameKind.QNAME)]);
		}

		[Test]
		public function testfindpropstrict():void {
			doTestParse(Opcode.findpropstrict, [new BaseMultiname(MultinameKind.QNAME)]);
		}

		[Test]
		public function testgetdescendants():void {
			doTestParse(Opcode.getdescendants, [new BaseMultiname(MultinameKind.QNAME)]);
		}

		[Test]
		public function testgetglobalscope():void {
			doTestParse(Opcode.getglobalscope, []);
		}

		[Test]
		public function testgetglobalslot():void {
			doTestParse(Opcode.getglobalslot, [1]);
		}

		[Test]
		public function testgetlex():void {
			doTestParse(Opcode.getlex, [new BaseMultiname(MultinameKind.QNAME)]);
		}

		[Test]
		public function testgetlocal():void {
			doTestParse(Opcode.getlocal, [1]);
		}

		[Test]
		public function testgetlocal_0():void {
			doTestParse(Opcode.getlocal_0, []);
		}

		[Test]
		public function testgetlocal_1():void {
			doTestParse(Opcode.getlocal_1, []);
		}

		[Test]
		public function testgetlocal_2():void {
			doTestParse(Opcode.getlocal_2, []);
		}

		[Test]
		public function testgetlocal_3():void {
			doTestParse(Opcode.getlocal_3, []);
		}

		[Test]
		public function testgetouterscope():void {
			doTestParse(Opcode.getouterscope, [new BaseMultiname(MultinameKind.QNAME)]);
		}

		[Test]
		public function testgetproperty():void {
			doTestParse(Opcode.getproperty, [new BaseMultiname(MultinameKind.QNAME)]);
		}

		[Test]
		public function testgetscopeobject():void {
			doTestParse(Opcode.getscopeobject, [1]);
		}

		[Test]
		public function testgetslot():void {
			doTestParse(Opcode.getslot, [1]);
		}

		[Test]
		public function testgetsuper():void {
			doTestParse(Opcode.getsuper, [new BaseMultiname(MultinameKind.QNAME)]);
		}

		[Test]
		public function testgreaterequals():void {
			doTestParse(Opcode.greaterequals, []);
		}

		[Test]
		public function testgreaterthan():void {
			doTestParse(Opcode.greaterthan, []);
		}

		[Test]
		public function testhasnext2():void {
			doTestParse(Opcode.hasnext2, [1, 1]);
		}

		[Test]
		public function testhasnext():void {
			doTestParse(Opcode.hasnext, []);
		}

		[Test]
		public function testifeq():void {
			doTestParse(Opcode.ifeq, [1]);
		}

		[Test]
		public function testiffalse():void {
			doTestParse(Opcode.iffalse, [1]);
		}

		[Test]
		public function testifge():void {
			doTestParse(Opcode.ifge, [1]);
		}

		[Test]
		public function testifgt():void {
			doTestParse(Opcode.ifgt, [1]);
		}

		[Test]
		public function testifle():void {
			doTestParse(Opcode.ifle, [1]);
		}

		[Test]
		public function testiflt():void {
			doTestParse(Opcode.iflt, [1]);
		}

		[Test]
		public function testifne():void {
			doTestParse(Opcode.ifne, [1]);
		}

		[Test]
		public function testifnge():void {
			doTestParse(Opcode.ifnge, [1]);
		}

		[Test]
		public function testifnle():void {
			doTestParse(Opcode.ifnle, [1]);
		}

		[Test]
		public function testifnlt():void {
			doTestParse(Opcode.ifnlt, [1]);
		}

		[Test]
		public function testifngt():void {
			doTestParse(Opcode.ifngt, [1]);
		}

		[Test]
		public function testifstricteq():void {
			doTestParse(Opcode.ifstricteq, [1]);
		}

		[Test]
		public function testifstrictne():void {
			doTestParse(Opcode.ifstrictne, [1]);
		}

		[Test]
		public function testiftrue():void {
			doTestParse(Opcode.iftrue, [1]);
		}

		[Test]
		public function testin_op():void {
			doTestParse(Opcode.in_op, []);
		}

		[Test]
		public function testinclocal():void {
			doTestParse(Opcode.inclocal, [1]);
		}

		[Test]
		public function testinclocal_i():void {
			doTestParse(Opcode.inclocal_i, [1]);
		}

		[Test]
		public function testincrement():void {
			doTestParse(Opcode.increment, []);
		}

		[Test]
		public function testincrement_i():void {
			doTestParse(Opcode.increment_i, []);
		}

		[Test]
		public function testinitproperty():void {
			doTestParse(Opcode.initproperty, [new BaseMultiname(MultinameKind.QNAME)]);
		}

		[Test]
		public function testinstance_of():void {
			doTestParse(Opcode.instance_of, []);
		}

		[Test]
		public function testistype():void {
			doTestParse(Opcode.istype, [new BaseMultiname(MultinameKind.QNAME)]);
		}

		[Test]
		public function testistypelate():void {
			doTestParse(Opcode.istypelate, []);
		}

		[Test]
		public function testjump():void {
			doTestParse(Opcode.jump, [1]);
		}

		[Test]
		public function testkill():void {
			doTestParse(Opcode.kill, [1]);
		}

		[Test]
		public function testlabel():void {
			doTestParse(Opcode.label, []);
		}

		[Test]
		public function testlessequals():void {
			doTestParse(Opcode.lessequals, []);
		}

		[Test]
		public function testlessthan():void {
			doTestParse(Opcode.lessthan, []);
		}

		[Test]
		public function testlookupswitch():void {
			doTestParse(Opcode.lookupswitch, [1, 1, [1, 1]]);
		}

		[Test]
		public function testlshift():void {
			doTestParse(Opcode.lshift, []);
		}

		[Test]
		public function testmodulo():void {
			doTestParse(Opcode.modulo, []);
		}

		[Test]
		public function testmultiply():void {
			doTestParse(Opcode.multiply, []);
		}

		[Test]
		public function testmultiply_i():void {
			doTestParse(Opcode.multiply_i, []);
		}

		[Test]
		public function testnegate():void {
			doTestParse(Opcode.negate, []);
		}

		[Test]
		public function testnegate_i():void {
			doTestParse(Opcode.negate_i, []);
		}

		[Test]
		public function testnewactivation():void {
			doTestParse(Opcode.newactivation, []);
		}

		[Test]
		public function testnewarray():void {
			doTestParse(Opcode.newarray, [1]);
		}

		[Test]
		public function testnewcatch():void {
			doTestParse(Opcode.newcatch, [new ExceptionInfo()]);
		}

		[Test]
		public function testnewclass():void {
			doTestParse(Opcode.newclass, [new ClassInfo()]);
		}

		[Test]
		public function testnewfunction():void {
			doTestParse(Opcode.newfunction, [1]);
		}

		[Test]
		public function testnewobject():void {
			doTestParse(Opcode.newobject, [1]);
		}

		[Test]
		public function testnextname():void {
			doTestParse(Opcode.nextname, []);
		}

		[Test]
		public function testnextvalue():void {
			doTestParse(Opcode.nextvalue, []);
		}

		[Test]
		public function testnop():void {
			doTestParse(Opcode.nop, []);
		}

		[Test]
		public function testnot():void {
			doTestParse(Opcode.not, []);
		}

		[Test]
		public function testpop():void {
			doTestParse(Opcode.pop, []);
		}

		[Test]
		public function testpopscope():void {
			doTestParse(Opcode.popscope, []);
		}

		[Test]
		public function testpushbyte():void {
			doTestParse(Opcode.pushbyte, [1]);
		}

		[Test]
		public function testpushconstant():void {
			doTestParse(Opcode.pushconstant, ["TestConstant"]);
		}

		[Test]
		public function testpushdouble():void {
			doTestParse(Opcode.pushdouble, [1]);
		}

		[Test]
		public function testpushfalse():void {
			doTestParse(Opcode.pushfalse, []);
		}

		[Test]
		public function testpushint():void {
			doTestParse(Opcode.pushint, [1]);
		}

		[Test]
		public function testpushnamespace():void {
			doTestParse(Opcode.pushnamespace, [new LNamespace(NamespaceKind.PACKAGE_NAMESPACE, "public")]);
		}

		[Test]
		public function testpushnan():void {
			doTestParse(Opcode.pushnan, []);
		}

		[Test]
		public function testpushnull():void {
			doTestParse(Opcode.pushnull, []);
		}

		[Test]
		public function testpushscope():void {
			doTestParse(Opcode.pushscope, []);
		}

		[Test]
		public function testpushshort():void {
			doTestParse(Opcode.pushshort, [1]);
		}

		[Test]
		public function testpushstring():void {
			doTestParse(Opcode.pushstring, ["TestString"]);
		}

		[Test]
		public function testpushtrue():void {
			doTestParse(Opcode.pushtrue, []);
		}

		[Test]
		public function testpushuint():void {
			doTestParse(Opcode.pushuint, [1]);
		}

		[Test]
		public function testpushundefined():void {
			doTestParse(Opcode.pushundefined, []);
		}

		[Test]
		public function testpushwith():void {
			doTestParse(Opcode.pushwith, []);
		}

		[Test]
		public function testreturnvalue():void {
			doTestParse(Opcode.returnvalue, []);
		}

		[Test]
		public function testreturnvoid():void {
			doTestParse(Opcode.returnvoid, []);
		}

		[Test]
		public function testrshift():void {
			doTestParse(Opcode.rshift, []);
		}

		[Test]
		public function testsetglobalslot():void {
			doTestParse(Opcode.setglobalslot, [1]);
		}

		[Test]
		public function testsetlocal():void {
			doTestParse(Opcode.setlocal, [1]);
		}

		[Test]
		public function testsetlocal_0():void {
			doTestParse(Opcode.setlocal_0, []);
		}

		[Test]
		public function testsetlocal_1():void {
			doTestParse(Opcode.setlocal_1, []);
		}

		[Test]
		public function testsetlocal_2():void {
			doTestParse(Opcode.setlocal_2, []);
		}

		[Test]
		public function testsetlocal_3():void {
			doTestParse(Opcode.setlocal_3, []);
		}

		[Test]
		public function testsetproperty():void {
			doTestParse(Opcode.setproperty, [new BaseMultiname(MultinameKind.QNAME)]);
		}

		[Test]
		public function testsetpropertylate():void {
			doTestParse(Opcode.setpropertylate, []);
		}

		[Test]
		public function testsetslot():void {
			doTestParse(Opcode.setslot, [1]);
		}

		[Test]
		public function testsetsuper():void {
			doTestParse(Opcode.setsuper, [new BaseMultiname(MultinameKind.QNAME)]);
		}

		[Test]
		public function teststrictequals():void {
			doTestParse(Opcode.strictequals, []);
		}

		[Test]
		public function testsubtract():void {
			doTestParse(Opcode.subtract, []);
		}

		[Test]
		public function testsubtract_i():void {
			doTestParse(Opcode.subtract_i, []);
		}

		[Test]
		public function testswap():void {
			doTestParse(Opcode.swap, []);
		}

		[Test]
		public function testthrow_op():void {
			doTestParse(Opcode.throw_op, []);
		}

		[Test]
		public function testtypeof_op():void {
			doTestParse(Opcode.typeof_op, []);
		}

		[Test]
		public function testurshift():void {
			doTestParse(Opcode.urshift, []);
		}

		public function doTestParse(opcode:Opcode, args:Array):void {
			var op:Op = opcode.op(args);
			var abcFile:AbcFile = new AbcFile();
			var methodBody:MethodBody = new MethodBody();
			if (args[0] is ExceptionInfo) {
				methodBody.addExceptionInfo(ExceptionInfo(args[0]));
			}
			var ba:ByteArray = OpcodeIO.serialize(new <Op>[op], methodBody, abcFile);
			ba.position = 0;
			//abcFile = new AbcFile();
			//methodBody = new MethodBody();
			var opcodes:Vector.<Op> = OpcodeIO.parse(ba, ba.length, methodBody, abcFile.constantPool);
			assertEquals(1, opcodes.length);
			assertTrue(opcodes[0] is Op);
			assertStrictlyEquals(Op(opcodes[0]).opcode, opcode);
			assertEquals(op.parameters.length, Op(opcodes[0]).parameters.length);
		}


	}
}
