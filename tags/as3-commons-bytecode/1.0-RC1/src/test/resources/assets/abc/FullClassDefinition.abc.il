magic 2e0010
Cpool numbers size 4 0 %
Cpool strings count 51 size 746 56 %
Cpool namespaces count 11 size 21 1 %
Cpool nssets count 4 size 28 2 %
Cpool names count 28 size 82 6 %
MethodInfo count 12 size 61 4 %
InstanceInfo size 55 4 %
ClassInfo size 23 1%
ScriptInfo size 11 0 %
MethodBodies size 249 18 %
script0

[ValuelessMetadata()]
[ValueOnlyMetadata(*="valueOnlyValue")]
[ClassMetadata(classKey2="classValue2",classKey1="classValue1",classKey3="classValue3")]
class assets.abc::FullClassDefinition extends Object
  implements Interface
{

  function assets.abc::FullClassDefinition():*	/* disp_id -1*/
  {
    // local_count=1 max_scope=1 max_stack=2 code_len=22
    0       getlocal0     	
    1       pushscope     	
    2       getlocal0     	
    3       constructsuper	(0)
    5       getlocal0     	
    6       findpropstrict	Dictionary
    8       constructprop 	Dictionary (0)
    11      initproperty  	dictionary
    13      findpropstrict	trace
    15      pushstring    	"Constructor"
    17      callproperty  	trace (1)
    20      pop           	
    21      returnvoid    	
  }

  function implementMeOrDie():void	/* disp_id 0*/
  {
    // local_count=1 max_scope=1 max_stack=2 code_len=11
    0       getlocal0     	
    1       pushscope     	
    2       findpropstrict	trace
    4       pushstring    	"I don't want to die."
    6       callproperty  	trace (1)
    9       pop           	
    10      returnvoid    	
  }

  [MethodMetadata(methodKey2="methodValue2",methodKey1="methodValue1")]
  function methodWithNoArguments():void	/* disp_id 0*/
  {
    // local_count=1 max_scope=1 max_stack=2 code_len=11
    0       getlocal0     	
    1       pushscope     	
    2       findpropstrict	trace
    4       pushstring    	"methodWithNoArguments"
    6       callproperty  	trace (1)
    9       pop           	
    10      returnvoid    	
  }

  function methodWithOptionalArguments(String,String,int):void	/* disp_id 0*/
  {
    // local_count=4 max_scope=1 max_stack=2 code_len=11
    0       getlocal0     	
    1       pushscope     	
    2       findpropstrict	trace
    4       pushstring    	"methodWithOptionalArguments"
    6       callproperty  	trace (1)
    9       pop           	
    10      returnvoid    	
  }

  function methodWithTwoArguments(String,int):void	/* disp_id 0*/
  {
    // local_count=3 max_scope=1 max_stack=2 code_len=11
    0       getlocal0     	
    1       pushscope     	
    2       findpropstrict	trace
    4       pushstring    	"methodWithTwoArguments"
    6       callproperty  	trace (1)
    9       pop           	
    10      returnvoid    	
  }

  function set setterForInternalValue(String):void	/* disp_id 0*/
  {
    // local_count=2 max_scope=1 max_stack=2 code_len=7
    0       getlocal0     	
    1       pushscope     	
    2       getlocal0     	
    3       getlocal1     	
    4       initproperty  	_internalValue
    6       returnvoid    	
  }
  var private::_internalValue:String	/* slot_id 0 */
  [FieldMetadata(fieldKey2="fieldValue2",fieldKey1="fieldValue1")]
  var private::dictionary:flash.utils::Dictionary	/* slot_id 0 */

  function http://www.maximporges.com::customNamespaceFunction():void	/* disp_id 0*/
  {
    // local_count=1 max_scope=1 max_stack=2 code_len=11
    0       getlocal0     	
    1       pushscope     	
    2       findpropstrict	trace
    4       pushstring    	"customNamespaceFunction"
    6       callproperty  	trace (1)
    9       pop           	
    10      returnvoid    	
  }

  function methodWithRestArguments(String):void	/* disp_id 0*/
  {
    // local_count=3 max_scope=1 max_stack=2 code_len=11
    0       getlocal0     	
    1       pushscope     	
    2       findpropstrict	trace
    4       pushstring    	"methodWithRestArguments"
    6       callproperty  	trace (1)
    9       pop           	
    10      returnvoid    	
  }

  function get getterForInternalValue():String	/* disp_id 0*/
  {
    // local_count=1 max_scope=1 max_stack=1 code_len=6
    0       getlocal0     	
    1       pushscope     	
    2       getlocal0     	
    3       getproperty   	_internalValue
    5       returnvalue   	
  }
  static var private::SOME_STATIC_VAR:String	/* slot_id 3 */

  static function staticMethod():void	/* disp_id 3*/
  {
    // local_count=1 max_scope=1 max_stack=2 code_len=11
    0       getlocal0     	
    1       pushscope     	
    2       findpropstrict	trace
    4       pushstring    	"staticMethod"
    6       callproperty  	trace (1)
    9       pop           	
    10      returnvoid    	
  }
  static const private::SOME_STATIC_CONSTANT:String = "SOME_STATIC_CONSTANT"	/* slot_id 2 */
  static const PUBLIC_STATIC_CONSTANT:String = "PUBLIC_STATIC_CONSTANT"	/* slot_id 1 */

  static function assets.abc::FullClassDefinition$cinit():*	/* disp_id 0*/
  {
    // local_count=1 max_scope=1 max_stack=2 code_len=21
    0       getlocal0     	
    1       pushscope     	
    2       findproperty  	PUBLIC_STATIC_CONSTANT
    4       pushstring    	"PUBLIC_STATIC_CONSTANT"
    6       initproperty  	PUBLIC_STATIC_CONSTANT
    8       findproperty  	private::SOME_STATIC_CONSTANT
    10      pushstring    	"SOME_STATIC_CONSTANT"
    12      initproperty  	private::SOME_STATIC_CONSTANT
    14      findproperty  	SOME_STATIC_VAR
    16      pushstring    	"SOME_STATIC_VAR"
    18      setproperty   	SOME_STATIC_VAR
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
  13        newclass      	assets.abc::FullClassDefinition
  15        popscope      	
  16        initproperty  	assets.abc::FullClassDefinition
  18        returnvoid    	
}
OPCODE	SIZE	% OF 152
callproperty  	24	15%
pushstring    	22	14%
findpropstrict	22	14%
getlocal0     	16	10%
pushscope     	13	8%
returnvoid    	11	7%
initproperty  	10	6%
pop           	8	5%
findproperty  	6	3%
getproperty   	6	3%
constructprop 	3	1%
constructsuper	2	1%
newclass      	2	1%
setproperty   	2	1%
getscopeobject	2	1%
popscope      	1	0%
returnvalue   	1	0%
getlocal1     	1	0%
