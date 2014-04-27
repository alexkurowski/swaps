package;

// helper class
class H
{
    static public function lerp(current: Float, dest: Float, speed: Float) {
        if (current != dest) {
            current = current * (1 - speed) + dest * speed;
            if (Math.abs(current - dest) <= 0.1 * speed) current = dest;
        }
        return current;
    }

    static public function sign(x: Float)
    {
        if (x < 0) return -1;
        if (x > 0) return 1;
        return 0;
    }
}