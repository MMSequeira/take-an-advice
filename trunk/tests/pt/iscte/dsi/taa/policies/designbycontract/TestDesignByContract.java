package pt.iscte.dsi.taa.policies.designbycontract;

import org.junit.*;

import pt.iscte.dsi.taa.qualifiers.StateValidator;

public class TestDesignByContract {
	
	public static class A {
		public boolean state;
		public A(final boolean state) {
			this.state = state;
		}
		
		public void foo() {
			
		}
		
		public void finalize() {
			
		}
		
		// TODO Declare error para más aplicações de StateValidator. Fará sentido o final.
		@StateValidator
		public final boolean stateValidator() {
			return state;
		}
	}
	
	/**
	 * Setting up Fixtures 
	 */
	@Before
	public void setUp(){
		a = new A(true);
		a.state = false;
	}

	@Test(expected = AssertionError.class)
	public void constructor(){
		new A(false);
	}

	@Test(expected = AssertionError.class)
	public void method(){
		a.foo();
	}
	
	@Test(expected = AssertionError.class)
	public void destructor(){
		a.finalize();
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
	A a;
		
	//TODO nao e testado o ultimo before
	
	//TODO temos que fazer testes do resto dos advices certo? aqui apenas é testado o primeiro after e o primeiro before do Enforcer
//	@StateModifier
//	public static final void main(String[] args) {
//		System.out.println("Number of instances: " + number_of_instances);
//		Rational r1 = new Rational();
//		System.out.println("Number of instances: " + number_of_instances);
//		r1.setDenominator(0);
//	}
}
