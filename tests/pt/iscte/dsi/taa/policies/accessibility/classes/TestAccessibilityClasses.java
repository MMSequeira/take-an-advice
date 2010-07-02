package pt.iscte.dsi.taa.policies.accessibility.classes;

import java.lang.reflect.InvocationTargetException;
import org.junit.*;
import static org.junit.Assert.*;
import pt.iscte.dsi.taa.policies.accessibility.IllicitAccessException;
import pt.iscte.dsi.taa.qualifiers.NonState;

public class TestAccessibilityClasses{
	
	/**
	 * Setting up Fixtures
	 */
	@Before
	public void setUp(){
		customer = new Customer("Jose Socrates");
	}
	
	/**
	 * Example of a good use of annotated methods
	 */
	@Test
	public void testAnnotatedMethods(){
		Mortgage mortgage = new Mortgage();
		boolean eligible = mortgage.isEligible(customer, 100000);

		System.out.println(customer.getName() + " has been "
				+ (eligible ? "Approved" : "Rejected"));
		
		assertTrue(eligible == true);
	}
	
	/** 
	 * Exception 1 - Access to an annotated method.
	 */
	@Test(expected = IllicitAccessException.class)
	public void accessAnnotatedMethod(){
//		Customer other_customer = new Customer("Max Payne");
		Credit credit = new Credit();
		System.out.println(customer.getName() + " has good credit: "
		+ credit.hasGoodCredit(customer));
	}
	
	/**
	 * Exception 2 - Access to an annotated attribute.
	 */
	@Test(expected = IllicitAccessException.class)
	public void accessAnnotatedAttribute(){
		Bank bank = new Bank();
		System.out.println("The minimum amount for a mortgage applicant is "
		+ bank.minimum_amount_for_mortgage + ".");
	}
	
	/**
	 * Assertion (True) 1 - Access to a method of a restricted access superclass.
	 */
	@Test
	public void accessMethodRestrictedAccessSuperclass(){
//		Customer another_customer = new Customer("Lara Croft");
		SubMortgage mortgage = new SubMortgage();
		boolean other_eligible = mortgage.isEligible(customer, 100000);

		System.out.println(customer.getName() + " has been "
				+ (other_eligible ? "Approved" : "Rejected"));
		assertTrue(other_eligible == true);
	}
		
	/**
	 * Exception 3 - Trying inheritance and override.
	 */
	@Test(expected = IllicitAccessException.class)
	public void inheritanceOverride(){
		SubCredit sub_credit = new SubCredit();
		System.out.println("SubCredit has access to its super: " + sub_credit.hasGoodCredit(customer)+ ".");
	}
	
	/**
	 * Exception 4 - Method invocation through reflection
	 * @throws NoSuchMethodException 
	 * @throws SecurityException 
	 * @throws InvocationTargetException 
	 * @throws IllicitAccessException 
	 * @throws IllegalArgumentException 
	 */
	//TODO porque InvocationTargetException e não IllegalAccess?
	@Test(expected = InvocationTargetException.class)
	public void methodInvocationThroughReflection() throws SecurityException, NoSuchMethodException, IllegalArgumentException, IllicitAccessException, InvocationTargetException, java.lang.IllegalAccessException{
			Credit credit = new Credit();
			java.lang.reflect.Method method = credit.getClass().getMethod("hasGoodCredit", Customer.class);
			boolean has_good_credit = (Boolean) method.invoke(credit, customer);
			System.out.println("Customer has access to Credit: " + has_good_credit + ".");
	}
	
	//TODO falta fazer os testes para o AccessibleFromMethods
	
	
	/**
	 * Tears down the Fixtures
	 */
	@After
	public void tearDown(){
		customer = null;
	}
	
	/*
 	 * Attributes
 	 */
	@NonState
	private Customer customer;
	
//	public static void main(String[] arguments) {		
//	
//	// Façade
//	Mortgage mortgage = new Mortgage();
//
//	//TODO isto nao ta a testar o bom uso de um metodo anotado, e deviamos testar isso
//	// Evaluate mortgage eligibility for customer
//	Customer customer = new Customer("Jose Socrates");
//	boolean eligable = mortgage.isEligible(customer, 100000);
//
//	System.out.println(customer.getName() + " has been "
//			+ (eligable ? "Approved" : "Rejected"));
//	
//	/** 
//	 * Exception 1 - Access to a method of an annotated class.
//	 */
//	//TODO nao devia ser Acces to an annotated method - confirmar com o tiago, se for isso, procurar/fazer testes com anotacoes em classes
//	Customer other_customer = new Customer("Max Payne");
//	Credit other_credit = new Credit();
//	System.out.println(other_customer.getName() + " has good credit: "
//	+ other_credit.hasGoodCredit(other_customer));
//	
//	/**
//	 * Exception 2 - Access to an annotated attribute.
//	 */
//			
////	Bank bank = new Bank();
////	System.out.println("The minimum amount for a mortgage applicant is "
////	+ bank.minimum_amount_for_mortgage + ".");
//	
//	/**
//	 * Assertion (True) 1 - Access to a method of a restricted access superclass.
//	 */
//	//TODO isto deve ser para mostrar que nao deve existir um erro quando acedemos a algo atraves de uma subclass da que tem acesso
////	Customer another_customer = new Customer("Lara Croft");
////	SubMortgage other_mortgage = new SubMortgage();
////	boolean other_eligable = other_mortgage.isEligible(another_customer, 100000);
////
////	System.out.println(another_customer.getName() + " has been "
////			+ (other_eligable ? "Approved" : "Rejected"));
//	
//	/**
//	 * Exception 3 - Trying inheritance and override.
//	 */
//			
////	SubCredit sub_credit = new SubCredit();
////	System.out.println("SubCredit has access to its super: " + sub_credit.hasGoodCredit(customer)+ ".");
//	
//	/**
//	 * Exception 4 - Method invocation through reflection
//	 */
//	
////	try {
////		Credit credit = new Credit();
////		java.lang.reflect.Method method = credit.getClass().getMethod("hasGoodCredit", Customer.class);
////		boolean has_good_credit = (Boolean) method.invoke(credit, customer);
////		System.out.println("Customer has access to Credit: " + has_good_credit + ".");
////	} catch (Exception e) {
////		e.printStackTrace();
////	}
//}
}
