magic 2e0010
Cpool numbers size 3 1 %
Cpool strings count 8 size 148 53 %
Cpool namespaces count 7 size 13 4 %
Cpool nssets count 2 size 6 2 %
Cpool names count 5 size 13 4 %
MethodInfo count 3 size 15 5 %
InstanceInfo size 8 2 %
ClassInfo size 2 0%
ScriptInfo size 7 2 %
MethodBodies size 55 20 %
script0

class loom.template::SubClassOfSubClassOfSubClass extends loom.template::SubClassOfSubClass
{

  function loom.template::SubClassOfSubClassOfSubClass(String,String):*	/* disp_id -1*/
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

  static function loom.template::SubClassOfSubClassOfSubClass$cinit():*	/* disp_id 0*/
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
  4         findpropstrict	loom.template::SubClassOfSubClass
  6         getproperty   	loom.template::SubClassOfSubClass
  8         pushscope     	
  9         findpropstrict	SubClassOfSubClass
  11        getproperty   	SubClassOfSubClass
  13        newclass      	loom.template::SubClassOfSubClassOfSubClass
  15        popscope      	
  16        initproperty  	loom.template::SubClassOfSubClassOfSubClass
  18        returnvoid    	
}
OPCODE	SIZE	% OF 30
pushscope     	4	13%
findpropstrict	4	13%
getproperty   	4	13%
getlocal0     	4	13%
returnvoid    	3	10%
constructsuper	2	6%
newclass      	2	6%
getscopeobject	2	6%
initproperty  	2	6%
popscope      	1	3%
getlocal1     	1	3%
getlocal2     	1	3%
