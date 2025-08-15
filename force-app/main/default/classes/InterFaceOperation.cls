public with sharing class InterFaceOperation {

    public interface Car {
        void Name();
    }

    public class Honda implements Car {
        public void Name() {
            System.debug('Honda');
        }
    }

    public static void main() {
        Honda h = new Honda();
        h.Name();
    }
}
