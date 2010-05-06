package org.as3commons.emit.reflect {
import org.as3commons.reflect.Parameter;
import org.as3commons.reflect.Type;
import org.as3commons.reflect.as3commons_reflect;

public class EmitParameter extends Parameter {
	
	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Constructor.
	 */
	public function EmitParameter(name:String, index:int, type:EmitType, isOptional:Boolean=false) {
		super(index, type, isOptional);
		
		_name = name;
	}
	
	//--------------------------------------------------------------------------
	//
	//  Properties
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	//  index
	//----------------------------------
	
	public function set index(value:int):void {
		as3commons_reflect::setIndex(value);
	}
	
	//----------------------------------
	//  isOptional
	//----------------------------------
	
	public function set isOptional(value:Boolean):void {
		as3commons_reflect::setIsOptional(value);
	}
	
	//----------------------------------
	//  name
	//----------------------------------
	
	private var _name:String;
	
	public function get name():String {
		return _name;
	}
	
	public function set name(value:String):void {
		_name = value;
	}
	
	//----------------------------------
	//  type
	//----------------------------------
	
	public function set type(value:Type):void {
		as3commons_reflect::setType(value);
	}
}
}