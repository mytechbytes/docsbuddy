/// "3 items" / "1 item".
String plural(int n, String noun) => '$n $noun${n == 1 ? '' : 's'}';
