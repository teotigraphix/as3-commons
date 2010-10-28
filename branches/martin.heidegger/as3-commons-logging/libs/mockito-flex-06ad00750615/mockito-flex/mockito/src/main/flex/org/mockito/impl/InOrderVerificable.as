package org.mockito.impl
{
import org.mockito.api.MethodSelector;
import org.mockito.api.MockVerificable;
import org.mockito.api.OrderedVerificable;

public class InOrderVerificable implements OrderedVerificable
{
    private var verificable:MockVerificable;

    public function InOrderVerificable(mockVerifier:MockVerificable)
    {
        this.verificable = mockVerifier;
    }

    public function verify():MethodSelector
    {
        return verificable.verify(new InOrder());
    }
}
}