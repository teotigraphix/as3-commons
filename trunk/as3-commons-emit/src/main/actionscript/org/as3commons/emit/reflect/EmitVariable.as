package org.as3commons.emit.reflect {
import org.as3commons.emit.bytecode.QualifiedName;
import org.as3commons.reflect.Type;
import org.as3commons.reflect.Variable;
import org.as3commons.reflect.as3commons_reflect;

public class EmitVariable extends Variable implements IEmitMember, IEmitProperty {
	
	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Constructor.
	 */
	public function EmitVariable(declaringType:EmitType, name:String, fullName:String, type:EmitType, visibility:uint, isStatic:Boolean, isOverride:Boolean, metaData:Array=null, ns:String=null) {
		super(name, type.name, declaringType.name, isStatic);
		
		_visibility = visibility;
		_isOverride = isOverride;
		as3commons_reflect::setDeclaringType(declaringType);
		as3commons_reflect::setType(type);
		as3commons_reflect::setNamespaceURI(ns || "");
		_qname = EmitReflectionUtils.getMemberQualifiedName(this);
		_fullName = (fullName || EmitReflectionUtils.getMemberFullName(declaringType, name));
	}
	
	//--------------------------------------------------------------------------
	//
	//  Properties
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	//  declaringType
	//----------------------------------
	
	public function set declaringType(value:Type):void {
		as3commons_reflect::setDeclaringType(value);
	}
	
	//----------------------------------
	//  fullName
	//----------------------------------
	
	private var _fullName:String;
	
	public function get fullName():String {
		return _fullName;
	}
	
	public function set fullName(value:String):void {
		_fullName = value;
	}
	
	//----------------------------------
	//  isOverride
	//----------------------------------
	
	private var _isOverride:Boolean = false;
	
	public function get isOverride():Boolean {
		return _isOverride;
	}
	
	public function set isOverride(value:Boolean):void {
		_isOverride = value;
	}
	
	//----------------------------------
	//  isStatic
	//----------------------------------
	
	public function set isStatic(value:Boolean):void {
		as3commons_reflect::setIsStatic(value);
	}
	
	//----------------------------------
	//  name
	//----------------------------------
	
	public function set name(value:String):void {
		as3commons_reflect::setName(value);
	}
	
	//----------------------------------
	//  namespaceURI
	//----------------------------------
	
	public function set namespaceURI(value:String):void {
		as3commons_reflect::setNamespaceURI(value);
	}
	
	//----------------------------------
	//  qname
	//----------------------------------
	
	private var _qname:QualifiedName;
	
	public function get qname():QualifiedName {
		return _qname;
	}
	
	public function set qname(value:QualifiedName):void {
		_qname = value;
	}
	
	//----------------------------------
	//  readable
	//----------------------------------
	
	public function get readable():Boolean {
		return true;
	}
	
	//----------------------------------
	//  type
	//----------------------------------
	
	public function set type(value:Type):void {
		as3commons_reflect::setType(value);
	}
	
	//----------------------------------
	//  visibility
	//----------------------------------
	
	private var _visibility:uint;
	
	public function get visibility():uint {
		return _visibility;
	}
	
	public function set visibility(value:uint):void {
		_visibility = value;
	}
	
	//----------------------------------
	//  writeable
	//----------------------------------
	
	public function get writeable():Boolean {
		return true;
	}
}
}