public class StringConverter {

    public static int stringToInt(String str) throws NumberFormatException {
        return Integer.parseInt(str);
    }

    public static double stringToDouble(String str) throws NumberFormatException {
        return Double.parseDouble(str);
    }

    public static long stringToLong(String str) throws NumberFormatException {
        return Long.parseLong(str);
    }

    public static void main(String[] args) {
        try {
            int intValue = stringToInt("123");
            double doubleValue = stringToDouble("123.45");
            long longValue = stringToLong("123456789");

            System.out.println("Integer: " + intValue);
            System.out.println("Double: " + doubleValue);
            System.out.println("Float: " + longValue);
        } catch (NumberFormatException e) {
            System.out.println("Invalid string format: " + e.getMessage());
        }
    }
}
