import java.util.PriorityQueue;

public class HeapExample {
    public static void main(String[] args) {
        PriorityQueue<Integer> minHeap = new PriorityQueue<>();

        minHeap.offer(10);
        minHeap.offer(5);
        minHeap.offer(15);

        System.out.println("stack top: " + minHeap.peek());

        while (!minHeap.isEmpty()) {
            System.out.println(minHeap.poll());
        }
    }
}
