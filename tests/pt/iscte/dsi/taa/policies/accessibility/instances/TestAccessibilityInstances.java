package pt.iscte.dsi.taa.policies.accessibility.instances;

import org.junit.*;
import pt.iscte.dsi.taa.qualifiers.InstancePrivate;
import pt.iscte.dsi.taa.policies.accessibility.IllicitAccessException;

public class TestAccessibilityInstances{
	// This procedure, being "@InstancePrivate", can only be called by the own instance.
	@InstancePrivate
	private void foo() {
		System.out.println("A Foo() Executed");
		++i;
	}
	
	public void bar(TestAccessibilityInstances i) {
		i.foo();
		// by dynamic invocation
		try {
			java.lang.reflect.Method method = i.getClass().getDeclaredMethod("foo");
			method.invoke(i);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	//TODO acho que esta tudo testado, nao ha mais situacoes diferentes pois n?

	@InstancePrivate
	private int i = 0;
	private TestAccessibilityInstances a;
	private TestAccessibilityInstances other_a;
	
	@Before
	public void setUp(){
		a = new TestAccessibilityInstances();
		other_a = new TestAccessibilityInstances();
	}
	
	@Test(expected = IllicitAccessException.class)
	public void instanceTest() {
		// This procedure receives an A class reference and calls its foo method. Should throw exception. 
		a.bar(other_a);
	}
	
	@After
	public void tearDown(){
		a = null;
		other_a = null;
	}
	
//	/** 
//	 * Exception 1 - Access to a method of an annotated class.
//	 */
//	public static void main(String[] args) {
//		// One instance from class A
//		A a = new A();
//		// Another instance of the same class
//		A other_a = new A();
//		// This procedure receives an A class reference and calls its foo method. Should throw exception. 
//		a.bar(other_a);
//	}
	
//	TODO Este veio da classe B, e inda nao esta inserido nos testes
	
//	/**
//	 * Exception 1 - Trying inheritance and override.
//	 */
//	public static void main(String[] args) {
//		// One instance from class B
//		B b = new B();
//		// Another instance of the same class
//		B other_b = new B();
//		// This procedure receives an B class reference and calls its foo method. Should throw exception. 
//		b.bar(other_b);
//	}
}
