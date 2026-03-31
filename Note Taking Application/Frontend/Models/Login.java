import java.util.Scanner;

public class Login {
    public static void main(String[] args) {
        try (Scanner scanner = new Scanner(System.in)) {
            System.out.println("=== Login Application ===");
            System.out.print("Username: ");
            String username = scanner.nextLine();
            
            System.out.print("Password: ");
            String password = scanner.nextLine();
            
            if (authenticate(username, password)) {
                System.out.println("Login successful!");
            } else {
                System.out.println("Invalid credentials!");
            }
        }
    }
    
    private static boolean authenticate(String username, String password) {
        // Check Login
        return username.equal("admin") && password.equal("password");
    }
}