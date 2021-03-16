/*
 *
 */
package echobouncer;

import com.github.slamdev.openapispringgenerator.plugin.api.RequestDto;
import com.github.slamdev.openapispringgenerator.plugin.api.ResponseDto;
import com.github.slamdev.openapispringgenerator.plugin.api.TestingApi;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

import java.util.List;

@SpringBootApplication
public final class EchoBouncer implements TestingApi {

    /**
     * App entrypoint.
     *
     * @param args
     */
    public static void main(final String[] args) {
        SpringApplication application = new SpringApplication(
                EchoBouncer.class);
        application.run(args);
    }

    @Override
    public List<ResponseDto> exec(final List<RequestDto> body) {
        return null;
    }
}
