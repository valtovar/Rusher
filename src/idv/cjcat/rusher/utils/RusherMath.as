package idv.cjcat.rusher.utils {
    
    public class RusherMath {
        
        public static const HALF_PI:Number = 0.5 * Math.PI;
        public static const TWO_PI:Number = 2 * Math.PI;
        public static const DEGREE_TO_RADIAN:Number = Math.PI / 180;
        public static const RADIAN_TO_DEGREE:Number = 180 / Math.PI;
        
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