class O {
    int x = 10;
  
    class I {
      int y = 5;
    }
  }
  
  public class M {
    public static void main(String[] args) {
      O m = new O();
      O.I i = m.new InnerClass();
      System.out.println(i.y + m.x);
    }
  }