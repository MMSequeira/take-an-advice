package pt.iscte.dsi.taa.policies.relationships.association.ordered;

import org.junit.After;
import org.junit.Before;
import org.junit.Test;

import pt.iscte.dsi.taa.qualifiers.InstancePrivate;
import pt.iscte.dsi.taa.qualifiers.StateModifier;

public class TestRelationshipsAssociationOrdered {
	
	/**
	 * Setting up Fixtures 
	 */
	@Before
	@StateModifier
	public void setUp(){
		a = new A();
	}
	
	@Test
	public void addOrderedElements(){
		a.addToList(new B(10));
		a.addToList(new B(20));
	}
	
	@Test(expected = AssertionError.class)
	public void addUnorderedElement(){
		a.addToList(new B(10));
		a.addToList(new B(5));
	}
	
	//TODO teste necessario?
//	@Test(expected = AssertionError.class)
//	public void addUnorderedElementsToList(){
//		a.addUnorderedElementsToList(40);
//	}

	@Test
//	TODO esta era a descricao deles: Remove an element with an ID and add another with the same ID. eles queriam objecto ou index na lista?
//	nao percebemos bem o que estamos a testar
	public void removeAndAddIdenticalElement(){
		B b = new B(10);
		a.addToList(b);
		a.removeFromList(b);
		a.addToList(b);
	}
	
	/**
	 * Tears down the fixtures
	 */
	@After
    @StateModifier
	public void tearDown(){
		a = null;
	}
	
	/*
 	 * Attributes
 	 */
	@InstancePrivate
	private A a;
	
	//TODO o 3º e 5º before nao teem teste
	
//	public static void main(String[] args) {
//	
//	A a = new A();
//	a.addToList(new B(10));
//	a.addToList(new B(20));
//	a.addToList(new B(5));
//	System.out.println("A size: " + a.size());
//	
//	/** 
//	 * Test an unordered list.
//	 */
//	//TODO necessario?
////	a.addUnorderedElementsToList(40);
//			
//	/**
//	 * Remove an element with an ID and add another with the same ID.
//	 */
//	a.removeFromList(10);
//	a.addToList(new B(10));
//	System.out.println("A new size: " + a.size());
//}
}
