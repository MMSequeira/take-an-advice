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

package pt.iscte.dsi.taa.policies.accessibility.classes;

import pt.iscte.dsi.taa.qualifiers.InstancePrivate;

public class Mortgage{

     public boolean isEligible(Customer customer, int amount){
          System.out.println(customer.getName() + " applies for "
          + amount + " loan.");

          boolean eligible = true;
          
          // Check creditworthyness of applicant 
          if (!bank.hasSufficientSavings(customer, amount) ||
             !loan.hasNoBadLoans(customer) ||
             !credit.hasGoodCredit(customer))
               eligible = false;
          
          return eligible;
     }
     
     /*
 	 * Attributes
 	 */
     @InstancePrivate
     private Bank bank = new Bank();
     @InstancePrivate
     private Loan loan = new Loan();
     @InstancePrivate
     private Credit credit = new Credit();
}

