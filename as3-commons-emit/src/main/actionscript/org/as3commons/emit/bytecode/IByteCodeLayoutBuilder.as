package org.as3commons.emit.bytecode
{
import org.as3commons.emit.reflect.EmitMethod;
import org.as3commons.emit.reflect.EmitType;
	
		
	public interface IByteCodeLayoutBuilder
	{
		function registerType(type : EmitType) : void;
		function registerMethodBody(method : EmitMethod, methodBody : DynamicMethod) : void;
		
		function createLayout() : IByteCodeLayout;
	}
}