import java.util.ArrayList;
import java.util.List;

public class CollectionExample {
  public static List<Integer> doubleValues(List<Integer> list) {
    List<Integer> result = new ArrayList<>();
    for (int value : list) {
      result.add(value * 2);
    }
    return result;
  }

  public static void printList(List<Integer> list) {
    for (int value : list) {
      System.out.println(value);
    }
  }

  public static void main(String[] args) {
    List<Integer> values = List.of(1, 2, 3, 4, 5);
    List<Integer> doubled = doubleValues(values);
    printList(doubled);
  }
}
