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

package pt.iscte.dcti.policies.relationships.association.multiplicity.tests;

import java.util.LinkedList;

import pt.iscte.dcti.qualifiers.InstancePrivate;
import pt.iscte.dcti.qualifiers.Multiplicity;

/**
 * 
 * @author Gustavo Cabral
 * @author Helena Monteiro
 * @author João Catarino
 * @author Tiago Moreiras
 * 
 */
public class A {

	/**
	 * Invoked when can be <code>@Multiplicity("0")</code>.
	 */
	public A() {
		b_list = new LinkedList<B>();
	}

	/**
	 * Invoked when <code>@Multiplicity("1")</code> or more.
	 * At least one instance must be added to the list.
	 */
	public A(final B b) {
		b_list = new LinkedList<B>();
		b_list.add(b);
	}

	/**
	 * Gets the size of the list.
	 * @return Size of the list.
	 */
	public int size() {
		return b_list.size();
	}

	/**
	 * Add instances of B to the list given number of times.
	 * @param number
	 */
	public void addToList(final int number) {
		for (int i = 0; i < number; i++) {
			b_list.add(new B(i));
		}
	}

	/**
	 * Remove an instance of B from the list that has the same index has the given index.
	 * @param index
	 */
	public void removeFromList(final int index) {
		b_list.remove(index);
	}
	
	/**
	 * Two intervals are defined with the ranges from 0 to 1 and from 3 to infinity.
	 * With these intervals defined, the <code>@Multiplicity("2")</code> is not complained and throws an exception.
	 */
	@InstancePrivate
	// @Multiplicity("*")
	// @Multiplicity("1..*")
	@Multiplicity("1..2,4..*")
	private LinkedList<B> b_list;

	public static void main(String[] args) {	
		// MULTIPLICITY TEST
		A a;
		
		/**
		 * Toggle comment on <code>@Multiplicity("*")</code>.
		 * An interval is defined with range from 0 to infinity.
		 * The <code>@Multiplicity("*")</code> is equivalent to <code>@Multiplicity("0..*")</code>
		 */
		//a = new A();
		
		/**
		 * Toggle comment on <code>@Multiplicity("1..*")</code>.
		 * An interval is defined with range from 1 to infinity.
		 * You must add an instance of B in order to respect the <code>@Multiplicity("1")</code>.
		 */
//		a = new A(new B(1));
		
		/**
		 * <code>@Multiplicity("1..2,4..*")</code>.
		 * Two intervals are defined with the ranges from 0 to 1 and from 3 to infinity.
		 */
//		a = new A(new B(1));
//		a.addToList(3);
//		System.out.println("A size: " + a.size());
		
		/**
		 * The last item on the list is removed.
		 * The multiplicity is checked again.
		 */
//		a.removeFromList(a.size()-1);
//		System.out.println("A new size: " + a.size());
		
		// STATIC TEST
//		C.addOneToStaticList(1);
//		C.addOneToStaticList(3);
		
		/**
		 * If the following code is uncommented, the list will not be ORDERED.
		 */
		//C.addOneToStaticList(2);
		
		/**
		 * If the following code is uncommented, one element of the list will not be UNIQUE.
		 */
		//C.addOneToStaticList(1);
		
		//System.out.println("ID: " + C.getStaticList().getFirst().getId());
		
	}
}