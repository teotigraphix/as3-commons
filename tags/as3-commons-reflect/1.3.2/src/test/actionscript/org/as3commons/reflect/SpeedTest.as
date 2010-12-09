package org.as3commons.reflect {

	import flash.utils.getTimer;

	import flexunit.framework.TestCase;

	public class SpeedTest extends TestCase {

		{
			trace("*** Running Speed Test ***");
		}

		private static const NUM_ITEMS_IN_LIST:uint = 100000;
		private static const NUM_ITERATIONS:uint = 20;



		private var m_xmlList:XMLList;

		public function SpeedTest() {
			super();
		}


		override public function setUp():void {
			super.setUp();

			m_xmlList = new XMLList();

			for (var i:uint = 0; i < NUM_ITEMS_IN_LIST; i++) {
				m_xmlList[i] = <node/>;
			}
		}

		public function testForEach():void {
			doSpeedTest("for each", doTestForEach);
		}

		private function doTestForEach():void {
			var nodes:Array = createArray();
			for each (var node:XML in m_xmlList) {
				nodes.push(node);
			}
		}

		public function testForEachWithIndexInsert():void {
			doSpeedTest("for each with index insert",
					function():void {
						var nodes:Array = createArray();
						for each (var node:XML in m_xmlList) {
							nodes[nodes.length] = node;
						}
					});
		}

		public function testFor():void {
			doSpeedTest("for", doTestFor);
		}

		private function doTestFor():void {
			var numNodes:uint = m_xmlList.length();
			var nodes:Array = createArray();
			for (var i:uint = 0; i < numNodes; i++) {
				nodes[i] = m_xmlList[i];
			}
		}

		private function doSpeedTest(name:String, func:Function):void {
			var startTime:uint = getTimer();
			for (var i:uint = 0; i < NUM_ITERATIONS; i++) {
				func();
			}

			trace("Tested '" + name + "'");
			trace("- iterations: " + NUM_ITERATIONS);
			trace("- number of items: " + NUM_ITEMS_IN_LIST);
			trace("-> total time: '" + (getTimer() - startTime) + "' ms");
			trace(" ");
		}

		private function createArray():Array {
			//return new Array(NUM_ITEMS_IN_LIST);
			return [];
			//return new Array();
		}
	}
}