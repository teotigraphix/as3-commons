/**
 * Copyright 2009 Maxim Cassian Porges
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package org.as3commons.bytecode.swf {
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.utils.ByteArray;
	import flash.utils.Endian;

	import org.as3commons.bytecode.abc.AbcFile;
	import org.as3commons.bytecode.util.AbcSerializer;

	/**
	 * Dispatched when the class loader has finished loading the SWF/ABC bytecode in the Flash Player/AVM.
	 * @eventType flash.events.Event.COMPLETE
	 */
	[Event(name="complete", type="flash.events.Event")]
	/**
	 * Dispatched when the class loader has encountered an IO related error.
	 * @eventType flash.events.IOErrorEvent.IO_ERROR
	 */
	[Event(name="ioError", type="flash.events.IOErrorEvent")]
	/**
	 * Dispatched when the class loader has encountered a SWF verification error.
	 * @eventType flash.events.IOErrorEvent.VERIFY_ERROR
	 */
	[Event(name="verifyError", type="flash.events.IOErrorEvent")]

	/**
	 * Classloader for ABC files, adapted from the EvalES4UI project (specifically, the <code>com.hurlant.eval.ByteLoader</code> class).
	 * <p>
	 * This class provides just enough of a SWF wrapper for an ABC file to be loaded in to the Flash Player/AVM.
	 * </p>
	 * @see http://eval.hurlant.com/
	 */
	public class AbcClassLoader extends EventDispatcher {
		private static const SWF_HEADER:Array = [0x46, 0x57, 0x53, 0x10, // FWS, Version 10
			0xff, 0xff, 0xff, 0xff, // File length
			0x78, 0x00, 0x03, 0xe8, 0x00, 0x00, 0x0b, 0xb8, 0x00, // size [Rect 0 0 8000 6000]
			0x00, 0x0c, 0x01, 0x00, // 16bit le frame rate 12, 16bit be frame count 1
			0x44, 0x11, // Tag type=69 (FileAttributes), length=4
			0x08, 0x00, 0x00, 0x00];

		private static const ABC_HEADER:Array = [0x3f, 0x12]; // Tag type=72 (DoABC), length=next.]

		private static var SWF_FOOTER:Array = [0x40, 0x00]; // Tag type=1 (ShowFrame), length=0

		private static var ALLOW_BYTECODE_PROPERTY_NAME:String = "allowLoadBytesCodeExecution";

		private var _loader:Loader;

		/**
		 * Creates a new <code>AbcClassLoader</code> instance.
		 */
		public function AbcClassLoader() {
			super();
			initAbcLoader();
		}

		/**
		 * Initializes the current <code>AbcClassLoader</code>.
		 */
		protected function initAbcLoader():void {
			_loader = new Loader();
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, function(event:Event):void {
				dispatchEvent(event);
			});
			_loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, function(event:Event):void {
				dispatchEvent(event);
			});
			_loader.contentLoaderInfo.addEventListener(IOErrorEvent.VERIFY_ERROR, function(event:Event):void {
				dispatchEvent(event);
			});
		}

		/**
		 * Wraps the ABC bytecode inside the simplest possible SWF file, for the purpose of allowing the player
		 * VM to load it.
		 *
		 * @param   bytes an array or ABC bytecode blocks
		 * @return  a byte array containing the contents of a valid SWF file ready for loading in to the Flash Player
		 *
		 */
		public function wrapBytecodeInSWF(arrayOfAbcByteCodeBlocks:Array):ByteArray {
			var outputStream:ByteArray = new ByteArray();
			outputStream.endian = Endian.LITTLE_ENDIAN;

			for each (var swfHeaderByte:int in SWF_HEADER) {
				outputStream.writeByte(swfHeaderByte);
			}

			for each (var abcByteCodeBlock:ByteArray in arrayOfAbcByteCodeBlocks) {
				for each (var abcHeaderByte:int in ABC_HEADER) {
					outputStream.writeByte(abcHeaderByte);
				}

				// set the length of the ABC bytecode block
				outputStream.writeInt(abcByteCodeBlock.length);
				outputStream.writeBytes(abcByteCodeBlock);
			}

			for each (var swfFooterByte:int in SWF_FOOTER) {
				outputStream.writeByte(swfFooterByte);
			}

			// set the length of the total SWF
			outputStream.position = 4;
			outputStream.writeInt(outputStream.length);

			outputStream.position = 0;
			return outputStream;
		}

		/**
		 * Loads the given bytecode in to the Flash Player/AVM, using the specified <code>ApplicationDomain</code>.
		 *
		 * @param bytes Either a single SWF or an array of ByteArrays containing SWF data to load in to the VM
		 * @param applicationDomain The <code>ApplicationDomain</code> that the ABC file will be loaded into, when null, <code>ApplicationDomain.currentDomain</code> is used.
		 *
		 * @see flash.utils.ByteArray
		 * @see flash.system.ApplicationDomain
		 */
		public function loadClassDefinitionsFromBytecode(bytes:*, applicationDomain:ApplicationDomain = null):void {
			applicationDomain = (applicationDomain == null) ? ApplicationDomain.currentDomain : applicationDomain;
			var v:uint = 0;
			if (bytes is ByteArray) {
				v = getType(bytes);
			}
			if (bytes is Array || (v == 2)) {
				if (!(bytes is Array)) {
					bytes = [bytes];
				}
				bytes = wrapBytecodeInSWF(bytes);
			}
			//throw new Error("type version: " + v);

			// allowLoadBytesCodeExecution is only available in AIR, so we have to flip it dynamically
			var c:LoaderContext = new LoaderContext(false, applicationDomain, null);
			if (c.hasOwnProperty(ALLOW_BYTECODE_PROPERTY_NAME)) {
				c[ALLOW_BYTECODE_PROPERTY_NAME] = true;
			}

			_loader.loadBytes(bytes, c);
		}

		/**
		 * Loads the specified <code>AbcFile</code> into the AVM using the specified <code>ApplicationDomain</code>.
		 * @param abcFile The specified <code>AbcFile</code>.
		 * @param applicationDomain The <code>ApplicationDomain</code> that the ABC file will be loaded into, when null, <code>ApplicationDomain.currentDomain</code> is used.
		 */
		public function loadAbcFile(abcFile:AbcFile, applicationDomain:ApplicationDomain = null):void {
			loadClassDefinitionsFromBytecode(new AbcSerializer().serializeAbcFile(abcFile), applicationDomain);
		}

		/**
		 * Determines what type of data was passed in to <code>loadClassDefinitionsFromBytecode()</code>.
		 *
		 * @param data
		 * @return  a value representing the type of data. 1 means SWF, 2 means raw ABC bytecode, 4 means a compressed SWF.
		 * @see #loadClassDefinitionsFromBytecode()
		 */
		public function getType(data:ByteArray):int {
			data.endian = Endian.LITTLE_ENDIAN;

			var version:uint = data.readUnsignedInt();
			//data.position = 0;
			switch (version) {
				case 46 << 16 | 14:
				case 46 << 16 | 15:
				case 46 << 16 | 16:
					return 2;

				case 67 | 87 << 8 | 83 << 16 | 9 << 24: // SWC9
				case 67 | 87 << 8 | 83 << 16 | 8 << 24: // SWC8
				case 67 | 87 << 8 | 83 << 16 | 7 << 24: // SWC7
				case 67 | 87 << 8 | 83 << 16 | 6 << 24: // SWC6
					return 5;

				case 70 | 87 << 8 | 83 << 16 | 9 << 24: // SWC9
				case 70 | 87 << 8 | 83 << 16 | 8 << 24: // SWC8
				case 70 | 87 << 8 | 83 << 16 | 7 << 24: // SWC7
				case 70 | 87 << 8 | 83 << 16 | 6 << 24: // SWC6
				case 70 | 87 << 8 | 83 << 16 | 5 << 24: // SWC5
				case 70 | 87 << 8 | 83 << 16 | 4 << 24: // SWC4
					return 1;

				default:
					return 0;
			}
		}
	}
}