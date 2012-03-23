/*
 * Copyright 2007-2012 the original author or authors.
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
package org.as3commons.aop.factory.util {
	import flash.display.LoaderInfo;

	import org.as3commons.aop.as3commons_aop;
	import org.as3commons.lang.ClassNotFoundError;
	import org.as3commons.lang.ClassUtils;

	use namespace as3commons_aop;

	/**
	 * Utilities for the proxy factory.
	 *
	 * @author Christophe Herreman
	 */
	public class ProxyFactoryUtil {

		private static const MX_CORE_FLEXGLOBALS:String = "mx.core::FlexGlobals";
		private static const MX_CORE_APPLICATION:String = "mx.core::Application";

		// --------------------------------------------------------------------
		//
		// Public Static Methods
		//
		// --------------------------------------------------------------------

		/**
		 * Returns the loader info by determining whether the application is a
		 * Flex 4 or Flex 3 application. If this is not a flex application and
		 * the loader info can hence not be fetched, an error is thrown.
		 * @return
		 */
		public static function getLoaderInfo():LoaderInfo {
			if (isFlex4()) {
				return loaderInfoFromFlex4();
			} else if (isFlex3()) {
				return loaderInfoFromFlex3();
			}
			throw new Error("LoaderInfo could not be determined.");
		}

		// --------------------------------------------------------------------
		//
		// Private Static Methods
		//
		// --------------------------------------------------------------------

		private static function isFlex4():Boolean {
			try {
				ClassUtils.forName(MX_CORE_FLEXGLOBALS);
				return true;
			} catch (e:ClassNotFoundError) {
			}
			return false;
		}

		private static function loaderInfoFromFlex4():LoaderInfo {
			var flexGlobalsClass:Class = ClassUtils.forName(MX_CORE_FLEXGLOBALS);
			return flexGlobalsClass.topLevelApplication.systemManager.stage.loaderInfo;
		}

		private static function isFlex3():Boolean {
			try {
				ClassUtils.forName(MX_CORE_APPLICATION);
				return true;
			} catch (e:ClassNotFoundError) {
			}
			return false;
		}

		private static function loaderInfoFromFlex3():LoaderInfo {
			var applicationClass:Class = ClassUtils.forName(MX_CORE_APPLICATION);
			return applicationClass.application.systemManager.stage.loaderInfo;
		}

		// --------------------------------------------------------------------
		//
		// Constructor
		//
		// --------------------------------------------------------------------

		public function ProxyFactoryUtil() {
		}


	}
}
