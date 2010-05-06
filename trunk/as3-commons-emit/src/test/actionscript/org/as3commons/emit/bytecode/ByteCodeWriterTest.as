package org.as3commons.emit.bytecode
{
	import flash.utils.ByteArray;
	
	import org.as3commons.emit.bytecode.ByteCodeWriter;
	import org.as3commons.emit.util.ByteArrayUtil;
	import org.flexunit.Assert;
	
	public class ByteCodeWriterTest
	{
		private var buffer : ByteArray;
		private var writer : ByteCodeWriter;
		
		[Before]
		public function setupTestData():void
		{
			// ByteArray.clear() not available outside AIR
			buffer = new ByteArray();
			writer = new ByteCodeWriter(buffer);
		}
		
		public function ByteCodeWriterTest()
		{
		}
		
		[Test]
		public function testWriteString() : void
		{
			writer.writeString("simple");
			
			var output : String = getBufferString();
			
			Assert.assertEquals("Unexpected data written to output", "0673696D706C65", output);
		}
		
		[Test]
		public function testWriteString_64() : void
		{
			var str : String = "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa";
			str += str;
			
			Assert.assertEquals(128, str.length);
			
			writer.writeString(str);
			
			var output : String = getBufferString();
			
			Assert.assertEquals("Unexpected data written to output", 260, output.length);
			Assert.assertEquals("Unexpected data written to output", "8001", output.substr(0, 4));
		}
		
		[Test]
		public function testWriteEmptyString() : void
		{
			writer.writeString("");
			
			var output : String = getBufferString();
			
			Assert.assertEquals("Unexpected data written to output", "00", output);
		}
		
		[Test]
		public function testWriteU8() : void
		{
			writer.writeU8(0);
			Assert.assertEquals("Unexpected data written to output", "00", getBufferString());
			
			writer.writeU8(1);
			Assert.assertEquals("Unexpected data written to output", "01", getBufferString());
			
			writer.writeU8(2);
			Assert.assertEquals("Unexpected data written to output", "02", getBufferString());
			
			writer.writeU8(4);
			Assert.assertEquals("Unexpected data written to output", "04", getBufferString());
			
			writer.writeU8(8);
			Assert.assertEquals("Unexpected data written to output", "08", getBufferString());
			
			writer.writeU8(16);
			Assert.assertEquals("Unexpected data written to output", "10", getBufferString());
			
			writer.writeU8(32);
			Assert.assertEquals("Unexpected data written to output", "20", getBufferString());
			
			writer.writeU8(64);
			Assert.assertEquals("Unexpected data written to output", "40", getBufferString());
			
			writer.writeU8(128);
			Assert.assertEquals("Unexpected data written to output", "80", getBufferString());
			
			writer.writeU8(255);
			Assert.assertEquals("Unexpected data written to output", "FF", getBufferString());
			
			writer.writeU8(256);
			Assert.assertEquals("Unexpected data written to output", "00", getBufferString());
		}
		
		[Test]
		public function testWriteU16() : void
		{
			writer.writeU16(0);
			Assert.assertEquals("Unexpected data written to output", "0000", getBufferString());
			
			writer.writeU16(1);
			Assert.assertEquals("Unexpected data written to output", "0100", getBufferString());
			
			writer.writeU16(0xFF);
			Assert.assertEquals("Unexpected data written to output", "FF00", getBufferString());
			
			writer.writeU16(0xFFFF);
			Assert.assertEquals("Unexpected data written to output", "FFFF", getBufferString());
			
			writer.writeU16(0xE5FFFF);
			Assert.assertEquals("Unexpected data written to output", "FFFF", getBufferString());
		}
		
		[Test]
		public function testWriteS24() : void
		{
			writer.writeS24(0);
			Assert.assertEquals("Unexpected data written to output", "000000", getBufferString());
			
			writer.writeS24(1);
			Assert.assertEquals("Unexpected data written to output", "010000", getBufferString());
			
			writer.writeS24(-1);
			Assert.assertEquals("Unexpected data written to output", "FFFFFF", getBufferString());
			
			writer.writeS24(0x40);
			Assert.assertEquals("Unexpected data written to output", "400000", getBufferString());
			
			writer.writeS24(-0x40);
			Assert.assertEquals("Unexpected data written to output", "C0FFFF", getBufferString());
			
			writer.writeS24(0x7F);
			Assert.assertEquals("Unexpected data written to output", "7F0000", getBufferString());
			
			writer.writeS24(-0x7F);
			Assert.assertEquals("Unexpected data written to output", "81FFFF", getBufferString());
			
			writer.writeS24(0x80);
			Assert.assertEquals("Unexpected data written to output", "800000", getBufferString());
			
			writer.writeS24(-0x80);
			Assert.assertEquals("Unexpected data written to output", "80FFFF", getBufferString());
			
			writer.writeS24(0x81);
			Assert.assertEquals("Unexpected data written to output", "810000", getBufferString());
			
			writer.writeS24(-0x81);
			Assert.assertEquals("Unexpected data written to output", "7FFFFF", getBufferString());
			
			writer.writeS24(0xFFFF);
			Assert.assertEquals("Unexpected data written to output", "FFFF00", getBufferString());
			
			writer.writeS24(-0xFFFF);
			Assert.assertEquals("Unexpected data written to output", "0100FF", getBufferString());
			
			writer.writeS24(0xABBCCD);
			Assert.assertEquals("Unexpected data written to output", "CDBCAB", getBufferString());
			
			writer.writeS24(-0xABBCCD);
			Assert.assertEquals("Unexpected data written to output", "334354", getBufferString());
		}
		
		[Test]
		public function testWriteU32() : void
		{
			writer.writeU32(0);
			Assert.assertEquals("Unexpected data written to output", "00", getBufferString());
			
			writer.writeU32(1);
			Assert.assertEquals("Unexpected data written to output", "01", getBufferString());
			
			writer.writeU32(0x40);
			Assert.assertEquals("Unexpected data written to output", "40", getBufferString());
			
			writer.writeU32(0x7F);
			Assert.assertEquals("Unexpected data written to output", "7F", getBufferString());
			
			writer.writeU32(0x80);
			Assert.assertEquals("Unexpected data written to output", "8001", getBufferString());
			
			writer.writeU32(0x81);
			Assert.assertEquals("Unexpected data written to output", "8101", getBufferString());
			
			writer.writeU32(0xFFFF);
			Assert.assertEquals("Unexpected data written to output", "FFFF03", getBufferString());
			
			writer.writeU32(0xABBCCD);
			Assert.assertEquals("Unexpected data written to output", "CDF9AE05", getBufferString());
		}
		
		[Test(expected="ArgumentError")]
		public function writeU32_invalidNumber_throwsArgumentError() : void
		{
			writer.writeU32(0xABBCCDDE);
		}
		
		[Test]
		public function testWriteU30() : void
		{
			// TODO: Are there any functional differences between u30 and u32?
			
			testWriteU32();
		}
		
		[Test]
		public function testWriteS32() : void
		{
			writer.writeS32(0);
			Assert.assertEquals("Unexpected data written to output", "00", getBufferString());
			
			writer.writeS32(1);
			Assert.assertEquals("Unexpected data written to output", "01", getBufferString());
			
			writer.writeS32(-1);
			Assert.assertEquals("Unexpected data written to output", "41", getBufferString());
			
			writer.writeS32(0x40);
			Assert.assertEquals("Unexpected data written to output", "C000", getBufferString());
			
			writer.writeS32(-0x40);
			Assert.assertEquals("Unexpected data written to output", "C040", getBufferString());
			
			writer.writeS32(0x7F);
			Assert.assertEquals("Unexpected data written to output", "FF00", getBufferString());
			
			writer.writeS32(-0x7F);
			Assert.assertEquals("Unexpected data written to output", "FF40", getBufferString());
			
			writer.writeS32(0x80);
			Assert.assertEquals("Unexpected data written to output", "8001", getBufferString());
			
			writer.writeS32(-0x80);
			Assert.assertEquals("Unexpected data written to output", "8041", getBufferString());
			
			writer.writeS32(0x81);
			Assert.assertEquals("Unexpected data written to output", "8101", getBufferString());
			
			writer.writeS32(-0x81);
			Assert.assertEquals("Unexpected data written to output", "8141", getBufferString());
			
			writer.writeS32(0xFFFF);
			Assert.assertEquals("Unexpected data written to output", "FFFF03", getBufferString());
			
			writer.writeS32(-0xFFFF);
			Assert.assertEquals("Unexpected data written to output", "FFFF43", getBufferString());
			
			writer.writeS32(0xABBCCD);
			Assert.assertEquals("Unexpected data written to output", "CDF9AE05", getBufferString());
			
			writer.writeS32(-0xABBCCD);
			Assert.assertEquals("Unexpected data written to output", "CDF9AE45", getBufferString());
		}
		
		[Test]
		public function testWriteD64() : void
		{
			writer.writeD64(0);
			Assert.assertEquals("Unexpected data written to output", "0000000000000000", getBufferString());
			
			writer.writeD64(1);
			Assert.assertEquals("Unexpected data written to output", "000000000000F03F", getBufferString());
			
			writer.writeD64(1.1);
			Assert.assertEquals("Unexpected data written to output", "9A9999999999F13F", getBufferString());
			
			writer.writeD64(-1);
			Assert.assertEquals("Unexpected data written to output", "000000000000F0BF", getBufferString());
			
			writer.writeD64(-1.1);
			Assert.assertEquals("Unexpected data written to output", "9A9999999999F1BF", getBufferString());
			
			writer.writeD64(64);
			Assert.assertEquals("Unexpected data written to output", "0000000000005040", getBufferString());
			
			writer.writeD64(64.64);
			Assert.assertEquals("Unexpected data written to output", "295C8FC2F5285040", getBufferString());
			
			writer.writeD64(-64);
			Assert.assertEquals("Unexpected data written to output", "00000000000050C0", getBufferString());
			
			writer.writeD64(-64.64);
			Assert.assertEquals("Unexpected data written to output", "295C8FC2F52850C0", getBufferString());
			
			writer.writeD64(65535);
			Assert.assertEquals("Unexpected data written to output", "00000000E0FFEF40", getBufferString());
			
			writer.writeD64(65535.65535);
			Assert.assertEquals("Unexpected data written to output", "2E90A0F8F4FFEF40", getBufferString());
			
			writer.writeD64(-65535);
			Assert.assertEquals("Unexpected data written to output", "00000000E0FFEFC0", getBufferString());
			
			writer.writeD64(-65535.65535);
			Assert.assertEquals("Unexpected data written to output", "2E90A0F8F4FFEFC0", getBufferString());
			
			writer.writeD64(11254989);
			Assert.assertEquals("Unexpected data written to output", "000000A099776541", getBufferString());
			
			writer.writeD64(-11254989);
			Assert.assertEquals("Unexpected data written to output", "000000A0997765C1", getBufferString());
			
			writer.writeD64(11254989.11254989);
			Assert.assertEquals("Unexpected data written to output", "3A029AA399776541", getBufferString());
			
			writer.writeD64(-11254989.11254989);
			Assert.assertEquals("Unexpected data written to output", "3A029AA3997765C1", getBufferString());
		}
		
		private function getBufferString() : String
		{
			buffer.position = 0;
			var str : String = ByteArrayUtil.toString(buffer);
			
			buffer = new ByteArray();
			writer = new ByteCodeWriter(buffer);
			
			return str;
		}
	}
}