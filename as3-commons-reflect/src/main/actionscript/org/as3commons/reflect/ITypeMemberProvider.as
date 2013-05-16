package org.as3commons.reflect {
import flash.system.ApplicationDomain;

public interface ITypeMemberProvider {

	function getConstructorForType(type:Type):Constructor;

	function getAccessorsForType(type:Type):Array;

	function getMethodsForType(type:Type):Array;

	function getStaticConstantsForType(type:Type):Array;

	function getConstantsForType(type:Type):Array;

	function getStaticVariablesForType(type:Type):Array;

	function getVariablesForType(type:Type):Array;

	function getMetadataForType(type:Type):Array;

}
}
