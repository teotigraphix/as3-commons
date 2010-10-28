package org.mockito.api
{
    public interface SequenceNumberTracker
    {
        function set sequenceNumber(sequenceNumber:int):void;

        function get sequenceNumber():int;
    }
}