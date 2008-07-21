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

package pt.iscte.dcti.policies;

/**
 * 
 * To make easier to locate and change the Enforcers precedences, this aspect was created with
 * that sole purpose. 
 * 
 * @version 1.0
 * @author Gustavo Cabral
 * @author Helena Monteiro
 * @author João Catarino
 * @author Tiago Moreiras
 */
public aspect Precedence {
	declare precedence :
		pt.iscte.dcti.policies.stack.StackReplica+,
		pt.iscte.dcti.policies.accessibility.classes.Enforcer+,
		pt.iscte.dcti.policies.accessibility.instances.Enforcer+,
		*;
}
