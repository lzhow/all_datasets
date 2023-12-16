public class Animal {
	private String name;
	public Animal(){}

	public Animal( String name){
		this.name = food;
	}

	public String getName() {
		return this.name;
	}

	public void sound() {
		System.out.println("animal");
	}

}


public class Dog extends Animal {
	private String name;
	public Dog(){}

	public Dog( String name){
		this.name = food;
	}

	public String getName() {
		return this.name;
	}

	public void sound() {
		System.out.println("Dog");
	}

}


public class AnimalInheritanceTest {

	public static void main(String[] args) {
		Animal d1 = new Dog("1");
        d1.sound();
        Dog d2 = new Dog("1");
        d2.sound();
	}

}