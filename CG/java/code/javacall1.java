class A {
    public static void aa() {
        System.out.printf("aa");
    }

    public static void cc() {
        System.out.printf("aa");
    }
}

class B {
    public static void aa() {
        System.out.printf("aa");
    }

    public static void cc() {
        System.out.printf("aa");
    }
}

class JC {
   
    public static void c() {
        A a = new A();
        a.aa();
        a.cc();
        B b = new B();
        b.aa();
        b.cc();
        System.out.printf("c");
    }
    public static void main(String[] args) {
        c();
    }
}
