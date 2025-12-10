package com.todo_app.service

import com.google.firebase.auth.FirebaseAuth
import com.google.firebase.auth.UserRecord
import com.todo_app.dto.request.LoginRequest
import com.todo_app.dto.request.RegisterRequest
import com.todo_app.dto.response.AuthResponse
import org.springframework.stereotype.Service

@Service
class AuthService {
    fun register(req: RegisterRequest): AuthResponse {
        val userRecord = FirebaseAuth.getInstance().createUser(
            UserRecord.CreateRequest()
                .setEmail(req.email)
                .setPassword(req.password)
        )

        return AuthResponse(
            uid = userRecord.uid,
            email = userRecord.email,
            message = "User registered"
        )
    }

    fun login(req: LoginRequest): AuthResponse {
        val decodedToken = FirebaseAuth.getInstance().verifyIdToken(req.idToken)
        val uid = decodedToken.uid
        val user = FirebaseAuth.getInstance().getUser(uid)

        return AuthResponse(
            uid = uid,
            email = user.email,
            message = "Login success"
        )
    }

    // VERIFY TOKEN
    fun verifyToken(authHeader: String): AuthResponse {
        if (!authHeader.startsWith("Bearer "))
            throw RuntimeException("Unsupported authorization scheme.")

        val token = authHeader.substringAfter("Bearer ").trim()

        val decoded = FirebaseAuth.getInstance().verifyIdToken(token)
        val user = FirebaseAuth.getInstance().getUser(decoded.uid)

        return AuthResponse(
            uid = decoded.uid,
            email = user.email,
            message = "Token is valid"
        )
    }
}