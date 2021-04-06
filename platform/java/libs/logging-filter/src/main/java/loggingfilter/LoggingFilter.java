package loggingfilter;

import com.sun.net.httpserver.Filter;
import com.sun.net.httpserver.HttpExchange;
import lombok.Builder;
import lombok.Value;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.IOException;

public class LoggingFilter extends Filter {

    private static final Logger LOGGER = LoggerFactory.getLogger(LoggingFilter.class);

    @Override
    public void doFilter(HttpExchange exchange, Chain chain) throws IOException {
        System.out.println(exchange.getRequestHeaders().entrySet());
        chain.doFilter(exchange);
    }

    @Override
    public String description() {
        return "log requests";
    }

    @Value
    @Builder
    static class TempDto {
        String name;
    }
}
