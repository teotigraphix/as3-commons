package org.as3commons.emit.reflect {
import flash.system.ApplicationDomain;

import org.as3commons.emit.bytecode.AbstractMultiname;
import org.as3commons.emit.bytecode.BCNamespace;
import org.as3commons.emit.bytecode.MultipleNamespaceName;
import org.as3commons.emit.bytecode.QualifiedName;
import org.as3commons.lang.ClassUtils;
import org.as3commons.logging.ILogger;
import org.as3commons.logging.LoggerFactory;
import org.as3commons.reflect.AbstractMember;
import org.as3commons.reflect.Field;
import org.as3commons.reflect.ITypeProvider;
import org.as3commons.reflect.Method;
import org.as3commons.reflect.Type;
import org.as3commons.reflect.errors.ClassNotFoundError;

public class EmitType extends Type {
	
	//--------------------------------------------------------------------------
	//
	//  Logging
	//
	//--------------------------------------------------------------------------
	
	private static const LOGGER:ILogger = LoggerFactory.getClassLogger(EmitType);
	
	//--------------------------------------------------------------------------
	//
	//  Class variables
	//
	//--------------------------------------------------------------------------
	
	private static var typeProvider:ITypeProvider;
	
	//--------------------------------------------------------------------------
	//
	//  Class methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Returns a <code>Type</code> object that describes the given instance.
	 *
	 * @param instance the instance from which to get a type description
	 */
	public static function forInstance(instance:*, applicationDomain:ApplicationDomain=null):EmitType {
		applicationDomain = (applicationDomain == null) ? ApplicationDomain.currentDomain : applicationDomain;
		var result:EmitType;
		var clazz:Class = ClassUtils.forInstance(instance, applicationDomain);
		
		if (clazz != null) {
			result = EmitType.forClass(clazz, applicationDomain);
		}
		return result;
	}
	
	/**
	 * Returns a <code>Type</code> object that describes the given classname.
	 *
	 * @param name the classname from which to get a type description
	 */
	public static function forName(name:String, applicationDomain:ApplicationDomain=null):EmitType {
		applicationDomain = (applicationDomain == null) ? ApplicationDomain.currentDomain : applicationDomain;
		var result:EmitType;
		switch (name) {
			case "void":
				result = EmitTypeUtils.VOID;
				break;
			case "*":
				result = EmitTypeUtils.UNTYPED;
				break;
			default:
				try {
					if (getTypeProvider().getTypeCache().contains(name)) {
						result = getTypeProvider().getTypeCache().get(name) as EmitType;
					} else {
						result = EmitType.forClass(ClassUtils.forName(name, applicationDomain), applicationDomain);
					}
				} catch (e:ReferenceError) {
					LOGGER.warn("Type.forName error: " + e.message + " The class '" + name + "' is probably an internal class or it may not have been compiled.");
				} catch (e:ClassNotFoundError) {
					LOGGER.warn("The class with the name '{0}' could not be found in the application domain '{1}'", name, applicationDomain);
				}
		}
		return result;
	}
	
	/**
	 * Returns a <code>Type</code> object that describes the given class.
	 *
	 * @param clazz the class from which to get a type description
	 */
	public static function forClass(clazz:Class, applicationDomain:ApplicationDomain=null):EmitType {
		applicationDomain = (applicationDomain == null) ? ApplicationDomain.currentDomain : applicationDomain;
		var result:EmitType;
		var fullyQualifiedClassName:String = ClassUtils.getFullyQualifiedName(clazz);
		
		if (getTypeProvider().getTypeCache().contains(fullyQualifiedClassName)) {
			result = getTypeProvider().getTypeCache().get(fullyQualifiedClassName) as EmitType;
		} else {
			result = getTypeProvider().getType(clazz, applicationDomain) as EmitType;
		}
		
		return result;
	}
	
	/**
	 * 
	 */
	public static function getTypeProvider():ITypeProvider {
		if(typeProvider == null) {
			typeProvider = new EmitTypeProvider();
		}
		return typeProvider;
	}	
	
	//--------------------------------------------------------------------------
	//
	//  Variables
	//
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Constructor.
	 */
	public function EmitType(applicationDomain:ApplicationDomain, qname:QualifiedName, multiname:AbstractMultiname=null, cls:Class=null) {
		super(applicationDomain);
		
		clazz = cls;
		_qname = qname;
		_multiname = multiname || qname;
		_multiNamespaceName = EmitTypeUtils.getMultiNamespaceName(qname);
		_typeNamespace = EmitTypeUtils.getTypeNamespace(qname);
	}
	
	//--------------------------------------------------------------------------
	//
	//  Overridden properties
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	//  fields
	//----------------------------------
	
	/**
	 * An array of all the static constants, constants, static variables and 
	 * variables of the <code>EmitType</code>
	 * 
	 * @see org.as3commons.reflect.IMember
	 */
	override public function get fields():Array {
		return staticConstants.concat(constants).concat(staticVariables).concat(variables);
	}
	
	//----------------------------------
	//  fullName
	//----------------------------------
	
	/**
	 * The full name of the class.
	 */
	override public function get fullName():String {
		return _qname.toString();
	}
	
	//----------------------------------
	//  name
	//----------------------------------
	
	/**
	 * The class name.
	 */
	override public function get name():String {
		return _qname.name;
	}
		
	//----------------------------------
	//  properties
	//----------------------------------
	
	/**
	 * An array of  containing all accessors.
	 *
	 * @see org.as3commons.reflect.Accessor
	 */
	override public function get properties():Array {
		return accessors.concat();
	}
	
	//--------------------------------------------------------------------------
	//
	//  Properties
	//
	//--------------------------------------------------------------------------
	
	//----------------------------------
	//  constructorMethod
	//----------------------------------
	
	private var _constructorMethod:EmitMethod;

	public function get constructorMethod():EmitMethod {
		if(_constructorMethod == null) {
			_constructorMethod = new EmitMethod(this, qname.name, null, EmitMemberVisibility.PUBLIC, false, false, [], EmitTypeUtils.UNTYPED);
		}
		return _constructorMethod;
	}
	
	public function set constructorMethod(value:EmitMethod):void {
		_constructorMethod = value;
	}
	
	//----------------------------------
	//  genericParameters
	//----------------------------------
	
	/**
	 * Storage for the genericParameters property.
	 */
	private var _genericParameters:Array;
	
	/**
	 * If the class is a generic type (Vector), an array containing parameters.
	 */
	public function get genericParameters():Array {
		return _genericParameters;
	}
	
	/**
	 * @private
	 */
	public function set genericParameters(value:Array):void {
		_genericParameters = value;
	}
	
	//----------------------------------
	//  genericTypeDefinition
	//----------------------------------
	
	/**
	 * Storage for the genericTypeDefinition property.
	 */
	private var _genericTypeDefinition:EmitType;
	
	/**
	 * The full name of the class.
	 */
	public function get genericTypeDefinition():EmitType {
		return _genericTypeDefinition;
	}
	
	/**
	 * @private
	 */
	public function set genericTypeDefinition(value:EmitType):void {
		_genericTypeDefinition = value;
	}
	
	//----------------------------------
	//  interfaces
	//----------------------------------
	
	/**
	 * Storage for the interfaces property.
	 */
	private var _interfaces:Array = [];
	
	/**
	 * An array of implemented interfaces.
	 */
	public function get interfaces():Array {
		return _interfaces;
	}
	
	/**
	 * @private
	 */
	public function set interfaces(value:Array):void {
		_interfaces = value;
	}
	
	//----------------------------------
	//  isGeneric
	//----------------------------------
	
	/**
	 * 
	 */
	public function get isGeneric():Boolean {
		return _genericTypeDefinition != null 
			&& _genericParameters != null 
			&& _genericParameters.length > 0;
	}
	
	//----------------------------------
	//  isGenericTypeDefinition
	//----------------------------------
	
	/**
	 * 
	 */
	public function get isGenericTypeDefinition():Boolean {
		return _genericTypeDefinition == null 
			&& _genericParameters != null 
			&& _genericParameters.length > 0;
	}
	
	//----------------------------------
	//  multiname
	//----------------------------------
	
	/**
	 * Storage for the multiname property.
	 */
	private var _multiname:AbstractMultiname;
	
	/**
	 * The multiname of the class.
	 */
	public function get multiname():AbstractMultiname {
		return _multiname;
	}
	
	/**
	 * @private
	 */
	public function set multiname(value:AbstractMultiname):void {
		_multiname = value;
	}
	
	//----------------------------------
	//  multiNamespaceName
	//----------------------------------
	
	/**
	 * Storage for the multiNamespaceName property.
	 */
	private var _multiNamespaceName:MultipleNamespaceName;
	
	/**
	 * The multiple namespace name of the class.
	 */
	public function get multiNamespaceName():MultipleNamespaceName {
		return _multiNamespaceName;
	}
	
	/**
	 * @private
	 */
	public function set multiNamespaceName(value:MultipleNamespaceName):void {
		_multiNamespaceName = value;
	}
	
	//----------------------------------
	//  packageName
	//----------------------------------
	
	/**
	 * The name of the package that houses the class.
	 */
	public function get packageName():String {
		return _qname.ns.name;
	}
	
	//----------------------------------
	//  qname
	//----------------------------------
	
	/**
	 * Storage for the qname property.
	 */
	private var _qname:QualifiedName;
	
	/**
	 * The fully qualified name of the class.
	 */
	public function get qname():QualifiedName {
		return _qname;
	}
	
	/**
	 * @private
	 */
	public function set qname(value:QualifiedName):void {
		_qname = value;
	}
	
	//----------------------------------
	//  scriptInitializer
	//----------------------------------
	
	/**
	 * Storage for the scriptInitializer property.
	 */
	private var _scriptInitializer:EmitMethod;
	
	/**
	 * The class's script initializer.
	 */
	public function get scriptInitializer():EmitMethod {
		if(_scriptInitializer == null) {
			_scriptInitializer = new EmitMethod(this, "", "", EmitMemberVisibility.PUBLIC, true, false, [], EmitTypeUtils.UNTYPED);
		}
		return _scriptInitializer;
	}
	
	/**
	 * @private
	 */
	public function set scriptInitializer(value:EmitMethod):void {
		_scriptInitializer = value;
	}
	
	//----------------------------------
	//  staticInitializer
	//----------------------------------
	
	/**
	 * Storage for the staticInitializer property.
	 */
	private var _staticInitializer:EmitMethod;
	
	/**
	 * The class's static initializer.
	 */
	public function get staticInitializer():EmitMethod {
		if(_staticInitializer == null) {
			_staticInitializer = new EmitMethod(this, "", "", EmitMemberVisibility.PUBLIC, true, false, [], EmitTypeUtils.UNTYPED);
		}
		return _staticInitializer;
	}
	
	/**
	 * @private
	 */
	public function set staticInitializer(value:EmitMethod):void {
		_staticInitializer = value;
	}
	
	//----------------------------------
	//  superClassType
	//----------------------------------
	
	/**
	 * @private
	 * Storage for the superClassType property.
	 */
	private var _superClassType:EmitType;
	
	/**
	 * The immediate super class type definition.
	 */
	public function get superClassType():EmitType {
		return _superClassType;
	}
	
	/**
	 * @private
	 */
	public function set superClassType(value:EmitType):void {
		_superClassType = value;
	}	
	
	//----------------------------------
	//  typeNamespace
	//----------------------------------
	
	/**
	 * Storage for the typeNamespace property.
	 */
	private var _typeNamespace:BCNamespace;
	
	/**
	 * The type namespace of the class.
	 */
	public function get typeNamespace():BCNamespace {
		return _typeNamespace;
	}
	
	/**
	 * @private
	 */
	public function set typeNamespace(value:BCNamespace):void {
		_typeNamespace = value;
	}
	
	//--------------------------------------------------------------------------
	//
	//  Overridden methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * @private
	 */
	override public function getField(name:String):Field {
		return findMember(fields, name) as Field;
	}
	
	//--------------------------------------------------------------------------
	//
	//  Methods
	//
	//--------------------------------------------------------------------------
	
	private function findMember(members:Array, name:String):IEmitMember {
		for each(var member:IEmitMember in members) {
			if(member.name == name) {
				return member;
			}
		}
		return null;
	}
	
	public function getDeclaredMethod(name:String, declared:Boolean=true):EmitMethod {
		var method:IEmitMember = findMember(methods, name);
		return (method == null && declared && superClassType != null)
			? superClassType.getDeclaredMethod(name, declared)
			: method as EmitMethod;
	}
	
	public function getDeclaredProperty(name:String, declared:Boolean=true):IEmitProperty {
		var property:IEmitMember = findMember(properties, name);
		return (property == null && declared && superClassType != null)
			? superClassType.getDeclaredProperty(name, declared)
			: property as IEmitProperty;
	}
	
	public function getFields(includeStatic:Boolean=true, includeInstance:Boolean=true):Array {
		return fields.filter(function (member:IEmitMember, i:int, arr:Array):Boolean {
			return (member.isStatic) ? includeStatic : includeInstance;
		});
	}
	
	public function getMethods(includeStatic:Boolean=true, includeInstance:Boolean=true):Array {
		return methods.concat().filter(function (method:EmitMethod, i:int, arr:Array):Boolean {
			return (method.isStatic) ? includeStatic : includeInstance;
		});
	}
	
	public function getProperties(includeStatic:Boolean=true, includeInstance:Boolean=true):Array {
		return properties.filter(function (member:IEmitProperty, i:int, arr:Array):Boolean {
			return (IEmitMember(member).isStatic) ? includeStatic : includeInstance;
		});
	}
}
}