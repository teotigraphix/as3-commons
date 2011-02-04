package org.mockito.impl
{
import org.mockito.api.MockitoVerificationError;

public class InvocationsNotInOrder extends MockitoVerificationError
{
    public function InvocationsNotInOrder(message:String="Invocation not in order", id:int=0)
    {
        super(message, id);
    }
}
}