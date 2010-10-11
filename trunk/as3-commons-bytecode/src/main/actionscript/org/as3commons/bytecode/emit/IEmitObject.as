package org.as3commons.bytecode.emit {
	import org.as3commons.bytecode.abc.QualifiedName;
	import org.as3commons.bytecode.emit.enum.MemberVisibility;

	public interface IEmitObject {
		function get packageName():String;
		function set packageName(value:String):void;
		function get name():String;
		function set name(value:String):void;
		function get visibility():MemberVisibility;
		function set visibility(value:MemberVisibility):void;
		function get namespace():String;
		function set namespace(value:String):void;
	}
}