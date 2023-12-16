public class Main {
    public static void main(String[] args) {
      int result = s(10);
     
    }
    public static int s(int k) {
      if (k > 0) {
        return k + s(k - 1);
      } else {
        m();
        return 0;
      }  
    }
    public static void m(){
    }
  }