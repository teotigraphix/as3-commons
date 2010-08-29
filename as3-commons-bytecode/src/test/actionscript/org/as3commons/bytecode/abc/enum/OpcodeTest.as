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

	import flexunit.framework.TestCase;

	import org.as3commons.bytecode.abc.AbcFile;
	import org.as3commons.bytecode.abc.BaseMultiname;
	import org.as3commons.bytecode.abc.ClassInfo;
	import org.as3commons.bytecode.abc.ExceptionInfo;
	import org.as3commons.bytecode.abc.LNamespace;
	import org.as3commons.bytecode.abc.MethodBody;
	import org.as3commons.bytecode.abc.NamedMultiname;
	import org.as3commons.bytecode.abc.Op;
	import org.as3commons.bytecode.util.AbcSpec;

	public class OpcodeTest extends TestCase {

		public function OpcodeTest() {
			super();
		}

		public function testParseAdd():void {
			doTestParse(Opcode.add, []);
		}

		public function testParseAdd_d():void {
			doTestParse(Opcode.add_d, []);
		}

		public function testParseAdd_i():void {
			doTestParse(Opcode.add_i, []);
		}

		public function testapplytype():void {
			doTestParse(Opcode.applytype, [1]);
		}

		public function testastype():void {
			doTestParse(Opcode.astype, [new BaseMultiname(MultinameKind.QNAME)]);
		}

		public function testastypelate():void {
			doTestParse(Opcode.astypelate, []);
		}

		public function testbitand():void {
			doTestParse(Opcode.bitand, []);
		}

		public function testbitnot():void {
			doTestParse(Opcode.bitnot, []);
		}

		public function testbitor():void {
			doTestParse(Opcode.bitor, []);
		}

		public function testbitxor():void {
			doTestParse(Opcode.bitxor, []);
		}

		public function testbkpt():void {
			doTestParse(Opcode.bkpt, []);
		}

		public function testbkptline():void {
			doTestParse(Opcode.bkptline, [1]);
		}

		public function testcall():void {
			doTestParse(Opcode.call, [1]);
		}

		public function testcallinterface():void {
			doTestParse(Opcode.callinterface, [new BaseMultiname(MultinameKind.QNAME), 1]);
		}

		public function testcallmethod():void {
			doTestParse(Opcode.callmethod, [1, 1]);
		}

		public function testcallproperty():void {
			doTestParse(Opcode.callproperty, [new BaseMultiname(MultinameKind.QNAME), 1]);
		}

		public function testcallproplex():void {
			doTestParse(Opcode.callproplex, [new BaseMultiname(MultinameKind.QNAME), 1]);
		}

		public function testcallpropvoid():void {
			doTestParse(Opcode.callpropvoid, [new BaseMultiname(MultinameKind.QNAME), 1]);
		}

		public function testcallstatic():void {
			doTestParse(Opcode.callstatic, [1, 1]);
		}

		public function testcallsuper():void {
			doTestParse(Opcode.callsuper, [new BaseMultiname(MultinameKind.QNAME), 1]);
		}

		public function testcallsuperid():void {
			doTestParse(Opcode.callsuperid, []);
		}

		public function testcallsupervoid():void {
			doTestParse(Opcode.callsupervoid, [new BaseMultiname(MultinameKind.QNAME), 1]);
		}

		public function testcheckfilter():void {
			doTestParse(Opcode.checkfilter, []);
		}

		public function testcoerce():void {
			doTestParse(Opcode.coerce, [new BaseMultiname(MultinameKind.QNAME)]);
		}

		public function testcoerce_a():void {
			doTestParse(Opcode.coerce_a, []);
		}

		public function testcoerce_b():void {
			doTestParse(Opcode.coerce_b, []);
		}

		public function testcoerce_d():void {
			doTestParse(Opcode.coerce_d, []);
		}

		public function testcoerce_i():void {
			doTestParse(Opcode.coerce_i, []);
		}

		public function testcoerce_o():void {
			doTestParse(Opcode.coerce_o, []);
		}

		public function testcoerce_s():void {
			doTestParse(Opcode.coerce_s, []);
		}

		public function testcoerce_u():void {
			doTestParse(Opcode.coerce_u, []);
		}

		public function testconcat():void {
			doTestParse(Opcode.concat, []);
		}

		public function testconstruct():void {
			doTestParse(Opcode.construct, [1]);
		}

		public function testconstructprop():void {
			doTestParse(Opcode.constructprop, [new BaseMultiname(MultinameKind.QNAME), 1]);
		}

		public function testconstructsuper():void {
			doTestParse(Opcode.constructsuper, [1]);
		}

		public function testconvert_b():void {
			doTestParse(Opcode.convert_b, []);
		}

		public function testconvert_d():void {
			doTestParse(Opcode.convert_d, []);
		}

		public function testconvert_i():void {
			doTestParse(Opcode.convert_i, []);
		}

		public function testconvert_o():void {
			doTestParse(Opcode.convert_o, []);
		}

		public function testconvert_s():void {
			doTestParse(Opcode.convert_s, []);
		}

		public function testconvert_u():void {
			doTestParse(Opcode.convert_u, []);
		}

		public function testdebug():void {
			doTestParse(Opcode.debug, [1, 1, 1, 1]);
		}

		public function testdebugfile():void {
			doTestParse(Opcode.debugfile, ["testfile.as"]);
		}

		public function testdebugline():void {
			doTestParse(Opcode.debugline, [1]);
		}

		public function testdeclocal():void {
			doTestParse(Opcode.declocal, [1]);
		}

		public function testdeclocal_i():void {
			doTestParse(Opcode.declocal_i, [1]);
		}

		public function testdecrement():void {
			doTestParse(Opcode.decrement, []);
		}

		public function testdecrement_i():void {
			doTestParse(Opcode.decrement_i, []);
		}

		public function testdeleteproperty():void {
			doTestParse(Opcode.deleteproperty, [new BaseMultiname(MultinameKind.QNAME)]);
		}

		public function testdeletepropertylate():void {
			doTestParse(Opcode.deletepropertylate, []);
		}

		public function testdivide():void {
			doTestParse(Opcode.divide, []);
		}

		public function testdup():void {
			doTestParse(Opcode.dup, []);
		}

		public function testdxns():void {
			doTestParse(Opcode.dxns, ["test_namespacename"]);
		}

		public function testdxnslate():void {
			doTestParse(Opcode.dxnslate, []);
		}

		public function testequals():void {
			doTestParse(Opcode.equals, []);
		}

		public function testesc_xattr():void {
			doTestParse(Opcode.esc_xattr, []);
		}

		public function testesc_xelem():void {
			doTestParse(Opcode.esc_xelem, []);
		}

		public function testfinddef():void {
			doTestParse(Opcode.finddef, [new BaseMultiname(MultinameKind.QNAME)]);
		}

		public function testfindpropglobalstrict():void {
			doTestParse(Opcode.findpropglobalstrict, [new BaseMultiname(MultinameKind.QNAME)]);
		}

		public function testfindpropglobal():void {
			doTestParse(Opcode.findpropglobal, [new BaseMultiname(MultinameKind.QNAME)]);
		}

		public function testfindproperty():void {
			doTestParse(Opcode.findproperty, [new BaseMultiname(MultinameKind.QNAME)]);
		}

		public function testfindpropstrict():void {
			doTestParse(Opcode.findpropstrict, [new BaseMultiname(MultinameKind.QNAME)]);
		}

		public function testgetdescendants():void {
			doTestParse(Opcode.getdescendants, [new BaseMultiname(MultinameKind.QNAME)]);
		}

		public function testgetglobalscope():void {
			doTestParse(Opcode.getglobalscope, []);
		}

		public function testgetglobalslot():void {
			doTestParse(Opcode.getglobalslot, [1]);
		}

		public function testgetlex():void {
			doTestParse(Opcode.getlex, [new BaseMultiname(MultinameKind.QNAME)]);
		}

		public function testgetlocal():void {
			doTestParse(Opcode.getlocal, [1]);
		}

		public function testgetlocal_0():void {
			doTestParse(Opcode.getlocal_0, []);
		}

		public function testgetlocal_1():void {
			doTestParse(Opcode.getlocal_1, []);
		}

		public function testgetlocal_2():void {
			doTestParse(Opcode.getlocal_2, []);
		}

		public function testgetlocal_3():void {
			doTestParse(Opcode.getlocal_3, []);
		}

		public function testgetouterscope():void {
			doTestParse(Opcode.getouterscope, [new BaseMultiname(MultinameKind.QNAME)]);
		}

		public function testgetproperty():void {
			doTestParse(Opcode.getproperty, [new BaseMultiname(MultinameKind.QNAME)]);
		}

		public function testgetscopeobject():void {
			doTestParse(Opcode.getscopeobject, [1]);
		}

		public function testgetslot():void {
			doTestParse(Opcode.getslot, [1]);
		}

		public function testgetsuper():void {
			doTestParse(Opcode.getsuper, [new BaseMultiname(MultinameKind.QNAME)]);
		}

		public function testgreaterequals():void {
			doTestParse(Opcode.greaterequals, []);
		}

		public function testgreaterthan():void {
			doTestParse(Opcode.greaterthan, []);
		}

		public function testhasnext2():void {
			doTestParse(Opcode.hasnext2, [1, 1]);
		}

		public function testhasnext():void {
			doTestParse(Opcode.hasnext, []);
		}

		public function testifeq():void {
			doTestParse(Opcode.ifeq, [1]);
		}

		public function testiffalse():void {
			doTestParse(Opcode.iffalse, [1]);
		}

		public function testifge():void {
			doTestParse(Opcode.ifge, [1]);
		}

		public function testifgt():void {
			doTestParse(Opcode.ifgt, [1]);
		}

		public function testifle():void {
			doTestParse(Opcode.ifle, [1]);
		}

		public function testiflt():void {
			doTestParse(Opcode.iflt, [1]);
		}

		public function testifne():void {
			doTestParse(Opcode.ifne, [1]);
		}

		public function testifnge():void {
			doTestParse(Opcode.ifnge, [1]);
		}

		public function testifnle():void {
			doTestParse(Opcode.ifnle, [1]);
		}

		public function testifnlt():void {
			doTestParse(Opcode.ifnlt, [1]);
		}

		public function testifngt():void {
			doTestParse(Opcode.ifngt, [1]);
		}

		public function testifstricteq():void {
			doTestParse(Opcode.ifstricteq, [1]);
		}

		public function testifstrictne():void {
			doTestParse(Opcode.ifstrictne, [1]);
		}

		public function testiftrue():void {
			doTestParse(Opcode.iftrue, [1]);
		}

		public function testin_op():void {
			doTestParse(Opcode.in_op, []);
		}

		public function testinclocal():void {
			doTestParse(Opcode.inclocal, [1]);
		}

		public function testinclocal_i():void {
			doTestParse(Opcode.inclocal_i, [1]);
		}

		public function testincrement():void {
			doTestParse(Opcode.increment, []);
		}

		public function testincrement_i():void {
			doTestParse(Opcode.increment_i, []);
		}

		public function testinitproperty():void {
			doTestParse(Opcode.initproperty, [new BaseMultiname(MultinameKind.QNAME)]);
		}

		public function testinstance_of():void {
			doTestParse(Opcode.instance_of, []);
		}

		public function testistype():void {
			doTestParse(Opcode.istype, [new BaseMultiname(MultinameKind.QNAME)]);
		}

		public function testistypelate():void {
			doTestParse(Opcode.istypelate, []);
		}

		public function testjump():void {
			doTestParse(Opcode.jump, [1]);
		}

		public function testkill():void {
			doTestParse(Opcode.kill, [1]);
		}

		public function testlabel():void {
			doTestParse(Opcode.label, []);
		}

		public function testlessequals():void {
			doTestParse(Opcode.lessequals, []);
		}

		public function testlessthan():void {
			doTestParse(Opcode.lessthan, []);
		}

		public function testlookupswitch():void {
			doTestParse(Opcode.lookupswitch, [1, 2, [1, 1]]);
		}

		public function testlshift():void {
			doTestParse(Opcode.lshift, []);
		}

		public function testmodulo():void {
			doTestParse(Opcode.modulo, []);
		}

		public function testmultiply():void {
			doTestParse(Opcode.multiply, []);
		}

		public function testmultiply_i():void {
			doTestParse(Opcode.multiply_i, []);
		}

		public function testnegate():void {
			doTestParse(Opcode.negate, []);
		}

		public function testnegate_i():void {
			doTestParse(Opcode.negate_i, []);
		}

		public function testnewactivation():void {
			doTestParse(Opcode.newactivation, []);
		}

		public function testnewarray():void {
			doTestParse(Opcode.newarray, [1]);
		}

		public function testnewcatch():void {
			doTestParse(Opcode.newcatch, [new ExceptionInfo()]);
		}

		public function testnewclass():void {
			doTestParse(Opcode.newclass, [new ClassInfo()]);
		}

		public function testnewfunction():void {
			doTestParse(Opcode.newfunction, [1]);
		}

		public function testnewobject():void {
			doTestParse(Opcode.newobject, [1]);
		}

		public function testnextname():void {
			doTestParse(Opcode.nextname, []);
		}

		public function testnextvalue():void {
			doTestParse(Opcode.nextvalue, []);
		}

		public function testnop():void {
			doTestParse(Opcode.nop, []);
		}

		public function testnot():void {
			doTestParse(Opcode.not, []);
		}

		public function testpop():void {
			doTestParse(Opcode.pop, []);
		}

		public function testpopscope():void {
			doTestParse(Opcode.popscope, []);
		}

		public function testpushbyte():void {
			doTestParse(Opcode.pushbyte, [1]);
		}

		public function testpushconstant():void {
			doTestParse(Opcode.pushconstant, ["TestConstant"]);
		}

		public function testpushdouble():void {
			doTestParse(Opcode.pushdouble, [1]);
		}

		public function testpushfalse():void {
			doTestParse(Opcode.pushfalse, []);
		}

		public function testpushint():void {
			doTestParse(Opcode.pushint, [1]);
		}

		public function testpushnamespace():void {
			doTestParse(Opcode.pushnamespace, [new LNamespace(NamespaceKind.PACKAGE_NAMESPACE, "public")]);
		}

		public function testpushnan():void {
			doTestParse(Opcode.pushnan, []);
		}

		public function testpushnull():void {
			doTestParse(Opcode.pushnull, []);
		}

		public function testpushscope():void {
			doTestParse(Opcode.pushscope, []);
		}

		public function testpushshort():void {
			doTestParse(Opcode.pushshort, [1]);
		}

		public function testpushstring():void {
			doTestParse(Opcode.pushstring, ["TestString"]);
		}

		public function testpushtrue():void {
			doTestParse(Opcode.pushtrue, []);
		}

		public function testpushuint():void {
			doTestParse(Opcode.pushuint, [1]);
		}

		public function testpushundefined():void {
			doTestParse(Opcode.pushundefined, []);
		}

		public function testpushwith():void {
			doTestParse(Opcode.pushwith, []);
		}

		public function testreturnvalue():void {
			doTestParse(Opcode.returnvalue, []);
		}

		public function testreturnvoid():void {
			doTestParse(Opcode.returnvoid, []);
		}

		public function testrshift():void {
			doTestParse(Opcode.rshift, []);
		}

		public function testsetglobalslot():void {
			doTestParse(Opcode.setglobalslot, [1]);
		}

		public function testsetlocal():void {
			doTestParse(Opcode.setlocal, [1]);
		}

		public function testsetlocal_0():void {
			doTestParse(Opcode.setlocal_0, []);
		}

		public function testsetlocal_1():void {
			doTestParse(Opcode.setlocal_1, []);
		}

		public function testsetlocal_2():void {
			doTestParse(Opcode.setlocal_2, []);
		}

		public function testsetlocal_3():void {
			doTestParse(Opcode.setlocal_3, []);
		}

		public function testsetproperty():void {
			doTestParse(Opcode.setproperty, [new BaseMultiname(MultinameKind.QNAME)]);
		}

		public function testsetpropertylate():void {
			doTestParse(Opcode.setpropertylate, []);
		}

		public function testsetslot():void {
			doTestParse(Opcode.setslot, [1]);
		}

		public function testsetsuper():void {
			doTestParse(Opcode.setsuper, [new BaseMultiname(MultinameKind.QNAME)]);
		}

		public function teststrictequals():void {
			doTestParse(Opcode.strictequals, []);
		}

		public function testsubtract():void {
			doTestParse(Opcode.subtract, []);
		}

		public function testsubtract_i():void {
			doTestParse(Opcode.subtract_i, []);
		}

		public function testswap():void {
			doTestParse(Opcode.swap, []);
		}

		public function testthrow_op():void {
			doTestParse(Opcode.throw_op, []);
		}

		public function testtypeof_op():void {
			doTestParse(Opcode.typeof_op, []);
		}

		public function testurshift():void {
			doTestParse(Opcode.urshift, []);
		}

		public function doTestParse(opcode:Opcode, args:Array):void {
			var op:Op = new Op(opcode, args);
			var abcFile:AbcFile = new AbcFile();
			var methodBody:MethodBody = new MethodBody();
			var ba:ByteArray = Opcode.serialize([op], methodBody, abcFile);
			ba.position = 0;
			abcFile = new AbcFile();
			methodBody = new MethodBody();
			var opcodes:Array = Opcode.parse(ba, ba.length, methodBody, abcFile);
			assertEquals(1, opcodes.length);
			assertTrue(opcodes[0] is Op);
			assertStrictlyEquals(Op(opcodes[0]).opcode, opcode);
			assertEquals(op.parameters.length, Op(opcodes[0]).parameters.length);
		}


	}
}