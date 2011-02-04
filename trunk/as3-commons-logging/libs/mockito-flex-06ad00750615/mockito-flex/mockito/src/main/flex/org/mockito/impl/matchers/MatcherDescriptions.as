package org.mockito.impl.matchers
{
import org.mockito.api.Matcher;

public class MatcherDescriptions
{
    public function MatcherDescriptions()
    {
    }

    public static function matchClasses(matcher:Matcher, expected:*):String
    {
        return "anyOf(" + expected  + ")";
    }

    public static function eq(matcher:Matcher, expected:*):String
    {
        return "eq(" + expected + ")";
    }
}
}