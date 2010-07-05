package org.mockito.asmock.framework.constraints
{
	import org.mockito.asmock.reflection.Type;
	
	/**
	 * Provides static methods that create general constraints to be used with 
	 * IMethodOptions.constraints  
	 */	
	public class Is
	{
		/**
		 * Removes validation on the argument 
		 * @return An Anything constraint
		 * @see Anything
		 */
		public static function anything() : AbstractConstraint
		{
			return new Anything();
		}
		
		/**
		 * Specifies that the argument must equal the value provided
		 * @param value The value to compare the argument to 
		 * @return An Equal constraint
		 * @see Equal
		 */
		public static function equal(value : Object) : AbstractConstraint
		{
			return new Equal(value);
		}
		
		/**
		 * Specifies that the argument must be greater than the value provided
		 * @param value The value to compare the argument to 
		 * @return A ComparingConstraint
		 * @see ComparingConstraint
		 */
		public static function greaterThan(value : Object) : AbstractConstraint
		{
			return new ComparingConstraint(value, true, false);
		}
		
		/**
		 * Specifies that the argument must be greater than or equal to the value provided
		 * @param value The value to compare the argument to 
		 * @return A ComparingConstraint
		 * @see ComparingConstraint
		 */
		public static function greaterThanOrEqual(value : Object) : AbstractConstraint
		{
			return new ComparingConstraint(value, true, true);
		}
		
		/**
		 * Specifies that the argument must be less than the value provided
		 * @param value The value to compare the argument to 
		 * @return A ComparingConstraint
		 * @see ComparingConstraint
		 */
		public static function lessThan(value : Object) : AbstractConstraint
		{
			return new ComparingConstraint(value, false, false);
		}
		
		/**
		 * Specifies that the argument must be less than or equal to the value provided
		 * @param value The value to compare the argument to 
		 * @return A ComparingConstraint
		 * @see ComparingConstraint
		 */
		public static function lessThanOrEqual(value : Object) : AbstractConstraint
		{
			return new ComparingConstraint(value, false, true);
		}
		
		/**
		 * Specifies a predicate function that will determine whether the 
		 * argument is valid at runtime.
		 * @param func The predicate that will accept the argument and return a Boolean  
		 * (true if the argument is valid; false otherwise)
		 * @return A PredicateConstraint
		 * @see PredicateConstraint
		 */
		public static function matching(func : Function) : AbstractConstraint
		{
			return new PredicateConstraint(func);
		}
		
		/**
		 * Specifies that the argument must not equal the value provided
		 * @param value The value to compare the argument to 
		 * @return A negated Equal constraint
		 * @see Not
		 * @see Equal
		 */
		public static function notEqual(value : Object) : AbstractConstraint
		{
			return new Not(new Equal(value));
		}
		
		/**
		 * Specifies that the argument must not be null
		 * @param value The value to compare the argument to 
		 * @return A negated Equal constraint
		 * @see Not
		 * @see Equal
		 */
		public static function notNull() : AbstractConstraint
		{
			return new Not(new Equal(null));
		}
		
		/**
		 * Specifies that the argument must not be the same object as the value provided. 
		 * The values are compared for object instances, not value.
		 * @param value The value to compare the argument to 
		 * @return A negated Same constraint
		 * @see Not
		 * @see Same
		 */
		public static function notSame(obj : Object) : AbstractConstraint
		{
			return new Not(new Same(obj));
		}
		
		/**
		 * Specifies that the argument must be null
		 * @param value The value to compare the argument to 
		 * @return An Equal constraint
		 * @see Equal
		 */
		public static function isNull() : AbstractConstraint
		{
			return new Equal(null);
		}
		
		/**
		 * Specifies that the argument must be the same object as the value provided. 
		 * The values are compared for object instances, not value.
		 * @param value The value to compare the argument to 
		 * @return A Same constraint
		 * @see Same
		 */
		public static function same(value : Object) : AbstractConstraint
		{
			return new Same(value);
		}
		
		/**
		 * Specifies that the argument must be, inherit from, or implement 
		 * the class provided
		 * @param value The type (Class or Interface) 
		 * @return A TypeOf constraint
		 * @see TypeOf
		 */
		public static function typeOf(cls : Class) : AbstractConstraint
		{
			return new TypeOf(cls);
		}
		
		/**
		 * Specifies that the argument be constrained by ALL the 
		 * constraints provided.
		 * @param value An array of AbstractConstraint objects 
		 * @return An And constraint
		 * @see And
		 */
		public static function all(constraints : Array) : AbstractConstraint	
		{
			return new And(constraints);
		}
		
		/**
		 * Specifies that the argument be constrained by ANY the 
		 * constraints provided.
		 * @param value An array of AbstractConstraint objects 
		 * @return An Or constraint
		 * @see Or
		 */
		public static function any(constraints : Array) : AbstractConstraint	
		{
			return new Or(constraints);
		}
	}
}