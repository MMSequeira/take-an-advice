package pt.iscte.dsi.taa.policies.relationships.association.unique;

import org.junit.After;
import org.junit.Before;
import org.junit.Test;

public class TestRelationshipsAssociationUnique {
	
	/**
	 * Setting up Fixtures 
	 */
	@Before
	public void setUp(){
		a = new A();
		a.addToUniqueList(40);
	}

	@Test(expected = AssertionError.class)
	public void addRepeatedElement(){
		a.addToList(1);
	}
	
	@Test
	public void removeAndAddIdenticalElement(){
		a.removeFromList(10);
		a.addToList(10);
	}
	
	/**
	 * Tears down the fixtures
	 */
	@After
	public void tearDown(){
		a = null;
	}
	
	/*
 	 * Attributes
 	 */
	private A a;
	
	//TODO o 3º e 5º before nao tem teste

//	public static void main(String[] args) {
//	A a = new A();		
//	a.addToUniqueList(40);
//	System.out.println("A size: " + a.size());
//	
//	/**
//	 * Adds an ID that already is contained on the list with the unique property.
//	 */
//	a.addToList(1);
//	
//	/**
//	 * Remove an element with an ID and add another with the same ID.
//	 */
//	a.removeFromList(10);
//	System.out.println("A new size: " + a.size());
//	a.addToList(10);
//	System.out.println("The final size: " + a.size());
//}
}