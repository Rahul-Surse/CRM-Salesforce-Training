public with sharing class AbsOperation {
    // Abstract inner class
    public abstract class Operation {
        public abstract void display();
    }

    // Concrete class that implements abstract method
    public class MyOperation extends Operation {
        public override void display() {
            System.debug('This is the implementation of display method.');
        }
    }

    public static void main() {
        Operation op = new MyOperation();
        op.display();
    }
}