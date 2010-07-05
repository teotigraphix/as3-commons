package org.mockito.impl
{
import org.mockito.api.Invocation;
import org.mockito.api.Invocations;
import org.mockito.api.Verifier;

public class InOrder implements Verifier
{
    public function InOrder()
    {
    }

    public function verify(wanted:Invocation, invocations:Invocations):void
    {
        var foundSequence:int = invocations.getSequenceNumberForFirstMatching(wanted, invocations.sequenceNumber);
        if (invocations.sequenceNumber > foundSequence || foundSequence < 0)
            throw new InvocationsNotInOrder("Invocation " + wanted.describe() + " not in order.");
        invocations.sequenceNumber = foundSequence;
    }
}
}