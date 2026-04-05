package controllers;

import models.Note;
import models.User;

import java.util.List;
import java.util.Scanner;

public class LoginTest {
    public static void main(String[] args) {
        Scanner scanner = new Scanner(System.in);

        UserController userController = new UserController();
        NoteController noteController = new NoteController();

        System.out.println("=== Login Test ===");
        System.out.print("Email: ");
        String email = scanner.nextLine();

        System.out.print("Password: ");
        String password = scanner.nextLine();

        User user = userController.login(email, password);

        if (user != null) {
            System.out.println("Login successful!");
            System.out.println("Welcome, " + user.getUsername());

            List<Note> allNotes = noteController.processLandingPageRequest(user);

            System.out.println("\n=== Landing Page Notes ===");
            if (allNotes.isEmpty()) {
                System.out.println("No notes found.");
            } else {
                for (Note note : allNotes) {
                    System.out.println("Note ID: " + note.getNoteID());
                    System.out.println("Title: " + note.getTitle());
                    System.out.println("Content: " + note.getContent());
                    System.out.println("----------------------");
                }
            }
        } else {
            System.out.println("Invalid login.");
        }

        scanner.close();
    }
}