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

package pt.iscte.dsi.taa.policies.accessibility.classes.tests;

import pt.iscte.dsi.taa.qualifiers.AccessibleFrom;


public class Credit {
	@AccessibleFrom(Mortgage.class)
	public boolean hasGoodCredit(Customer customer) {
		System.out.println("Check credit for " + customer.getName());
		return true;
	}

	@AccessibleFrom(Mortgage.class)
	public boolean hasBadCredit(Customer customer) {
		System.out.println("Check credit for " + customer.getName());
		return false;
	}
}
