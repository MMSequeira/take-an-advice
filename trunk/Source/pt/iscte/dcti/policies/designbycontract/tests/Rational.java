/*
 * This file is part of Take an Advice.
 * 
 * Take an Advice is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 * 
 * Take an Advice is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Lesser General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License
 * along with Take an Advice.  If not, see <http://www.gnu.org/licenses/>. 
 * 
 */

package pt.iscte.dcti.policies.designbycontract.tests;

import pt.iscte.dcti.qualifiers.InstancePrivate;
import pt.iscte.dcti.qualifiers.PureFunction;
import pt.iscte.dcti.qualifiers.StateModifier;
import pt.iscte.dcti.qualifiers.StateValidator;

public class Rational {

	public Rational(final int numerator, final int denominator) {
		if (denominator == 0)
			throw new IllegalArgumentException("zero denominator!");

		int gcd = greatestCommonDivisor(numerator, denominator);

		if (denominator < 0) {
			this.numerator = -numerator / gcd;
			this.denominator = -denominator / gcd;
		} else {
			this.numerator = numerator / gcd;
			this.denominator = denominator / gcd;
		}
	}

	public Rational(final int value) {
		numerator = value;
		denominator = 1;
	}

	public Rational() {
		numerator = 0;
		denominator = 1;
		
		Rational.incrementNumberOfInstances();
	}

	@PureFunction
	public int getNumerator() {
		return numerator;
	}

	@PureFunction
	public int getDenominator() {
		return denominator;
	}
	
	@StateModifier
	public void setDenominator(final int new_denominator){
		this.denominator = new_denominator;
	}

	@StateModifier
	public void setNumerator(final int new_numerator){
		this.numerator = new_numerator;
	}

	@StateModifier
	public void increaseBy(final Rational another) {
		if (another == null)
			throw new IllegalArgumentException("Referência para another nula!");

		numerator = numerator * another.getDenominator() + another.getNumerator()
				* denominator;
		denominator *= another.getDenominator();

		int gcd = greatestCommonDivisor(numerator, denominator);

		numerator /= gcd;
		denominator /= gcd;
	}

	@Override
	public boolean equals(Object object) {
		if (this == object) {
			return true;
		} else if (!object.getClass().equals(getClass())) {
			return false;
		} else {
			Rational another = (Rational) object;
			return getNumerator() == another.getNumerator()
					&& getDenominator() == another.getDenominator();
		}
	}
	
	@StateValidator
	public final boolean stateIsValid() {
		return 0 < denominator
				&& Rational.greatestCommonDivisor(numerator, denominator) == 1;
	}

	public static final int greatestCommonDivisor(final int m, final int n) {
		assert m != 0 || n != 0 : "m = " + m + " n = " + n;

		int a = Math.abs(m);
		int b = Math.abs(n);

		while (true) {
			if (a == 0) {
				assert 0 < b && m % b == 0 && n % b == 0 : "m = " + m
						+ ", n = " + n + " and gcd = " + b;
				return b;
			}

			b %= a;

			if (b == 0) {
				assert 0 < a && m % a == 0 && n % a == 0 : "m = " + m
						+ ", n = " + n + " and gcd = " + a;
				return a;
			}

			a %= b;
		}
	}
	
	@StateModifier
	public static void incrementNumberOfInstances(){
		++number_of_instances;
	}
	
	@PureFunction
	public static int numberOfInstances(){
		return number_of_instances;
	}
	
	@StateValidator
	public static final boolean classStateIsValid(){
		return number_of_instances >= 0;
	}
	
	@InstancePrivate
	private int denominator;

	@InstancePrivate
	private int numerator;
	
	private static int number_of_instances = 0;

	@StateModifier
	public static final void main(String[] args) {
		System.out.println("Number of instances: " + number_of_instances);
		Rational r1 = new Rational();
		System.out.println("Number of instances: " + number_of_instances);
		r1.setDenominator(0);
	}
}
