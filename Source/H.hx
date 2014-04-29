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

    // public static function deepCopy<T>( v:T ) : T 
    // { 
    //     if (!Reflect.isObject(v)) // simple type 
    //     { 
    //         return v; 
    //     } 
    //     else if( Std.is( v, Array ) ) // array 
    //     { 
    //         var r = Type.createInstance(Type.getClass(v), []); 
    //         untyped 
    //     { 
    //     for( ii in 0...v.length ) 
    //         r.push(deepCopy(v[ii])); 
    //     } 
    //     return r; 
    //     } 
    //     else if( Type.getClass(v) == null ) // anonymous object 
    //     { 
    //     var obj : Dynamic = {}; 
    //     for( ff in Reflect.fields(v) ) 
    //     Reflect.setField(obj, ff, deepCopy(Reflect.field(v, ff))); 
    //     return obj; 
    //     } 
    //     else // class 
    //     { 
    //     var obj = Type.createEmptyInstance(Type.getClass(v)); 
    //     for( ff in Reflect.fields(v) ) 
    //     Reflect.setField(obj, ff, deepCopy(Reflect.field(v, ff))); 
    //     return obj; 
    //     } 
    //     return null; 
    // }
}