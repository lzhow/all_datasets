public class A {
    protected String m = "A";
    public void p() {
      System.out.printl("A");
    }
  }
  
class B extends A {
    private String n = "B";
    public static void main(String[] args) {
      B b = new B();
      b.p();
    }
  }

