magic 2e0010
Cpool numbers size 3 1 %
Cpool strings count 7 size 66 35 %
Cpool namespaces count 7 size 13 6 %
Cpool nssets count 2 size 6 3 %
Cpool names count 4 size 10 5 %
MethodInfo count 3 size 13 6 %
InstanceInfo size 8 4 %
ClassInfo size 2 1%
ScriptInfo size 7 3 %
MethodBodies size 53 28 %
script0

class classes::SimpleClass extends Object
{

  function classes::SimpleClass():*	/* disp_id -1*/
  {
    // local_count=1 max_scope=1 max_stack=1 code_len=6
    0       getlocal0     	
    1       pushscope     	
    2       getlocal0     	
    3       constructsuper	(0)
    5       returnvoid    	
  }

  static function classes::SimpleClass$cinit():*	/* disp_id 0*/
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
  13        newclass      	classes::SimpleClass
  15        popscope      	
  16        initproperty  	classes::SimpleClass
  18        returnvoid    	
}
OPCODE	SIZE	% OF 28
pushscope     	4	14%
findpropstrict	4	14%
getproperty   	4	14%
getlocal0     	4	14%
returnvoid    	3	10%
constructsuper	2	7%
newclass      	2	7%
getscopeobject	2	7%
initproperty  	2	7%
popscope      	1	3%
