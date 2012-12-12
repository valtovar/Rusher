package idv.cjcat.rusher.utils {
    
    public class RusherMath {
        
        public static const PI_2  :Number = Math.PI / 2.0;
        public static const PI_3  :Number = Math.PI / 3.0;
        public static const PI_4  :Number = Math.PI / 4.0;
        public static const PI_5  :Number = Math.PI / 5.0;
        public static const PI_6  :Number = Math.PI / 6.0;
        public static const PI_7  :Number = Math.PI / 7.0;
        public static const PI_8  :Number = Math.PI / 8.0;
        public static const TWO_PI:Number = 2.0 * Math.PI;
        public static const DEGREE_TO_RADIAN:Number = Math.PI / 180.0;
        public static const RADIAN_TO_DEGREE:Number = 180.0 / Math.PI;
        
        /**
         * Clamps a value within bounds.
         * @param    input
         * @param    lowerBound
         * @param    upperBound
         * @return
         */
        public static function clamp(input:Number, lowerBound:Number, upperBound:Number):Number
        {
            if (input < lowerBound) return lowerBound;
            if (input > upperBound) return upperBound;
            return input;
        }
        
        /**
         * Interpolates linearly between two values.
         * @param    x1
         * @param    y1
         * @param    x2
         * @param    y2
         * @param    x3
         * @return
         */
        public static function lerp(x1:Number, y1:Number, x2:Number, y2:Number, x3:Number):Number
        {
            return y1 - ((y1 - y2) * (x1 - x3) / (x1 - x2));
        }
        
        /**
         * The remainder of value1 divided by value 2, negative value1 exception taken into accound. 
         * Value2 must be positive.
         * @param    value1
         * @param    value2
         */
        public static function mod(value1:Number, value2:Number):Number
        {
            var remainder:Number = value1 % value2;
            return (remainder < 0)?(remainder + value2):(remainder);
        }
        
        public static function randomFloor(num:Number):int
        {
            var floor:int = num | 0;
            return floor + int(((num - floor) > Math.random())?(1):(0));
        }
    }
}