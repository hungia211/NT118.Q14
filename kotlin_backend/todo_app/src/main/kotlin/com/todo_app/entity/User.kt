package com.todo_app.entity

import jakarta.persistence.Entity
import jakarta.persistence.Id

@Entity
data class User(
    @Id
    val uid: String,

    val email: String? = null,
    val name: String? = null
)
