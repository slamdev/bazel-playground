package main

import (
	"encoding/xml"
	"fmt"
	"io"
	"io/ioutil"
	"log"
	"net/http"
	"strings"
)

var mavenBoms = []string{
	"org.springframework.boot:spring-boot-dependencies:2.3.6.RELEASE",
	"org.springframework.cloud:spring-cloud-dependencies:Hoxton.SR9",
}

type Project struct {
	XMLName              xml.Name             `xml:"project"`
	Version              string               `xml:"version"`
	GroupId              string               `xml:"groupId"`
	Properties           StringMap            `xml:"properties"`
	DependencyManagement DependencyManagement `xml:"dependencyManagement"`
	Parent               Parent               `xml:"parent"`
}

type Parent struct {
	XMLName    xml.Name `xml:"parent"`
	GroupId    string   `xml:"groupId"`
	ArtifactId string   `xml:"artifactId"`
	Version    string   `xml:"version"`
}

type DependencyManagement struct {
	XMLName               xml.Name              `xml:"dependencyManagement"`
	DependenciesContainer DependenciesContainer `xml:"dependencies"`
}

type DependenciesContainer struct {
	XMLName      xml.Name     `xml:"dependencies"`
	Dependencies []Dependency `xml:"dependency"`
}

type Dependency struct {
	XMLName    xml.Name `xml:"dependency"`
	GroupId    string   `xml:"groupId"`
	ArtifactId string   `xml:"artifactId"`
	Version    string   `xml:"version"`
	Type       string   `xml:"type"`
}

func main() {
	var dependencies []Dependency
	for _, bom := range mavenBoms {
		deps, err := resolveDependencies(bom)
		if err != nil {
			log.Fatalf("failed to resolve deps from %s; %w", bom, err)
		}
		dependencies = append(dependencies, deps...)
	}
	depsMap := make(map[string]string)
	for _, d := range dependencies {
		depsMap[d.GroupId+":"+d.ArtifactId] = d.GroupId + ":" + d.ArtifactId + ":" + d.Version
	}
	fmt.Println("MAVEN_BOMS = {")
	format := `    "%s": "%s",`
	for k, v := range depsMap {
		fmt.Printf(format+"\n", k, v)
	}
	fmt.Println("}")
}

func resolveDependencies(gav string) ([]Dependency, error) {
	url := gav2url(gav)
	p, err := getProject(url)
	if err != nil {
		return nil, fmt.Errorf("failed to build project from %s; %w", gav, err)
	}
	var dependencies []Dependency
	for _, d := range p.DependencyManagement.DependenciesContainer.Dependencies {
		if isProp(d.GroupId) {
			prop := trimProperty(d.GroupId)
			if prop == "project.groupId" {
				d.GroupId = p.GroupId
			} else {
				return nil, fmt.Errorf("don't know how to handle %s in %+v", prop, d)
			}
		}

		if isProp(d.Version) {
			prop := trimProperty(d.Version)
			if prop == "project.version" {
				if p.Version == "" {
					p.Version = p.Parent.Version
				}
				d.Version = p.Version
			} else if _, ok := p.Properties.m[prop]; ok {
				d.Version, err = searchPropInProps(prop, p)
				if err != nil {
					return nil, fmt.Errorf("don't know how to handle %s in %+v", prop, d)
				}
			} else if p.Parent.ArtifactId != "" {
				v, err := searchPropInParent(prop, p.Parent)
				if err != nil {
					return nil, fmt.Errorf("failed to search for %s in parent %+v; %w", prop, p.Parent, err)
				}
				d.Version = v
			} else {
				return nil, fmt.Errorf("don't know how to handle %s in %+v", prop, d)
			}
		}

		if isProp(d.ArtifactId) {
			prop := trimProperty(d.GroupId)
			return nil, fmt.Errorf("don't know how to handle %s in %+v", prop, d)
		}

		if d.Type == "pom" {
			gav := dep2gav(d)
			deps, err := resolveDependencies(gav)
			if err != nil {
				return nil, fmt.Errorf("failed to build dependencies from %s; %w", gav, err)
			}
			dependencies = append(dependencies, deps...)
		} else {
			dependencies = append(dependencies, d)
		}
	}
	return dependencies, nil
}

func searchPropInProps(prop string, proj Project) (string, error) {
	p := trimProperty(prop)
	if v, ok := proj.Properties.m[p]; ok {
		if isProp(v) {
			return searchPropInProps(v, proj)
		}
		return v, nil
	}
	if p == "project.version" {
		return proj.Version, nil
	}
	return "", fmt.Errorf("don't know how to handle %s in %+v", prop, proj)
}

func searchPropInParent(prop string, parent Parent) (string, error) {
	gav := dep2gav(Dependency{
		GroupId:    parent.GroupId,
		ArtifactId: parent.ArtifactId,
		Version:    parent.Version,
	})
	url := gav2url(gav)

	p, err := getProject(url)
	if err != nil {
		return "", fmt.Errorf("failed to get parent project from %s; %w", url, err)
	}

	if v, ok := p.Properties.m[prop]; ok {
		if isProp(v) {
			pp := trimProperty(v)
			if pp == "project.version" {
				if isProp(p.Version) {
					return "", fmt.Errorf("don't know how to handle %s in %+v", p.Version, p)
				}
				return p.Version, nil
			} else {
				return "", fmt.Errorf("don't know how to handle %s in %+v", prop, p)
			}
		}
		return v, nil
	}

	if p.Parent.ArtifactId != "" {
		v, err := searchPropInParent(prop, p.Parent)
		if err != nil {
			return "", fmt.Errorf("failed to search for %s in parent %+v; %w", prop, p.Parent, err)
		}
		return v, nil
	}

	return "", fmt.Errorf("failed to find %s prop in parent %s", prop, gav)
}

func isProp(p string) bool {
	return strings.HasPrefix(p, "${") && strings.HasSuffix(p, "}")
}

func trimProperty(p string) string {
	p = strings.TrimPrefix(p, "${")
	return strings.TrimSuffix(p, "}")
}

func dep2gav(d Dependency) string {
	return fmt.Sprintf("%s:%s:%s", d.GroupId, d.ArtifactId, d.Version)
}

func gav2url(gav string) string {
	format := "https://repo1.maven.org/maven2/%[1]s/%[2]s/%[3]s/%[2]s-%[3]s.pom"
	parts := strings.Split(gav, ":")
	group := strings.Replace(parts[0], ".", "/", -1)
	artifact := strings.Replace(parts[1], ".", "/", -1)
	version := parts[2]
	return fmt.Sprintf(format, group, artifact, version)
}

func getProject(url string) (Project, error) {
	resp, err := http.Get(url)
	if err != nil {
		return Project{}, fmt.Errorf("failed to get url %s; %w", url, err)
	}
	//goland:noinspection GoUnhandledErrorResult
	defer resp.Body.Close()

	if resp.StatusCode != http.StatusOK {
		return Project{}, fmt.Errorf("status code is not OK, but %d", resp.StatusCode)
	}

	data, err := ioutil.ReadAll(resp.Body)
	if err != nil {
		return Project{}, fmt.Errorf("failed to read body from %s; %w", url, err)
	}

	var project Project
	if err := xml.Unmarshal(data, &project); err != nil {
		return Project{}, fmt.Errorf("failed to unmarshal %s; %w", url, err)
	}

	return project, nil
}

type StringMap struct {
	m map[string]string
}

type xmlMapEntry struct {
	XMLName xml.Name
	Value   string `xml:",chardata"`
}

func (c *StringMap) UnmarshalXML(d *xml.Decoder, start xml.StartElement) error {
	c.m = map[string]string{}
	for {
		var e xmlMapEntry
		err := d.Decode(&e)
		if err == io.EOF {
			break
		} else if err != nil {
			return err
		}
		(c.m)[e.XMLName.Local] = e.Value
	}
	return nil
}
