using System;

namespace Calculator
{
    /// <summary>
    /// Calculator engine that performs basic arithmetic operations
    /// </summary>
    public class CalculatorEngine
    {
        /// <summary>
        /// Adds two numbers
        /// </summary>
        public double Add(double a, double b)
        {
            return a + b;
        }

        /// <summary>
        /// Subtracts second number from first number
        /// </summary>
        public double Subtract(double a, double b)
        {
            return a - b;
        }

        /// <summary>
        /// Multiplies two numbers
        /// </summary>
        public double Multiply(double a, double b)
        {
            return a * b;
        }

        /// <summary>
        /// Divides first number by second number
        /// </summary>
        /// <exception cref="DivideByZeroException">Thrown when divisor is zero</exception>
        public double Divide(double a, double b)
        {
            if (b == 0)
            {
                throw new DivideByZeroException("Cannot divide by zero!");
            }
            return a / b;
        }

        /// <summary>
        /// Raises first number to the power of second number
        /// </summary>
        public double Power(double baseNumber, double exponent)
        {
            return Math.Pow(baseNumber, exponent);
        }

        /// <summary>
        /// Calculates the square root of a number
        /// </summary>
        /// <exception cref="ArgumentException">Thrown when number is negative</exception>
        public double SquareRoot(double number)
        {
            if (number < 0)
            {
                throw new ArgumentException("Cannot calculate square root of a negative number!");
            }
            return Math.Sqrt(number);
        }
    }
}
