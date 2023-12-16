import java.util.ArrayList;
import java.util.Scanner;

public class SimpleReader {
    private Scanner scanner;

    public SimpleReader() {
        scanner = new Scanner(System.in);
    }

    public int readInt() {
        return scanner.nextInt();
    }

    public double readDouble() {
        return scanner.nextDouble();
    }

    public String readString() {
        return scanner.next();
    }

    public char readChar() {
        return scanner.next().charAt(0);
    }

    public boolean hasNextChar() {
        return scanner.hasNext();
    }

    public boolean hasNextLine() {
        return scanner.hasNextLine();
    }

    public String readLine() {
        return scanner.nextLine();
    }

    public int[] readAllInts() {
        ArrayList<Integer> ints = new ArrayList<>();
        while (scanner.hasNextInt()) {
            ints.add(scanner.nextInt());
        }
        return ints.stream().mapToInt(i -> i).toArray();
    }

    public static void main(String[] args) {
        SimpleReader reader = new SimpleReader();
        System.out.println("Reading an integer: " + reader.readInt());
        System.out.println("Reading a double: " + reader.readDouble());
        System.out.println("Reading a string: " + reader.readString());
        System.out.println("Reading a char: " + reader.readChar());
        System.out.println("Has next char: " + reader.hasNextChar());
        System.out.println("Has next line: " + reader.hasNextLine());
        System.out.println("Reading a line: " + reader.readLine());
        System.out.println("Reading all integers: ");
        int[] allInts = reader.readAllInts();
        for (int i : allInts) {
            System.out.print(i + " ");
        }
        System.out.println();
    }
}
