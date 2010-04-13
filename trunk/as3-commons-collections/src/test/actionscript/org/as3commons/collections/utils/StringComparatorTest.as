package org.as3commons.collections.utils {
	import flexunit.framework.TestCase;

	import org.as3commons.collections.framework.IComparator;

	/**
	 * @author jes 13.03.2009
	 */
	public class StringComparatorTest extends TestCase {


		public function test_ascendingCasesensitive() : void {
			var comparator : IComparator = new StringComparator(StringComparator.ORDER_ASC, StringComparator.OPTION_CASESENSITIVE);
			
			// case
			
			assertEquals(
				"A < a",
				-1,
				comparator.compare("A", "a")
			);

			assertEquals(
				"a > A",
				1,
				comparator.compare("a", "A")
			);

			assertEquals(
				"namE < name",
				-1,
				comparator.compare("namE", "name")
			);

			assertEquals(
				"name > namE",
				1,
				comparator.compare("name", "namE")
			);

			// empty string

			assertEquals(
				"'' < a",
				-1,
				comparator.compare("", "a")
			);

			assertEquals(
				"a > ''",
				1,
				comparator.compare("a", "")
			);

			assertEquals(
				"'' == ''",
				0,
				comparator.compare("", "")
			);

			// different length

			assertEquals(
				"name < namee",
				-1,
				comparator.compare("name", "namee")
			);

			assertEquals(
				"namee > name",
				1,
				comparator.compare("namee", "name")
			);

			// case and length

			assertEquals(
				"name > nAmee",
				1,
				comparator.compare("name", "nAmee")
			);

			assertEquals(
				"nAmee < name",
				-1,
				comparator.compare("nAmee", "name")
			);

			// numbers as strings

			assertEquals(
				"name1 < name2",
				-1,
				comparator.compare("name1", "name2")
			);

			assertEquals(
				"name2 > name1",
				1,
				comparator.compare("name2", "name1")
			);

			// numbers vs strings

			assertEquals(
				"1 < A",
				-1,
				comparator.compare("1", "A")
			);

			assertEquals(
				"A > 1",
				1,
				comparator.compare("A", "1")
			);

		}

		public function test_ascendingCaseinsensitive() : void {
			var comparator : IComparator = new StringComparator(StringComparator.ORDER_ASC, StringComparator.OPTION_CASEINSENSITIVE);
			
			// case
			
			assertEquals(
				"A == a",
				0,
				comparator.compare("A", "a")
			);

			assertEquals(
				"a == A",
				0,
				comparator.compare("a", "A")
			);

			assertEquals(
				"namE == name",
				0,
				comparator.compare("namE", "name")
			);

			assertEquals(
				"name == namE",
				0,
				comparator.compare("name", "namE")
			);

			// empty string

			assertEquals(
				"'' < a",
				-1,
				comparator.compare("", "a")
			);

			assertEquals(
				"a > ''",
				1,
				comparator.compare("a", "")
			);

			assertEquals(
				"'' == ''",
				0,
				comparator.compare("", "")
			);

			// different length

			assertEquals(
				"name < namee",
				-1,
				comparator.compare("name", "namee")
			);

			assertEquals(
				"namee > name",
				1,
				comparator.compare("namee", "name")
			);

			// case and length

			assertEquals(
				"name < nAmee",
				-1,
				comparator.compare("name", "nAmee")
			);

			assertEquals(
				"nAmee > name",
				1,
				comparator.compare("nAmee", "name")
			);

			// numbers as strings

			assertEquals(
				"name1 < name2",
				-1,
				comparator.compare("name1", "name2")
			);

			assertEquals(
				"name2 > name1",
				1,
				comparator.compare("name2", "name1")
			);

			// numbers vs strings

			assertEquals(
				"1 < A",
				-1,
				comparator.compare("1", "A")
			);

			assertEquals(
				"A > 1",
				1,
				comparator.compare("A", "1")
			);

		}

		public function test_descendingCasesensitive() : void {
			var comparator : IComparator = new StringComparator(StringComparator.ORDER_DESC, StringComparator.OPTION_CASESENSITIVE);
			
			// case
			
			assertEquals(
				"A > a",
				1,
				comparator.compare("A", "a")
			);

			assertEquals(
				"a < A",
				-1,
				comparator.compare("a", "A")
			);

			assertEquals(
				"namE > name",
				1,
				comparator.compare("namE", "name")
			);

			assertEquals(
				"name < namE",
				-1,
				comparator.compare("name", "namE")
			);

			// empty string

			assertEquals(
				"'' > a",
				1,
				comparator.compare("", "a")
			);

			assertEquals(
				"a < ''",
				-1,
				comparator.compare("a", "")
			);

			assertEquals(
				"'' == ''",
				0,
				comparator.compare("", "")
			);

			// different length

			assertEquals(
				"name > namee",
				1,
				comparator.compare("name", "namee")
			);

			assertEquals(
				"namee < name",
				-1,
				comparator.compare("namee", "name")
			);

			// case and length

			assertEquals(
				"name < nAmee",
				-1,
				comparator.compare("name", "nAmee")
			);

			assertEquals(
				"nAmee > name",
				1,
				comparator.compare("nAmee", "name")
			);

			// numbers as strings

			assertEquals(
				"name1 > name2",
				1,
				comparator.compare("name1", "name2")
			);

			assertEquals(
				"name2 < name1",
				-1,
				comparator.compare("name2", "name1")
			);

			// numbers vs strings

			assertEquals(
				"1 > A",
				1,
				comparator.compare("1", "A")
			);

			assertEquals(
				"A < 1",
				-1,
				comparator.compare("A", "1")
			);

		}

		public function test_descendingCaseinsensitive() : void {
			var comparator : IComparator = new StringComparator(StringComparator.ORDER_DESC, StringComparator.OPTION_CASEINSENSITIVE);
			
			// case
			
			assertEquals(
				"A == a",
				0,
				comparator.compare("A", "a")
			);

			assertEquals(
				"a == A",
				0,
				comparator.compare("a", "A")
			);

			assertEquals(
				"namE == name",
				0,
				comparator.compare("namE", "name")
			);

			assertEquals(
				"name == namE",
				0,
				comparator.compare("name", "namE")
			);

			// empty string

			assertEquals(
				"'' > a",
				1,
				comparator.compare("", "a")
			);

			assertEquals(
				"a < ''",
				-1,
				comparator.compare("a", "")
			);

			assertEquals(
				"'' == ''",
				0,
				comparator.compare("", "")
			);

			// different length

			assertEquals(
				"name > namee",
				1,
				comparator.compare("name", "namee")
			);

			assertEquals(
				"namee < name",
				-1,
				comparator.compare("namee", "name")
			);

			// case and length

			assertEquals(
				"name > nAmee",
				1,
				comparator.compare("name", "nAmee")
			);

			assertEquals(
				"nAmee < name",
				-1,
				comparator.compare("nAmee", "name")
			);

			// numbers as strings

			assertEquals(
				"name1 > name2",
				1,
				comparator.compare("name1", "name2")
			);

			assertEquals(
				"name2 < name2",
				-1,
				comparator.compare("name2", "name1")
			);

			// numbers vs strings

			assertEquals(
				"1 > A",
				1,
				comparator.compare("1", "A")
			);

			assertEquals(
				"A < 1",
				-1,
				comparator.compare("A", "1")
			);

		}

	}
}
