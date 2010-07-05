package org.mockito.integrations.flexunit4
{
import org.flexunit.assertThat;
import org.hamcrest.object.notNullValue;
import org.mockito.integrations.mock;

[Mock(type="org.mockito.integrations.flexunit4.NewNonPreparedMock")]
[Mock(type="org.mockito.integrations.flexunit4.NewNonPreparedMock2")]

[RunWith("org.mockito.integrations.flexunit4.MockitoClassRunner")]
public class MockPreparationWoAssignment
{
    public function MockPreparationWoAssignment()
    {
    }

    [Test]
    public function shouldPrepareMockClassWhenAnnotationAddedOnTheClassLevel():void
    {
        var mockie:NewNonPreparedMock = mock(NewNonPreparedMock);
        assertThat(mockie, notNullValue());
        
    }

    [Test]
    public function shouldPrepareMoreThanOnceClass():void
    {
        var mockie:NewNonPreparedMock2 = mock(NewNonPreparedMock2);
        assertThat(mockie, notNullValue());
    }
}
}