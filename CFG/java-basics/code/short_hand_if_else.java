public class short_hand_if_else {
    public static void main(String[] args) {   
        int money = args[1];
        String result = (money < 18) ? "Enough." : "Insufficient.";
        System.out.println(result);
      }
}
