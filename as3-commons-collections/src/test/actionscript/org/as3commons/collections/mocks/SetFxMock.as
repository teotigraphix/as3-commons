package org.as3commons.collections.mocks {
	import org.as3commons.collections.fx.SetFx;
	import org.as3commons.collections.units.ITestCollection;

	/**
	 * @author jes 26.03.2010
	 */
	public class SetFxMock extends SetFx implements
		ITestCollection
	{
		public function SetFxMock() {
			super();
		}
		
		public function addMock(item : *) : void {
			add(item);
		}
	}
}
