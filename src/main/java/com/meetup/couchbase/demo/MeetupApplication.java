package com.meetup.couchbase.demo;

import com.github.javafaker.Faker;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.ApplicationArguments;
import org.springframework.boot.ApplicationRunner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.data.annotation.Id;
import org.springframework.data.couchbase.core.CouchbaseTemplate;
import org.springframework.data.couchbase.core.mapping.Document;
import org.springframework.data.repository.CrudRepository;
import org.springframework.stereotype.Component;
import org.springframework.stereotype.Repository;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;
import java.util.Optional;

import static java.util.stream.IntStream.range;

@SpringBootApplication
public class MeetupApplication {

	public static void main(String[] args) {
		SpringApplication.run(MeetupApplication.class, args);
	}

}

@Component
class AppInitializer implements ApplicationRunner {

	private final PersonRepository personRepository;

	AppInitializer(PersonRepository personRepository) {
		this.personRepository = personRepository;
	}

	@Override
	public void run(ApplicationArguments args) {
		range(0,100).forEach(id -> {
			var faker = new Faker();
			var person = new Person();
			person.setId(String.valueOf(id));
			person.setFirstName(faker.name().firstName());
			person.setLastName(faker.name().lastName());
			person.setPhoneNumber(faker.phoneNumber().phoneNumber());
			person.setStreetAddress(faker.address().streetAddress());
			personRepository.save(person);
		});
	}
}


@Document
class Person {

	@Id
	private String id;
	private String firstName;
	private String lastName;
	private String streetAddress;
	private String phoneNumber;

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public String getFirstName() {
		return firstName;
	}

	public void setFirstName(String firstName) {
		this.firstName = firstName;
	}

	public String getLastName() {
		return lastName;
	}

	public void setLastName(String lastName) {
		this.lastName = lastName;
	}

	public String getStreetAddress() {
		return streetAddress;
	}

	public void setStreetAddress(String streetAddress) {
		this.streetAddress = streetAddress;
	}

	public String getPhoneNumber() {
		return phoneNumber;
	}

	public void setPhoneNumber(String phoneNumber) {
		this.phoneNumber = phoneNumber;
	}
}

@Repository
interface PersonRepository extends CrudRepository<Person, String> {
}

@RestController
@RequestMapping("/people")
class PersonController {

	@Autowired
	private CouchbaseTemplate template;

	@PostMapping
	public Person createPerson(@RequestBody Person person) {
		return template.insertById(Person.class).one(person);
	}

	@GetMapping("/all")
	public List<Person> allPersons() {
		return template.findByQuery(Person.class).all();
	}

	@GetMapping("/{id}")
	public Person getPerson(@PathVariable String id) {
		return Optional.of(template.findById(Person.class).one(id)).get();
	}
}
