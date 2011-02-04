package org.mockito.impl.matchers
{
    import org.mockito.api.Matcher;

    public class PropertyMatcher implements Matcher
    {
        protected var propertyChain:Array;

        protected var expectedPropertyValue:Object;

        public function PropertyMatcher(propertyChain:Object, expectedPropertyValue:Object)
        {
            super();
            this.propertyChain = propertyChain is Array ? propertyChain as Array : [propertyChain];
            this.expectedPropertyValue = expectedPropertyValue;
        }

        public function matches(actual:*):Boolean
        {
            var actualPropertyValue:Object = actual;
            for each (var propertyName:String in propertyChain)
            {
                actualPropertyValue = actualPropertyValue[propertyName];
            }
            return MatcherFunctions.eqFunction(expectedPropertyValue, actualPropertyValue);
        }

        public function describe():String
        {
            return propertyChain.join(".") + "=" + expectedPropertyValue;
        }
    }
}