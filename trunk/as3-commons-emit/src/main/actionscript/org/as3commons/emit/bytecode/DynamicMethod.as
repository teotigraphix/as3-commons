package org.as3commons.emit.bytecode {
import org.as3commons.emit.reflect.EmitMethod;

public class DynamicMethod {
	private var _method : EmitMethod;
	private var _maxStack : uint = 0;
	private var _minScope : uint = 0;
	private var _maxScope : uint = 0;
	private var _maxLocal : uint = 0;
	private var _instructionSet : Array = new Array();
	
	public function get instructionSet() : Array {
		return _instructionSet;
	}
	
	public function get method():EmitMethod {return _method;}
	public function get maxStack() : uint { return _maxStack; } 
	public function get minScope() : uint { return _minScope; } 
	public function get maxScope() : uint { return _maxScope; } 
	public function get maxLocal() : uint { return _maxLocal; } 
	
	public function DynamicMethod(method : EmitMethod, maxStack : uint, maxLocal : uint, minScope : uint, maxScope : uint, instructions : Array)
	{
		_method = method;
		_minScope = minScope;
		_maxScope = maxScope;
		_maxLocal = maxLocal;
		_maxStack = maxStack;
		
		_instructionSet = instructions;
	}
}
}