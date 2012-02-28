package org.as3commons.logging.setup.log4j {
	import org.as3commons.logging.api.ILogTarget;
	/**
	 * @author mh
	 */
	public class TestClassWithArgument implements ILogTarget {
		public function TestClassWithArgument(name : String) {
			// name isn't used just for the test.
		}
	
		
		public function log(name : String, shortName : String, level : int, timeStamp : Number, message : String, parameters : *=null, person : String=null) : void {
		}
		
	}
}
