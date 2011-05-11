package org.as3commons.codec.serialization
{
	import org.as3commons.codec.ICodec;

	/**
	 * A Data Serialization Codec.
	 * 
	 * @author Jan Van Coppenolle
	 */
	public interface ISerializationCodec extends ICodec, ISerializer, IDeserializer
	{
	}
}