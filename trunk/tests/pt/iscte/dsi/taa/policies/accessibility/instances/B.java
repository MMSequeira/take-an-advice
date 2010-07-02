package pt.iscte.dsi.taa.policies.accessibility.instances;

import pt.iscte.dsi.taa.qualifiers.InstancePrivate;

public class B extends A {

	@InstancePrivate
	public void foo() {
		System.out.println("A Foo() Executed from B");
		++i;
	}
	
	/*
 	 * Attributes
 	 */
	@InstancePrivate
	private int i = 0;
}
