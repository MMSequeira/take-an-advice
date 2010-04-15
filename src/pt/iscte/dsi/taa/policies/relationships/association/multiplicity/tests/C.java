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

package pt.iscte.dsi.taa.policies.relationships.association.multiplicity.tests;

import java.util.LinkedList;

import pt.iscte.dsi.taa.qualifiers.Multiplicity;

/**
 * 
 * @author Gustavo Cabral
 * @author Helena Monteiro
 * @author João Catarino
 * @author Tiago Moreiras
 * 
 */
public class C {
		
	/**
	 * Get the list of B instances.
	 * @return List of B instances.
	 */
	public static LinkedList<B> getStaticList(){
		return b_static_list;
	}
	
	/**
	 * Add and instance of B to the list with a given ID number.
	 * @param index is the index of the B object to be created.
	 */
	public static void addOneToStaticList(int index){	
		b_static_list.add(new B(index));
	}
	
	/**
	 * Static List
	 * One interval is defined with the range from 0 to 3.
	 * The list is set to be ordered.
	 */
	@Multiplicity("0..3")
	private static LinkedList<B> b_static_list = new LinkedList<B>();
}
