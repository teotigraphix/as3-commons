package org.as3commons.logging.setup.target {
	import org.as3commons.logging.level.DEBUG;
	import org.as3commons.logging.api.ILogTarget;
	import org.as3commons.logging.util.alike;
	import org.as3commons.logging.util.verifyNothingCalled;
	import org.mockito.integrations.eq;
	import org.mockito.integrations.flexunit3.MockitoTestCase;
	import org.mockito.integrations.inOrder;
	import org.mockito.integrations.mock;

	/**
	 * @author mh
	 */
	public class MergedTest extends MockitoTestCase {
		public function MergedTest() {
			super([ILogTarget]);
		}
		
		public function testNormal(): void {
			
			var targetA: ILogTarget = mock( ILogTarget );
			var targetB: ILogTarget = mock( ILogTarget );
			
			var merged: MergedTarget = new MergedTarget( targetA, targetB );
			
			merged.log("A", "a", DEBUG, 1234, "Hello World", ["#"], null, null, null );
			
			inOrder().verify().that( targetA.log( eq("A"), eq("a"), eq( DEBUG), eq(1234), eq("Hello World"), alike(["#"]), eq(null), eq(null), eq(null)));
			inOrder().verify().that( targetB.log( eq("A"), eq("a"), eq( DEBUG), eq(1234), eq("Hello World"), alike(["#"]), eq(null), eq(null), eq(null)));
			
			verifyNothingCalled( targetA );
			verifyNothingCalled( targetB );
		}
		
		public function testMergingFunction(): void {
			var a: ILogTarget = new SampleTarget("a");
			var b: ILogTarget = new SampleTarget("b");
			var c: ILogTarget = new SampleTarget("c");
			var d: ILogTarget = new SampleTarget("d");
			
			var merged: ILogTarget;
			merged = mergeTargets();
			assertNull("Merging nothing should not change anything", merged);
			
			merged = mergeTargets(null);
			assertNull("Merging nothing should not change anything", merged);
			
			merged = mergeTargets(null, null, null);
			assertNull("Merging nothing should not change anything", merged);
			
			merged = mergeTargets(a);
			assertEquals("Merging with nothing should result the merged setup", a, merged);
			
			merged = mergeTargets(a, null);
			assertEquals("Merging with nothing should result the merged setup", a, merged);
			
			merged = mergeTargets(null, a, null);
			assertEquals("Merging with nothing should result the merged setup", a, merged);
			
			merged = mergeTargets(a, a);
			assertEquals("Merging something with itself should not do anything", a, merged);
			
			merged = mergeTargets(a,[null]);
			assertEquals("Merging with a null array shouldn't do anything eigther", a, merged);
			
			merged = mergeTargets([null],a);
			assertEquals("Merging with a null array shouldn't do anything eigther", a, merged);
			
			merged = mergeTargets(mergeTargets(a),a);
			assertEquals("Merging with a null array shouldn't do anything eigther", a, merged);
			
			merged = mergeTargets(a,b);
			merged.log(null,null,1,1,null, null, null, null, null);
			assertObjectEquals("Merging with one other setup should work", ["a","b"], stack);
			stack = [];
			
			merged = mergeTargets(a,b,b);
			merged.log(null,null,1,1,null, null, null, null, null);
			assertObjectEquals("Merging with duplicates should work just once", ["a","b"], stack);
			stack = [];
			
			merged = mergeTargets(a,a,b);
			merged.log(null,null,1,1,null, null, null, null, null);
			assertObjectEquals("Merging with duplicates should work just once", ["a","b"], stack);
			stack = [];
			
			merged = mergeTargets(a,b,a);
			merged.log(null,null,1,1,null, null, null, null, null);
			assertObjectEquals("The order is important", ["a","b"], stack);
			stack = [];
			
			merged = mergeTargets(a,b,c);
			merged.log(null,null,1,1,null, null, null, null, null);
			assertObjectEquals("Merging has to work deeper", ["a","b","c"], stack);
			stack = [];
			
			merged = mergeTargets(a,b,c,d);
			merged.log(null,null,1,1,null, null, null, null, null);
			assertObjectEquals("Merging has to work even deeper", ["a","b","c","d"], stack);
			stack = [];
			
			merged = mergeTargets(a,[b,c],d);
			merged.log(null,null,1,1,null, null, null, null, null);
			assertObjectEquals("Merging has to work even deeper with arrays", ["a","b","c","d"], stack);
			stack = [];
			
			merged = mergeTargets(a,[b,[null,c]],d);
			merged.log(null,null,1,1,null, null, null, null, null);
			assertObjectEquals("Merging has to work even deeper with arrays", ["a","b","c","d"], stack);
			stack = [];
			
			merged = mergeTargets(a,mergeTargets(mergeTargets(b,c),d));
			merged.log(null,null,1,1,null, null, null, null, null);
			assertObjectEquals("Order may not be disturbed by deeper hierarchies", ["a","b","c","d"], stack);
			stack = [];
			
			merged = mergeTargets(a,mergeTargets(b,a));
			merged.log(null,null,1,1,null, null, null, null, null);
			assertObjectEquals("Order may not be disturbed by deeper hierarchies", ["a","b"], stack);
			stack = [];
		}
		
		public function testSpecialCases(): void {
			var target: ILogTarget = mock( ILogTarget );
			var merged: MergedTarget = new MergedTarget( null, null );
			
			try {
				merged.log( "A", "a", DEBUG, 1, "message", [], null, null, null );
				fail( "If both targets are missing it should throw an error");
			} catch( e: Error ) {}
			
			merged = new MergedTarget( target, null );
			
			try {
				merged.log( "A", "a", DEBUG, 1, "message", [], null, null, null );
				fail( "If second target is missing it should throw an error");
			} catch( e: Error ) {}
			
			merged = new MergedTarget( null, target );
			
			try {
				merged.log( "A", "a", DEBUG, 1, "message", [], null, null, null );
				fail( "If first target is missing it should throw an error");
			} catch( e: Error ) {}
		}
	}
}
import org.as3commons.logging.api.ILogTarget;

var stack: Array = [];

class SampleTarget implements ILogTarget {
	
	private var _name:String;
	
	public function SampleTarget(name:String) {
		_name=name;
	}
	
	public function log(name : String, shortName : String, level : int, timeStamp : Number, message : String, parameters: *, person: String, context:String, shortContext:String) : void {
		stack.push(_name);
	}
}
