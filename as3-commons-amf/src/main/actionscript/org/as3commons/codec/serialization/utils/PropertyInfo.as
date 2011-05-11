package org.as3commons.codec.serialization.utils
{
	/**
	 * Value Object that holds info about a property.
	 * 
	 * @author Jan Van Coppenolle
	 */
	public class PropertyInfo
	{
		public var name:String;
		public var traits:TraitsInfo;
		
		/**
		 * @private
		 */
		public function PropertyInfo(name:String, traits:TraitsInfo = null)
		{
			this.name = name;
			this.traits = traits;
		}
	}
}