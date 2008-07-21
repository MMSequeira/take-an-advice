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

package pt.iscte.dcti.policies.relationships.association.ordered.tests;

import java.util.LinkedList;
import java.util.Random;

// import pt.iscte.ci.policies.relations.multiplicity.MultiplicityItem;
import pt.iscte.dcti.qualifiers.InstancePrivate;
import pt.iscte.dcti.qualifiers.Multiplicity;
import pt.iscte.dcti.qualifiers.Ordered;

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
	public void addToList(final B b) {
		
			b_list.add(b);
		
	}
	
	/**
	 * Add instances of B to the list given number of times.
	 * A set of B instances are initialized with random ids.
	 * @param number
	 */
	public void addToUnorderedList(final int number) {
		Random random = new Random();
		
		for (int i = 0; i < number; i++) {
			b_list.add(new B(random.nextInt()));
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
	 * Toggle comment on <code>@Multiplicity("*")</code>.
	 * An interval is defined with range from 0 to infinity.
	 * The <code>@Multiplicity("*")</code> is equivalent to <code>@Multiplicity("0..*")</code>
	 */
	@InstancePrivate
	@Multiplicity("*")
	@Ordered
	private LinkedList<B> b_list = new LinkedList<B>();

	public static void main(String[] args) {
		A a = new A();
		a.addToList(new B(10));
		a.addToList(new B(20));
		a.addToList(new B(5));
		//System.out.println("A size: " + a.size());
		
		/** 
		 * Test an unordered list.
		 */
//		a.addToUnorderedList(40);
				
		/**
		 * Remove an element with an ID and add another with the same ID.
		 */
//		a.removeFromList(10);
//		a.addToList(new B(10));
//		System.out.println("A new size: " + a.size());
	}
}