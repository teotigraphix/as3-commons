magic 2e0010
Cpool numbers size 4 0 %
Cpool strings count 34 size 500 43 %
Cpool namespaces count 15 size 29 2 %
Cpool nssets count 6 size 58 5 %
Cpool names count 32 size 93 8 %
MethodInfo count 13 size 69 5 %
InstanceInfo size 53 4 %
ClassInfo size 2 0%
ScriptInfo size 7 0 %
MethodBodies size 333 28 %
script0

class assets.abc::FCDSubClass extends assets.abc::FullClassDefinition
{

  function assets.abc::FCDSubClass():*	/* disp_id -1*/
  {
    // local_count=1 max_scope=1 max_stack=2 code_len=14
    0       getlocal0     	
    1       pushscope     	
    2       getlocal0     	
    3       constructsuper	(0)
    5       getlocal0     	
    6       findpropstrict	Dictionary
    8       constructprop 	Dictionary (0)
    11      initproperty  	http://loom.ninjitsoft.com::handlerMappings
    13      returnvoid    	
  }

  function http://www.maximporges.com::customNamespaceFunction():void	/* disp_id 0*/
  {
    // local_count=2 max_scope=1 max_stack=6 code_len=18
    0       getlocal0     	
    1       pushscope     	
    2       getlocal0     	
    3       findpropstrict	MethodInvocation
    5       getlocal0     	
    6       pushstring    	"customNamespaceFunction"
    8       getlocal1     	
    9       pushnull      	
    10      constructprop 	MethodInvocation (4)
    13      callproperty  	http://loom.ninjitsoft.com::proxyInvocation (1)
    16      pop           	
    17      returnvoid    	
  }

  function http://loom.ninjitsoft.com::proxyInvocation(loom.template::MethodInvocation):*	/* disp_id 0*/
  {
    // local_count=3 max_scope=1 max_stack=3 code_len=37
    0       getlocal0     	
    1       pushscope     	
    2       getlocal0     	
    3       getproperty   	http://loom.ninjitsoft.com::handlerMappings
    5       getlocal1     	
    6       getproperty   	methodName
    8       getproperty   	null
    10      coerce        	Function
    12      setlocal2     	
    13      findpropstrict	Boolean
    15      getlocal2     	
    16      callproperty  	Boolean (1)
    19      iffalse       	L1

    23      getlocal2     	
    24      getlocal0     	
    25      getlocal1     	
    26      newarray      	[1]
    28      callproperty  	apply (2)
    31      returnvalue   	
    
    L1: 
    32      getlocal1     	
    33      callproperty  	proceed (0)
    36      returnvalue   	
  }

  function methodWithOptionalArguments(String,String,int):void	/* disp_id 0*/
  {
    // local_count=4 max_scope=1 max_stack=7 code_len=24
    0       getlocal0     	
    1       pushscope     	
    2       getlocal0     	
    3       findpropstrict	MethodInvocation
    5       getlocal0     	
    6       pushstring    	"methodWithOptionalArguments"
    8       getlocal1     	
    9       getlocal2     	
    10      getlocal3     	
    11      newarray      	[3]
    13      getlocal0     	
    14      getsuper      	methodWithOptionalArguments
    16      constructprop 	MethodInvocation (4)
    19      callproperty  	http://loom.ninjitsoft.com::proxyInvocation (1)
    22      pop           	
    23      returnvoid    	
  }

  function http://loom.ninjitsoft.com::setHandler(String,Function):void	/* disp_id 0*/
  {
    // local_count=3 max_scope=1 max_stack=3 code_len=10
    0       getlocal0     	
    1       pushscope     	
    2       getlocal0     	
    3       getproperty   	http://loom.ninjitsoft.com::handlerMappings
    5       getlocal1     	
    6       getlocal2     	
    7       setproperty   	null
    9       returnvoid    	
  }

  function http://loom.ninjitsoft.com::getProperty(String):String	/* disp_id 0*/
  {
    // local_count=2 max_scope=1 max_stack=2 code_len=7
    0       getlocal0     	
    1       pushscope     	
    2       getlocal0     	
    3       getlocal1     	
    4       getsuper      	null
    6       returnvalue   	
  }

  function methodWithNoArguments():void	/* disp_id 0*/
  {
    // local_count=2 max_scope=1 max_stack=6 code_len=20
    0       getlocal0     	
    1       pushscope     	
    2       getlocal0     	
    3       findpropstrict	MethodInvocation
    5       getlocal0     	
    6       pushstring    	"methodWithNoArguments"
    8       getlocal1     	
    9       getlocal0     	
    10      getsuper      	methodWithNoArguments
    12      constructprop 	MethodInvocation (4)
    15      callproperty  	http://loom.ninjitsoft.com::proxyInvocation (1)
    18      pop           	
    19      returnvoid    	
  }
  var http://loom.ninjitsoft.com::handlerMappings:flash.utils::Dictionary	/* slot_id 0 */

  function set setterForInternalValue(String):void	/* disp_id 0*/
  {
    // local_count=3 max_scope=1 max_stack=7 code_len=20
    0       getlocal0     	
    1       pushscope     	
    2       getlocal0     	
    3       findpropstrict	MethodInvocation
    5       getlocal0     	
    6       pushstring    	"setterForInternalValue"
    8       getlocal2     	
    9       pushnull      	
    10      pushbyte      	2
    12      constructprop 	MethodInvocation (5)
    15      callproperty  	http://loom.ninjitsoft.com::proxyInvocation (1)
    18      pop           	
    19      returnvoid    	
  }

  function get getterForInternalValue():String	/* disp_id 0*/
  {
    // local_count=2 max_scope=1 max_stack=7 code_len=19
    0       getlocal0     	
    1       pushscope     	
    2       getlocal0     	
    3       findpropstrict	MethodInvocation
    5       getlocal0     	
    6       pushstring    	"getterForInternalValue"
    8       getlocal1     	
    9       pushnull      	
    10      pushbyte      	1
    12      constructprop 	MethodInvocation (5)
    15      callproperty  	http://loom.ninjitsoft.com::proxyInvocation (1)
    18      returnvalue   	
  }

  function http://loom.ninjitsoft.com::setProperty(String,String):void	/* disp_id 0*/
  {
    // local_count=3 max_scope=1 max_stack=3 code_len=8
    0       getlocal0     	
    1       pushscope     	
    2       getlocal0     	
    3       getlocal1     	
    4       getlocal2     	
    5       setsuper      	null
    7       returnvoid    	
  }

  function methodWithRestArguments(String):void	/* disp_id 0*/
  {
    // local_count=3 max_scope=1 max_stack=6 code_len=23
    0       getlocal0     	
    1       pushscope     	
    2       getlocal0     	
    3       findpropstrict	MethodInvocation
    5       getlocal0     	
    6       pushstring    	"methodWithRestArguments"
    8       getlocal1     	
    9       getlocal2     	
    10      newarray      	[2]
    12      getlocal0     	
    13      getsuper      	methodWithRestArguments
    15      constructprop 	MethodInvocation (4)
    18      callproperty  	http://loom.ninjitsoft.com::proxyInvocation (1)
    21      pop           	
    22      returnvoid    	
  }

  static function assets.abc::FCDSubClass$cinit():*	/* disp_id 0*/
  {
    // local_count=1 max_scope=1 max_stack=1 code_len=3
    0       getlocal0     	
    1       pushscope     	
    2       returnvoid    	
  }
}

function script0$init():*	/* disp_id 0*/
{
  // local_count=1 max_scope=3 max_stack=2 code_len=25
  0         getlocal0     	
  1         pushscope     	
  2         getscopeobject	0
  4         findpropstrict	Object
  6         getproperty   	Object
  8         pushscope     	
  9         findpropstrict	assets.abc::FullClassDefinition
  11        getproperty   	assets.abc::FullClassDefinition
  13        pushscope     	
  14        findpropstrict	FullClassDefinition
  16        getproperty   	FullClassDefinition
  18        newclass      	assets.abc::FCDSubClass
  20        popscope      	
  21        popscope      	
  22        initproperty  	assets.abc::FCDSubClass
  24        returnvoid    	
}
OPCODE	SIZE	% OF 228
getlocal0     	35	15%
callproperty  	27	11%
findpropstrict	22	9%
constructprop 	21	9%
pushscope     	15	6%
getproperty   	14	6%
pushstring    	12	5%
getlocal1     	11	4%
returnvoid    	10	4%
getsuper      	8	3%
getlocal2     	7	3%
newarray      	6	2%
pop           	5	2%
iffalse       	4	1%
pushbyte      	4	1%
returnvalue   	4	1%
initproperty  	4	1%
pushnull      	3	1%
setsuper      	2	0%
popscope      	2	0%
constructsuper	2	0%
newclass      	2	0%
setproperty   	2	0%
getscopeobject	2	0%
coerce        	2	0%
getlocal3     	1	0%
setlocal2     	1	0%
