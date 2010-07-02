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

import pt.iscte.dsi.taa.qualifiers.InstancePrivate;

public class B implements Comparable<B>{

	public B(final int id){
		this.id=id;
	}
	
	public int compareTo(B object){
		if(this==object)		
			return 0;
		else
			return this.id - ((B)object).getId();
	}
	
	public boolean equals(Object object){
		if(this == object)
			return true;
		else if(!(object instanceof B))
			return false;
		else
			return this.getId() == ((B)object).getId();
	}
	
	public int getId(){
		return this.id;
	}
	
	/*
 	 * Attributes
 	 */
	@InstancePrivate
	private int id;
}
