package org.as3commons.logging.util {
	
	import flexunit.framework.TestCase;
	import mx.utils.Base64Encoder;
	import flash.utils.ByteArray;

	/**
	 * @author mh
	 */
	public class Base64Test extends TestCase {
		
		public function testShort(): void {
			var en: Base64Encoder = new Base64Encoder();
			var byte: ByteArray;
			
			byte = new ByteArray;
			byte.writeByte(1);
			byte.position = 0;
			assertEquals( "AQ==", base64enc(byte) );
			
			byte = new ByteArray;
			byte.writeByte(2);
			byte.position = 0;
			assertEquals( "Ag==", base64enc(byte) );
			
			byte = new ByteArray;
			byte.writeByte(1);
			byte.writeByte(1);
			byte.position = 0;
			assertEquals( "AQE=", base64enc(byte) );
			
			byte = new ByteArray;
			byte.writeUTF("A");
			byte.position = 0;
			assertEquals( "AAFB", base64enc(byte) );
			
			byte = new ByteArray;
			byte.writeByte(1);
			byte.writeByte(3);
			byte.position = 0;
			assertEquals( base64enc(byte), "AQM=" );
			
			byte = new ByteArray;
			byte.writeUTFBytes("ABCDEFGHIJKLMNOPQRSTUVW");
			byte.position = 0;
			assertEquals( base64enc(byte), "QUJDREVGR0hJSktMTU5PUFFSU1RVVlc=" );
			
			byte = new ByteArray;
			byte.writeUTFBytes("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz01234567890=");
			byte.position = 0;
			assertEquals( base64enc(byte), "QUJDREVGR0hJSktMTU5PUFFSU1RVVldYWVphYmNkZWZnaGlqa2xtbm9wcXJzdHV2d3h5ejAxMjM0\nNTY3ODkwPQ==" );
			
			byte.position = 0;
			en.encodeBytes(byte);
			var data: String = en.toString();
			assertEquals( data, "QUJDREVGR0hJSktMTU5PUFFSU1RVVldYWVphYmNkZWZnaGlqa2xtbm9wcXJzdHV2d3h5ejAxMjM0\nNTY3ODkwPQ==" );
			
			
		}
	}
}
