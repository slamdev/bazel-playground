package echobouncer;

import com.github.slamdev.openapispringgenerator.plugin.api.RequestDto;
import com.github.slamdev.openapispringgenerator.plugin.api.ResponseDto;
import lombok.extern.slf4j.Slf4j;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import com.github.slamdev.openapispringgenerator.plugin.api.TestingApi;

import java.util.List;

@Slf4j
@SpringBootApplication
public class EchoBouncer implements TestingApi {

    public EchoBouncer() {
        log.info("{}", "asd");
    }

    public static void main(String[] args) {
        SpringApplication application = new SpringApplication(EchoBouncer.class);
        application.run(args);
    }

    @Override
    public List<ResponseDto> exec(List<RequestDto> body) {
        return null;
    }
}
