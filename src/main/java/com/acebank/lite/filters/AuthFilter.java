package com.acebank.lite.filters;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

/*
   AuthFilter acts as a security guard.
   Any protected URL must pass through this filter.
*/

@WebFilter(urlPatterns = {
        "/home",
        "/Withdraw",
        "/Transfer",
        "/getStatement",
        "/ApplyLoan",
        "/loan.jsp"
})
public class AuthFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request,
                         ServletResponse response,
                         FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;

        String uri = httpRequest.getRequestURI();

        // Allow static resources without authentication
        if (uri.contains("/assets/") ||
                uri.contains(".css") ||
                uri.contains(".js") ||
                uri.contains(".png") ||
                uri.contains(".jpg") ||
                uri.contains(".svg")) {

            chain.doFilter(request, response);
            return;
        }

        // Do NOT create new session
        HttpSession session = httpRequest.getSession(false);

        boolean isLoggedIn =
                (session != null && session.getAttribute("accountNumber") != null);

        if (isLoggedIn) {
            chain.doFilter(request, response);
        } else {
            httpResponse.sendRedirect(
                    httpRequest.getContextPath() + "/Login"
            );
        }
    }

    @Override
    public void init(FilterConfig filterConfig) {
    }

    @Override
    public void destroy() {
    }
}