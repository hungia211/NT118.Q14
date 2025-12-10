package com.todo_app.config

import com.google.auth.oauth2.GoogleCredentials
import com.google.firebase.FirebaseApp
import com.google.firebase.FirebaseOptions
import org.springframework.context.annotation.Bean
import org.springframework.context.annotation.Configuration
import java.io.FileInputStream
import javax.annotation.PostConstruct

// Khởi tạo Firebase trong Spring Boot
@Configuration
class FirebaseConfig {
    @Bean
    fun firebaseApp(): FirebaseApp {
        val stream = javaClass.classLoader
            .getResourceAsStream("firebase/serviceAccountKey.json")
            ?: throw IllegalStateException("serviceAccountKey.json not found")

        val options = FirebaseOptions.builder()
            .setCredentials(GoogleCredentials.fromStream(stream))
            .build()

        return FirebaseApp.initializeApp(options)
    }
}