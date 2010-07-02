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

package pt.iscte.dsi.taa.policies.relationships.association.ordered;

import java.util.Collection;
import java.util.HashMap;
import java.util.Iterator;
import java.util.WeakHashMap;

import org.aspectj.lang.Signature;
import org.aspectj.lang.annotation.SuppressAjWarnings;


import pt.iscte.dsi.taa.policies.Pointcuts;
import pt.iscte.dsi.taa.qualifiers.Ordered;

/*****************************************************************************************
 * 
 * This Aspect represents the Ordered Policy Enforcer.
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
		Pointcuts.executionOfPrivateMethod() || Pointcuts.executionOfPrivateConstructor();
	private pointcut executionOfNonStaticNonPrivateAndNonDestructorMethod() :
		Pointcuts.executionOfNonStaticNonPrivateMethod() && !Pointcuts.executionOfDestructor();
		
	
	// Static Initialization
	private pointcut staticInitialization() :  staticinitialization(*);
	
	
	// Get
	private pointcut getOfOrderedField() : get(@Ordered * *);
	private pointcut getOfCollectionField() : get(Collection+ *);
	private pointcut getOfComparableCollectionField() : get(Collection<Comparable+>+ *);
	private pointcut getOfNonCollectionField() : get(!Collection+ *);
	
	private pointcut getOfNonStaticOrderedField() :
		Pointcuts.getOfNonStaticField() && getOfOrderedField();
	private pointcut getOfStaticOrderedField() :
		Pointcuts.getOfStaticField() && getOfOrderedField();
	
	private pointcut getOfNonStaticOrderedCollectionField() :
		Pointcuts.getOfNonStaticField() && getOfOrderedField() && getOfCollectionField();
	private pointcut getOfStaticOrderedCollectionField() :
		Pointcuts.getOfStaticField() && getOfOrderedField() && getOfCollectionField();
	
	private pointcut getOfNonStaticOrderedNonComparableCollectionField() :
		Pointcuts.getOfNonStaticField() && getOfOrderedField() && !getOfComparableCollectionField();
	private pointcut getOfStaticOrderedNonComparableCollectionField() :
		Pointcuts.getOfStaticField() && getOfOrderedField() && !getOfComparableCollectionField();
	
		
	// Set
	private pointcut setOfOrderedField() : set(@Ordered * *);
	private pointcut setOfCollectionField() : set(Collection+ *);
	private pointcut setOfComparableCollectionField() : set(Collection<Comparable+>+ *);
	private pointcut setOfNonCollectionField() : set(!Collection+ *);
	
	private pointcut setOfNonStaticOrderedField() :
		Pointcuts.setOfNonStaticField() && setOfOrderedField();
	private pointcut setOfStaticOrderedField() :
		Pointcuts.setOfStaticField() && setOfOrderedField();
	
	private pointcut setOfNonStaticOrderedCollectionField() :
		Pointcuts.setOfNonStaticField() && setOfOrderedField() && setOfCollectionField();
	private pointcut setOfStaticOrderedCollectionField() :
		Pointcuts.setOfStaticField() && setOfOrderedField() && setOfCollectionField();
	
	private pointcut setOfNonStaticOrderedNonComparableCollectionField() :
		Pointcuts.setOfNonStaticField() && setOfOrderedField() && !setOfComparableCollectionField();
	private pointcut setOfStaticOrderedNonComparableCollectionField() :
		Pointcuts.setOfStaticField() && setOfOrderedField() && !setOfComparableCollectionField();
	
		
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
	private pointcut instancesOrderedCollectionSet(Object object, Collection<?> collection) :
		scope() && !exclusions() &&
		setOfNonStaticOrderedCollectionField() &&
		target(object) && args(collection);
	
	private pointcut classOrderedCollectionSet(Collection<?> collection) :
		scope() && !exclusions() &&
		setOfStaticOrderedCollectionField() &&
		args(collection);
	

	/*
	 * Non-Static executions
	 */
	private pointcut executionOfPossibleNonStaticStateChangerMethodOrConstructor(Object target_object) :
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
	private pointcut executionOfPossibleStaticStateChangerMethodOrStaticInitialization() :
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
				
			assert instanceCollectionIsOrdered(target_object) :location.getFileName() + ":" + location.getLine() + "\n" +
			"\tordered property invalid before " + thisJoinPoint + "\n" +
			"\tcollection has unordered element at position "+
				Enforcer.order_verification;
		
			Class<?> target_class = thisJoinPointStaticPart.getSignature().getDeclaringType();
			assert classCollectionIsOrdered(target_class) :location.getFileName() + ":" + location.getLine() + "\n" +
			"\tordered property invalid before " + thisJoinPoint + "\n" +
			"\tcollection has unordered element at position "+
				Enforcer.order_verification;
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
		
		Class<?> target_class = thisJoinPointStaticPart.getSignature().getDeclaringType();
		assert classCollectionIsOrdered(target_class) :location.getFileName() + ":" + location.getLine() + "\n" +
		"\tordered property invalid before " + thisJoinPoint + "\n" +
		"\tcollection has unordered element at position "+
			Enforcer.order_verification;
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
    	
	    assert instanceCollectionIsOrdered(target_object) :location.getFileName() + ":" + location.getLine() + "\n" +
			"\tordered property invalid before " + thisJoinPoint + "\n" +
			"\tcollection has unordered elements at position "+
				Enforcer.order_verification;

	    Class<?> target_class = thisJoinPointStaticPart.getSignature().getDeclaringType();
		assert classCollectionIsOrdered(target_class) :location.getFileName() + ":" + location.getLine() + "\n" +
			"\tordered property invalid before " + thisJoinPoint + "\n" +
			"\tcollection has unordered elements at position "+
				Enforcer.order_verification;
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

    	Class<?> target_class = thisJoinPointStaticPart.getSignature().getDeclaringType();
    	assert classCollectionIsOrdered(target_class) :location.getFileName() + ":" + location.getLine() + "\n" +
		"\tordered property invalid before " + thisJoinPoint + "\n" +
		"\tcollection has unordered elements at position "+
			Enforcer.order_verification;
	
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
		
        if(!instanceCollectionIsOrdered(target_object))
        	System.out.println(location.getFileName() + ":" + location.getLine() + "\n" +
        			"\tordered property invalid before " + thisJoinPoint + "\n" +
        			"\tcollection has unordered element at position "+
        				Enforcer.order_verification);
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
	before(Object object, Collection<?> orderedCollection) : instancesOrderedCollectionSet(object, orderedCollection)
	{
		if(debug) System.out.println("(Register) " + thisJoinPointStaticPart + " within " + thisEnclosingJoinPointStaticPart + " {");
		if(debug) System.out.println("\tRegistring part collection for " + thisJoinPointStaticPart.getSignature().toLongString() + ".");

		if(!instances_ordered_collections.containsKey(object)) 
			instances_ordered_collections.put(object,
				new HashMap<Signature, Collection<?>>());
		
		final Signature signature = thisJoinPointStaticPart.getSignature();
		
		if(!instances_ordered_collections.get(object).containsKey(signature) ||
				instances_ordered_collections.get(object).get(signature) != orderedCollection)					
			instances_ordered_collections.get(object).put(signature, orderedCollection);		
		
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
	before(Collection<?> orderedCollection) : classOrderedCollectionSet(orderedCollection)
	{
		if(debug) System.out.println("(Register) " + thisJoinPointStaticPart + " within " + thisEnclosingJoinPointStaticPart + " {");
		if(debug) System.out.println("\tRegistring part collection for " + thisJoinPointStaticPart.getSignature().toLongString() + ".");

		Object object = thisJoinPointStaticPart.getSignature().getDeclaringType();
		
		if(!class_ordered_collections.containsKey(object)) 
			class_ordered_collections.put(object,
				new HashMap<Signature, Collection<?>>());
		
		
		final Signature signature = thisJoinPointStaticPart.getSignature();
		
		if(!class_ordered_collections.get(object).containsKey(signature) ||
				class_ordered_collections.get(object).get(signature) != orderedCollection)					
			class_ordered_collections.get(object).put(signature, orderedCollection);		
		
		if(debug) System.out.println("}");
	}
	
	
   	/*
	 * Declared Warnings and Errors
	 */
	
	/*
	 * Errors
	 */

	/*
	 * Declarations of fields not eligible to be declared with the <code>@Ordered</code> qualifier.
	 */
	// Annotate an object, which is not a Collection, with the Ordered qualifier
	declare error : scope() && !exclusions() && getOfNonStaticOrderedNonComparableCollectionField()
        : "The non-static attribute being gotten can't be annotated with the Ordered qualifier. Only a Collection can.";
	
	// Annotate an object, which is not a Collection, with the Ordered qualifier
    declare error : scope() && !exclusions() && setOfNonStaticOrderedNonComparableCollectionField()
        : "The non-static attribute being set can't be annotated with the Ordered qualifier. Only a Collection can.";
    
	// Annotate an object, which is not a Collection, with the Ordered qualifier
	declare error : scope() && !exclusions() && getOfStaticOrderedNonComparableCollectionField()
        : "The static attribute being gotten can't be annotated with the Ordered qualifier. Only a Collection can.";
	
	// Annotate an object, which is not a Collection, with the Ordered qualifier
    declare error : scope() && !exclusions() && setOfStaticOrderedNonComparableCollectionField()
        : "The static attribute being set can't be annotated with the Ordered qualifier. Only a Collection can.";
    
      
    /*
	 * Warnings
	 */
    
	/*
	 * Features, outside of scope, declared as <code>@Ordered</code>.
	 */
	// Access to a attribute with the @Ordered qualifier, outside the scope of the enforcement.
	declare warning : !scope() && !exclusions() && setOfOrderedField()
		: "The attribute being set is declared with the @Ordered qualifier outside the scope of the enforcement.";
	
	// Access to a attribute with the @Ordered qualifier, outside the scope of the enforcement.
	declare warning : !scope() && !exclusions() && getOfOrderedField()
		: "The attribute being gotten is declared with the @Ordered qualifier outside the scope of the enforcement.";
    
   
    
    /*
	 * Methods
	 */	
	
    /**
	 * Checks if an instance's collection is ordered.
	 * 
	 * @pre object != null
	 * @post true
	 * 
	 * @param object is the object whose ordered property is to be validated.
	 * 
	 * @return true if the instance's collection is ordered, false otherwise.
	 */
	private static boolean instanceCollectionIsOrdered(Object object) {
		if(debug) 
			System.out.println("Order is valid of: " + object);
				
    	if(instances_ordered_collections.containsKey(object))
    		for(Collection collection : instances_ordered_collections.get(object).values()){
    			if(!collection.isEmpty() && collection.size() > 1){
    				Enforcer.order_verification = 1;
	    			@SuppressWarnings("unchecked")
    				Iterator<Comparable> iterator = collection.iterator();
	        		Comparable<?> previous_element = iterator.next();
	        		while(iterator.hasNext())
	        		{
	        			@SuppressWarnings("unchecked")
	        			Comparable<Comparable> current_element = iterator.next();
	        			if(current_element.compareTo(previous_element) < 0)
	        				return false;
	        			else{
	        				previous_element = current_element;
	        				Enforcer.order_verification++;
	        			}
	        		}
    			}
    		}
    	  	    
    	return true;
    }
	
    /**
	 * Checks if an class's collection is ordered.
	 * 
	 * @pre object != null
	 * @post true
	 * 
	 * @param target_class is the class whose ordered property is to be validated.
	 * 
	 * @return true if the class's collection is ordered, false otherwise.
	 */
	private static boolean classCollectionIsOrdered(Class target_class) {
		if(debug) 
			System.out.println("Order is valid of: " + target_class);
				
    	if(class_ordered_collections.containsKey(target_class))
    		for(Collection collection : class_ordered_collections.get(target_class).values()){
    			if(!collection.isEmpty() && collection.size() > 1){
    				Enforcer.order_verification = 1;
	    			@SuppressWarnings("unchecked")
    				Iterator<Comparable> iterator = collection.iterator();
	        		Comparable<?> previous_element = iterator.next();
	        		while(iterator.hasNext())
	        		{
	        			@SuppressWarnings("unchecked")
	        			Comparable<Comparable> current_element = iterator.next();
	        			if(current_element.compareTo(previous_element) < 0)
	        				return false;
	        			else{
	        				previous_element = current_element;
	        				Enforcer.order_verification++;
	        			}
	        		}
    			}
    		}
    	  	    
    	return true;
    }
	
		
    /*
	 * Attributes
	 */
	
	private static WeakHashMap<Object, HashMap<Signature, Collection<?>>> instances_ordered_collections =
    	new WeakHashMap<Object, HashMap<Signature, Collection<?>>>();
	
	private static WeakHashMap<Object, HashMap<Signature, Collection<?>>> class_ordered_collections =
    	new WeakHashMap<Object, HashMap<Signature, Collection<?>>>();
	
	private static int order_verification = 0;
	
    private static boolean debug = false;   
}


