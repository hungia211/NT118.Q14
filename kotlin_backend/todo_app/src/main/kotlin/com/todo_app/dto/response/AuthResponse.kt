package com.todo_app.dto.response

data class AuthResponse (
    val uid: String,
    val email: String?,
    val message: String
)