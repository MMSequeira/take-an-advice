package pt.iscte.dsi.taa.policies;

import org.junit.runner.RunWith;
import org.junit.runners.Suite;
import pt.iscte.dsi.taa.policies.accessibility.classes.TestAccessibilityClasses;
import pt.iscte.dsi.taa.policies.accessibility.instances.TestAccessibilityInstances;
import pt.iscte.dsi.taa.policies.designbycontract.TestDesignByContract;
import pt.iscte.dsi.taa.policies.relationships.association.multiplicity.TestRelationshipsAssociationMultiplicity;
import pt.iscte.dsi.taa.policies.relationships.association.ordered.TestRelationshipsAssociationOrdered;
import pt.iscte.dsi.taa.policies.relationships.association.unique.TestRelationshipsAssociationUnique;

@RunWith(Suite.class)
@Suite.SuiteClasses({
	TestAccessibilityClasses.class,
	TestAccessibilityInstances.class,
	TestDesignByContract.class,
	TestRelationshipsAssociationMultiplicity.class,
	TestRelationshipsAssociationOrdered.class,
	TestRelationshipsAssociationUnique.class
})

// TODO Remove this annotation after understanding why this compiles!
@ClassStateValidated
public class AllTests {

}
