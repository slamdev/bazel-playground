package echobouncer;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
public class EchoBouncer {
    public static void main(String[] args) {
        SpringApplication application = new SpringApplication(EchoBouncer.class);
        application.run(args);
    }
}
