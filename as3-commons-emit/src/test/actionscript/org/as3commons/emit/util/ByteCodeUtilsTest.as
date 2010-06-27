package org.as3commons.emit.util {
	import flash.events.Event;

	import org.flexunit.Assert;
	import org.as3commons.emit.bytecode.ByteCodeUtils;

	public class ByteCodeUtilsTest {

		[Test]
		public function testPackagesMatch():void {
			var ignoredPackages:Array = ["flash.*", "mx.*", "fl.*", ":Object"];

			Assert.assertTrue(ByteCodeUtils.packagesMatch(ignoredPackages[0], Event));
			Assert.assertTrue(ByteCodeUtils.packagesMatch(ignoredPackages[0], new Event("complete")));
			Assert.assertTrue(ByteCodeUtils.packagesMatch(ignoredPackages[0], "flash.events:Event"));

			Assert.assertFalse(ByteCodeUtils.packagesMatch(ignoredPackages[1], Event));
			Assert.assertFalse(ByteCodeUtils.packagesMatch(ignoredPackages[1], new Event("complete")));
			Assert.assertFalse(ByteCodeUtils.packagesMatch(ignoredPackages[1], "flash.events:Event"));
		}
	}
}