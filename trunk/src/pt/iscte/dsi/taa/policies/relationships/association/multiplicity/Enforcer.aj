/*
 * This file is part of Take an Advice. Take an Advice is free software: you can
 * redistribute it and/or modify it under the terms of the GNU Lesser General
 * Public License as published by the Free Software Foundation, either version 3
 * of the License, or (at your option) any later version. Take an Advice is
 * distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
 * without even the implied warranty of MERCHANTABILITY or FITNESS FOR A
 * PARTICULAR PURPOSE. See the GNU Lesser General Public License for more
 * details. You should have received a copy of the GNU General Public License
 * along with Take an Advice. If not, see <http://www.gnu.org/licenses/>.
 */

package pt.iscte.dsi.taa.policies.relationships.association.multiplicity;

import java.util.Collection;
import java.util.HashMap;
import java.util.WeakHashMap;

import org.aspectj.lang.Signature;
import org.aspectj.lang.annotation.SuppressAjWarnings;
import org.aspectj.lang.reflect.SourceLocation;

import pt.iscte.dsi.taa.policies.Pointcuts;
import pt.iscte.dsi.taa.policies.relationships.association.multiplicity.MultiplicityItem;
import pt.iscte.dsi.taa.qualifiers.InstancePrivate;
import pt.iscte.dsi.taa.qualifiers.Multiplicity;
import pt.iscte.dsi.taa.qualifiers.PureFunction;

/*****************************************************************************************
 * This Aspect represents the Multiplicity Policy Enforcer.
 * 
 * @version 1.0
 * @author Gustavo Cabral
 * @author Helena Monteiro
 * @author João Catarino
 * @author Tiago Moreiras
 */
public abstract aspect Enforcer {

    /*
     * Pointcuts
     */
    protected pointcut scope() : Pointcuts.all();

    /*
     * Exclude pointcuts inside the Policy Enforcer
     */
    private pointcut exclusions() :
		within(Enforcer+) ||
		within(pt.iscte.dsi.taa.policies.stack.StackReplica) ||
		within(pt.iscte.dsi.taa.policies.accessibility.classes.Enforcer+) ||
		within(pt.iscte.dsi.taa.policies.accessibility.instances.Enforcer+) ||
		within(pt.iscte.dsi.taa.policies.designbycontract.Enforcer+) ||
		within(pt.iscte.dsi.taa.policies.relationships.association.ordered.Enforcer+) ||
		within(pt.iscte.dsi.taa.policies.relationships.association.unique.Enforcer+) ||
		within(pt.iscte.dsi.taa.policies.state.Enforcer+);

    /*
     * Auxiliar Pointcuts
     */
    // Call

    // Execution
    private pointcut executionOfPrivateMethodOrPrivateConstructor() :
		Pointcuts.executionOfPrivateMethod() || Pointcuts.executionOfPrivateConstructor();

    private pointcut executionOfNonStaticNonPrivateAndNonDestructorMethod() :
		Pointcuts.executionOfNonStaticNonPrivateMethod() && !Pointcuts.executionOfDestructor();

    // Static Initialization
    private pointcut staticInitialization() :  staticinitialization(*);

    // Get
    private pointcut getOfMultiplicityField() : get(@Multiplicity * *);

    private pointcut getOfCollectionField() : get(Collection+ *);

    private pointcut getOfNonCollectionField() : get(!Collection+ *);

    private pointcut getOfNonStaticMultiplicityCollectionField() :
		Pointcuts.getOfNonStaticField() && getOfMultiplicityField() && getOfCollectionField();

    private pointcut getOfStaticMultiplicityCollectionField() :
		Pointcuts.getOfStaticField() && getOfMultiplicityField() && getOfCollectionField();

    private pointcut getOfNonStaticMultiplicityNonCollectionField() :
		Pointcuts.getOfNonStaticField() && getOfMultiplicityField() && getOfNonCollectionField();

    private pointcut getOfStaticMultiplicityNonCollectionField() :
		Pointcuts.getOfStaticField() && getOfMultiplicityField() && getOfNonCollectionField();

    // Set
    private pointcut setOfMultiplicityField() : set(@Multiplicity * *);

    private pointcut setOfCollectionField() : set(Collection+ *);

    private pointcut setOfNonCollectionField() : set(!Collection+ *);

    private pointcut setOfNonStaticMultiplicityCollectionField() :
		Pointcuts.setOfNonStaticField() && setOfMultiplicityField() && setOfCollectionField();

    private pointcut setOfStaticMultiplicityCollectionField() :
		Pointcuts.setOfStaticField() && setOfMultiplicityField() && setOfCollectionField();

    private pointcut setOfNonStaticMultiplicityNonCollectionField() :
		Pointcuts.setOfNonStaticField() && setOfMultiplicityField() && setOfNonCollectionField();

    private pointcut setOfStaticMultiplicityNonCollectionField() :
		Pointcuts.setOfStaticField() && setOfMultiplicityField() && setOfNonCollectionField();

    // Access (Get or Set)

    // Within

    // Within Code

    // Control Flow (cflow)

    /*
     * Advice's Pointcuts
     */

    /*
     * Collections to save
     */
    private pointcut instancesCollectionSet(Object object,
                                            Collection<?> collection,
                                            Multiplicity multiplicity) :
		scope() && !exclusions() &&
		setOfNonStaticMultiplicityCollectionField() &&
		target(object) && args(collection) && @annotation(multiplicity);

    private pointcut classCollectionSet(Collection<?> collection,
                                        Multiplicity multiplicity) :
		scope() && !exclusions() &&
		setOfStaticMultiplicityCollectionField() &&
		args(collection) && @annotation(multiplicity);

    /*
     * Non-Static executions
     */
    private pointcut executionOfNonStaticPossibleStateChangerMethodOrConstructor(Object target_object) :
		scope() && !exclusions() &&
		(executionOfNonStaticNonPrivateAndNonDestructorMethod() ||
		Pointcuts.executionOfNonPrivateConstructor()) &&
		target(target_object);

    private pointcut executionOfNonStaticPossibleStateChangerMethod(Object target_object) :
		scope() && !exclusions() &&
		executionOfNonStaticNonPrivateAndNonDestructorMethod() &&
		target(target_object);

    private pointcut executionOfPossibleStateChangerDestructor(Object target_object) :
		scope() && !exclusions() &&
		Pointcuts.executionOfDestructor() &&
		target(target_object);

    /*
     * Static executions
     */
    private pointcut executionOfStaticPossibleStateChangerMethodOrStaticInitialization() :
		scope() && !exclusions() &&
		(Pointcuts.executionOfStaticNonPrivateMethod() || staticInitialization());

    private pointcut executionOfStaticPossibleStateChangerMethod() :
		scope() && !exclusions() && Pointcuts.executionOfStaticNonPrivateMethod();

    /*
     * Advices
     */

    /**
     * <b>AdviceType:</b> After
     * <p>
     * <b>Scope:</b> Execution of non destructors, non private and non static
     * methods or constructors.
     * <p>
     * <b>Name:</b>
     * afterExecutionOfNonStaticNonPrivateNonDestructorMethodOrConstructor
     * <p>
     * This advice verifies if after the execution of constructors or non
     * static, non private, non destructor methods, the object's non-static
     * state is valid.
     */
    after(Object target_object): executionOfNonStaticPossibleStateChangerMethodOrConstructor(target_object) {

        SourceLocation location = thisJoinPointStaticPart.getSourceLocation();

        assert instanceMultiplicityIsValidOf(target_object) : location.getFileName() + ":" + location.getLine() + "\n" +
			"\tmultiplicity invalid after " + thisJoinPoint + "\n" +
			"\tmultiplicity expected: " + getInstanceCollectionWithInvalidMultiplicity(target_object).getMultiplicityItem() + "\n" + 
			"\tmultiplicity found: " + getInstanceCollectionWithInvalidMultiplicity(target_object).getCollection().size();

        Class<?> target_class = thisJoinPointStaticPart.getSignature()
                                                       .getDeclaringType();
        assert classMultiplicityIsValidOf(target_class) : location.getFileName() + ":" + location.getLine() + "\n" +
			"\tmultiplicity invalid after " + thisJoinPoint + "\n" +
			"\tmultiplicity expected: " + getClassCollectionWithInvalidMultiplicity(target_class).getMultiplicityItem() + "\n" + 
			"\tmultiplicity found: " + getClassCollectionWithInvalidMultiplicity(target_class).getCollection().size();
    }

    /**
     * <b>AdviceType:</b> After
     * <p>
     * <b>Scope:</b> Execution of non private and static methods or static
     * initializations.
     * <p>
     * <b>Name:</b> afterExecutionOfStaticNonPrivateMethodOrStaticInitialization
     * <p>
     * This advice verifies if after the execution of static initializations or
     * after the execution of static, non private, non destructor methods, the
     * object's static state is valid.
     */
    after(): executionOfStaticPossibleStateChangerMethodOrStaticInitialization() {

        SourceLocation location = thisJoinPointStaticPart.getSourceLocation();

        Class<?> target_class = thisJoinPointStaticPart.getSignature()
                                                       .getDeclaringType();
        assert classMultiplicityIsValidOf(target_class) : location.getFileName() + ":" + location.getLine() + "\n" +
			"\tmultiplicity invalid after " + thisJoinPoint + "\n" +
			"\tmultiplicity expected: " + getClassCollectionWithInvalidMultiplicity(target_class).getMultiplicityItem() + "\n" + 
			"\tmultiplicity found: " + getClassCollectionWithInvalidMultiplicity(target_class).getCollection().size();

    }

    /*
     * This before advice must come later than the after. This guarantees
     * precedence for the before. Hence, if an assertion fails during the before
     * advice, it will not be caught by the after advice, which would otherwise
     * have another assertion failed that would mask the one from the before
     * advice.
     */

    /**
     * <b>AdviceType:</b> Before
     * <p>
     * <b>Scope:</b> Execution of non destructors, non private and non static
     * methods.
     * <p>
     * <b>Name:</b> afterExecutionOfNonStaticNonPrivateNonDestructorMethod
     * <p>
     * This advice verifies if before the execution of non static, non private,
     * non destructor methods, the object's non-static state is valid.
     */
    before(Object target_object): executionOfNonStaticPossibleStateChangerMethod(target_object) {
        if (debug)
            System.out.println("Before method: " + thisJoinPoint);

        SourceLocation location = thisJoinPointStaticPart.getSourceLocation();

        assert instanceMultiplicityIsValidOf(target_object) : location.getFileName() + ":" + location.getLine() + "\n" +
			"\tmultiplicity invalid before " + thisJoinPoint + "\n" +
			"\tmultiplicity expected: " + getInstanceCollectionWithInvalidMultiplicity(target_object).getMultiplicityItem() + "\n" + 
			"\tmultiplicity found: " + getInstanceCollectionWithInvalidMultiplicity(target_object).getCollection().size();

        Class<?> target_class = thisJoinPointStaticPart.getSignature()
                                                       .getDeclaringType();
        assert classMultiplicityIsValidOf(target_class) : location.getFileName() + ":" + location.getLine() + "\n" +
    		"\tmultiplicity invalid before " + thisJoinPoint + "\n" +
    		"\tmultiplicity expected: " + getClassCollectionWithInvalidMultiplicity(target_class).getMultiplicityItem() + "\n" + 
    		"\tmultiplicity found: " + getClassCollectionWithInvalidMultiplicity(target_class).getCollection().size();

    }

    /**
     * <b>AdviceType:</b> Before
     * <p>
     * <b>Scope:</b> Execution of non private and static methods.
     * <p>
     * <b>Name:</b> afterExecutionOfStaticNonPrivateMethodOrStaticInitialization
     * <p>
     * This advice verifies if before the execution of static, non private, non
     * destructor methods, the object's static state is valid.
     */
    before(): executionOfStaticPossibleStateChangerMethod() {
        if (debug)
            System.out.println("Before method: " + thisJoinPoint);

        org.aspectj.lang.reflect.SourceLocation location = thisJoinPointStaticPart.getSourceLocation();

        // Object target_object =
        // thisJoinPointStaticPart.getSignature().getDeclaringType();

        Class<?> target_class = thisJoinPointStaticPart.getSignature()
                                                       .getDeclaringType();
        assert classMultiplicityIsValidOf(target_class) : location.getFileName() + ":" + location.getLine() + "\n" +
    		"\tmultiplicity invalid before " + thisJoinPoint + "\n" +
    		"\tmultiplicity expected: " + getClassCollectionWithInvalidMultiplicity(target_class).getMultiplicityItem() + "\n" + 
    		"\tmultiplicity found: " + getClassCollectionWithInvalidMultiplicity(target_class).getCollection().size();

    }

    /**
     * <b>AdviceType:</b> Before
     * <p>
     * <b>Scope:</b> Execution of destructors.
     * <p>
     * <b>Name:</b> beforeExecutionOfDestructor
     * <p>
     * This advice verifies if before the execution of the class destructor the
     * object's non-static state is valid.
     */
    @SuppressAjWarnings("adviceDidNotMatch")
    before(Object target_object): executionOfPossibleStateChangerDestructor(target_object) {
        if (debug)
            System.out.println("Before destructor: ");

        org.aspectj.lang.reflect.SourceLocation location = thisJoinPointStaticPart.getSourceLocation();

        if (target_object == null)
            target_object = thisJoinPointStaticPart.getSignature()
                                                   .getDeclaringType();

        if (!instanceMultiplicityIsValidOf(target_object))
            System.out.println(location.getFileName()
                               + ":"
                               + location.getLine()
                               + " state invalid before "
                               + thisJoinPoint);
    }

    /**
     * <b>AdviceType:</b> Before
     * <p>
     * <b>Scope:</b> Set of instances collections.
     * <p>
     * <b>Name:</b> setOfInstancesCollections
     * <p>
     * This advice captures the set of instances collections and saves them in
     * the aspect maps.
     */
    @SuppressAjWarnings("adviceDidNotMatch")
    before(Object object,
           Collection<?> referencesCollection,
           Multiplicity multiplicity) :
		instancesCollectionSet(object, referencesCollection, multiplicity) {
        if (debug)
            System.out.println("(Register) "
                               + thisJoinPointStaticPart
                               + " within "
                               + thisEnclosingJoinPointStaticPart
                               + " {");
        if (debug)
            System.out.println("\tRegistring part collection for "
                               + thisJoinPointStaticPart.getSignature()
                                                        .toLongString() + ".");

        if (!instances_references_collections.containsKey(object))
            instances_references_collections.put(object,
                                                 new HashMap<Signature, ReferencesCollectionData>());

        final Signature signature = thisJoinPointStaticPart.getSignature();

        if (!instances_references_collections.get(object)
                                             .containsKey(signature)
            || instances_references_collections.get(object)
                                               .get(signature)
                                               .getCollection() != referencesCollection) {
            MultiplicityItem multiplicity_item = new MultiplicityItem(multiplicity.value());

            instances_references_collections.get(object)
                                            .put(signature,
                                                 new ReferencesCollectionData(referencesCollection,
                                                                              multiplicity_item));
        }

        if (debug)
            System.out.println("}");
    }

    /**
     * <b>AdviceType:</b> Before
     * <p>
     * <b>Scope:</b> Set of class collections.
     * <p>
     * <b>Name:</b> setOfClassCollections
     * <p>
     * This advice captures the set of class collections and saves them in the
     * aspect maps.
     */
    @SuppressAjWarnings("adviceDidNotMatch")
    before(Collection<?> referencesCollection, Multiplicity multiplicity) :
		classCollectionSet(referencesCollection, multiplicity) {
        if (debug)
            System.out.println("(Register) "
                               + thisJoinPointStaticPart
                               + " within "
                               + thisEnclosingJoinPointStaticPart
                               + " {");
        if (debug)
            System.out.println("\tRegistring part collection for "
                               + thisJoinPointStaticPart.getSignature()
                                                        .toLongString() + ".");

        Object object = thisJoinPointStaticPart.getSignature()
                                               .getDeclaringType();

        if (!class_collections.containsKey(object))
            class_collections.put(object,
                                  new HashMap<Signature, ReferencesCollectionData>());

        final Signature signature = thisJoinPointStaticPart.getSignature();

        if (!class_collections.get(object).containsKey(signature)
            || class_collections.get(object).get(signature).getCollection() != referencesCollection) {
            MultiplicityItem multiplicity_item = new MultiplicityItem(multiplicity.value());

            class_collections.get(object)
                             .put(signature,
                                  new ReferencesCollectionData(referencesCollection,
                                                               multiplicity_item));
        }

        if (debug)
            System.out.println("}");
    }

    /*
     * Declared Warnings and Errors
     */

    /*
     * Errors
     */

    /*
     * Declarations of fields not eligible to be declared with the
     * <code>@Multiplicity</code> qualifier.
     */
    // Annotate a non-static object, which is not a Collection, with the
    // Multiplicity qualifier
    declare error : scope() && !exclusions() && getOfNonStaticMultiplicityNonCollectionField()
        : "The non-static attribute being gotten can't be annotated with the Multiplicity qualifier. Only a Collection can.";

    // Annotate a non-static object, which is not a Collection, with the
    // Multiplicity qualifier
    declare error : scope() && !exclusions() && setOfNonStaticMultiplicityNonCollectionField()
    	: "The non-static attribute being set can't be annotated with the Multiplicity qualifier. Only a Collection can.";

    // Annotate a static object, which is not a Collection, with the
    // Multiplicity qualifier
    declare error : scope() && !exclusions() && getOfStaticMultiplicityNonCollectionField()
    	: "The static attribute being gotten can't be annotated with the Multiplicity qualifier. Only a Collection can.";

    // Annotate a static object, which is not a Collection, with the
    // Multiplicity qualifier
    declare error : scope() && !exclusions() && setOfStaticMultiplicityNonCollectionField()
    	: "The static attribute being set can't be annotated with the Multiplicity qualifier. Only a Collection can.";

    /*
     * Warnings
     */

    /*
     * Features, outside of scope, declared as <code>@Multiplicity</code>.
     */
    // Access to an attribute with the @Multiplicity qualifier, outside the
    // scope of the enforcement.
    declare warning : !scope() && !exclusions() && setOfMultiplicityField()
		: "The attribute being set is declared with the @Multiplicity qualifier outside the scope of the enforcement.";

    // Access to an attribute with the @Multiplicity qualifier, outside the
    // scope of the enforcement.
    declare warning : !scope() && !exclusions() && getOfMultiplicityField()
		: "The attribute being gotten is declared with the @Multiplicity qualifier outside the scope of the enforcement.";

    /*
     * Methods
     */

    /**
     * Checks if an instance's collection multiplicity is valid.
     * 
     * @pre object != null
     * @post true
     * @param object is the object whose multiplicity is to be validated.
     * @return true if the instance's collection multiplicity is valid, false
     *         otherwise.
     */
    private static boolean instanceMultiplicityIsValidOf(Object object) {
        if (debug)
            System.out.println("Multiplicity is valid of: " + object);

        if (instances_references_collections.containsKey(object))
            for (ReferencesCollectionData data : instances_references_collections.get(object)
                                                                                 .values()) {
                if (!data.getMultiplicityItem().contains(data.getCollection()
                                                             .size()))
                    return false;
            }

        return true;
    }

    /**
     * Checks if a class's collection multiplicity is valid.
     * 
     * @pre object != null
     * @post true
     * @param target_class is the class whose multiplicity is to be validated.
     * @return true if the class's collection multiplicity is valid, false
     *         otherwise.
     */
    private static boolean classMultiplicityIsValidOf(Class<?> target_class) {
        if (debug)
            System.out.println("Multiplicity is valid of: " + target_class);

        if (class_collections.containsKey(target_class))
            for (ReferencesCollectionData data : class_collections.get(target_class)
                                                                  .values()) {
                if (!data.getMultiplicityItem().contains(data.getCollection()
                                                             .size()))
                    return false;
            }

        return true;
    }

    /**
     * Retrieve the instance collection with the invalid multiplicity from the
     * aspect's maps.
     * 
     * @pre object != null
     * @post true
     * @param object is the object containing the instance collection with
     *            invalid multiplicity.
     * @return the instance collection with the invalid multiplicity or null if
     *         it doesn't exist.
     */
    private static ReferencesCollectionData getInstanceCollectionWithInvalidMultiplicity(Object object) {
        if (instances_references_collections.containsKey(object))
            for (ReferencesCollectionData data : instances_references_collections.get(object)
                                                                                 .values()) {
                if (!data.getMultiplicityItem().contains(data.getCollection()
                                                             .size()))
                    return data;
            }

        return null;
    }

    /**
     * Retrieve the class collection with the invalid multiplicity from the
     * aspect's maps.
     * 
     * @pre object != null
     * @post true
     * @param target_class is the class containing the collection with invalid
     *            multiplicity.
     * @return the class collection with the invalid multiplicity or null if it
     *         doesn't exist.
     */
    private static ReferencesCollectionData getClassCollectionWithInvalidMultiplicity(Class<?> target_class) {
        if (class_collections.containsKey(target_class))
            for (ReferencesCollectionData data : class_collections.get(target_class)
                                                                  .values()) {
                if (!data.getMultiplicityItem().contains(data.getCollection()
                                                             .size()))
                    return data;
            }

        return null;
    }

    /*
     * Attributes
     */
    private static WeakHashMap<Object, HashMap<Signature, ReferencesCollectionData>> instances_references_collections = new WeakHashMap<Object, HashMap<Signature, ReferencesCollectionData>>();

    private static WeakHashMap<Object, HashMap<Signature, ReferencesCollectionData>> class_collections = new WeakHashMap<Object, HashMap<Signature, ReferencesCollectionData>>();

    private static boolean debug = false;

    /**
     * Structure containing the reference to a collection captured in the
     * Enforcer and its respective multiplicity.
     */
    private static class ReferencesCollectionData {

        /**
         * Constructs an object of the ReferencesCollectionData, given a valid
         * collection and its multiplicity.
         * 
         * @pre collection != null && multiplicity_item != null
         * @post true
         * @param collection is an object's collection object.
         * @param multiplicity_item is the object representing the collection's
         *            multiplicity.
         */
        public ReferencesCollectionData(Collection<?> collection,
                                        MultiplicityItem multiplicity_item) {
            this.collection = collection;
            this.multiplicity_item = multiplicity_item;
        }

        /**
         * Returns the collection of the structure.
         * 
         * @pre true
         * @post true
         * @return ReferencesCollectionData's collection.
         */
        @PureFunction
        public Collection<?> getCollection() {
            return this.collection;
        }

        /**
         * Returns the multiplicity of the structure's collection.
         * 
         * @pre true
         * @post true
         * @return ReferencesCollectionData collection's multiplicity.
         */
        @PureFunction
        public MultiplicityItem getMultiplicityItem() {
            return this.multiplicity_item;
        }

        /*
         * Attributes
         */
        @InstancePrivate
        private Collection<?> collection;
        @InstancePrivate
        private MultiplicityItem multiplicity_item;
    }
}
