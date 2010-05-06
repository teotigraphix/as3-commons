package org.as3commons.emit.reflect {
import org.as3commons.emit.bytecode.BCNamespace;
import org.as3commons.emit.bytecode.NamespaceKind;
import org.as3commons.emit.bytecode.QualifiedName;
import org.as3commons.reflect.INamespaceOwner;

/**
 * 
 * @author Andrew Lewisohn
 */
public class EmitReflectionUtils {

	/**
	 * 
	 */
	public static function getMemberFullName(declaringType:EmitType, name:String):String {
		return (declaringType.isInterface)
			? declaringType.fullName.concat("/", declaringType.fullName, ":", name)
			: declaringType.fullName.concat("/", name);	
	}
	
	/**
	 * 
	 */
	public static function getMemberQualifiedName(member:IEmitMember):QualifiedName {
		var namespaceURI:String = INamespaceOwner(member).namespaceURI;
		var packageName:String = EmitType(member.declaringType).packageName;
		
		return (member.visibility == EmitMemberVisibility.PUBLIC)
			? new QualifiedName(new BCNamespace(namespaceURI, NamespaceKind.PACKAGE_NAMESPACE), member.name)
			: new QualifiedName(new BCNamespace(packageName + ":" + member.declaringType.name, member.visibility), member.name);
	}
	
	/**
	 * 
	 */
	public static function getRequiredArgumentCount(method:EmitMethod):uint {
		var i : uint = 0;
		
		for(; i<method.parameters.length; i++) {
			var param:EmitParameter = method.parameters[i];
			
			if(param.isOptional) {
				return i;
			}
		}
		
		return method.parameters.length;
	}
}
}