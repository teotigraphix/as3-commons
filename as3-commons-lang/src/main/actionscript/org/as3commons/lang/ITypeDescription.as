package org.as3commons.lang {
public interface ITypeDescription {

	function get clazz():Class;

	function get classInfo():*;

	function get instanceInfo():*;
	

	function isImplementationOf(interfaze:Class):Boolean;

	function isInformalImplementationOf(interfaze:Class):Boolean;

	function isSubclassOf(parentClass:Class):Boolean;

	function isInterface():Boolean;

	function getFullyQualifiedImplementedInterfaceNames(replaceColons:Boolean = false):Array;

	function getProperties(statik:Boolean = false, readable:Boolean = true, writable:Boolean = true):Object;

	function getSuperClass():Class;

}
}
