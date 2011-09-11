package perf {
	/**
	 * @author mh
	 */
	public interface IPerformance {
		function simple(count:int): Number;
		function nullLogger(count:int):Number;
		function get name(): String;
	}
}
