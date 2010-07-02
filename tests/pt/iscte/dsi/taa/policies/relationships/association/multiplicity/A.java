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

package pt.iscte.dsi.taa.policies.relationships.association.multiplicity;

import java.util.LinkedList;

import pt.iscte.dsi.taa.qualifiers.InstancePrivate;
import pt.iscte.dsi.taa.qualifiers.Multiplicity;

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
	public A(final int list) {
		switch(list){
		case 1:
			b_list1 = new LinkedList<B>();
			break;
		case 2:
			b_list2 = new LinkedList<B>();
			break;
		case 3:
			b_list3 = new LinkedList<B>();
			break;
		}
	}

	/**
	 * Invoked when <code>@Multiplicity("1")</code> or more.
	 * At least one instance must be added to the list.
	 */
	public A(final int list, final B b) {
		
		switch(list){
		case 1:
			b_list1 = new LinkedList<B>();
			if(b != null)
				b_list1.add(b);
			break;
		case 2:
			b_list2 = new LinkedList<B>();
			if(b != null)
				b_list2.add(b);
			break;
		case 3:
			b_list3 = new LinkedList<B>();
			if(b != null)
				b_list3.add(b);
			break;
		}
	}

	/**
	 * Gets the size of the list.
	 * @return Size of the list.
	 */
	public int size(final int list) {
		switch(list){
		case 1:
			return b_list1.size();
		case 2:
			return b_list2.size();
		case 3:
			return b_list3.size();
		default:
			return -1;
		}
	}

	/**
	 * Add instances of B to the list given number of times.
	 * @param number
	 */
	public void addToList(final int list, final int number) {
		switch(list){
		case 1:
			for (int i = 0; i < number; i++)
				b_list1.add(new B(i));
			break;
		case 2:
			for (int i = 0; i < number; i++)
				b_list2.add(new B(i));
			break;
		case 3:
			for (int i = 0; i < number; i++)
				b_list3.add(new B(i));
			break;
		}
	}

	/**
	 * Remove an instance of B from the list that has the same index has the given index.
	 * @param index
	 */
	public void removeFromList(final int list, final int index) {
		switch(list){
		case 1:
			b_list1.remove(index);
			break;
		case 2:
			b_list2.remove(index);
			break;
		case 3:
			b_list3.remove(index);
			break;
		}
	}
	
	//TODO nao percebo o que eles queriam fazer com estes comentarios
	/**
	 * Two intervals are defined with the ranges from 0 to 1 and from 3 to infinity.
	 * With these intervals defined, the <code>@Multiplicity("2")</code> is not complained and throws an exception.
	 */
	
	/*
 	 * Attributes
 	 */
	@InstancePrivate
	@Multiplicity("0..*")
	private LinkedList<B> b_list1;
	
	@InstancePrivate
	@Multiplicity("1..5")
	private LinkedList<B> b_list2;
	
	@InstancePrivate
	@Multiplicity("1..2,4..*")
	private LinkedList<B> b_list3;
}