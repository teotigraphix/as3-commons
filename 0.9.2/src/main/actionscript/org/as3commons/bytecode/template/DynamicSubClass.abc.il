magic 2e0010
Cpool numbers size 3 0 %
Cpool strings count 28 size 343 43 %
Cpool namespaces count 13 size 25 3 %
Cpool nssets count 5 size 37 4 %
Cpool names count 28 size 81 10 %
MethodInfo count 8 size 45 5 %
InstanceInfo size 33 4 %
ClassInfo size 2 0%
ScriptInfo size 7 0 %
MethodBodies size 215 27 %
script0

class loom.template::DynamicSubClass extends loom.template::BaseClass
{

  function loom.template::DynamicSubClass(String,String):*	/* disp_id -1*/
  {
    // local_count=3 max_scope=1 max_stack=3 code_len=16
    0       getlocal0     	
    1       pushscope     	
    2       getlocal0     	
    3       getlocal1     	
    4       getlocal2     	
    5       constructsuper	(2)
    7       getlocal0     	
    8       findpropstrict	Dictionary
    10      constructprop 	Dictionary (0)
    13      initproperty  	http://loom.ninjitsoft.com::handlerMappings
    15      returnvoid    	
  }

  function methodCallThree(String,Number):String	/* disp_id 0*/
  {
    // local_count=4 max_scope=1 max_stack=6 code_len=19
    0       getlocal0     	
    1       pushscope     	
    2       getlocal0     	
    3       findpropstrict	MethodInvocation
    5       getlocal0     	
    6       pushstring    	"methodCallThree"
    8       getlocal3     	
    9       getlocal0     	
    10      getsuper      	methodCallThree
    12      constructprop 	MethodInvocation (4)
    15      callproperty  	http://loom.ninjitsoft.com::proxyInvocation (1)
    18      returnvalue   	
  }

  function methodCallOne(String,Number):int	/* disp_id 0*/
  {
    // local_count=4 max_scope=1 max_stack=6 code_len=19
    0       getlocal0     	
    1       pushscope     	
    2       getlocal0     	
    3       findpropstrict	MethodInvocation
    5       getlocal0     	
    6       pushstring    	"methodCallOne"
    8       getlocal3     	
    9       getlocal0     	
    10      getsuper      	methodCallOne
    12      constructprop 	MethodInvocation (4)
    15      callproperty  	http://loom.ninjitsoft.com::proxyInvocation (1)
    18      returnvalue   	
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

  function methodCallTwo(String,Number,Object):void	/* disp_id 0*/
  {
    // local_count=5 max_scope=1 max_stack=6 code_len=21
    0       getlocal0     	
    1       pushscope     	
    2       getlocal0     	
    3       findpropstrict	MethodInvocation
    5       getlocal0     	
    6       pushstring    	"methodCallTwo"
    8       getlocal      	4
    10      getlocal0     	
    11      getsuper      	methodCallTwo
    13      constructprop 	MethodInvocation (4)
    16      callproperty  	http://loom.ninjitsoft.com::proxyInvocation (1)
    19      pop           	
    20      returnvoid    	
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
  var http://loom.ninjitsoft.com::handlerMappings:flash.utils::Dictionary	/* slot_id 0 */

  static function loom.template::DynamicSubClass$cinit():*	/* disp_id 0*/
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
  9         findpropstrict	loom.template::BaseClass
  11        getproperty   	loom.template::BaseClass
  13        pushscope     	
  14        findpropstrict	BaseClass
  16        getproperty   	BaseClass
  18        newclass      	loom.template::DynamicSubClass
  20        popscope      	
  21        popscope      	
  22        initproperty  	loom.template::DynamicSubClass
  24        returnvoid    	
}
OPCODE	SIZE	% OF 150
getlocal0     	22	14%
callproperty  	18	12%
findpropstrict	16	10%
getproperty   	14	9%
constructprop 	12	8%
pushscope     	10	6%
getsuper      	6	4%
pushstring    	6	4%
returnvoid    	5	3%
getlocal1     	5	3%
iffalse       	4	2%
returnvalue   	4	2%
initproperty  	4	2%
getlocal2     	4	2%
popscope      	2	1%
constructsuper	2	1%
newarray      	2	1%
newclass      	2	1%
setproperty   	2	1%
getlocal      	2	1%
getscopeobject	2	1%
coerce        	2	1%
getlocal3     	2	1%
pop           	1	0%
setlocal2     	1	0%
