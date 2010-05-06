package org.as3commons.emit {
import org.as3commons.emit.bytecode.DynamicClass;
import org.as3commons.emit.reflect.EmitType;

public interface IClassGenerator {
	
	function createClass(type:EmitType):DynamicClass;
}
}