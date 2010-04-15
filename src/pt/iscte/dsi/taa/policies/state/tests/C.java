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

import java.util.HashMap;
import java.util.Map;

import pt.iscte.dsi.taa.qualifiers.ContainerOfParts;
import pt.iscte.dsi.taa.qualifiers.InstancePrivate;
import pt.iscte.dsi.taa.qualifiers.NonState;
import pt.iscte.dsi.taa.qualifiers.Part;
import pt.iscte.dsi.taa.qualifiers.PureFunction;
import pt.iscte.dsi.taa.qualifiers.StateModifier;

public class C {
	public C(B owner, A one, A another, String name) {
		this.name = name;
		this.i = 1;
		this.integer = new Integer(2);
		this.partA = one;
		this.partnerA = another;
		this.partB = owner;
		this.partnerB = owner;
		this.myAs.put("partA", partA);
		this.myAs.put("partnerA", partnerA);
	}
		
	@StateModifier
	public void modifier() {
//		this.i++;
//		this.integer = new Integer(3); 
		
		myAs.get("partA").modifier();
		// myAs.get("partA").modifier2();
		// partA.modifier2();
		// partnerA.modifier2();
		// partA.nonModifier2();
		// partnerA.nonModifier2();
		// partB.modifier2();
		// partnerB.modifier2();
		// partB.nonModifier2();
		// partnerB.nonModifier2();
	}
	
	public void nonModifier() {
//		this.i++;
//		this.integer = new Integer(3); 
		
		myAs.put("newA", new A("newA"));
		myAs.get("newA").modifier();
//		A a = new A("newA");
//		System.out.println("Comecei aqui");
//		// myAsArray[0] = a;
//		myAsArray = new A[10];
//		System.out.println("Passei aqui");
//		myAsArray[1] = a;
//		System.out.println("Acabei aqui");
		// myAsArray = new A[20];
		// myAsArray[0].modifier();
		
		
		// partA.modifier2(); depth 1
		// partnerA.modifier2(); depth 1
		// partA.nonModifier2();
		// partnerA.nonModifier2();
		// partB.modifier2(); // depth 1
		// partnerB.modifier2(); // depth 1
		// partB.nonModifier2();
		// partnerB.nonModifier2();
		
		
		System.out.println("Part B" + partB);
		System.out.println("Partner B" + partnerB);
	}
	
	@Override
	public String toString() {
		return name == null ? "" + hashCode() : name;
	}
	
	
	@PureFunction
	public void pureFunctionShowPartAndPartners()
	{
//		System.out.println("Part B" + partB);		
//		System.out.println("Partner B" + partnerB);
	}
	
	
	/**
	 * Class Attributes
	 */
	
	@InstancePrivate
	private String name = "Cdefault";
	
	@NonState
	public int i;
	@NonState
	public Integer integer;
	
	@Part
	@InstancePrivate
	private A partA;
	@InstancePrivate
	private A partnerA;
	
	@Part
	@InstancePrivate
	private B partB;
	@NonState
	@InstancePrivate
	private B partnerB;
	
	@ContainerOfParts
	@InstancePrivate
	private Map<String, A> myAs = new HashMap<String, A>();
	
	// @ContainerOfParts
	@Part
	@InstancePrivate
	private A[] myAsArray = new A[10];
}
