package org.as3commons.codec.serialization.utils
{
	/**
	 * Value Object that hold info about a Serialized Class.
	 * 
	 * @author Jan Van Coppenolle
	 */
	public class TraitsInfo
	{
		public var type:String;
		public var isDynamic:Boolean;
		public var isExternalizable:Boolean;
		public var kind:Class;
		public var properties:Vector.<PropertyInfo>;
		
		/**
		 * @private
		 */
		public function TraitsInfo(type:String, isDynamic:Boolean = false, isExternalizable:Boolean = false)
		{
			this.type = type;
			this.isDynamic = isDynamic;
			this.isExternalizable = isExternalizable;
			
			properties = new Vector.<PropertyInfo>();
		}
		
		/**
		 * Adds a property to the traits info for a certain class.
		 */
		public function addProperty(name:String, traits:TraitsInfo = null):void
		{
			properties.push(new PropertyInfo(name, traits));
		}
	}
}