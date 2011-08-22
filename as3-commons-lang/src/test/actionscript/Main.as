package 
{
	import org.as3commons.lang.builder.ToStringBuilderTest;
	import org.as3commons.lang.builder.EqualsBuilderTest;
	import org.as3commons.lang.ArrayUtilsTest;
	import org.as3commons.lang.XMLUtilsTest;
	import org.as3commons.lang.HashArrayTest;
	import org.as3commons.lang.DictionaryUtilsTest;
	import org.as3commons.lang.DateUtilsTest;
	import org.as3commons.lang.StringUtilsTest;
	import org.as3commons.lang.ObjectUtilsTest;
	import org.as3commons.lang.ClassUtilsTest;
	import org.as3commons.lang.EnumTest;
	import org.flexunit.internals.TraceListener;
	import org.flexunit.runner.FlexUnitCore;

	import flash.display.Sprite;

	public class Main extends Sprite
	{
		public function Main()
		{
			var core: FlexUnitCore = new FlexUnitCore();
			core.addListener( new TraceListener() );
			core.run( [
				new StringUtilsTest(),
				new DateUtilsTest(),
				new DictionaryUtilsTest(),
				new HashArrayTest(),
				new XMLUtilsTest(),
				new ArrayUtilsTest(),
				new EqualsBuilderTest(),
				new ToStringBuilderTest(),
				new ObjectUtilsTest(),
				new ClassUtilsTest(),
				new EnumTest(),
			]);
		}
	}
}
