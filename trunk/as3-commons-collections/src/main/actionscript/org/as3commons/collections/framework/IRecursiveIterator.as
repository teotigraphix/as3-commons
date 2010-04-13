package org.as3commons.collections.framework {
	import org.as3commons.collections.framework.IIterator;

	/**
	 * Recursive iterator definition.
	 * 
	 * <p><strong>Description</strong></p>
	 * 
	 * <p>A recursive iterator enables the recursive enumeration of an iterable data structure,
	 * where the contained elements are either also iterable or single items.</p>
	 * 
	 * <p><strong>Features</strong></p>
	 * 
	 * <p>This interface adds a recursion <code>depth</code> information to the <code>IIterable</code> definition.</p>
	 * 
	 * <p><strong>Notes</strong></p>
	 * 
	 * <p>There are 2 resursive iterators provided by this library. The <code>RecursiveIterator</code>
	 * returns all items of a recursive structure. The <code>RecursiveFilterIterator</code> lets
	 * apply a filter function and returns only items that pass this filter.</p>
	 * 
	 * <p>A recursive iterator does not have the ability to modify its underlying data structure.</p>
	 * 
	 * <p>A recursive iterator recognises recursions and skips the iteration over items
	 * that are direct or later children of itself.</p>
	 * 
	 * @author jes 17.02.2010
	 * @see IIterator IIterator interface - Description of the basic iterator features.
	 * @see org.as3commons.collections.iterators.RecursiveIterator RecursiveIterator - RecursiveIterator usage example.
	 * @see org.as3commons.collections.iterators.RecursiveFilterIterator RecursiveFilterIterator - RecursiveFilterIterator usage example.
	 */
	public interface IRecursiveIterator extends IIterator {

		/**
		 * The recursion depth of the current item.
		 */
		function get depth() : uint;

	}
}
