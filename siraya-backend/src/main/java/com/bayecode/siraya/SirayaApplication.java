package com.bayecode.siraya;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.scheduling.annotation.EnableScheduling;

@SpringBootApplication(scanBasePackages = {"com.bayecode.siraya"})
@EnableScheduling
public class SirayaApplication {

	public static void main(String[] args) {
		SpringApplication.run(SirayaApplication.class, args);
	}
}
