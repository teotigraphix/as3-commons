/*
* Copyright 2007-2011 the original author or authors.
*
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
*      http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
*/
package org.as3commons.async.command {
	import flexunit.framework.Assert;

	public class CompositeCommandKindTest {

		public function CompositeCommandKindTest() {
			super();
		}

		[Test(expects = "org.as3commons.lang.IllegalStateError")]
		public function testCreate():void {
			var cck:CompositeCommandKind = new CompositeCommandKind("test");
		}

		[Test]
		public function testEnumMembers():void {
			Assert.assertNotNull(CompositeCommandKind.PARALLEL);
			Assert.assertNotNull(CompositeCommandKind.SEQUENCE);
		}

		[Test]
		public function testFromNameWithUnknownName():void {
			var kind:CompositeCommandKind = CompositeCommandKind.fromName("unknown");
			Assert.assertNull(kind);
		}

		[Test]
		public function testFromNameWithValidNames():void {
			var kind:CompositeCommandKind = CompositeCommandKind.fromName("sequence");
			Assert.assertStrictlyEquals(kind, CompositeCommandKind.SEQUENCE);
			kind = CompositeCommandKind.fromName("parallel");
			Assert.assertStrictlyEquals(kind, CompositeCommandKind.PARALLEL);

			kind = CompositeCommandKind.fromName("SEQUENCE");
			Assert.assertStrictlyEquals(kind, CompositeCommandKind.SEQUENCE);
			kind = CompositeCommandKind.fromName("PARALLEL");
			Assert.assertStrictlyEquals(kind, CompositeCommandKind.PARALLEL);
		}

	}

}
