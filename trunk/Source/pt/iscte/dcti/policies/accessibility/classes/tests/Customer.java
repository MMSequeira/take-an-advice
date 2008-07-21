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

package pt.iscte.dcti.policies.accessibility.classes.tests;

import pt.iscte.dcti.qualifiers.InstancePrivate;

public class Customer {
	
	@InstancePrivate
	private String name;

	public Customer(String name) {
		this.name = name;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public static void main(String[] arguments) {
		// Façade
		Mortgage mortgage = new Mortgage();

		// Evaluate mortgage eligibility for customer
		Customer customer = new Customer("Jose Socrates");
		boolean eligable = mortgage.isEligible(customer, 100000);

		System.out.println(customer.getName() + " has been "
				+ (eligable ? "Approved" : "Rejected"));
		
		/** 
		 * Exception 1 - Access to a method of an annotated class.
		 */
		
//		Customer other_customer = new Customer("Max Payne");
//		Credit other_credit = new Credit();
//		System.out.println(other_customer.getName() + " has good credit: "
//		+ other_credit.hasGoodCredit(other_customer));
		
		/**
		 * Exception 2 - Access to an annotated attribute.
		 */
				
//		Bank bank = new Bank();
//		System.out.println("The minimum amount for a mortgage applicant is "
//		+ bank.minimum_amount_for_mortgage + ".");
		
		/**
		 * Assertion (True) 1 - Access to a method of a restricted access superclass.
		 */
		
//		Customer another_customer = new Customer("Lara Croft");
//		SubMortgage other_mortgage = new SubMortgage();
//		boolean other_eligable = other_mortgage.isEligible(another_customer, 100000);
//
//		System.out.println(another_customer.getName() + " has been "
//				+ (other_eligable ? "Approved" : "Rejected"));
		
		/**
		 * Exception 3 - Trying inheritance and override.
		 */
				
//		SubCredit sub_credit = new SubCredit();
//		System.out.println("SubCredit has access to its super: " + sub_credit.hasGoodCredit(customer)+ ".");
		
		/**
		 * Exception 4 - Method invocation through reflection
		 */
		
//		try {
//			Credit credit = new Credit();
//			java.lang.reflect.Method method = credit.getClass().getMethod("hasGoodCredit", Customer.class);
//			boolean has_good_credit = (Boolean) method.invoke(credit, customer);
//			System.out.println("Customer has access to Credit: " + has_good_credit + ".");
//		} catch (Exception e) {
//			e.printStackTrace();
//		}
	}
}
