package;

// helper class
class H
{
    static public function lerp(current: Float, dest: Float, speed: Float): Float
    {
        if (current != dest) {
            current = current * (1 - speed) + dest * speed;
            if (Math.abs(current - dest) <= 0.1 * speed) current = dest;
        }
        return current;
    }

    static public function sign(x: Float): Int
    {
        if (x < 0) return -1;
        if (x > 0) return 1;
        return 0;
    }

    static public function randomNot(range: Int, not: Int): Int
    {
        var result: Int;
        do {
            result = Std.random(range);
        } while (result == not);
        return result;
    }
}