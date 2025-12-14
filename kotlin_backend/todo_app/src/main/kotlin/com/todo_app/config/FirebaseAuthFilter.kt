package com.todo_app.config

import com.google.firebase.auth.FirebaseAuth
import jakarta.servlet.FilterChain
import jakarta.servlet.http.HttpServletRequest
import jakarta.servlet.http.HttpServletResponse
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken
import org.springframework.security.core.context.SecurityContextHolder
import org.springframework.stereotype.Component
import org.springframework.web.filter.OncePerRequestFilter

// Lọc request, kiểm tra token Firebase
@Component
class FirebaseAuthFilter : OncePerRequestFilter() {

    override fun doFilterInternal(
        request: HttpServletRequest,
        response: HttpServletResponse,
        filterChain: FilterChain
    ) {
        val authHeader = request.getHeader("Authorization")

        if (authHeader != null && authHeader.startsWith("Bearer ")) {
            val token = authHeader.substring(7)
            try {
                val decoded = FirebaseAuth.getInstance().verifyIdToken(token)
                val auth = UsernamePasswordAuthenticationToken(decoded.uid, null, emptyList())
                SecurityContextHolder.getContext().authentication = auth
            } catch (e: Exception) {
                response.status = 401
                response.writer.write("Invalid token")
                return
            }
        }

        filterChain.doFilter(request, response)
    }
}