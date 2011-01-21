package org.as3commons.reflect.testclasses {
	
	
	/**
	 * Class description
	 *
	 * @author Christophe
	 * @since 13-jan-2009
	 */
	[ClassMetadata]
	[ClassMetadata(key="value", key1="value1")]
	[ClassMetadata(key="value2", key1="value3")]
	public class MetadataClass {
		
		[VarMetadata]
		[VarMetadata(key="value", key1="value1")]
		[VarMetadata(key="value2", key1="value3")]
		public var aVariable:String = "";
		
		/**
		 * Creates a new MetadataClass object.
		 */
		public function MetadataClass()
		{
		}
		
	}
}