package org.as3commons.emit.reflect {
import org.as3commons.emit.bytecode.QualifiedName;
import org.as3commons.reflect.IMember;
import org.as3commons.reflect.Type;

public interface IEmitMember {
	
	//--------------------------------------------------------------------------
	//
	//  Properties
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	//  declaringType
	//----------------------------------
	
	/**
	 * Returns the <code>EmitType</code> object that declares this member.
	 */
	function get declaringType():Type;
	
	/**
	 * @private
	 */
	function set declaringType(value:Type):void;
	
	//----------------------------------
	//  fullName
	//----------------------------------
	
	function get fullName():String;
	
	function set fullName(value:String):void;
	
	//----------------------------------
	//  isOverride
	//----------------------------------
	
	function get isOverride():Boolean;
	
	function set isOverride(value:Boolean):void;
	
	//----------------------------------
	//  isStatic
	//----------------------------------
	
	function get isStatic():Boolean;
	
	function set isStatic(value:Boolean):void;
	
	//----------------------------------
	//  name
	//----------------------------------
	
	/**
	 * Returns the name of this member.
	 */
	function get name():String;
	
	/**
	 * @private
	 */
	function set name(value:String):void;
	
	//----------------------------------
	//  namespaceURI
	//----------------------------------
	
	function get namespaceURI():String;
	
	function set namespaceURI(value:String):void;
	
	//----------------------------------
	//  qname
	//----------------------------------
	
	function get qname():QualifiedName;
	
	function set qname(value:QualifiedName):void;
	
	//----------------------------------
	//  visibility
	//----------------------------------
	
	function get visibility():uint;
	
	function set visibility(value:uint):void;
}
}