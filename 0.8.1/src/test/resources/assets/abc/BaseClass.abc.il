magic 2e0010
Cpool numbers size 3 0 %
Cpool strings count 17 size 168 42 %
Cpool namespaces count 9 size 17 4 %
Cpool nssets count 3 size 15 3 %
Cpool names count 10 size 28 7 %
MethodInfo count 5 size 24 6 %
InstanceInfo size 16 4 %
ClassInfo size 2 0%
ScriptInfo size 7 1 %
MethodBodies size 106 27 %
script0

class loom.template::BaseClass extends Object
{

  function loom.template::BaseClass():*	/* disp_id -1*/
  {
    // local_count=1 max_scope=1 max_stack=1 code_len=6
    0       getlocal0     	
    1       pushscope     	
    2       getlocal0     	
    3       constructsuper	(0)
    5       returnvoid    	
  }

  function operationTwo(String,int,Object):void	/* disp_id 0*/
  {
    // local_count=4 max_scope=1 max_stack=3 code_len=26
    0       getlocal0     	
    1       pushscope     	
    2       findpropstrict	trace
    4       pushstring    	"^^^ operationTwo("
    6       getlocal1     	
    7       add           	
    8       pushstring    	", "
    10      add           	
    11      getlocal2     	
    12      add           	
    13      pushstring    	", "
    15      add           	
    16      getlocal3     	
    17      add           	
    18      pushstring    	") ^^^"
    20      add           	
    21      callproperty  	trace (1)
    24      pop           	
    25      returnvoid    	
  }

  function operationOne():void	/* disp_id 0*/
  {
    // local_count=1 max_scope=1 max_stack=2 code_len=11
    0       getlocal0     	
    1       pushscope     	
    2       findpropstrict	trace
    4       pushstring    	"^^^ operationOne ^^^"
    6       callproperty  	trace (1)
    9       pop           	
    10      returnvoid    	
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
OPCODE	SIZE	% OF 65
pushstring    	10	15%
findpropstrict	8	12%
pushscope     	6	9%
callproperty  	6	9%
add           	6	9%
getlocal0     	6	9%
returnvoid    	5	7%
getproperty   	4	6%
pop           	2	3%
constructsuper	2	3%
newclass      	2	3%
getscopeobject	2	3%
initproperty  	2	3%
popscope      	1	1%
getlocal1     	1	1%
getlocal2     	1	1%
getlocal3     	1	1%
