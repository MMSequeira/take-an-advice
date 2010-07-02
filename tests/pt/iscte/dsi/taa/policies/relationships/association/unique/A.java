package pt.iscte.dsi.taa.policies.relationships.association.unique;

import java.util.LinkedList;

import pt.iscte.dsi.taa.qualifiers.InstancePrivate;
import pt.iscte.dsi.taa.qualifiers.Unique;

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
	
	/*
 	 * Attributes
 	 */
	/**
	 * The <code>@Unique</code> property states that an element cannot be added if it equals to one of the Container.
	 * The Container cannot contain duplicated elements. 
	 */
	@InstancePrivate
	@Unique
	private LinkedList<B> b_list = new LinkedList<B>();
	
}