public interface Flyable {
    void fly();
}

public interface Swimmable {
    void swim();
}

public class Bird implements Flyable {
    @Override
    public void fly() {
        System.out.println("Bird is flying");
    }
}

public class Fish implements Swimmable {
    @Override
    public void swim() {
        System.out.println("Fish is swimming");
    }
}

public class FlyingFish implements Flyable, Swimmable {
    @Override
    public void fly() {
        System.out.println("Flying fish is flying");
    }

    @Override
    public void swim() {
        System.out.println("Flying fish is swimming");
    }
}

Bird bird = new Bird();
bird.fly();

Fish fish = new Fish();
fish.swim();

FlyingFish flyingFish = new FlyingFish();
flyingFish.fly();
flyingFish.swim();