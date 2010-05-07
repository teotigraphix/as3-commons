package org.as3commons.emit.reflect {
import org.as3commons.emit.bytecode.AbstractMultiname;
import org.as3commons.emit.bytecode.BCNamespace;
import org.as3commons.emit.bytecode.GenericName;
import org.as3commons.emit.bytecode.MultipleNamespaceName;
import org.as3commons.emit.bytecode.NamespaceKind;
import org.as3commons.emit.bytecode.NamespaceSet;
import org.as3commons.emit.bytecode.QualifiedName;
import org.as3commons.emit.reflect.EmitType;
import org.as3commons.lang.ClassUtils;

public class EmitTypeUtils {
	
	//--------------------------------------------------------------------------
	//
	//  Class properties
	//
	//--------------------------------------------------------------------------
	
	public static var _rest:EmitType;
	
	public static function get REST():EmitType {
		if(_rest == null) {
			_rest = new EmitType(null, new QualifiedName(BCNamespace.packageNS(""), "..."));
		}
		return _rest;
	}
	
	public static var _untyped:EmitType;
	
	public static function get UNTYPED():EmitType {
		if(_untyped == null) {
			_untyped = new EmitType(null, new QualifiedName(BCNamespace.packageNS("*"), "*"));
		}
		return _untyped;
	}
	
	public static var _void:EmitType;
	
	public static function get VOID():EmitType {
		if(_void == null) {
			_void = new EmitType(null, new QualifiedName(BCNamespace.packageNS(""), "void"));
		}
		return _void;
	}
	
	//--------------------------------------------------------------------------
	//
	//  Class methods
	//
	//--------------------------------------------------------------------------
	
	public static function getGenericName(genericTypeDefinition:EmitType, genericParams:Array):GenericName 
	{
		genericParams = genericParams.map(
			function(type:EmitType, ... args):AbstractMultiname { 
				return type.multiname; 
			}
		);
		
		return new GenericName(genericTypeDefinition.multiname, genericParams);
	}
	
	public static function getGenericTypeDefinition(typeName:String):EmitType {
		var genericExpr : RegExp = /^([^\<]+)\.\<.+\>$/;	
		var genericTypeName : String = genericExpr.exec(typeName)[1].toString();
		
		return EmitType.forName(genericTypeName);
	}
	
	public static function getGenericParameters(typeName:String):Array
	{
		var genericParameters : Array = new Array();		
		var paramsExpr : RegExp = /\<(.+)\>$/;		
		var result : Object = paramsExpr.exec(typeName);
		
		if(result != null) {
			// TODO: Update with correct delmiter
			var paramTypeNames : Array = result[1].toString().split(', ');
			
			for each(var paramTypeName : String in paramTypeNames) {
				genericParameters.push(EmitType.forName(paramTypeName));
			}
		}
		
		return genericParameters;
	}
	
	public static function getMultiNamespaceName(qname:QualifiedName):MultipleNamespaceName {
		return new MultipleNamespaceName(
			qname.name, 
			new NamespaceSet([qname.ns])
		);
	}
	
	public static function getQualifiedName(typeName:String):QualifiedName {
		var ns:String;
		var nsKind:uint;
		var name:String;
		
		if(typeName.indexOf('::') == -1) {
			ns = "";
			nsKind = NamespaceKind.PACKAGE_NAMESPACE;
			name = typeName;
		} else {
			ns = typeName.substr(0, typeName.indexOf('::'));
			name = typeName.substr(typeName.indexOf('::') + 2);
			nsKind = org.as3commons.lang.ClassUtils.isPrivateClass(ns)
				? NamespaceKind.PRIVATE_NS
				: NamespaceKind.PACKAGE_NAMESPACE;
		}
		
		return new QualifiedName(new BCNamespace(ns, nsKind), name);
	}
	
	public static function getTypeNamespace(qname:QualifiedName):BCNamespace {
		var typeNamespaceKind : uint = (qname.ns.kind == NamespaceKind.PACKAGE_NAMESPACE)
			? NamespaceKind.NAMESPACE
			: NamespaceKind.PROTECTED_NAMESPACE;
		return new BCNamespace(qname.ns.name.concat(':', qname.name), typeNamespaceKind);
	}
}
}