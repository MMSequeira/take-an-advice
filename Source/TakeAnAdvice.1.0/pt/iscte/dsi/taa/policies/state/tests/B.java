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

package pt.iscte.dsi.taa.policies.state.tests;

import pt.iscte.dsi.taa.qualifiers.InstancePrivate;
import pt.iscte.dsi.taa.qualifiers.NonState;
import pt.iscte.dsi.taa.qualifiers.Part;
import pt.iscte.dsi.taa.qualifiers.PureFunction;
import pt.iscte.dsi.taa.qualifiers.StateModifier;

public class B {
	public B(A owner, String name) {
		this.name = name;
		this.i = 1;
		this.integer = new Integer(2);
		//this.partA = owner;
		//this.partA.put("partA", owner);
		//this.partA.add(owner);
		
		//this.partA.add(new A("newA"));
		//partA[0] = owner;
		this.partnerA = owner;
		this.partC = new C(this, owner, owner, name + "o->C");
		this.partnerC = new C(this, owner, owner, name + "->C");
	}
		
	@StateModifier
	public void modifier() {
		this.i++;
		this.integer = new Integer(3); 
		this.partA = new A("empty");;

		//partC = new C(this, partA, partnerA, name + "o->C1");
		//partnerC = new C(this, partA, partnerA, name + "->C1");
		
		//partC = new C(this, partA.get("partA"), partnerA, name + "o->C1");
		//partnerC = new C(this, partA.get("partA"), partnerA, name + "->C1");
//		partC = new C(this, partA.get(0), partnerA, name + "o->C1");
//		partnerC = new C(this, partA.get(0), partnerA, name + "->C1");
		//partC = new C(this, partA[0], partnerA, name + "o->C1");
		//partnerC = new C(this, partA[0], partnerA, name + "->C1");
		
		//partA.modifier2();
		//partA.get("partA").modifier2();
		//partA.get(0).modifier();
		//partA[0].modifier2();
//		partnerA.modifier2();
		//partA.nonModifier2();
		//partA.get("partA").nonModifier2();
//		partA.get(0).nonModifier2();
		//partA[0].nonModifier2();
//		partnerA.nonModifier2();
		//partC.modifier();
//		partnerC.modifier();
//		partC.nonModifier();
//		partnerC.nonModifier();
	}
	
	public void nonModifier() {
//		this.i++;
//		this.integer = new Integer(3); 
		//this.partC = new C(this, partA, partnerA, name + "->PartCn");
		//this.partnerC = new C(this, partA, partnerA, name + "->PartnerCn");
		
		
//		A a = new A("newA");
//		partA.add(a);
//		partA.get(1).modifier();
		
		//partC.nonModifier();
		//partA.modifier2(); depth 1
		//partnerA.modifier2(); depth 1
		//partA.nonModifier2();
		//partA.get("partA").nonModifier2();
		//partA.get(0).nonModifier2();
		//partA[0].nonModifier2();
		//partnerA.nonModifier2();
		partC.nonModifier(); // depth 1
		//partnerC.modifier(); //depth 2
		//partC.nonModifier();
		//partnerC.nonModifier();
		
//		System.out.println("Part A" + partA);
//		System.out.println("Part C" + partC);
//		System.out.println("Partner A" + partnerA);
//		System.out.println("Partner C" + partnerC);
	}
	
	@Override
	public String toString() {
		return name == null ? "" + hashCode() : name;
	}
	
	@PureFunction
	public void pureFunctionShowPartAndPartners()
	{
//		System.out.println("Part A" + partA);
//		System.out.println("Part C" + partC);
//		
//		System.out.println("Partner A" + partnerA);
//		System.out.println("Partner C" + partnerC);
	}
	
	
	/**
	 * Class Attributes
	 */
	
	@InstancePrivate
	private String name = "Bdefault";

	@NonState
	public int i;
	@NonState
	public Integer integer;
	
	//@ContainerOfParts
	@InstancePrivate
	//private List<A> partA = new LinkedList<A>();
	@Part
	private A partA;
	
	@NonState
	@InstancePrivate
	private A partnerA;
	
	@Part
	@InstancePrivate
	private C partC;
	@NonState
	@InstancePrivate
	private C partnerC;
	
	@StateModifier
	public static void change()
	{
		//A.static_part_b = new B(null, "Class A->StaticPartB");
	}
}
