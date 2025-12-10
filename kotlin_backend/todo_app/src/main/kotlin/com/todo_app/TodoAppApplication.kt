package com.todo_app

import org.springframework.boot.autoconfigure.SpringBootApplication
import org.springframework.boot.jdbc.autoconfigure.DataSourceAutoConfiguration
import org.springframework.boot.runApplication

@SpringBootApplication(
    scanBasePackages = ["com.todo_app"],
    exclude = [DataSourceAutoConfiguration::class]
)
class TodoAppApplication

fun main(args: Array<String>) {
    runApplication<TodoAppApplication>(*args)
}
