package org.as3commons.collections.utils {
	import org.as3commons.collections.framework.IIterable;
	import org.as3commons.collections.framework.IRecursiveIterator;
	import org.as3commons.collections.iterators.RecursiveIterator;

	/**
	 * Collections utils.
	 *    
	 * @author jes 09.03.2009
	 */
	public class CollectionUtils {

		/**
		 * Dumps an iterable structure recursively into a formatted string literal.
		 * 
		 * <p id="link_DumpAsStringExample"><strong><code>dumpAsString()</code> example</strong></p>
		 * 
		 * {{EXAMPLE: DumpAsStringExample}}<br />
		 * 
		 * @param data The iterable data structure.
		 * @return The dump.
		 */
		public static function dumpAsString(data : IIterable) : String {
			var info : String = data + "\n";
			var iterator : IRecursiveIterator = new RecursiveIterator(data);
			var i : uint = 0;
			var j : uint = 0;
			var next : *;
			var prefix : String;
			while (iterator.hasNext()) {
				next = iterator.next();

				prefix = "";
				for (j = 0; j < iterator.depth + 1; j++) {
					prefix += ".......";
				}
				
				info += prefix + next;
				if (iterator.hasNext()) info += "\n";
				i++;
			}
			return info;
		}

	}
}
