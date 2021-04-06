package loggingfilter;

import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertNotNull;

public class LoggingFilterTest {

    @Test
    public void should_do_something() {
        LoggingFilter.TempDto v = LoggingFilter.TempDto.builder().name("test").build();
        assertNotNull(v);
    }
}
