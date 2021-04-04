/*
 *
 */
package importboms;

import ch.qos.logback.classic.Level;
import ch.qos.logback.classic.Logger;
import ch.qos.logback.classic.LoggerContext;
import org.apache.maven.repository.internal.MavenRepositorySystemUtils;
import org.eclipse.aether.DefaultRepositorySystemSession;
import org.eclipse.aether.RepositorySystem;
import org.eclipse.aether.RepositorySystemSession;
import org.eclipse.aether.artifact.DefaultArtifact;
import org.eclipse.aether.connector.basic.BasicRepositoryConnectorFactory;
import org.eclipse.aether.graph.Dependency;
import org.eclipse.aether.impl.DefaultServiceLocator;
import org.eclipse.aether.repository.LocalRepository;
import org.eclipse.aether.repository.RemoteRepository;
import org.eclipse.aether.resolution.ArtifactDescriptorException;
import org.eclipse.aether.resolution.ArtifactDescriptorRequest;
import org.eclipse.aether.resolution.ArtifactDescriptorResult;
import org.eclipse.aether.spi.connector.RepositoryConnectorFactory;
import org.eclipse.aether.spi.connector.transport.TransporterFactory;
import org.eclipse.aether.transport.file.FileTransporterFactory;
import org.eclipse.aether.transport.http.HttpTransporterFactory;
import org.eclipse.aether.util.repository.SimpleArtifactDescriptorPolicy;
import org.slf4j.LoggerFactory;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.Arrays;
import java.util.Collection;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

public final class Main {

    /**
     * List of BOM files to process.
     */
    private static final String[] BOMS = new String[]{
            "org.springframework.boot:spring-boot-dependencies:2.4.4",
            "org.springframework.cloud:spring-cloud-dependencies:2020.0.2",
    };

    /**
     * List of maven repositories to use.
     */
    private static final String[] REPOS = new String[]{
            "https://repo1.maven.org/maven2",
    };

    private Main() {
        // Utility class
    }

    /**
     * CLI entrypoint.
     *
     * @param args
     */
    public static void main(final String[] args) throws IOException {
        configureLogging();

        RepositorySystem sys = repositorySystem();
        RepositorySystemSession ses = session(sys);

        List<RemoteRepository> repos = Arrays.stream(REPOS)
                .map(url -> new RemoteRepository.Builder(url, "default", url))
                .map(RemoteRepository.Builder::build)
                .collect(Collectors.toList());

        Map<String, String> deps = Arrays.stream(BOMS)
                .map(DefaultArtifact::new)
                .map(a -> new ArtifactDescriptorRequest(a, repos, null))
                .map(r -> readArtifactDescriptor(sys, ses, r))
                .map(ArtifactDescriptorResult::getManagedDependencies)
                .flatMap(Collection::stream)
                .map(Dependency::getArtifact)
                .collect(Collectors.toMap(
                        a -> a.getGroupId() + ":" + a.getArtifactId(),
                        a -> a.getGroupId() + ":" + a.getArtifactId() + ":" + a.getVersion(),
                        (existing, replacement) -> existing
                ));

        System.out.println("MAVEN_BOMS = {");
        deps.forEach((key, value) -> System.out.printf("    \"%s\": \"%s\",%n", key, value));
        System.out.println("}");
    }

    /**
     * @param sys
     * @param ses
     * @param req
     * @return ArtifactDescriptorResult
     */
    private static ArtifactDescriptorResult readArtifactDescriptor(final RepositorySystem sys,
                                                                   final RepositorySystemSession ses,
                                                                   final ArtifactDescriptorRequest req) {
        try {
            return sys.readArtifactDescriptor(ses, req);
        } catch (ArtifactDescriptorException e) {
            throw new IllegalStateException(e);
        }
    }

    /**
     * @param repositorySystem
     * @return RepositorySystemSession
     * @throws IOException
     */
    private static RepositorySystemSession session(final RepositorySystem repositorySystem) throws IOException {
        Path tmpDir = Files.createTempDirectory("mvn");
        LocalRepository localRepo = new LocalRepository(tmpDir.toFile());
        DefaultRepositorySystemSession session = MavenRepositorySystemUtils.newSession();
        session.setArtifactDescriptorPolicy(new SimpleArtifactDescriptorPolicy(false, false));
        session.setLocalRepositoryManager(repositorySystem.newLocalRepositoryManager(session, localRepo));
        return session;
    }

    /**
     * @return RepositorySystem
     */
    private static RepositorySystem repositorySystem() {
        DefaultServiceLocator locator = MavenRepositorySystemUtils.newServiceLocator();
        locator.addService(RepositoryConnectorFactory.class, BasicRepositoryConnectorFactory.class);
        locator.addService(TransporterFactory.class, FileTransporterFactory.class);
        locator.addService(TransporterFactory.class, HttpTransporterFactory.class);
        locator.setErrorHandler(new DefaultServiceLocator.ErrorHandler() {
            @Override
            public void serviceCreationFailed(final Class<?> type, final Class<?> impl, final Throwable exception) {
                exception.printStackTrace();
            }
        });
        return locator.getService(RepositorySystem.class);
    }

    /**
     *
     */
    private static void configureLogging() {
        LoggerContext ctx = (LoggerContext) LoggerFactory.getILoggerFactory();
        Logger root = ctx.getLogger("root");
        root.setLevel(Level.INFO);
    }
}
