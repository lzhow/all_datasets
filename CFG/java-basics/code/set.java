import java.util.HashSet;
import java.util.Set;

public class SetExample {
    public static void main(String[] args) {
        Set<String> set = new HashSet<>();

        set.add("apple");
        set.add("banana");
        set.add("orange");

        set.add("banana");

        for (String fruit : set) {
            System.out.println(fruit);
        }
    }
}
