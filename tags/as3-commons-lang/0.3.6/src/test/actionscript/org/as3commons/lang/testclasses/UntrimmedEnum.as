package org.as3commons.lang.testclasses {

import org.as3commons.lang.Enum;

public class UntrimmedEnum extends Enum {

    public function UntrimmedEnum(name:String) { super(name); }

    public static function get values():Array { return Enum.getValues(UntrimmedEnum); }

    public static const NONE:UntrimmedEnum = new UntrimmedEnum("NONE");
    public static const POST:UntrimmedEnum = new UntrimmedEnum("POST ");
    public static const PRE:UntrimmedEnum = new UntrimmedEnum(" PRE");
    public static const BOTH:UntrimmedEnum = new UntrimmedEnum(" BOTH ");
}
}
