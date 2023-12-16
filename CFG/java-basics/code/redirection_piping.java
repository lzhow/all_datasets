import java.io.*;

public class RedirectionAndPipingExample {
    public static void main(String[] args) throws IOException {
        PrintStream ps = new PrintStream(new FileOutputStream("output.txt"));
        System.setOut(ps);

        System.setIn(new FileInputStream("input.txt"));
        BufferedReader reader = new BufferedReader(new InputStreamReader(System.in));
        String line;
        while ((line = reader.readLine()) != null) {
            System.out.println("read from the file " + line);
        }
        PipedOutputStream pout = new PipedOutputStream();
        PipedInputStream pin = new PipedInputStream();
        pout.connect(pin);

        Thread producer = new Thread(() -> {
            try {
                pout.write("Hello from one thread to another!".getBytes());
                pout.close();
            } catch (IOException e) {
                e.printStackTrace();
            }
        });

        Thread consumer = new Thread(() -> {
            try {
                int data = pin.read();
                while (data != -1) {
                    System.out.print((char) data);
                    data = pin.read();
                }
                pin.close();
            } catch (IOException e) {
                e.printStackTrace();
            }
        });

        producer.start();
        consumer.start();
    }
}
