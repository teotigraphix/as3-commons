package org.as3commons.collections.mocks {
	import org.as3commons.collections.fx.MapFx;
	import org.as3commons.collections.testhelpers.UniqueMapKey;
	import org.as3commons.collections.units.ITestDuplicates;

	/**
	 * @author jes 29.03.2010
	 */
	public class MapFxMock extends MapFx implements
		ITestDuplicates
	{

		public function addMock(item : *) : void {
			add(UniqueMapKey.key, item);
		}

	}
}
