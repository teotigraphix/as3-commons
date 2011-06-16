package org.as3commons.logging.setup.target {
	import org.as3commons.logging.level.DEBUG;
	import org.as3commons.logging.setup.ILogTarget;
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
			
			merged.log("A", "a", DEBUG, 1234, "Hello World", ["#"] );
			
			inOrder().verify().that( targetA.log( eq("A"), eq("a"), eq( DEBUG), eq(1234), eq("Hello World"), alike(["#"]), eq(null)));
			inOrder().verify().that( targetB.log( eq("A"), eq("a"), eq( DEBUG), eq(1234), eq("Hello World"), alike(["#"]), eq(null)));
			
			verifyNothingCalled( targetA );
			verifyNothingCalled( targetB );
		}
		
		public function testSpecialCases(): void {
			var target: ILogTarget = mock( ILogTarget );
			var merged: MergedTarget = new MergedTarget( null, null );
			
			try {
				merged.log( "A", "a", DEBUG, 1, "message", [] );
				fail( "If both targets are missing it should throw an error");
			} catch( e: Error ) {}
			
			merged = new MergedTarget( target, null );
			
			try {
				merged.log( "A", "a", DEBUG, 1, "message", [] );
				fail( "If second target is missing it should throw an error");
			} catch( e: Error ) {}
			
			merged = new MergedTarget( null, target );
			
			try {
				merged.log( "A", "a", DEBUG, 1, "message", [] );
				fail( "If first target is missing it should throw an error");
			} catch( e: Error ) {}
		}
		
		public function testMergingFunction(): void {
			
			var targetA: ILogTarget = mock( ILogTarget );
			var targetB: ILogTarget = mock( ILogTarget );
			var targetC: ILogTarget = mock( ILogTarget );
			
			assertNull( mergeTargets() );
			assertEquals( mergeTargets(targetA), targetA );
			assertEquals( mergeTargets(targetA,null), targetA );
			assertEquals( mergeTargets(null,targetA,null), targetA );
			
			var test: ILogTarget;
			
			test = mergeTargets(null,targetA,targetB);
			
			test.log( "a", "a", DEBUG, 1, "Hello World", [] );
			inOrder().verify().that( targetA.log( eq("a"), eq("a"), eq(DEBUG), eq(1), eq("Hello World"), alike([]), eq(null) ) );
			inOrder().verify().that( targetB.log( eq("a"), eq("a"), eq(DEBUG), eq(1), eq("Hello World"), alike([]), eq(null) ) );
			verifyNothingCalled( targetA );
			verifyNothingCalled( targetB );
			
			test = mergeTargets(targetA,targetA);
			test.log( "b", "a", DEBUG, 1, "Hello World", [], null );
			inOrder().verify().that( targetA.log( eq("b"), eq("a"), eq(DEBUG), eq(1), eq("Hello World"), alike([]), eq(null) ) );
			verifyNothingCalled( targetA );
			
			test = mergeTargets(targetA,mergeTargets(targetA));
			test.log( "C", "B", DEBUG, 1, "Hello World", [], null );
			inOrder().verify().that( targetA.log( eq("C"), eq("B"), eq(DEBUG), eq(1), eq("Hello World"), alike([]), eq(null) ) );
			verifyNothingCalled( targetA );
			
			test = mergeTargets(targetA,mergeTargets(null),null,mergeTargets(targetB,targetA,targetC));
			test.log( "D", "E", DEBUG, 1, "Hello World", [], null );
			inOrder().verify().that( targetA.log( eq("D"), eq("E"), eq(DEBUG), eq(1), eq("Hello World"), alike([]), eq(null) ) );
			inOrder().verify().that( targetB.log( eq("D"), eq("E"), eq(DEBUG), eq(1), eq("Hello World"), alike([]), eq(null) ) );
			inOrder().verify().that( targetA.log( eq("D"), eq("E"), eq(DEBUG), eq(1), eq("Hello World"), alike([]), eq(null) ) );
			inOrder().verify().that( targetC.log( eq("D"), eq("E"), eq(DEBUG), eq(1), eq("Hello World"), alike([]), eq(null) ) );
			verifyNothingCalled( targetA );
			verifyNothingCalled( targetB );
			verifyNothingCalled( targetC );
		}
	}
}
