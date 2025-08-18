public with sharing class MethodOveriding {

    // Parent class
    public virtual class Animal {
        public virtual void sound() {
            System.debug('Animal makes a sound');
        }
    }

    // Child class 
    public class Dog extends Animal {
        public override void sound() {
            System.debug('Dog barks');
        }
    }

    // Main method
    public static void mainMethod() {
        Animal a = new Animal();
        a.sound(); // Output: Animal makes a sound

        Animal d = new Dog();
        d.sound(); // Output: Dog barks
    }
}