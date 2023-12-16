class JC {
    public static void f() {
        String[] arg1 = {"a"};
        b(arg1);
    }
    
    public static void b( String[] myList ) {
        if (0) {
            b(myList);
        }
        c();
    }
    public static void c() {
        System.out.printf("c");
    }
    public static void main(String[] args) {
        f();
        c();
    }
}
