magic 2e0010
Cpool numbers size 3 1 %
Cpool strings count 9 size 86 38 %
Cpool namespaces count 7 size 13 5 %
Cpool nssets count 2 size 6 2 %
Cpool names count 6 size 16 7 %
MethodInfo count 3 size 15 6 %
InstanceInfo size 8 3 %
ClassInfo size 2 0%
ScriptInfo size 7 3 %
MethodBodies size 61 27 %
script0

class loom.template::SubClass extends loom.template::BaseClass
{

  function loom.template::SubClass(String,String):*	/* disp_id -1*/
  {
    // local_count=3 max_scope=1 max_stack=3 code_len=8
    0       getlocal0     	
    1       pushscope     	
    2       getlocal0     	
    3       getlocal1     	
    4       getlocal2     	
    5       constructsuper	(2)
    7       returnvoid    	
  }

  static function loom.template::SubClass$cinit():*	/* disp_id 0*/
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
  18        newclass      	loom.template::SubClass
  20        popscope      	
  21        popscope      	
  22        initproperty  	loom.template::SubClass
  24        returnvoid    	
}
OPCODE	SIZE	% OF 36
findpropstrict	6	16%
getproperty   	6	16%
pushscope     	5	13%
getlocal0     	4	11%
returnvoid    	3	8%
popscope      	2	5%
constructsuper	2	5%
newclass      	2	5%
getscopeobject	2	5%
initproperty  	2	5%
getlocal1     	1	2%
getlocal2     	1	2%
