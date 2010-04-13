package org.as3commons.collections.utils {
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;

	/**
	 * Uncomparable type Exception.
	 * 
	 * @author jes 17.03.2009
	 */
	public class UncomparableType extends TypeError {

		/**
		 * UncomparableType constructor.
		 * 
		 * @param expectedType The expected type of the value.
		 * @param failedValue The value not matching that type.
		 */
		public function UncomparableType(expectedType : Class, failedValue : *) {
			var failedType : *;
			var className : String = getQualifiedClassName(failedValue);
			try {
				failedType = getDefinitionByName(className);
			} catch (e : Error) {
				failedType = "[class " + className + "]";
			}
			
			super("Type not supported - expected: " + expectedType + " found: " + failedType);
		}

	}
}
