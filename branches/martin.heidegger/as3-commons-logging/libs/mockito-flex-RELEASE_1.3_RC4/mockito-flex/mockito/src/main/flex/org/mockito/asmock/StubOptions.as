package org.mockito.asmock
{
	/**
	 * Specifies which, if any, parts of a class should be automatically stubbed upon creation
	 */	
	public class StubOptions
	{
		private var _stubProperties : Boolean;
		private var _stubEvents : Boolean;
		
		public function StubOptions(stubProperties : Boolean, stubEvents : Boolean)
		{
			this._stubProperties = stubProperties;
			this._stubEvents = stubEvents;
		}
		
		/**
		 * Specifies whether properties should be stubbed.
		 * @return true if properties should be stubbed; false otherwise
		 */
		public function get stubProperties() : Boolean
		{
			return _stubProperties;
		}
		
		/**
		 * Specifies whether events should be stubbed.
		 * @return true if events should be stubbed; false otherwise
		 */
		public function get stubEvents() : Boolean
		{
			return _stubEvents;
		}
		
		/**
		 * Specifies that both properties and events should be stubbed  
		 */		
		public static function get ALL() : StubOptions 
		{
			return new StubOptions(true, true);
		}
		
		/**
		 * Specifies that only properties should be stubbed  
		 */
		public static function get PROPERTIES() : StubOptions 
		{
			return new StubOptions(true, false);
		} 
		
		/**
		 * Specifies that only events should be stubbed.
		 */
		public static function get EVENTS() : StubOptions 
		{
			return new StubOptions(false, true);
		}
		
		/**
		 * Specifies that neither properties nor events should be stubbed  
		 */
		public static function get NONE() : StubOptions 
		{
			return new StubOptions(false, false);
		}
	}
}