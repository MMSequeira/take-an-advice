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

package pt.iscte.dcti.policies.state.tests;
import java.util.LinkedList;

import pt.iscte.dcti.qualifiers.ContainerOfParts;
import pt.iscte.dcti.qualifiers.InstancePrivate;
import pt.iscte.dcti.qualifiers.NonState;
import pt.iscte.dcti.qualifiers.Part;
import pt.iscte.dcti.qualifiers.PureFunction;
import pt.iscte.dcti.qualifiers.StateModifier;

public class A {
	public A(String name) {
//		this.name = name;
//		this.i = 1;
//		this.integer = new Integer(2);
//		this.partB = new B(this, name + "->PartB");
//		this.partnerB = new B(this, name + "->PartnerB");
	}
			
	@StateModifier
	public void modifier() {
//		this.i++;
//		this.integer = new Integer(3); 
		this.partB = new B(this, name + "->PartBm");
		this.partnerB = new B(this, name + "->PartnerBm");

		// this.partB.modifier();
		// this.partnerB.modifier();
		// this.partB.nonModifier();
		// this.partnerB.nonModifier();
	}
	
	public void nonModifier() {
		// this.i++;
		// this.integer = new Integer(3); 
//		this.partB = new B(this, name + "->PartBn");
//		this.partnerB = new B(this, name + "->PartnerBn");
		
//		this.partB.modifier(); //depth 1
//		this.partnerB.modifier(); // depth 2
		
		// this.partB.nonModifier();
		 this.partnerB.nonModifier();
	}
		
	
	@PureFunction
	public void pureFunction()
	{
		// B new_b = this.partnerB;
		// this.partnerB = new B(this, name + "->PartnerBn");
		// System.out.println("Creating new PartnerB; OLD ->" + partnerB);
	}
		
	@Override
	public String toString() {
		hashCode();
		return name == null ? "" + hashCode() : name;
	}
	
	/**
	 * Class Attributes
	 */
	@InstancePrivate
	private String name = "Adefault";
	
	@NonState
	public int i;
	@NonState
	public Integer integer;
	
	@Part
	@InstancePrivate
	private B partB;
	
	@InstancePrivate
	private B partnerB;
	
	@Part
	private static A static_part_a = new A("A");
	private static LinkedList<A> list = new LinkedList<A>();
	
	public static void staticNonStateModifier()
	{
//		A.static_part_a = new A("A");
		
//		A.static_part_a.modifier();
//		A.getA();
		
//		list.add(A.static_part_a);
//		list.get(0).modifier();
		
//		linked.add(new A("A"));
//		//linked.get(0).modifier();
//		linked = new LinkedList<A>();
//		//A.static_part_a = new A("A");
	}
	
	/**
	 * Main Method
	 * @param arguments of main method
	 */
	@StateModifier
	public static void main(String[] arguments) {
		System.out.println("Tests started...");

		try {
//			A.static_part_a = new A("A");
//			A.staticNonStateModifier();
			
			A a = new A("A");
			a.modifier();
			a.nonModifier();
		} catch(Throwable thrown) {
			System.out.println("Test thrown exception:");
			thrown.printStackTrace();
			thrown = thrown.getCause();
			while(thrown != null) {
				System.out.println("Caused by:");
				thrown.printStackTrace();
				thrown = thrown.getCause();
			}
		}
		
		System.out.println("... tests ended.");
	}
}
