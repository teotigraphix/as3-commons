magic 2e0010
Cpool numbers size 6 0 %
Cpool strings count 33 size 329 34 %
Cpool namespaces count 10 size 19 1 %
Cpool nssets count 4 size 25 2 %
Cpool names count 40 size 115 11 %
MethodInfo count 9 size 45 4 %
InstanceInfo size 57 5 %
ClassInfo size 20 2%
ScriptInfo size 7 0 %
MethodBodies size 335 34 %
script0

class loom.template::MethodInvocation extends Object
{

  function loom.template::MethodInvocation(*,String,Array,Function,int):*	/* disp_id -1*/
  {
    // local_count=6 max_scope=1 max_stack=2 code_len=28
    0       getlocal0     	
    1       pushscope     	
    2       getlocal0     	
    3       constructsuper	(0)
    5       getlocal0     	
    6       getlocal1     	
    7       initproperty  	_instance
    9       getlocal0     	
    10      getlocal2     	
    11      initproperty  	_methodName
    13      getlocal0     	
    14      getlocal3     	
    15      initproperty  	_args
    17      getlocal0     	
    18      getlocal      	4
    20      initproperty  	_originalMethodReference
    22      getlocal0     	
    23      getlocal      	5
    25      initproperty  	_getterSetter
    27      returnvoid    	
  }

  function get methodName():String	/* disp_id 0*/
  {
    // local_count=1 max_scope=1 max_stack=1 code_len=6
    0       getlocal0     	
    1       pushscope     	
    2       getlocal0     	
    3       getproperty   	_methodName
    5       returnvalue   	
  }
  var private::_getterSetter:int	/* slot_id 0 */
  var private::_methodName:*	/* slot_id 0 */

  function toString():String	/* disp_id 0*/
  {
    // local_count=1 max_scope=1 max_stack=3 code_len=21
    0       getlocal0     	
    1       pushscope     	
    2       getlocal0     	
    3       getproperty   	_methodName
    5       pushstring    	"("
    7       add           	
    8       getlocal0     	
    9       getproperty   	args
    11      pushstring    	", "
    13      callproperty  	join (1)
    16      add           	
    17      pushstring    	")"
    19      add           	
    20      returnvalue   	
  }

  function proceed():*	/* disp_id 0*/
  {
    // local_count=2 max_scope=1 max_stack=5 code_len=148
    0       getlocal0     	
    1       pushscope     	
    2       jump          	L1

    
    L2: 
    6       label         	
    7       getlocal0     	
    8       getproperty   	originalMethodReference
    10      getlocal0     	
    11      getproperty   	instance
    13      getlocal0     	
    14      getproperty   	args
    16      callproperty  	apply (2)
    19      returnvalue   	
    
    L3: 
    20      label         	
    21      getlocal0     	
    22      getproperty   	instance
    24      findpropstrict	loom_namespace
    26      getproperty   	loom_namespace
    28      coerce        	Namespace
    30      getlocal0     	
    31      getproperty   	methodName
    33      convert_s     	
    34      getproperty   	null
    36      returnvalue   	
    
    L4: 
    37      label         	
    38      getlocal0     	
    39      getproperty   	instance
    41      findpropstrict	loom_namespace
    43      getproperty   	loom_namespace
    45      coerce        	Namespace
    47      getlocal0     	
    48      getproperty   	methodName
    50      convert_s     	
    51      getlocal0     	
    52      getproperty   	args
    54      pushbyte      	0
    56      getproperty   	null
    58      setproperty   	null
    60      returnvoid    	
    
    L5: 
    61      label         	
    62      jump          	L6
    
    L1: 
    66      getlocal0     	
    67      getproperty   	_getterSetter
    69      setlocal1     	
    70      findpropstrict	REGULAR_METHOD
    72      getproperty   	REGULAR_METHOD
    74      getlocal1     	
    75      ifstrictne    	L7

    79      pushshort     	0
    81      jump          	L8
    
    L7: 
    85      findpropstrict	GETTER
    87      getproperty   	GETTER
    89      getlocal1     	
    90      ifstrictne    	L9

    94      pushshort     	1
    96      jump          	L8
    
    L9: 
    100     findpropstrict	SETTER
    102     getproperty   	SETTER
    104     getlocal1     	
    105     ifstrictne    	L10

    109     pushshort     	2
    111     jump          	L8
    
    L10: 
    115     pushfalse     	
    116     iffalse       	L11

    120     pushshort     	3
    122     jump          	L8
    
    L11: 
    126     pushshort     	3
    
    L8: 
    128     kill          	1
    130     lookupswitch  	default:L5 maxcase:3 L2 L3 L4 L5
    
    L6: 
    147     returnvoid    	
  }

  function get instance():*	/* disp_id 0*/
  {
    // local_count=1 max_scope=1 max_stack=1 code_len=6
    0       getlocal0     	
    1       pushscope     	
    2       getlocal0     	
    3       getproperty   	_instance
    5       returnvalue   	
  }

  function get originalMethodReference():Function	/* disp_id 0*/
  {
    // local_count=1 max_scope=1 max_stack=1 code_len=6
    0       getlocal0     	
    1       pushscope     	
    2       getlocal0     	
    3       getproperty   	_originalMethodReference
    5       returnvalue   	
  }
  var private::_originalMethodReference:Function	/* slot_id 0 */
  var private::_instance:*	/* slot_id 0 */
  var private::_args:*	/* slot_id 0 */

  function get args():Array	/* disp_id 0*/
  {
    // local_count=1 max_scope=1 max_stack=1 code_len=6
    0       getlocal0     	
    1       pushscope     	
    2       getlocal0     	
    3       getproperty   	_args
    5       returnvalue   	
  }
  static const REGULAR_METHOD:int = 0	/* slot_id 1 */
  static const GETTER:int = 1	/* slot_id 2 */
  static const SETTER:int = 2	/* slot_id 3 */

  static function loom.template::MethodInvocation$cinit():*	/* disp_id 0*/
  {
    // local_count=1 max_scope=1 max_stack=2 code_len=21
    0       getlocal0     	
    1       pushscope     	
    2       findproperty  	REGULAR_METHOD
    4       pushbyte      	0
    6       initproperty  	REGULAR_METHOD
    8       findproperty  	GETTER
    10      pushbyte      	1
    12      initproperty  	GETTER
    14      findproperty  	SETTER
    16      pushbyte      	2
    18      initproperty  	SETTER
    20      returnvoid    	
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
  13        newclass      	loom.template::MethodInvocation
  15        popscope      	
  16        initproperty  	loom.template::MethodInvocation
  18        returnvoid    	
}
OPCODE	SIZE	% OF 261
getproperty   	48	18%
getlocal0     	30	11%
jump          	24	9%
initproperty  	18	6%
lookupswitch  	17	6%
findpropstrict	14	5%
ifstrictne    	12	4%
pushshort     	10	3%
pushscope     	10	3%
pushbyte      	8	3%
returnvalue   	7	2%
pushstring    	6	2%
callproperty  	6	2%
findproperty  	6	2%
returnvoid    	5	1%
label         	4	1%
iffalse       	4	1%
getlocal      	4	1%
coerce        	4	1%
getlocal1     	4	1%
add           	3	1%
kill          	2	0%
constructsuper	2	0%
newclass      	2	0%
setproperty   	2	0%
getscopeobject	2	0%
convert_s     	2	0%
popscope      	1	0%
pushfalse     	1	0%
getlocal2     	1	0%
getlocal3     	1	0%
setlocal1     	1	0%
