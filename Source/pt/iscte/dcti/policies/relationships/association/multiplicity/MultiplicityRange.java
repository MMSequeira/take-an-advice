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

package pt.iscte.dcti.policies.relationships.association.multiplicity;

import pt.iscte.dcti.qualifiers.InstancePrivate;

public class MultiplicityRange {
	public MultiplicityRange(final String upper_bound)
	{
		this.upper_bound = upper_bound;
	}
	
	public MultiplicityRange(final String lower_bound, final String upper_bound)
	{
		if(!upper_bound.equals(MultiplicityRange.UNLIMITED) &&
			Integer.parseInt(lower_bound) > Integer.parseInt(upper_bound))
			throw new InvalidMultiplicityRange("Upper bound smaller than lower bound (" + upper_bound + " < " + lower_bound + ")." );
		
		this.lower_bound = lower_bound;
		this.upper_bound = upper_bound;
	}
	
	public boolean isDoubleBounded()
	{
		return lower_bound != null;
	}
	
	public boolean contains(final int value)
	{
		if(isDoubleBounded())
		{
			if(isUpperBoundUnlimited())
				return value >= Integer.parseInt(lower_bound);
			else
				return	value >= Integer.parseInt(lower_bound) && value <= Integer.parseInt(upper_bound);
		} else { //isSingleBounded
			if(isUpperBoundUnlimited())
				return value >= 0;
			else
				return Integer.parseInt(upper_bound) == value;
		}
	}
	
	@InstancePrivate
	private boolean isUpperBoundUnlimited(){
		return upper_bound.equals(MultiplicityRange.UNLIMITED);
	}
	
	public String toString()
	{
		if(isDoubleBounded())
			return lower_bound + ".." + upper_bound;
		else
			return upper_bound;
	}
	
	@InstancePrivate
	private String lower_bound;
	@InstancePrivate
	private String upper_bound;
	private final static String UNLIMITED = "*";
}
