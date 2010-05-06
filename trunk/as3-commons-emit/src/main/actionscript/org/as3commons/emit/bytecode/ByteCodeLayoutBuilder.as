package org.as3commons.emit.bytecode
{
	import flash.utils.Dictionary;
	
	import org.as3commons.emit.reflect.EmitMethod;
	import org.as3commons.emit.reflect.EmitType;
	import org.as3commons.lang.IEquals;
	
	
	public class ByteCodeLayoutBuilder implements IByteCodeLayoutBuilder
	{
		private var _types : Array = new Array();
		private var _methods : Dictionary = new Dictionary();
		
		private var _ignoredPackages : Array = [
			"flash.*", "mx.*", "fl.*", ":Object"
			];
		
		public function ByteCodeLayoutBuilder()
		{
		}
		
		public function registerType(type : EmitType) : void
		{
			if (_types.indexOf(type) == -1)
			{
				/* if (type.isGeneric)
				{
					registerType(type.genericTypeDefinition);
				} */
				
				if (type.superClassType != type && type.superClassType != null)
				{
					registerType(type.superClassType);
				}
				
				for each(var interfaze : Class in type.interfaces)
				{
					var interfaceType:EmitType = EmitType.forClass(interfaze);
					registerType(interfaceType);
				}
				
				_types.push(type);
			}
		}
		
		public function registerMethodBody(method : EmitMethod, methodBody : DynamicMethod) : void
		{
			_methods[method] = methodBody;
		}
		
		public function createLayout() : IByteCodeLayout
		{
			var layout : ByteCodeLayout = new ByteCodeLayout();
			
			for each(var type : EmitType in this._types)
			{
				var dynamicClass : DynamicClass = type as DynamicClass;
				
				if (isIgnored(type) || dynamicClass == null)
				{
					layout.registerMultiname(type.multiname);
					layout.registerMultiname(type.multiNamespaceName);
				}
				else
				{
					layout.registerClass(type);
					
					//if (dynamicClass != null)
					{
						for each (var methodBody : DynamicMethod in dynamicClass.methodBodies)
						{
							layout.registerMethodBody(methodBody.method, methodBody);
						}
					}
				}
			}
			
			return layout;
		}
		
		private function isIgnored(type : EmitType) : Boolean
		{
			for each(var ignoredPackage : String in _ignoredPackages)
			{
				if (ByteCodeUtils.packagesMatch(ignoredPackage, type.fullName))
				{
					return true;
				}
			}
			
			return false;
		}
		
		private function pushUniqueValue(array : Array, value : IEquals) : uint
		{
			for (var i:uint =0; i<array.length; i++)
			{
				if (value.equals(array[i]))
					return i;
			}
			
			array.push(value);
			
			return array.length - 1;
		}
	}
}