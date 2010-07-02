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

package pt.iscte.dsi.taa.policies.relationships.association.ordered;

import java.util.LinkedList;

// import pt.iscte.ci.policies.relations.multiplicity.MultiplicityItem;
import pt.iscte.dsi.taa.qualifiers.InstancePrivate;
import pt.iscte.dsi.taa.qualifiers.Multiplicity;
import pt.iscte.dsi.taa.qualifiers.Ordered;

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
	//TODO os comentario nao fazem muito sentido... ele apenas adiciona uma instancia de b
	public void addToList(final B b) {
			b_list.add(b);
	}
	
	/**
	 * Add instances of B to the list given number of times.
	 * A set of B instances are initialized with random ids.
	 * @param number
	 */
	//TODO necessario?
//	public void addUnorderedElementsToList(final int number) {
//		Random random = new Random();
//		
//		for (int i = 0; i < number; i++) {
//			b_list.add(new B(random.nextInt()));
//		}
//	}

	/**
	 * Remove an instance of B from the list that has the same index has the given index.
	 * @param index
	 */
	//TODO tendo em conta os testes, nao faz muito sentido usar o index, mas sim o int do B,
//	a nao ser que se faca aquele teste de meter 40 coisas la dentro, mas mesmo assim, quando se adiciona outro B, nao e adicionado
//	no mesmo index, isto ta um pouco confuso
	public void removeFromList(/*final int index*/ final B b) {
//		b_list.remove(index);
		b_list.remove(b);
	}
	
	/*
 	 * Attributes
 	 */
	
	/**
	 * Toggle comment on <code>@Multiplicity("*")</code>.
	 * An interval is defined with range from 0 to infinity.
	 * The <code>@Multiplicity("*")</code> is equivalent to <code>@Multiplicity("0..*")</code>
	 */
	//TODO para aceitar so o "*" temos que alterar as expressoes regulares no metodo syntaxIsValid da classe MultiplicityItem
	//TODO dá erro causado por um declare error do enforcer
	@InstancePrivate
	@Multiplicity("0..*")
	@Ordered
	private LinkedList<B> b_list = new LinkedList<B>();
}