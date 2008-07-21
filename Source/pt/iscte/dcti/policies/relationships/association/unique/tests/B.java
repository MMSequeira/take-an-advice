package pt.iscte.dcti.policies.relationships.association.unique.tests;

import pt.iscte.dcti.qualifiers.InstancePrivate;

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
