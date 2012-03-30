package org.as3commons.swc {

	/**
	 * Represents a component defined in a SWC catalog.
	 *
	 * @author Christophe Herreman
	 */
	public class SWCComponent {

		private var _className:String;
		private var _name:String;
		private var _uri:String;

		// --------------------------------------------------------------------
		//
		// Constructor
		//
		// --------------------------------------------------------------------

		public function SWCComponent(className:String, name:String, uri:String) {
			_className = className;
			_name = name;
			_uri = uri;
		}

		// --------------------------------------------------------------------
		//
		// Properties
		//
		// --------------------------------------------------------------------

		public function get className():String {
			return _className;
		}

		public function get name():String {
			return _name;
		}

		public function get uri():String {
			return _uri;
		}
	}
}
