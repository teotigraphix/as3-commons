package org.mockito.flemit.framework.bytecode
{
	import org.mockito.asmock.reflection.MethodInfo;
	
	[ExcludeClass]
	public class DynamicMethod
	{
		private var _method : MethodInfo;
		private var _maxStack : uint = 0;
		private var _minScope : uint = 0;
		private var _maxScope : uint = 0;
		private var _maxLocal : uint = 0;
		private var _instructionSet : Array = new Array();
		
		public function get instructionSet() : Array 
		{
			return _instructionSet;
		}
		
		public function get method():MethodInfo{return _method;}
		public function get maxStack() : uint { return _maxStack; } 
		public function get minScope() : uint { return _minScope; } 
		public function get maxScope() : uint { return _maxScope; } 
		public function get maxLocal() : uint { return _maxLocal; } 
		
		public function DynamicMethod(method : MethodInfo, maxStack : uint, maxLocal : uint, minScope : uint, maxScope : uint, instructions : Array)
		{
			_method = method;
			_minScope = minScope;
			_maxScope = maxScope;
			_maxLocal = maxLocal;
			_maxStack = maxStack;
			
			_instructionSet = instructions;
		}
		
		/*
		private static function createInstructionInfoMap() : Dictionary
		{
			var ih : Dictionary = new Dictionary();
			
			with(Instructions)
			{
				with (InstructionArgumentType)
				{
					ih[AsType] = new InstructionInfo([Multiname], 0, 0);
		            ih[Call] = new InstructionInfo([U30], 0, 0, callInstructionHandler);
		            ih[CallMethod] = new InstructionInfo([Method, U30], 0, 0, callMethodInstructionHandler);
		            ih[CallProperty] = new InstructionInfo([Multiname, U30], 0, 0, callPropertyInstructionHandler);
		            ih[CallPropLex] = new InstructionInfo([Multiname, U30], 0, 0, callPropertyInstructionHandler);
		            ih[CallPropVoid] = new InstructionInfo([Multiname, U30], 0, 0, callPropertyVoidInstructionHandler);
		            ih[CallStatic] = new InstructionInfo([Method, U30], 0, 0, callMethodInstructionHandler);
		            ih[CallSuper] = new InstructionInfo([Multiname, U30], 0, 0, callPropertyInstructionHandler);
		            ih[CallSuperVoid] = new InstructionInfo([Multiname, U30], 0, 0, callPropertyVoidInstructionHandler);
		            ih[Coerce] = new InstructionInfo([Multiname], 0, 0);
		            ih[Construct] = new InstructionInfo([Multiname], 0, 0, callInstructionHandler);
		            ih[ConstructProp] = new InstructionInfo([Multiname], 0, 0, callPropertyInstructionHandler);
		            ih[ConstructSuper] = u30InstructionHandler;
		            ih[Debug] = debugInstructionHandler;
		            ih[DebugLine] = u30InstructionHandler;
		            ih[DebugFile] = stringInstructionHandler;
		            ih[DecrementLocal] = u30InstructionHandler;
		            ih[DecrementLocalInteger] = u30InstructionHandler;
		            ih[DeleteProperty] = multinameInstructionHandler;
		            ih[DefaultXMLNamespace] = stringInstructionHandler;
		            ih[FindProperty] = multinameInstructionHandler;
		            ih[FindPropertyStrict] = multinameInstructionHandler;
		            ih[GetDescendants] = multinameInstructionHandler;
		            ih[GetGlobalSlot] = u30InstructionHandler;
		            ih[GetLex] = multinameInstructionHandler;
		            ih[GetLocal] = u30InstructionHandler;
		            ih[GetProperty] = multinameInstructionHandler;
		            ih[GetScopeObject] = u8InstructionHandler;
		            ih[GetSlot] = u30InstructionHandler;
		            ih[GetSuper] = multinameInstructionHandler;
		            ih[HasNext2] = hasNext2InstructionHandler;
		            ih[IfEquals] = u8InstructionHandler;
		            ih[IfFalse] = u8InstructionHandler;
		            ih[IfGreaterThanOrEquals] = u8InstructionHandler;
		            ih[IfGreaterThan] = u8InstructionHandler;
		            ih[IfLessThanOrEquals] = u8InstructionHandler;
		            ih[IfLessThan] = u8InstructionHandler;
		            ih[IfNotGreaterThanOrEquals] = u8InstructionHandler;
		            ih[IfNotGreaterThan] = u8InstructionHandler;
		            ih[IfNotLessThanOrEquals] = u8InstructionHandler;
		            ih[IfNotLessThan] = u8InstructionHandler;
		            ih[IfNotEquals] = u8InstructionHandler;
		            ih[IfStrictEquals] = u8InstructionHandler;
		            ih[IfStrictNotEquals] = u8InstructionHandler;
		            ih[IfTrue] = u8InstructionHandler;
		            ih[IncrementLocal] = u30InstructionHandler;
		            ih[IncrementLocalInteger] = u30InstructionHandler;
		            ih[InitProperty] = multinameInstructionHandler;
		            ih[IsType] = multinameInstructionHandler;
		            ih[Jump] = s24InstructionHandler;
		            ih[Kill] = u30InstructionHandler;
		            ih[LookUpSwitch] = switchInstructionHandler;
		            ih[NewArray] = u30InstructionHandler;
		            ih[NewCatch] = u30InstructionHandler;
		            ih[NewClass] = u30InstructionHandler; // classInstructionHandler?
		            ih[NewFunction] = u30InstructionHandler;
		            ih[PushByte] = u8InstructionHandler;
		            ih[PushDouble] = u8InstructionHandler; // double index
		            ih[PushInt] = u8InstructionHandler; // int index
		            ih[PushUInt] = u8InstructionHandler; // uint index
		            ih[PushShort] = u30InstructionHandler;
		            ih[PushString] = stringInstructionHandler;
		            ih[SetLocal] = u30InstructionHandler;
		            ih[SetGlobalSlot] = u30InstructionHandler;
		            ih[SetProperty] = multinameInstructionHandler;
		            ih[SetSlot] = u30InstructionHandler;
		            ih[SetSuper] = multinameInstructionHandler;
				}
			}
			
			return ih;
		}*/
	}
}

class InstructionInfo
{
}

class InstructionArgumentType
{
	public static const Class : uint = 1;
	public static const Method : uint = 2;
	public static const Multiname : uint = 3;
	public static const U30 : uint = 4;
}