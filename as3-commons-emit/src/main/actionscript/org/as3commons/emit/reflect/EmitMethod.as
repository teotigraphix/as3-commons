package org.as3commons.emit.reflect {
import org.as3commons.emit.bytecode.BCNamespace;
import org.as3commons.emit.bytecode.NamespaceKind;
import org.as3commons.emit.bytecode.QualifiedName;
import org.as3commons.reflect.Method;
import org.as3commons.reflect.Type;
import org.as3commons.reflect.as3commons_reflect;

public class EmitMethod extends Method implements IEmitMember {
	
	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Constructor.
	 */
	public function EmitMethod(declaringType:EmitType, 
						   name:String, 
						   fullName:String,
						   visibility:uint,
						   isStatic:Boolean, 
						   isOverride:Boolean, 
						   parameters:Array, 
						   returnType:*, 
						   metaData:Array=null,
						   ns:String=null) {
		super(declaringType, name, isStatic, parameters, returnType, metaData);
		
		_isOverride = isOverride;
		_visibility = visibility;
		as3commons_reflect::setNamespaceURI(ns || "");
		_qname = EmitReflectionUtils.getMemberQualifiedName(this);
		as3commons_reflect::setFullName(fullName || EmitReflectionUtils.getMemberFullName(declaringType, name));
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
	
	public function set fullName(value:String):void {
		as3commons_reflect::setFullName(value);
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
	//  qname
	//----------------------------------
	
	private var _qname:QualifiedName;
	
	public function get qname():QualifiedName {
		return _qname;
	}
	
	public function set qname(value:QualifiedName):void {
		_qname = value;
	}
}
}