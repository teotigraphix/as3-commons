package org.mockito.impl
{
public class AsmockMethodNameFormatter
{
    public function AsmockMethodNameFormatter()
    {
    }

    public function extractFunctionName(fullName:String):String
    {
        try
        {
            var index:int = fullName.indexOf('/');
            if (index >= 0)
            {
                fullName = fullName.substr(index + 1);
                if (isGetOrSet(fullName))
                    fullName = reformatGetterOrSetter(fullName);
            }
        } catch (e:Error)
        {
        }
        return fullName;
    }

    public function reformatGetterOrSetter(fullName:String):String
    {
        var index:int = fullName.lastIndexOf("/");
        var getSet:String = fullName.substring(index + 1);
        return getSet + " " + fullName.substring(0, index - 1);
    }

    public function isGetOrSet(fullName:String):Boolean
    {
        return fullName.lastIndexOf("/get") != -1 || fullName.lastIndexOf("/set") != -1;
    }

}
}