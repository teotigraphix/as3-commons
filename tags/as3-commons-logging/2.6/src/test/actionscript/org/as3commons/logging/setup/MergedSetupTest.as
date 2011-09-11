package org.as3commons.logging.setup {
	import flexunit.framework.TestCase;

	import org.as3commons.logging.api.ILogSetup;

	/**
	 * @author mh
	 */
	public class MergedSetupTest extends TestCase {
		public function MergedSetupTest() {
			super();
		}
		
		public function testMerging(): void {
			var a: ILogSetup = new SampleSetup("a");
			var b: ILogSetup = new SampleSetup("b");
			var c: ILogSetup = new SampleSetup("c");
			var d: ILogSetup = new SampleSetup("d");
			
			var merged: ILogSetup;
			merged = mergeSetups();
			assertNull("Merging nothing should not change anything", merged);
			
			merged = mergeSetups(null);
			assertNull("Merging nothing should not change anything", merged);
			
			merged = mergeSetups(null, null, null);
			assertNull("Merging nothing should not change anything", merged);
			
			merged = mergeSetups(a);
			assertEquals("Merging with nothing should result the merged setup", a, merged);
			
			merged = mergeSetups(a, null);
			assertEquals("Merging with nothing should result the merged setup", a, merged);
			
			merged = mergeSetups(null, a, null);
			assertEquals("Merging with nothing should result the merged setup", a, merged);
			
			merged = mergeSetups(a, a);
			assertEquals("Merging something with itself should not do anything", a, merged);
			
			merged = mergeSetups(a,[null]);
			assertEquals("Merging with a null array shouldn't do anything eigther", a, merged);
			
			merged = mergeSetups([null],a);
			assertEquals("Merging with a null array shouldn't do anything eigther", a, merged);
			
			merged = mergeSetups(mergeSetups(a),a);
			assertEquals("Merging with a null array shouldn't do anything eigther", a, merged);
			
			merged = mergeSetups(a,b);
			merged.applyTo(null);
			assertObjectEquals("Merging with one other setup should work", ["a","b"], stack);
			stack = [];
			
			merged = mergeSetups(a,b,b);
			merged.applyTo(null);
			assertObjectEquals("Merging with duplicates should work just once", ["a","b"], stack);
			stack = [];
			
			merged = mergeSetups(a,a,b);
			merged.applyTo(null);
			assertObjectEquals("Merging with duplicates should work just once", ["a","b"], stack);
			stack = [];
			
			merged = mergeSetups(a,b,a);
			merged.applyTo(null);
			assertObjectEquals("The order is important", ["a","b"], stack);
			stack = [];
			
			merged = mergeSetups(a,b,c);
			merged.applyTo(null);
			assertObjectEquals("Merging has to work deeper", ["a","b","c"], stack);
			stack = [];
			
			merged = mergeSetups(a,b,c,d);
			merged.applyTo(null);
			assertObjectEquals("Merging has to work even deeper", ["a","b","c","d"], stack);
			stack = [];
			
			merged = mergeSetups(a,[b,c],d);
			merged.applyTo(null);
			assertObjectEquals("Merging has to work even deeper with arrays", ["a","b","c","d"], stack);
			stack = [];
			
			merged = mergeSetups(a,[b,[null,c]],d);
			merged.applyTo(null);
			assertObjectEquals("Merging has to work even deeper with arrays", ["a","b","c","d"], stack);
			stack = [];
			
			merged = mergeSetups(a,[b,[a,b]]);
			merged.applyTo(null);
			assertObjectEquals("Order may not be disturbed by deeper hierarchies", ["a","b"], stack);
			stack = [];
			
			merged = mergeSetups(a,mergeSetups(mergeSetups(b,c),d));
			merged.applyTo(null);
			assertObjectEquals("Order may not be disturbed by deeper hierarchies", ["a","b","c","d"], stack);
			stack = [];
			
			merged = mergeSetups(a,mergeSetups(b,a));
			merged.applyTo(null);
			assertObjectEquals("Order may not be disturbed by deeper hierarchies", ["a","b"], stack);
			stack = [];
		}
	}
}
import org.as3commons.logging.api.ILogSetup;
import org.as3commons.logging.api.Logger;

var stack: Array = [];

class SampleSetup implements ILogSetup {
	
	private var _name:String;
	
	public function SampleSetup(name:String) {
		_name=name;
	}
	
	public function applyTo(logger : Logger) : void {
		stack.push(_name);
	}
}
