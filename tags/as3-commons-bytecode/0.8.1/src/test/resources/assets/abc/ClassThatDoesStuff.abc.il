magic 2e0010
Cpool numbers size 3 0 %
Cpool strings count 14 size 188 47 %
Cpool namespaces count 9 size 17 4 %
Cpool nssets count 3 size 15 3 %
Cpool names count 9 size 25 6 %
MethodInfo count 5 size 23 5 %
InstanceInfo size 16 4 %
ClassInfo size 2 0%
ScriptInfo size 7 1 %
MethodBodies size 94 23 %
script0

class classes::ClassThatDoesStuff extends Object
{

  function classes::ClassThatDoesStuff():*	/* disp_id -1*/
  {
    // local_count=1 max_scope=1 max_stack=2 code_len=14
    0       getlocal0     	
    1       pushscope     	
    2       getlocal0     	
    3       constructsuper	(0)
    5       findpropstrict	trace
    7       pushstring    	"VALUE_TRACED_IN_CONSTRUCTOR"
    9       callproperty  	trace (1)
    12      pop           	
    13      returnvoid    	
  }

  function printAString():void	/* disp_id 0*/
  {
    // local_count=1 max_scope=1 max_stack=2 code_len=11
    0       getlocal0     	
    1       pushscope     	
    2       findpropstrict	trace
    4       pushstring    	"VALUE_TRACED_IN_PRINT_A_STRING"
    6       callproperty  	trace (1)
    9       pop           	
    10      returnvoid    	
  }

  function addTwoNumbers(int,int):int	/* disp_id 0*/
  {
    // local_count=3 max_scope=1 max_stack=2 code_len=6
    0       getlocal0     	
    1       pushscope     	
    2       getlocal1     	
    3       getlocal2     	
    4       add           	
    5       returnvalue   	
  }

  static function classes::ClassThatDoesStuff$cinit():*	/* disp_id 0*/
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
  13        newclass      	classes::ClassThatDoesStuff
  15        popscope      	
  16        initproperty  	classes::ClassThatDoesStuff
  18        returnvoid    	
}
OPCODE	SIZE	% OF 53
findpropstrict	8	15%
pushscope     	6	11%
callproperty  	6	11%
getlocal0     	6	11%
pushstring    	4	7%
returnvoid    	4	7%
getproperty   	4	7%
pop           	2	3%
constructsuper	2	3%
newclass      	2	3%
getscopeobject	2	3%
initproperty  	2	3%
popscope      	1	1%
returnvalue   	1	1%
add           	1	1%
getlocal1     	1	1%
getlocal2     	1	1%
