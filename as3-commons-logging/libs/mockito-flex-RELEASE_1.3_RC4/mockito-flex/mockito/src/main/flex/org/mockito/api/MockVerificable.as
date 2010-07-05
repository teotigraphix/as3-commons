package org.mockito.api
{
public interface MockVerificable
{
    /**
     * A starter function for verification of executions
     * If you dont specify the verifier, an equivalent of times(1) is used.
     * @param verifier object responsible for verification of the following execution
     */
    function verify(verifier:Verifier=null):MethodSelector;
}
}