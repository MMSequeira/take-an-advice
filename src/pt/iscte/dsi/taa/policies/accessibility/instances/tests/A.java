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

package pt.iscte.dsi.taa.policies.accessibility.instances.tests;

import pt.iscte.dsi.taa.qualifiers.InstancePrivate;

public class A {
	
	// This procedure, being "@InstancePrivate", can only be called by the own instance.
	@InstancePrivate
	private void foo() {
		System.out.println("A Foo() Executed");
		++i;
	}

	public void bar(A other_a) {
		other_a.foo();
		// by dynamic invocation
		try {
			java.lang.reflect.Method method = other_a.getClass().getDeclaredMethod("foo");
			method.invoke(other_a);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	@InstancePrivate
	private int i = 0;
		
	public static void main(String[] args) {
		// One instance from class A
		A a = new A();
		// Another instance of the same class
		A other_a = new A();
		// This procedure receives an A class reference and calls its foo method. Should throw exception. 
		a.bar(other_a);
	}
}
