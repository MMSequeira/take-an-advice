package pt.iscte.dsi.taa.policies.relationships.association.multiplicity;

import org.junit.*;

import pt.iscte.dsi.taa.qualifiers.InstancePrivate;

public class TestRelationshipsAssociationMultiplicity {
	
	/**
	 * Setting up Fixtures 
	 */
	@Before
	public void setUp(){
		C.clearStaticList();
	}
	
//	Testes para a lista b_1

	@Test
	public void multiplicity0ToInfinity_0Element(){
		a = new A(1);
	}
	
	@Test
	public void multiplicity0ToInfinity_1Element(){
		a = new A(1, new B(1));
	}
	
	@Test
	public void multiplicity0ToInfinity_MoreThan1Element(){
		a = new A(1, new B(1));
		a.addToList(1, 2);
	}
	
	
//	Testes para a lista b_2	
	
	
	@Test(expected = AssertionError.class)
	public void multiplicity1To5_0Element(){
		a = new A(2);
	}
	
	@Test
	public void multiplicity1To5_1Element(){
		a = new A(2, new B(1));
	}
	
	@Test
	public void multiplicity1To5_5Element(){
		a = new A(2, new B(1));
		a.addToList(2, 2);
		a.addToList(2, 3);
		a.addToList(2, 4);
		a.addToList(2, 5);
	}
	
	@Test(expected = AssertionError.class)
	public void multiplicity1To5_MoreThan5Element(){
		a = new A(2, new B(1));
		a.addToList(2, 2);
		a.addToList(2, 3);
		a.addToList(2, 4);
		a.addToList(2, 5);
		a.addToList(2, 6);
	}
	
	@Test(expected = AssertionError.class)
	public void multiplicity1To5_RemoveElement(){
		a = new A(2, new B(1));
		a.removeFromList(2, 0);
	}
	
//	Testes para a lista b_3
	
	@Test(expected = AssertionError.class)
	public void multiplicity1To2And4ToInfinity_0Element(){
		a = new A(3);
	}
	
	@Test
	public void multiplicity1To2And4ToInfinity_1Element(){
		a = new A(3, new B(1));
	}
	
	@Test(expected = AssertionError.class)
	public void multiplicity1To2And4ToInfinity_3Element(){
		a = new A(3, new B(1));
		a.addToList(3, 2);
		a.addToList(3, 3);
	}
	
	@Test
	public void multiplicity1To2And4ToInfinity_4Elements(){
		a = new A(3, new B(1));
		a.addToList(3, 2);
		a.addToList(3, 3);
		a.addToList(3, 4);
	}
	
	@Test(expected = AssertionError.class)
	public void multiplicity1To2And4ToInfinity_MoreThan4Element(){
		a = new A(3, new B(1));
		a.addToList(3, 2);
		a.addToList(3, 3);
		a.addToList(3, 4);
		a.addToList(3, 5);
	}
	
	//TODO fizemos os testes tendo em conta que vão ser feitos por esta ordem, sera que e melhor fazer clear a lista no inicio de todos os testes e comecar do inicio? o before é feito antes de cada teste por isso n e preciso
	@Test
	public void staticMultiplicity0To3_1Element(){
		C.addToStaticList(1);
	}
	
	@Test
	public void staticMultiplicity0To3_3Element(){
		C.addToStaticList(2);
		C.addToStaticList(3);
	}
	
	@Test(expected = AssertionError.class)
	public void staticMultiplicity0To3_MoreThan3Element(){
		C.addToStaticList(4);
	}
	
	/**
	 * Tears down the fixtures
	 */
	@After
	public void tearDown(){
		a = null;
	}
	
	//TODO falta teste para o 3º before
	
	
	//TODO destructors
	
	public void destructor(){
		
	}
	
	/*
 	 * Attributes
 	 */
    @InstancePrivate
	private A a;
	
	//TODO o terceiro before nao tem teste
	
//	public static void main(String[] args) {	
//	// MULTIPLICITY TEST
//	A a;
//	
//	/**
//	 * Toggle comment on <code>@Multiplicity("*")</code>.
//	 * An interval is defined with range from 0 to infinity.
//	 * The <code>@Multiplicity("*")</code> is equivalent to <code>@Multiplicity("0..*")</code>
//	 */
//	//TODO testar sem itens, com 1 item e com muitos itens
////	a = new A();
//	
//	/**
//	 * Toggle comment on <code>@Multiplicity("1..*")</code>.
//	 * An interval is defined with range from 1 to infinity.
//	 * You must add an instance of B in order to respect the <code>@Multiplicity("1")</code>.
//	 */
//	//TODO testar sem itens, com 1 item e com muitos itens
////	a = new A(new B(1));
//	
//	//TODO o comment nao está coerente: "1..2,4..*" nao e from 0 to 1 and from 3 to infinity
//	/**
//	 * <code>@Multiplicity("1..2,4..*")</code>.
//	 * Two intervals are defined with the ranges from 0 to 1 and from 3 to infinity.
//	 */
//	//TODO testar sem itens, com 1 item, com 3 itens e com muitos itens
////	a = new A(new B(1));
////	a.addToList(3);
////	System.out.println("A size: " + a.size());
//	
//	/**
//	 * The last item on the list is removed.
//	 * The multiplicity is checked again.
//	 */
//	//TODO testar ficar fora do range e dentro do range
////	a.removeFromList(a.size()-1);
////	System.out.println("A new size: " + a.size());
//	
//	// STATIC TEST
//	//TODO testar sem itens, com 1 item, com 3 itens e com muitos itens
////	C.addOneToStaticList(1);
////	C.addOneToStaticList(3);
//	
//	//TODO porque e que estes testes estao aqui? nao faz muito sentido, devia tar no ordered e no unique
//	/**
//	 * If the following code is uncommented, the list will not be ORDERED.
//	 */
//	//C.addOneToStaticList(2);
//	
//	/**
//	 * If the following code is uncommented, one element of the list will not be UNIQUE.
//	 */
//	//C.addOneToStaticList(1);
//	
//	//System.out.println("ID: " + C.getStaticList().getFirst().getId());
//	
//}
}
