/*
 * Copyright (c) 2009 the original author or authors
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */
package org.as3commons.lang.builder {
	
	import org.as3commons.lang.StringBuffer;
	
	/**
	 *
	 * @author Christophe Herreman
	 */
	public class ToStringBuilder {
		
		public static var defaultStyle:ToStringStyle = ToStringStyle.DEFAULT_STYLE;
		
		private var _object:Object;
		
		private var _style:ToStringStyle;
		
		private var _stringBuffer:StringBuffer;
		
		/**
		 * Creates a new ToStringBuilder.
		 *
		 * @param object the object for which to build a "toString"
		 * @param style the ToStringStyle
		 */
		public function ToStringBuilder(object:Object, style:ToStringStyle = null) {
			_object = object;
			_style = (style ? style : defaultStyle);
			_stringBuffer = new StringBuffer();
			
			_style.appendBegin(_stringBuffer, _object);
		}
		
		/**
		 *
		 */
		public function append(value:Object, fieldName:String = null):ToStringBuilder {
			_style.append(_stringBuffer, _object, value, fieldName);
			
			return this;
		}
		
		/**
		 *
		 */
		public function toString():String {
			_style.appendEnd(_stringBuffer);
			return _stringBuffer.toString();
		}
	}
}