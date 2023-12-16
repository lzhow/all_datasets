class Animal:
    def __init__(self, name, sound):
        self.name = name
        self.sound = sound

    def make_sound(self):
        return f"{self.name} says {self.sound}"

    def __repr__(self):
        return f"Animal('{self.name}', '{self.sound}')"

class Dog(Animal):
    def __init__(self, name, sound, breed):
        super().__init__(name, sound)
        self.breed = breed

    def __repr__(self):
        return f"Dog('{self.name}', '{self.sound}', '{self.breed}')"

generic_animal = Animal("Generic Animal", "some sound")
print(generic_animal)
print(generic_animal.make_sound())

my_dog = Dog("Rex", "Bark", "Golden Retriever")
print(my_dog)
print(my_dog.make_sound())
