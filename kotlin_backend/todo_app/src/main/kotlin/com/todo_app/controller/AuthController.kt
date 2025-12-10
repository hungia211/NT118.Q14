package com.todo_app.controller

import com.todo_app.dto.request.LoginRequest
import com.todo_app.dto.request.RegisterRequest
import com.todo_app.dto.response.AuthResponse
import com.todo_app.service.AuthService
import org.springframework.web.bind.annotation.*

@RestController
@RequestMapping("/auth")
class AuthController(
    private val authService: AuthService
) {

    @PostMapping("/register")
    fun register(@RequestBody req: RegisterRequest) =
        authService.register(req)

    // login bằng ID Token Firebase (Email/Password hoặc Google)
    @PostMapping("/login")
    fun login(@RequestBody req: LoginRequest) =
        authService.login(req)

    // verify ID Token từ header Authorization
    @GetMapping("/verify")
    fun verify(@RequestHeader("Authorization") authHeader: String): AuthResponse {
        return authService.verifyToken(authHeader)
    }
}