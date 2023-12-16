class Animal {
    public void makeSound() {
        System.out.println("Some sound");
    }
}

class Dog extends Animal {
    @Override
    public void makeSound() {
        System.out.println("Bark");
    }

    public void fetch() {
        System.out.println("Fetching...");
    }
}

public class TypeCastingAndInferenceExample {
    public static void main(String[] args) {
        Animal animal = new Dog();

        animal.makeSound(); // "Bark"

        if (animal instanceof Dog) {
            Dog dog = (Dog) animal; 
            dog.fetch(); // "Fetching..."
        }
    }
}
