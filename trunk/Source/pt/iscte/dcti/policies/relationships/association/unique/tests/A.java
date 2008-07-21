package pt.iscte.dcti.policies.relationships.association.unique.tests;

import java.util.LinkedList;

import pt.iscte.dcti.qualifiers.InstancePrivate;
import pt.iscte.dcti.qualifiers.Unique;

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
	public void addToList(final int number) {
			b_list.add(new B(number));
	}
	
	/**
	 * Add instances of B to the list given number of times.
	 * A set of B instances are initialized with the same id.
	 * @param number
	 */
	public void addToUniqueList(final int number) {		
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
	 * The <code>@Unique</code> property states that an element cannot be added if it equals to one of the Container.
	 * The Container cannot contain duplicated elements. 
	 */
	@InstancePrivate
	@Unique
	private LinkedList<B> b_list = new LinkedList<B>();

	public static void main(String[] args) {
		A a = new A();		
		a.addToUniqueList(40);
		System.out.println("A size: " + a.size());
		
		/**
		 * Adds an ID that already is contained on the list with the unique property.
		 */
		a.addToList(1);
		
		/**
		 * Remove an element with an ID and add another with the same ID.
		 */
		a.removeFromList(10);
		a.addToList(10);
		System.out.println("A new size: " + a.size());
	}
}