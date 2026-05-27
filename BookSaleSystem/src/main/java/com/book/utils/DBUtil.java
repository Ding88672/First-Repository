package com.book.utils;

public class DBUtil {
    public static boolean checkUser(String username, String password) {
        return "admin".equals(username) && "123456".equals(password);
    }
}