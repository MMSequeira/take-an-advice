package pt.iscte.dsi.taa.policies.relationships.association.unique;

import java.util.Collection;
import java.util.HashMap;
import java.util.WeakHashMap;

import org.aspectj.lang.Signature;
import org.aspectj.lang.annotation.SuppressAjWarnings;


import pt.iscte.dsi.taa.policies.Idiom;
import pt.iscte.dsi.taa.qualifiers.Unique;


/*
 * Tasks
 */
/*
 * 1. Restringir inicialmente a colecções
 * 2. Verificação "interessantes" em tempo de execução.
 * 3. Verificação directa, sem recorrer a invariantes.
 * 4. Locais de verificação: tais como os invariantes.
 */

//Limitations
//N/A


/*****************************************************************************************
 * 
 * This Aspect represents the Unique Policy Enforcer.
 * 
 * @version 1.0
 * @author Gustavo Cabral
 * @author Helena Monteiro
 * @author João Catarino
 * @author Tiago Moreiras
 */
public abstract aspect Enforcer {

	/*
	 * General Pointcuts
	 */
	private pointcut none();
	private pointcut all() : !none();
		
	protected pointcut scope() : all();
	
	/*
	 * Exclude pointcuts inside the Policy Enforcer
	 */  
	private pointcut exclusions() :
		within(Enforcer+) ||
		within(pt.iscte.dsi.taa.policies.stack.StackReplica) ||
		within(pt.iscte.dsi.taa.policies.accessibility.classes.Enforcer+) ||
		within(pt.iscte.dsi.taa.policies.accessibility.instances.Enforcer+) ||
		within(pt.iscte.dsi.taa.policies.designbycontract.Enforcer+) ||
		within(pt.iscte.dsi.taa.policies.relationships.association.unique.Enforcer+) ||
		within(pt.iscte.dsi.taa.policies.relationships.association.multiplicity.Enforcer+) ||
		within(pt.iscte.dsi.taa.policies.state.Enforcer+);
	
	/*
	 * Pointcuts
	 */
	
	/*
	 * Auxiliar Pointcuts
	 */
	// Call
	
	
	// Execution
	private pointcut executionOfPrivateMethodOrPrivateConstructor() :
		Idiom.executionOfPrivateMethod() || Idiom.executionOfPrivateConstructor();
	private pointcut executionOfNonStaticNonPrivateAndNonDestructorMethod() :
		Idiom.executionOfNonStaticNonPrivateMethod() && !Idiom.executionOfDestructor();
		
	
	// Static Initialization
	private pointcut staticInitialization() :  staticinitialization(*);
	
	
	// Get
	private pointcut getOfUniqueField() : get(@Unique * *);
	private pointcut getOfCollectionField() : get(Collection+ *);
	private pointcut getOfNonCollectionField() : get(!Collection+ *);
	
	private pointcut getOfNonStaticUniqueField() :
		Idiom.getOfNonStaticField() && getOfUniqueField();
	private pointcut getOfStaticUniqueField() :
		Idiom.getOfStaticField() && getOfUniqueField();
	
	private pointcut getOfNonStaticUniqueCollectionField() :
		Idiom.getOfNonStaticField() && getOfUniqueField() && getOfCollectionField();
	private pointcut getOfStaticUniqueCollectionField() :
		Idiom.getOfStaticField() && getOfUniqueField() && getOfCollectionField();
	
	private pointcut getOfNonStaticUniqueNonCollectionField() :
		Idiom.getOfNonStaticField() && getOfUniqueField() && !getOfCollectionField();
	private pointcut getOfStaticUniqueNonCollectionField() :
		Idiom.getOfStaticField() && getOfUniqueField() && !getOfCollectionField();
	
		
	// Set
	private pointcut setOfUniqueField() : set(@Unique * *);
	private pointcut setOfCollectionField() : set(Collection+ *);
	private pointcut setOfNonCollectionField() : set(!Collection+ *);
	
	private pointcut setOfNonStaticUniqueField() :
		Idiom.setOfNonStaticField() && setOfUniqueField();
	private pointcut setOfStaticUniqueField() :
		Idiom.setOfStaticField() && setOfUniqueField();
	
	private pointcut setOfNonStaticUniqueCollectionField() :
		Idiom.setOfNonStaticField() && setOfUniqueField() && setOfCollectionField();
	private pointcut setOfStaticUniqueCollectionField() :
		Idiom.setOfStaticField() && setOfUniqueField() && setOfCollectionField();
	
	private pointcut setOfNonStaticUniqueNonCollectionField() :
		Idiom.setOfNonStaticField() && setOfUniqueField() && !setOfCollectionField();
	private pointcut setOfStaticUniqueNonCollectionField() :
		Idiom.setOfStaticField() && setOfUniqueField() && !setOfCollectionField();
	
		
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
	private pointcut instancesUniqueCollectionSet(Object object, Collection collection) :
		scope() && !exclusions() &&
		setOfNonStaticUniqueCollectionField() &&
		target(object) && args(collection);
	
	private pointcut classUniqueCollectionSet(Collection collection) :
		scope() && !exclusions() &&
		setOfStaticUniqueCollectionField() &&
		args(collection);
	

	/*
	 * Non-Static executions
	 */
	private pointcut executionOfPossibleNonStaticStateChangerMethodOrConstructor(Object target_object) :
		scope() && !exclusions() &&
		(executionOfNonStaticNonPrivateAndNonDestructorMethod() ||
		Idiom.executionOfNonPrivateConstructor()) &&
		target(target_object);
	
	private pointcut executionOfNonStaticPossibleStateChangerMethod(Object target_object) :
		scope() && !exclusions() &&
		executionOfNonStaticNonPrivateAndNonDestructorMethod() &&
		target(target_object);
	
	private pointcut executionOfPossibleStateChangerDestructor(Object target_object) :
		scope() && !exclusions() &&
		Idiom.executionOfDestructor() &&
		target(target_object);
	
	/*
	 * Static executions
	 */
	private pointcut executionOfPossibleStaticStateChangerMethodOrStaticInitialization() :
		scope() && !exclusions() &&
		(Idiom.executionOfStaticNonPrivateMethod() || staticInitialization());
	
	private pointcut executionOfStaticPossibleStateChangerMethod() :
		scope() && !exclusions() && Idiom.executionOfStaticNonPrivateMethod();
		
	
	
	/*
	 * Advices
	 */
	
	
	/**
	 * <b>AdviceType:</b> After
	 * <p>
	 * <b>Scope:</b> Execution of non destructors, non private and non static methods or constructors.
	 * <p>
	 * <b>Name:</b> afterExecutionOfNonStaticNonPrivateNonDestructorMethodOrConstructor
	 * <p>
	 * 
	 * This advice verifies if after the execution of constructors or after the execution of
	 * non static, non private, non destructor methods, the object's non-static state is valid.
	 * 
	 */		
	after(Object target_object): executionOfPossibleNonStaticStateChangerMethodOrConstructor(target_object) 
	{
    	
		org.aspectj.lang.reflect.SourceLocation location = 
            thisJoinPointStaticPart.getSourceLocation();
		
		assert instanceCollectionIsUnique(target_object) :location.getFileName() + ":" + location.getLine() + "\n" +
			"\tunique property invalid after " + thisJoinPoint + "\n" +
			"\tcollection has duplicated elements at positions "+
				Enforcer.unique_verification_first_element+" and "+
				Enforcer.unique_verification_second_element;
		
		Class target_class = thisJoinPointStaticPart.getSignature().getDeclaringType();
		assert classCollectionIsUnique(target_class) :location.getFileName() + ":" + location.getLine() + "\n" +
			"\tunique property invalid after " + thisJoinPoint + "\n" +
			"\tcollection has duplicated elements at positions "+
				Enforcer.unique_verification_first_element+" and "+
				Enforcer.unique_verification_second_element;
		
    }
    
	
	/**
	 * <b>AdviceType:</b> After
	 * <p>
	 * <b>Scope:</b> Execution of non private and static methods or static initializations.
	 * <p>
	 * <b>Name:</b> afterExecutionOfStaticNonPrivateMethodOrStaticInitialization
	 * <p>
	 * 
	 * This advice verifies if after the execution of static initializations or after the
	 * execution of static, non private, non destructor methods, the object's static state is valid.
	 * 
	 */	
	after(): executionOfPossibleStaticStateChangerMethodOrStaticInitialization()
	{
    	
		org.aspectj.lang.reflect.SourceLocation location = 
            thisJoinPointStaticPart.getSourceLocation();
		
		Class target_class = thisJoinPointStaticPart.getSignature().getDeclaringType();
		assert classCollectionIsUnique(target_class) :location.getFileName() + ":" + location.getLine() + "\n" +
			"\tunique property invalid before " + thisJoinPoint + "\n" +
			"\tcollection has duplicated elements at positions "+
				Enforcer.unique_verification_first_element+" and "+
				Enforcer.unique_verification_second_element;		
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
	 * <b>Scope:</b> Execution of non destructors, non private and non static methods.
	 * <p>
	 * <b>Name:</b> afterExecutionOfNonStaticNonPrivateNonDestructorMethod
	 * <p>
	 * 
	 * This advice verifies if before the execution of non static, non private,
	 * non destructor methods, the object's non-static state is valid.
	 * 
	 */		
	before(Object target_object): executionOfNonStaticPossibleStateChangerMethod(target_object) 
	{
    	if(debug) 
    		System.out.println("Before method: " + thisJoinPoint);

    	org.aspectj.lang.reflect.SourceLocation location = 
    		thisJoinPointStaticPart.getSourceLocation();

		target_object = thisJoinPointStaticPart.getSignature().getDeclaringType();

	    assert instanceCollectionIsUnique(target_object) :location.getFileName() + ":" + location.getLine() + "\n" +
			"\tunique property invalid before " + thisJoinPoint + "\n" +
			"\tcollection has duplicated elements at positions "+
				Enforcer.unique_verification_first_element+" and "+
				Enforcer.unique_verification_second_element;
	    
	    Class target_class = thisJoinPointStaticPart.getSignature().getDeclaringType();
	    assert classCollectionIsUnique(target_class) :location.getFileName() + ":" + location.getLine() + "\n" +
			"\tunique property invalid before " + thisJoinPoint + "\n" +
			"\tcollection has duplicated elements at positions "+
				Enforcer.unique_verification_first_element+" and "+
				Enforcer.unique_verification_second_element;
    }
	

	/**
	 * <b>AdviceType:</b> Before
	 * <p>
	 * <b>Scope:</b> Execution of non private and static methods.
	 * <p>
	 * <b>Name:</b> afterExecutionOfStaticNonPrivateMethodOrStaticInitialization
	 * <p>
	 * 
	 * This advice verifies if before the execution of static, non private,
	 * non destructor methods, the object's static state is valid.
	 * 
	 */	 
	before(): executionOfStaticPossibleStateChangerMethod()
	{ 
    	if(debug) 
    		System.out.println("Before method: " + thisJoinPoint);

    	org.aspectj.lang.reflect.SourceLocation location = 
    		thisJoinPointStaticPart.getSourceLocation();

		Class target_class = thisJoinPointStaticPart.getSignature().getDeclaringType();
    	assert classCollectionIsUnique(target_class) :location.getFileName() + ":" + location.getLine() + "\n" +
		"\tunique property invalid before " + thisJoinPoint + "\n" +
		"\tcollection has duplicated elements at positions "+
			Enforcer.unique_verification_first_element+" and "+
			Enforcer.unique_verification_second_element;
    }
	
	
	/**
	 * <b>AdviceType:</b> Before
	 * <p>
	 * <b>Scope:</b> Execution of destructors.
	 * <p>
	 * <b>Name:</b> beforeExecutionOfDestructor
	 * <p>
	 * 
	 * This advice verifies if before the execution of the class destructor the object's
	 * non-static state is valid.
	 * 
	 */
	@SuppressAjWarnings("adviceDidNotMatch")
    before(Object target_object): executionOfPossibleStateChangerDestructor(target_object)
    {
    	if(debug) 
    		System.out.println("Before destructor: ");
    	
		org.aspectj.lang.reflect.SourceLocation location = 
            thisJoinPointStaticPart.getSourceLocation();
		
		if(target_object == null)
			target_object = thisJoinPointStaticPart.getSignature().getDeclaringType();
		
        if(!instanceCollectionIsUnique(target_object))
			System.out.println(location.getFileName() + ":" + location.getLine() + "\n" +
		"\tunique property invalid before " + thisJoinPoint + "\n" +
		"\tcollection has duplicated elements at positions "+
			Enforcer.unique_verification_first_element+" and "+
			Enforcer.unique_verification_second_element);
    }
            
    /**
	 * <b>AdviceType:</b> Before
	 * <p>
	 * <b>Scope:</b> Set of instances collections.
	 * <p>
	 * <b>Name:</b> setOfInstancesCollections
	 * <p>
	 * 
	 * This advice captures the set of instances collections and saves them in the aspect maps.
	 * 
	 */
    @SuppressAjWarnings("adviceDidNotMatch")
	before(Object object, Collection unique_collection) : instancesUniqueCollectionSet(object, unique_collection)
	{
		if(debug) System.out.println("(Register) " + thisJoinPointStaticPart + " within " + thisEnclosingJoinPointStaticPart + " {");
		if(debug) System.out.println("\tRegistring part collection for " + thisJoinPointStaticPart.getSignature().toLongString() + ".");

		if(!unique_instances_collections.containsKey(object)) 
			unique_instances_collections.put(object,
				new HashMap<Signature, Collection>());
		
		
		final Signature signature = thisJoinPointStaticPart.getSignature();
		
		if(!unique_instances_collections.get(object).containsKey(signature) ||
				unique_instances_collections.get(object).get(signature) != unique_collection)					
			unique_instances_collections.get(object).put(signature, unique_collection);		
		
		if(debug) System.out.println("}");
	}
	

	/**
	 * <b>AdviceType:</b> Before
	 * <p>
	 * <b>Scope:</b> Set of class collections.
	 * <p>
	 * <b>Name:</b> setOfClassCollections
	 * <p>
	 * 
	 * This advice captures the set of class collections and saves them in the aspect maps.
	 * 
	 */
    @SuppressAjWarnings("adviceDidNotMatch")
	before(Collection unique_collection) : classUniqueCollectionSet(unique_collection)
	{
		if(debug) System.out.println("(Register) " + thisJoinPointStaticPart + " within " + thisEnclosingJoinPointStaticPart + " {");
		if(debug) System.out.println("\tRegistring part collection for " + thisJoinPointStaticPart.getSignature().toLongString() + ".");

		Object object = thisJoinPointStaticPart.getSignature().getDeclaringType();
		
		if(!unique_class_collections.containsKey(object)) 
			unique_class_collections.put(object,
				new HashMap<Signature, Collection>());
		
		
		final Signature signature = thisJoinPointStaticPart.getSignature();
		
		if(!unique_class_collections.get(object).containsKey(signature) ||
				unique_class_collections.get(object).get(signature) != unique_collection)					
			unique_class_collections.get(object).put(signature, unique_collection);		
		
		if(debug) System.out.println("}");
	}
	
	/*
	 * Declared Warnings and Errors
	 */
	
    /*
	 * Errors
	 */
	
	/*
	 * Declarations of fields not eligible to be declared with the <code>@Unique</code> qualifier.
	 */
	// Annotate an object, which is not a Collection, with the Unique qualifier
	declare error : scope() && !exclusions() && getOfNonStaticUniqueNonCollectionField()
    : "The non-static attribute being gotten can't be annotated with the Unique qualifier. Only a Collection can.";

	// Annotate an object, which is not a Collection, with the Unique qualifier
	declare error : scope() && !exclusions() && setOfNonStaticUniqueNonCollectionField()
	    : "The non-static attribute being set can't be annotated with the Unique qualifier. Only a Collection can.";

	// Annotate an object, which is not a Collection, with the Unique qualifier
	declare error : scope() && !exclusions() && getOfStaticUniqueNonCollectionField()
	    : "The static attribute being gotten can't be annotated with the Unique qualifier. Only a Collection can.";
	
	// Annotate an object, which is not a Collection, with the Unique qualifier
	declare error : scope() && !exclusions() && setOfStaticUniqueNonCollectionField()
	    : "The static attribute being set can't be annotated with the Unique qualifier. Only a Collection can.";

    
	/*
	 * Warnings
	 */
	
	/*
	 * Features, outside of scope, declared as <code>@Unique</code>.
	 */
	// Access to a attribute with the @Unique qualifier, outside the scope of the enforcement.
	declare warning : !scope() && !exclusions() && setOfUniqueField()
		: "The attribute being set is declared with the @Unique qualifier outside the scope of the enforcement.";
	
	// Access to a attribute with the @Unique qualifier, outside the scope of the enforcement.
	declare warning : !scope() && !exclusions() && getOfUniqueField()
		: "The attribute being gotten is declared with the @Unique qualifier outside the scope of the enforcement.";
    
	
	
	
    
    /*
	 * Methods
	 */	
		
	// TODO Search for a more elegant solution... Duplication of huge collections
	// into arrays will be of great cost to the application performance
	/**
	 * Checks if an instance's collection is unique.
	 * 
	 * @pre object != null
	 * @post true
	 * 
	 * @param object is the object whose unique property is to be validated. 
	 * 
	 * @return true if the instance's collection is unique, false otherwise.
	 */
	private static boolean instanceCollectionIsUnique(Object object) {
		if(debug) 
			System.out.println("Unique is valid of: " + object);
				
    	if(unique_instances_collections.containsKey(object))
    		for(Collection collection : unique_instances_collections.get(object).values())
    			if(!collection.isEmpty() && collection.size() > 1){
    				Object[] collection_in_array = collection.toArray();
    				for(int i=0; i < collection_in_array.length - 1; ++i)
    					for(int j=i+1; j < collection_in_array.length; ++j)
    						if(collection_in_array[i].equals(collection_in_array[j]))
    						{
    							Enforcer.unique_verification_first_element = i;
    							Enforcer.unique_verification_second_element = j;
    							return false;
    						}
    			}
    	    						       	  	    
    	return true;
    }
	
	
	// TODO Search for a more elegant solution... Duplication of huge collections
	// into arrays will be of great cost to the application performance
	/**
	 * Checks if an class's collection is unique.
	 * 
	 * @pre object != null
	 * @post true
	 * 
	 * @param target_class is the class whose unique property is to be validated. 
	 * 
	 * @return true if the class's collection is unique, false otherwise.
	 */
	private static boolean classCollectionIsUnique(Class target_class) {
		if(debug) 
			System.out.println("Unique is valid of: " + target_class);
				
    	if(unique_class_collections.containsKey(target_class))
    		for(Collection collection : unique_class_collections.get(target_class).values())
    			if(!collection.isEmpty() && collection.size() > 1){
    				Object[] collection_in_array = collection.toArray();
    				for(int i=0; i < collection_in_array.length - 1; ++i)
    					for(int j=i+1; j < collection_in_array.length; ++j)
    						if(collection_in_array[i].equals(collection_in_array[j]))
    						{
    							Enforcer.unique_verification_first_element = i;
    							Enforcer.unique_verification_second_element = j;
    							return false;
    						}
    			}
    	    						       	  	    
    	return true;
    }
	
		
    /*
	 * Attributes
	 */
	private static WeakHashMap<Object, HashMap<Signature, Collection>> unique_instances_collections =
    	new WeakHashMap<Object, HashMap<Signature, Collection>>();
	
	private static WeakHashMap<Object, HashMap<Signature, Collection>> unique_class_collections =
    	new WeakHashMap<Object, HashMap<Signature, Collection>>();
	
	private static int unique_verification_first_element = 0;
	private static int unique_verification_second_element = 0;
		
    private static boolean debug = false;
        
}


