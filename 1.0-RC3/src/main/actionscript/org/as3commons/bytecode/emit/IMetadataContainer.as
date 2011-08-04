package org.as3commons.bytecode.emit {

	public interface IMetadataContainer {
		/**
		 * an <code>Array</code> of <code>IMetadataBuilder</code> instances that describe the metadata that
		 * will be generated for the current <code>IMetadataContainer</code>.
		 */
		function get metadata():Array;

		/**
		 * @private
		 */
		function set metadata(value:Array):void;

		/**
		 * Creates an <code>IMetadataBuilder</code> instance that is able to generate a metadata entry
		 * for the current <code>IMetadataContainer</code>.
		 * @return The specified <code>IMetadataBuilder</code>.
		 */
		function defineMetadata(name:String = null, arguments:Array = null):IMetadataBuilder;

	}
}