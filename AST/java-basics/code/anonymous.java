public interface Greeting {
    void greet();
}

Greeting greeting = new Greeting() {
    @Override
    public void greet() {
        System.out.println("Hello!");
    }
};

greeting.greet();