/*
 * Copyright 2007-2010 the original author or authors.
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
package org.as3commons.bytecode.tags.struct {
	import org.as3commons.bytecode.abc.enum.BaseEnum;

	public final class FillStyleType extends BaseEnum {

		private static var _enumCreated:Boolean = false;

		public static const SOLID_FILL:FillStyleType = new FillStyleType(0x00);
		public static const LINEAR_GRADIENT_FILL:FillStyleType = new FillStyleType(0x10);
		public static const RADIAL_GRADIENT_FILL:FillStyleType = new FillStyleType(0x12);
		public static const FOCAL_RADIAL_GRADIENT_FILL:FillStyleType = new FillStyleType(0x13);
		public static const REPEATING_BITMAP_FILL:FillStyleType = new FillStyleType(0x40);
		public static const CLIPPED_BITMAP_FILL:FillStyleType = new FillStyleType(0x41);
		public static const NONSMOOTHED_REPEATING_BITMAP:FillStyleType = new FillStyleType(0x42);
		public static const NONSMOOTHED_CLIPPED_BITMAP:FillStyleType = new FillStyleType(0x43);

		{
			_enumCreated = true;
		}

		public function FillStyleType(value:uint) {
			super(value);
		}

		public static function fromValue(fillStyleTypeValue:uint):FillStyleType {
			var fillStyleType:FillStyleType = items[fillStyleTypeValue];
			if (fillStyleType == null) {
				throw new Error("Unable to match FillStyleType to " + fillStyleTypeValue);
			}
			return fillStyleType;
		}

	}
}