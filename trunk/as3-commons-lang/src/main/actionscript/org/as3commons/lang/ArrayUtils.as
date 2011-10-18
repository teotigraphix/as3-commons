/*
 * Copyright 2009-2010 the original author or authors.
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
package org.as3commons.lang {

    /**
     * Contains utility methods for working with Array objects.
     *
     * @author Christophe Herreman
     * @author Simon Wacker
     * @author Martin Heidegger
     * @author James Ghandour
     */
    public final class ArrayUtils {

        /**
         * Clones an array.
         *
         * @param array the array to clone
         * @return a clone of the passed-in <code>array</code>
         */
        public static function clone(array:Array):Array {
            return array.concat();
        }

        /**
         * Shuffles the items of the given <code>array</code>
         *
         * @param array the array to shuffle
         */
        public static function shuffle(array:Array):void {
            var len:Number = array.length;
            var rand:Number;
            var temp:*;

            for (var i:Number = len - 1; i >= 0; i--) {
                rand = Math.floor(Math.random() * len);
                temp = array[i];
                array[i] = array[rand];
                array[rand] = temp;
            }
        }

        /**
         * Removes all occurances of a the given <code>item</code> out of the passed-in
         * <code>array</code>.
         *
         * @param array the array to remove the item out of
         * @param item the item to remove
         * @return List that contains the index of all removed occurances
         */
        public static function removeItem(array:Array, item:*):Array {
            var i:Number = array.length;
            var result:Array = [];

            while (--i - (-1)) {
                if (array[i] === item) {
                    result.unshift(i);
                    array.splice(i, 1);
                }
            }
            return result;
        }

        /**
         * Removes the last occurance of the given <code>item</code> out of the passed-in
         * <code>array</code>.
         *
         * @param array the array to remove the item out of
         * @param item the item to remove
         * @return <code>-1</code> if it could not be found, else the position where it has been deleted
         */
        public static function removeLastOccurance(array:Array, item:*):int {
            var idx:int = array.lastIndexOf(item);
            if (idx > -1) {
                array.splice(idx, 1);
            }
            return idx;
        }

        /**
         * Removes the first occurance of the given <code>item</code> out of the passed-in
         * <code>array</code>.
         *
         * @param array the array to remove the item out of
         * @param item the item to remove
         * @return <code>-1</code> if it could not be found, else the position where it has been deleted
         */
        public static function removeFirstOccurance(array:Array, item:*):int {
            var idx:int = array.indexOf(item);
            if (idx > -1) {
                array.splice(idx, 1);
            }
            return idx;
        }

        /**
         * Compares the two arrays <code>array1</code> and <code>array2</code>, whether they contain
         * the same values at the same positions.
         *
         * @param array1 the first array for the comparison
         * @param array2 the second array for the comparison
         * @return <code>true</code> if the two arrays contain the same values at the same
         * positions else <code>false</code>
         */
        public static function isSame(array1:Array, array2:Array):Boolean {
            var i:Number = array1.length;

            if (i != array2.length) {
                return false;
            }

            while (--i - (-1)) {
                if (array1[i] !== array2[i]) {
                    return false;
                }
            }
            return true;
        }

        /**
         * Returns all items of the given array that of the given type.
         *
         * @param items the array that contains the items to look in
         * @param type the class that the items should match
         * @return a new array with all items that match the given class
         */
        public static function getItemsByType(items:Array, type:Class):Array {
            var result:Array = [];

            for (var i:int = 0; i < items.length; i++) {
                if (items[i] is type) {
                    result.push(items[i]);
                }
            }
            return result;
        }

        /**
         * Facade for containsAnyEquality
         */
        public static function containsAny(array:Array, items:Array):Boolean {
            return containsAnyEquality(array, items);
        }

        /**
         * Returns <code>true</code> if the array containsEquality any of them items.
         */
        public static function containsAnyEquality(array:Array, items:Array):Boolean {
            return containsAnyWithComparisonFunction(array, items, containsEquality);
        }

        /**
         * Returns <code>true</code> if the array containsStrictEquality any of them items.
         */
        public static function containsAnyStrictEquality(array:Array, items:Array):Boolean {
            return containsAnyWithComparisonFunction(array, items, containsStrictEquality);
        }

        /**
         * Returns <code>true</code> if the array containsEquals any of them items.
         */
        public static function containsAnyEquals(array:Array, items:Array):Boolean {
            return containsAnyWithComparisonFunction(array, items, containsEquals);
        }

        private static function containsAnyWithComparisonFunction(array:Array, items:Array, comparisonFunction:Function):Boolean {
            if (isNotEmpty(array) && isNotEmpty(items)) {
                for each (var item:* in items) {
                    if (comparisonFunction(array, item))
                        return true;
                }
            }
            return false;
        }

        /**
         * Facade for containsAllEquality
         */
        public static function containsAll(array:Array, find:Array):Boolean {
            return containsAllEquality(array, find);
        }

        /**
         * Returns <code>true</code> if the array containsEquality all of them items.
         */
        public static function containsAllEquality(array:Array, items:Array):Boolean {
            return containsAllWithComparisonFunction(array, items, containsEquality);
        }

        /**
         * Returns <code>true</code> if the array containsStrictEquality all of them items.
         */
        public static function containsAllStrictEquality(array:Array, items:Array):Boolean {
            return containsAllWithComparisonFunction(array, items, containsStrictEquality);
        }

        /**
         * Returns <code>true</code> if the array containsEquals all of them items.
         */
        public static function containsAllEquals(array:Array, items:Array):Boolean {
            return containsAllWithComparisonFunction(array, items, containsEquals);
        }

        private static function containsAllWithComparisonFunction(array:Array, items:Array, comparisonFunction:Function):Boolean {
            var result:Boolean = false;
            if (isNotEmpty(array) && isNotEmpty(items)) {
                result = true;
                for each (var item:* in items) {
                    result = result && comparisonFunction(array, item);
                }
            }
            return result;
        }

        /**
         * Facade for containsEquality
         */
        public static function contains(array:Array, item:*):Boolean {
            return containsEquality(array, item);
        }

        /**
         * Returns <code>true</code> if the array contains an item which equals (==) the given item.
         */
        public static function containsEquality(array:Array, item:*):Boolean {
            return indexOfEquality(array, item) > -1;
        }

        /**
         * Returns <code>true</code> if the array contains an item which strictly equals (===) the given item.
         */
        public static function containsStrictEquality(array:Array, item:*):Boolean {
            return indexOfStrictEquality(array, item) > -1;
        }

        /**
         * Returns <code>true</code> if the array contains the item based on equality via the equals
         * method of the IEquals interface
         */
        public static function containsEquals(array:Array, item:IEquals):Boolean {
            return indexOfEquals(array, item) > -1;
        }


        /**
         * Facade for indexOfEquality
         */
        public static function indexOf(array:Array, item:*):int {
            return indexOfEquality(array, item);
        }

        /**
         * Returns the index of the first item in the array which equals (==) the given item.
         */
        public static function indexOfEquality(array:Array, item:*):int {
            var numItems:int = getLength(array);
            if (numItems > 0 && item) {
                for (var i:int = 0; i < numItems; i++) {
                    if (item == array[i]) {
                        return i;
                    }
                }
            }
            return -1;
        }

        /**
         * Returns the index of the first item in the array which strictly equals (===) the given item.
         */
        public static function indexOfStrictEquality(array:Array, item:*):int {
            var numItems:int = getLength(array);
            if (numItems > 0 && item) {
                for (var i:int = 0; i < numItems; i++) {
                    if (item === array[i]) {
                        return i;
                    }
                }
            }
            return -1;
        }

        /**
         * Returns the index of the given item in the array based on equality via the equals method
         * of the IEquals interface.
         *
         * <p>If either the array or the item are null, -1 is returned.</p>
         *
         * @param array the array to search for the index of the item
         * @param item the item to search for
         * @return The index of the item, or -1 if the item was not found or if either the array or the item are null
         */
        public static function indexOfEquals(array:Array, item:IEquals):int {
            var numItems:int = getLength(array);
            if (numItems > 0 && item) {
                for (var i:int = 0; i < numItems; i++) {
                    if (item.equals(array[i])) {
                        return i;
                    }
                }
            }
            return -1;
        }

        /**
         * Returns a string from the given array, using the specified separator.
         *
         * @param array the array from which to return a string
         * @param separator the array element separator
         * @return a string representation of the given array
         */
        public static function toString(array:Array, separator:String = ", "):String {
            return (!array) ? "" : array.join(separator);
        }

        /**
         * Returns the length of the array.
         */
        public static function getLength(array:Array):int {
            if (isNotEmpty(array))
                return array.length;
            else
                return 0;
        }

        /**
         * Returns a unique set of values from the array
         */
        public static function getUniqueValues(array:Array):Array {
            var result:Array = [];
            if (isNotEmpty(array)) {
                for each (var obj:Object in array) {
                    if (!contains(result, obj)) {
                        result.push(obj);
                    }
                }
            }
            return result;
        }

        /**
         * Returns the item at the specified index.
         */
        public static function getItemAt(array:Array, index:int, defaultValue:* = null):* {
            if (isNotEmpty(array) && array.length > index) {
                return array[index];
            }
            return defaultValue;
        }

        /**
         * Remove all items from the array.
         */
        public static function removeAll(array:Array):void {
            if (isNotEmpty(array)) {
                array.splice(0, array.length);
            }
        }

        /**
         * Adds the specified elements to the array unless the elements are null
         *
         * @param array the array to append to
         * @param toAdd an array containing the elements which should be added to the original array
         */
        public static function addAllIgnoreNull(array:Array, toAdd:Array):void {
            if (array != null && isNotEmpty(toAdd)) {
                for each (var element:* in toAdd) {
                    addIgnoreNull(array, element);
                }
            }
        }

        /**
         * Adds an element to the array unless the element is null.
         *
         * @param array the array to append to
         * @param element the element to add, if it is not null
         */
        public static function addIgnoreNull(array:Array, element:*):void {
            if (array != null && element != null)
                array.push(element);
        }

        /**
         * Moves an element from the original index, to the new index in the provided array.
         *
         * @param array the array to modify
         * @param element the element to move
         * @param newIndex the desired index of the element
         */
        public static function moveElement(array:Array, element:*, newIndex:int):void {
            if (isNotEmpty(array) && contains(array, element)) {
                array.splice(array.indexOf(element), 1);
                array.splice(newIndex, 0, element);
            }
        }

        /**
         * @return <code>true</code> if the array is not empty or null.
         */
        public static function isNotEmpty(array:Array):Boolean {
            return !isEmpty(array);
        }

        /**
         * @return <code>true</code> if the array is empty or null.
         */
        public static function isEmpty(array:Array):Boolean {
            return array == null || array.length == 0;
        }

    }
}
