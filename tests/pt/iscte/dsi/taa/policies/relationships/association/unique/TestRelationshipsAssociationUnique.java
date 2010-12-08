package pt.iscte.dsi.taa.policies.relationships.association.unique;

import org.junit.After;
import org.junit.Before;
import org.junit.Test;

import pt.iscte.dsi.taa.qualifiers.InstancePrivate;
import pt.iscte.dsi.taa.qualifiers.StateModifier;

public class TestRelationshipsAssociationUnique {
	
	/**
	 * Setting up Fixtures 
	 */
	@Before
    @StateModifier
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
    @StateModifier
	public void tearDown(){
		a = null;
	}
	
	/*
 	 * Attributes
 	 */
    @InstancePrivate
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
