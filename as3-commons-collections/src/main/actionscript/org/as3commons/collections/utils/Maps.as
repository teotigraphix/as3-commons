package org.as3commons.collections.utils {
	import org.as3commons.collections.framework.IMap;
	/**
	 * <p>A set of common utilities for working with IMap implementations.</p>
	 * 
	 * @author John Reeves
	 */
	public class Maps {
		/**
		 * <p>Attempts to retrieve the item mapped to the supplied key.  If the supplied key is not mapped an 
		 * ArgumentError will be thrown.</p>
		 *
		 * @param map the IMap instance to operate on. 
		 * @param key the key to perform the lookup using.
		 * @param errorMessage optional error message which will be used if an Error needs to be thrown.
		 * @return the item mapped to the supplied key.
		 * @throws ArgumentError if no mapping exists for the supplied key.
		 */
		public static function itemOrError(map : IMap, key : *, errorMessage : String = null) : * {
			if (!map.hasKey(key)) {
				throw new ArgumentError(errorMessage || key + " does not exist in supplied map");
			}
			return map.itemFor(key);
		}
		
		/**
		 * <p>Attempts to retrieve the item mapped to the supplied key.  If the supplied key is not mapped then the
		 * supplied default value will be returned instead.</p>
		 * 
		 * @param map the IMap instance to operate on.
		 * @param key the key to perform the lookup using.
		 * @param defaultValue the value to return if the supplied key does not exist in the supplied Map.
		 * @return if the supplied key exists in the map then the value mapped to that key will be  returned, otherwise 
		 * the supplied defaultValue will be returned instead. 
		 */
		public static function itemOrValue(map : IMap, key : *, defaultValue : *) : * {
			if (!map.hasKey(key)) {
				return defaultValue;
			}
			return map.itemFor(key);
		}
		
		/**
		 * <p>Attempts to retrieve the item mapped to the supplied key.  If the supplied key is not mapped then the
		 * supplied value will mapped to the key and returned.</p>
		 * 
		 * @param map the IMap instance to operate on.
		 * @param key the key to perform the lookup using.
		 * @param item	if no mapping exists for the supplied key a new mapping will be added between the key and 
		 * this value.
		 * @return if a prior mapping exists for the supplied key then the assosiated value in the map will be 
		 * returned; if no prior mapping exists the supplied value will be returned instead. 
		 */
		public static function itemOrAdd(map : IMap, key : *, item : *) : * {
			if (!map.hasKey(key)) {
				map.add(key, item);
			}
			return map.itemFor(key);
		}
		
		/**
		 * <p>Filters the supplied IMap instance returning a new IMap of the same type which only contains  
		 * mappings where the key meets the supplied predicate.<p>
		 * 
		 * @param map the IMap instance to operate on.
		 * @param predicate	Function which will be be applied to each key in the supplied map.  This function should expect 
		 * a single argument (the key) and return a Boolean value, true if the key should exist in the returned Map instance
		 * or false if it should not be included in the returned Map.
		 * @return a new Map instance consisting only of mappings where the key met the supplied predicate.
		 */
		public static function filterKeys(map : IMap, predicate : Function) : IMap {
			const result : IMap = new ((map as Object).constructor) as IMap;
			for each (var key : * in map.keysToArray()) {
				if (predicate(key)) {
					result.add(key, map.itemFor(key));
				}
			}
			return result;
		}
	}
}
