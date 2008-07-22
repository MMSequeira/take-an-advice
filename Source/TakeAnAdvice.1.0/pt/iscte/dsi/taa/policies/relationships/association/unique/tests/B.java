package pt.iscte.dsi.taa.policies.relationships.association.unique.tests;

import pt.iscte.dsi.taa.qualifiers.InstancePrivate;

public class B{

	public B(final int id){
		this.id=id;
	}
	
	public boolean equals(Object object)
	{
		if(this == object)
			return true;
		else if(!(object instanceof B))
			return false;
		else
			return this.getId() == ((B)object).getId();
	}
	
	public int getId()
	{
		return this.id;
	}
	
	@InstancePrivate
	private int id;
}
