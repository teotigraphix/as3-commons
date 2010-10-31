magic 2e0010
Cpool numbers size 3 1 %
Cpool strings count 7 size 129 51 %
Cpool namespaces count 7 size 13 5 %
Cpool nssets count 2 size 6 2 %
Cpool names count 4 size 10 4 %
MethodInfo count 3 size 13 5 %
InstanceInfo size 8 3 %
ClassInfo size 2 0%
ScriptInfo size 7 2 %
MethodBodies size 53 21 %
script0

class assets.abc::ClassWithNoMethodsOrProperties extends Object
{

  function assets.abc::ClassWithNoMethodsOrProperties():*	/* disp_id -1*/
  {
    // local_count=1 max_scope=1 max_stack=1 code_len=6
    0       getlocal0     	
    1       pushscope     	
    2       getlocal0     	
    3       constructsuper	(0)
    5       returnvoid    	
  }

  static function assets.abc::ClassWithNoMethodsOrProperties$cinit():*	/* disp_id 0*/
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
  13        newclass      	assets.abc::ClassWithNoMethodsOrProperties
  15        popscope      	
  16        initproperty  	assets.abc::ClassWithNoMethodsOrProperties
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
