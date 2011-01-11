magic 2e0010
Cpool numbers size 3 0 %
Cpool strings count 20 size 265 50 %
Cpool namespaces count 9 size 17 3 %
Cpool nssets count 3 size 15 2 %
Cpool names count 12 size 34 6 %
MethodInfo count 6 size 34 6 %
InstanceInfo size 20 3 %
ClassInfo size 2 0%
ScriptInfo size 7 1 %
MethodBodies size 122 23 %
script0

class loom.template::BaseClass extends Object
{

  function loom.template::BaseClass(String,String):*	/* disp_id -1*/
  {
    // local_count=3 max_scope=1 max_stack=2 code_len=14
    0       getlocal0     	
    1       pushscope     	
    2       getlocal0     	
    3       constructsuper	(0)
    5       findpropstrict	trace
    7       pushstring    	"BaseClass::constructor()"
    9       callproperty  	trace (1)
    12      pop           	
    13      returnvoid    	
  }

  function methodCallTwo(String,Number,Object):void	/* disp_id 0*/
  {
    // local_count=4 max_scope=1 max_stack=2 code_len=11
    0       getlocal0     	
    1       pushscope     	
    2       findpropstrict	trace
    4       pushstring    	"BaseClass::methodCallTwo()"
    6       callproperty  	trace (1)
    9       pop           	
    10      returnvoid    	
  }

  function methodCallThree(String,Number):String	/* disp_id 0*/
  {
    // local_count=3 max_scope=1 max_stack=2 code_len=13
    0       getlocal0     	
    1       pushscope     	
    2       findpropstrict	trace
    4       pushstring    	"BaseClass::methodCallThree()"
    6       callproperty  	trace (1)
    9       pop           	
    10      pushstring    	"stringValue"
    12      returnvalue   	
  }

  function methodCallOne(String,Number):int	/* disp_id 0*/
  {
    // local_count=3 max_scope=1 max_stack=2 code_len=13
    0       getlocal0     	
    1       pushscope     	
    2       findpropstrict	trace
    4       pushstring    	"BaseClass::methodCallOne()"
    6       callproperty  	trace (1)
    9       pop           	
    10      pushbyte      	100
    12      returnvalue   	
  }

  static function loom.template::BaseClass$cinit():*	/* disp_id 0*/
  {
    // local_count=1 max_scope=1 max_stack=1 code_len=3
    0       getlocal0     	
    1       pushscope     	
    2       returnvoid    	
  }
}

function script0$init():*	/* disp_id 0*/
{
  // local_count=1 max_scope=2 max_stack=2 code_len=19
  0         getlocal0     	
  1         pushscope     	
  2         getscopeobject	0
  4         findpropstrict	Object
  6         getproperty   	Object
  8         pushscope     	
  9         findpropstrict	Object
  11        getproperty   	Object
  13        newclass      	loom.template::BaseClass
  15        popscope      	
  16        initproperty  	loom.template::BaseClass
  18        returnvoid    	
}
OPCODE	SIZE	% OF 73
callproperty  	12	16%
findpropstrict	12	16%
pushstring    	10	13%
pushscope     	7	9%
getlocal0     	7	9%
pop           	4	5%
returnvoid    	4	5%
getproperty   	4	5%
pushbyte      	2	2%
returnvalue   	2	2%
constructsuper	2	2%
newclass      	2	2%
getscopeobject	2	2%
initproperty  	2	2%
popscope      	1	1%
