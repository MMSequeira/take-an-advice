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

package pt.iscte.dsi.taa.policies.designbycontract;

import java.lang.reflect.Method;
import java.lang.reflect.Modifier;
import java.util.ArrayList;
import java.util.List;

import org.aspectj.lang.Aspects;
import org.aspectj.lang.JoinPoint.StaticPart;
import org.aspectj.lang.annotation.SuppressAjWarnings;

import pt.iscte.dsi.taa.helpers.EclipseConsoleHelper;
import pt.iscte.dsi.taa.policies.Pointcuts;
import pt.iscte.dsi.taa.qualifiers.InstancePrivate;
import pt.iscte.dsi.taa.qualifiers.NonState;
import pt.iscte.dsi.taa.qualifiers.StateModifier;
import pt.iscte.dsi.taa.qualifiers.StateValidator;

/**
 * The Design by Contract Policy addresses just one part of this technique, the class invariant.
 * It provides tools so that the designer can specify the operations responsible for the invariant
 * assertion. You can have one or more class invariant validators and they all must be declared with
 * the <code>@StateValidator</code> qualifier. The assertion’s value is the conjunction’s result of
 * all the <code>@StateValidator</code> operations. Any class declared with, at least, one valid
 * <code>@StateValidator</code> method is, hence, a <code>@StateValidated</code> class.
 * 
 * This Aspect represents the Design by Contract Policy Enforcer.
 * 
 * @version 1.0
 * @author Gustavo Cabral
 * @author Helena Monteiro
 * @author João Catarino
 * @author Tiago Moreiras
 */
public abstract aspect Enforcer pertypewithin(@(StateValidated || ClassStateValidated) *) {
		
	// Declare a class as StateValidated if there are, at least, one non static method
	// declared as StateValidator.
	declare @type : hasmethod(@StateValidator public !static final boolean *()) :  @StateValidated;
	
	// Declare a class as ClassStateValidated if there are, at least, one static method
	// declared as StateValidator.
	declare @type : hasmethod(@StateValidator public static final boolean *()) :  @ClassStateValidated;
	
    protected void errorHandler(final Object target, StaticPart static_part){
        assert stateIsValidOf(target) : "\n\tState invalid before execution of " +
        EclipseConsoleHelper.convertToHyperlinkFormat(static_part);
    }
    
	/*
	 * Pointcuts
	 */
	protected pointcut scope() : Pointcuts.all();
	private pointcut enforceable() : withinOfStateValidatedClass() || withinOfClassStateValidatedClass();
	
	/*
	 * Exclude pointcuts inside the Policy Enforcer
	 */  
	private pointcut exclusions() : within(Enforcer+);
	
	/*
	 * Auxiliar Pointcuts
	 */
	// Call
	private pointcut callToStateModifierMethod() : call(@StateModifier * *(..));
	private pointcut callToNonStaticStateModifierMethod() : call(@StateModifier !static * *(..));
	private pointcut callToStaticStateModifierMethod() : call(@StateModifier static * *(..));
	private pointcut callToStateValidatorMethod() : call(@StateValidator * *(..));
	private pointcut callToBooleanMethod() : call(boolean *(..));
	private pointcut callToMethodWithNoParameters() : call(* *());
	private pointcut callToNonFinalMethod() : call(!final * *(..));
	private pointcut callToFinalMethod() : call(final * *(..));
	
	private pointcut callToNonStaticValidStateValidatorMethod() :
		Pointcuts.callToNonStaticPublicMethod() && callToStateValidatorMethod() &&
		callToBooleanMethod() && callToMethodWithNoParameters() && callToFinalMethod();
	
	private pointcut callToValidStaticStateValidatorMethod() :
		Pointcuts.callToStaticPublicMethod() && callToStateValidatorMethod() &&
		callToBooleanMethod() && callToMethodWithNoParameters() && callToFinalMethod();;
	
	private pointcut callToNonFinalNonPrivateMethod() :
		callToNonFinalMethod() && Pointcuts.callToNonPrivateMethod();

	
	// Execution
	private pointcut executionOfStateValidatorMethod() : execution(@StateValidator * *(..));
	private pointcut executionOfBooleanMethod() : execution(boolean *(..));
	private pointcut executionOfMethodWithNoParameters() : execution(* *());
	private pointcut executionOfFinalMethod() : execution(final * *(..));
	
	private pointcut executionOfValidStateValidatorMethod() :
		Pointcuts.executionOfNonStaticPublicMethod() && executionOfStateValidatorMethod() &&
		executionOfBooleanMethod() && executionOfMethodWithNoParameters() && executionOfFinalMethod();
	
	private pointcut executionOfInvalidStateValidatorMethod() :
		executionOfStateValidatorMethod() && 
		!(Pointcuts.executionOfNonStaticPublicMethod() && executionOfBooleanMethod() &&
			executionOfMethodWithNoParameters() && executionOfFinalMethod());
	
	private pointcut executionOfPrivateMethodOrPrivateConstructor() :
		Pointcuts.executionOfPrivateMethod() || Pointcuts.executionOfPrivateConstructor();
	
	private pointcut executionOfNonStaticNonPrivateAndNonDestructorMethod() :
		Pointcuts.executionOfNonStaticNonPrivateMethod() && !Pointcuts.executionOfDestructor();
	
	private pointcut executionOfNonStaticPossibleStateChangerMethod() : 
		executionOfNonStaticNonPrivateAndNonDestructorMethod() &&
		!executionOfValidStateValidatorMethod();
	
	private pointcut executionOfPossibleStateChangerConstructor() : 
		Pointcuts.executionOfNonPrivateConstructor();
	
	private pointcut executionOfValidClassStateValidatorMethod() :
		Pointcuts.executionOfStaticPublicMethod() && executionOfStateValidatorMethod() &&
		executionOfBooleanMethod() && executionOfMethodWithNoParameters() && executionOfFinalMethod();
	
	private pointcut executionOfInvalidClassStateValidatorMethod() :
		executionOfStateValidatorMethod() && 
		!(Pointcuts.executionOfStaticPublicMethod() && executionOfBooleanMethod() &&
			executionOfMethodWithNoParameters() && executionOfFinalMethod());
	
	private pointcut executionOfPrivateMethodOrStaticInitializers() :
		Pointcuts.executionOfStaticPrivateMethod() || staticInitialization();
	
	private pointcut executionOfStaticPossibleStateChangerMethod() : 
		Pointcuts.executionOfStaticNonPrivateMethod() &&
		!executionOfValidClassStateValidatorMethod();
	

	
	
	// Static Initialization
	private pointcut staticInitialization() :  staticinitialization(*);
	
	// Get
	private pointcut getOfNonStaticNonStateField() : get(@NonState !static * *);
	private pointcut getOfNonStaticStateField() : get(!@NonState !static * *);
	private pointcut getOfStaticNonStateField() : get(@NonState static * *);
	private pointcut getOfStaticStateField() : get(!@NonState static * *);
	
	
	// Set
	private pointcut setOfNonStaticNonStateField() : set(@NonState !static * *);
	private pointcut setOfNonStaticStateField() : set(!@NonState !static * *);
	private pointcut setOfStaticNonStateField() : set(@NonState static * *);
	private pointcut setOfStaticStateField() : set(!@NonState static * *);
	private pointcut setOfStateField() : set(!@NonState * *);
	
	
	// Access (Get or Set)
	private pointcut accessToNonStaticNonStateField() : getOfNonStaticNonStateField() || setOfNonStaticNonStateField();
	private pointcut accessToStaticNonStateField() : getOfStaticNonStateField() || setOfStaticNonStateField();
	
	
	// Within
	private pointcut withinOfEnforcer() : within(Enforcer);
	private pointcut withinOfStateValidatedClass() : within(@StateValidated *);
	private pointcut withinOfClassStateValidatedClass() : within(@ClassStateValidated *);
	
	
	// Within Code
	private pointcut withinCodeOfNonStaticValidStateValidatorMethod() : withincode(@StateValidator !static public boolean *());
	private pointcut withinCodeOfStaticValidStateValidatorMethod() : withincode(@StateValidator static public boolean *());
	
	// Control Flow (cflow)
	private pointcut inTheControlFlowOfExecutionOfStateValidatorMethod() : cflow(executionOfStateValidatorMethod());
	
	
	
	
	/*
	 * Advice's Pointcuts
	 */
	private pointcut executionOfNonStaticPossibleStateChangerMethodOrConstructor(Object target_object) :
		scope() && !exclusions() && withinOfStateValidatedClass() &&
		(executionOfNonStaticPossibleStateChangerMethod() ||
		executionOfPossibleStateChangerConstructor()) &&
		target(target_object);
	
	private pointcut executionOfNonStaticPossibleStateChangerMethodWithTarget(Object target_object) :
		scope() && !exclusions() && withinOfStateValidatedClass() &&
		executionOfNonStaticPossibleStateChangerMethod() &&
		target(target_object);
	
	private pointcut executionOfPossibleStateChangerDestructor(Object target_object) :
		scope() && !exclusions() && withinOfStateValidatedClass() &&
		Pointcuts.executionOfDestructor() &&
		target(target_object);
	
	private pointcut executionOfPossibleStaticStateChangerMethodOrStaticInitializer() :
		scope() && !exclusions() && withinOfClassStateValidatedClass() &&
		(executionOfStaticPossibleStateChangerMethod() || staticInitialization());
		
	
	
		
	
	/*
	 * Advices
	 */
	
	/**
	 * <b>AdviceType:</b> After
	 * <p>
	 * <b>Scope:</b> Execution of non destructors, non private and non static methods or constructors
	 * 		   not declared as <code>@StateValidator</code>s.
	 * <p>
	 * <b>Name:</b> nonStaticNonPrivateMethodsAndConstructorsInStateValidatedClassEnforcer
	 * <p>
	 * 
     * This advice verifies if after the execution of non private and non static methods
     * or constructors, excluding methods declared as <code>@StateValidator</code>s, the object's state
     * is valid.
	 */		
	after(final Object target_object): 
		!inTheControlFlowOfExecutionOfStateValidatorMethod() &&
		executionOfNonStaticPossibleStateChangerMethodOrConstructor(target_object) {
		if(DEBUG) System.out.println("After method or constructor " + thisJoinPoint);

		assert stateIsValidOf(target_object) : "\n\tState invalid after execution of " +
			EclipseConsoleHelper.convertToHyperlinkFormat(thisJoinPointStaticPart);
    }
	
	/**
	 * <b>AdviceType:</b> After
	 * <p>
	 * <b>Scope:</b> Execution of non private and static methods or static initializers
	 * 		   not declared as <code>@StateValidator</code>s.
	 * <p>
	 * <b>Name:</b> staticNonPrivateMethodsAndStaticInitializersInStateValidatedClassEnforcer
	 * <p>
	 * 
	 * This advice verifies if after the execution of static initializers, non private and static
	 * methods, excluding methods declared as <code>@StateValidator</code>s, the object's state
	 * is valid.
	 * 
	 */		
	after(): !inTheControlFlowOfExecutionOfStateValidatorMethod() &&
		executionOfPossibleStaticStateChangerMethodOrStaticInitializer() {
		if(DEBUG) System.out.println("After method or static initializer " + thisJoinPoint);

		Class<?> target_class = thisJoinPointStaticPart.getSignature().getDeclaringType();
		
		assert classStateIsValidOf(target_class) : "\n\tState invalid after execution of " +
			EclipseConsoleHelper.convertToHyperlinkFormat(thisJoinPointStaticPart);
    }
    
	
	/**
	 * <b>AdviceType:</b> Before
	 * <p>
	 * <b>Scope:</b> Execution of non destructors, non private and non static methods
	 *         or constructors not being annotated with <code>@StateValidator/code>.
	 * <p>
	 * <b>Name:</b> nonPrivateNonStaticMethodsInStateValidatedClassEnforcer
	 * <p>
	 * 
     * This advice verifies if before the execution non private and non static
     * methods, excluding methods declared as <code>@StateValidator</code>s, the object's state
     * is valid.
	 * 
	 */	
    before(final Object target_object):
    	!inTheControlFlowOfExecutionOfStateValidatorMethod() &&
    	executionOfNonStaticPossibleStateChangerMethodWithTarget(target_object) { 
    	if(DEBUG) System.out.println("Before method: " + thisJoinPoint);

    	assert stateIsValidOf(target_object) : "\n\tState invalid before execution of " +
    		EclipseConsoleHelper.convertToHyperlinkFormat(thisJoinPointStaticPart);
    }
    
    
    /**
	 * <b>AdviceType:</b> Before
	 * <p>
	 * <b>Scope:</b> Execution of non private and static methods
	 *         or static initializers not being annotated with <code>@StateValidator/code>.
	 * <p>
	 * <b>Name:</b> nonPrivateStaticMethodsAndStaticInitializersInStateValidatedClassEnforcer
	 * <p>
	 * 
	 * This advice verifies if before the execution of static initializers, non private and static
	 * methods, excluding methods declared as <code>@StateValidator</code>s, the object's state
	 * is valid.
	 */	
    before(): !inTheControlFlowOfExecutionOfStateValidatorMethod() &&
    	executionOfStaticPossibleStateChangerMethod() {
    	if(DEBUG) System.out.println("Before method: " + thisJoinPoint);

    	Class<?> target_class = thisJoinPointStaticPart.getSignature().getDeclaringType();

    	assert classStateIsValidOf(target_class) : "\n\tState invalid before execution of " +
    		EclipseConsoleHelper.convertToHyperlinkFormat(thisJoinPointStaticPart);
    }

    
    /**
	 * <b>AdviceType:</b> Before
	 * <p>
	 * <b>Scope:</b> Execution of destructors.
	 * <p>
	 * <b>Name:</b> destructorInStateValidatedClassEnforcer
	 * <p>
	 * 
	 * This advice verifies if before the execution of the class destructor, the object's
	 * state is valid.
	 */
    @SuppressAjWarnings("adviceDidNotMatch")
    before(final Object target_object): !inTheControlFlowOfExecutionOfStateValidatorMethod() &&
    	executionOfPossibleStateChangerDestructor(target_object) { 
		if(DEBUG) System.out.println("Before destructor " + thisJoinPoint);

        errorHandler(target_object, thisJoinPointStaticPart);
    }
    
    /*
	 * Declared Warnings and Errors
	 */
	
    /*
	 * Errors
	 */

    /*
     * Declarations of method not eligible to be declared as <code>@StateValidator</code>.
     */    
    // Definition of how a instance StateValidator method should be declared.
    declare error : 
    	scope() && !exclusions() && enforceable() &&
    	executionOfInvalidStateValidatorMethod() && Pointcuts.executionOfNonStaticMethod()
        : "An instance @StateValidator must be non-static, final, public, return a boolean and have no parameters.";
    
        // Definition of how a class StateValidator method should be declared.
    declare error :
    	scope() && !exclusions() && enforceable() &&
    	executionOfInvalidClassStateValidatorMethod() && Pointcuts.executionOfStaticMethod() 
    	: "A class @StateValidator must be static, final, public, return a boolean and have no parameters.";

    	
    	
    /*
     * Methods declared as <code>@StateValidator</code> should enforce that the object's state remain
     * valid before and after any non-private execution. Fields declared as <code>@NonState</code>
     * aren't part of the object's state hence they should not be used in these methods.
     */	
        declare error : scope() && !exclusions() && enforceable() && 
        (withinCodeOfNonStaticValidStateValidatorMethod() || withinCodeOfStaticValidStateValidatorMethod()) &&
            accessToNonStaticNonStateField() : "A @StateValidator method cannot use @NonState attributes.";
    
    /*
     * Methods not declared as <code>@StateModifier</code>s being non final must have private accessibility
     * to be called by a <code>@StateValidator</code> method.
     */
            declare error : scope() && !exclusions() && enforceable() &&
            (withinCodeOfNonStaticValidStateValidatorMethod() || withinCodeOfStaticValidStateValidatorMethod()) &&
                callToNonFinalNonPrivateMethod() : "A @StateValidator method can only call non private methods if they are declared as final.";
    	
    /*
     * Methods declared as <code>@StateValidator</code> aren't supposed to change the object's state,
     * therefore they can't call <code>@StateModifier</code>s methods.
     */ 
                declare error : scope() && !exclusions() && enforceable() &&
                (withinCodeOfNonStaticValidStateValidatorMethod() || withinCodeOfStaticValidStateValidatorMethod()) &&
                    callToStateModifierMethod() : "A @StateValidator cannot change state, hence it cannot call a @StateModifier.";          
    	
    /*
	 * Warnings
	 */
    
    /*
     * One of the purposes of this policy is to enforce the class invariant assertion before and
     * after any public operation, thus, it is advisable to let the enforcer invoke the
     * StateValidator methods in the appropriate places. However, the user can invoke them at his
     * own risk. Invokation of <code>@StateValidator</code> methods, not by the enforcer, is
     * strongly unadvisable.
     * 
     * This warning checks if any <code>@StateValidator</code> method is invoked outside the
     * enforcer aspect.
     */
    declare warning : scope() && !exclusions() && enforceable() && !withinOfEnforcer() && callToStateValidatorMethod()
        : "A @StateValidator method should only be called by the enforcer.";
  
        	
    /*
     * Use of the <code>StateValidator</code> qualifier outside the scope of the enforcement.
     */	
    // Definition of a method declared as @StateValidator outside the scope of the enforcement.
    declare warning : !scope() && !exclusions() && executionOfStateValidatorMethod() 
    	: "Definition of method declared as @StateValidator outside the scope of the enforcement.";

    // Call to a method declared as @StateValidator outside the scope of the enforcement.
   	declare warning : !scope() && !exclusions() && callToStateValidatorMethod() 
    	: "The method being called is declared as @StateValidator outside the scope of the enforcement.";
    	
    	
    	
    	
    	
    /*
	 * Aspect Methods
	 */
       
    /**
	 * Updates the declared object's <code>@StateValidator</code> methods list.
	 * 
	 * @pre object != null
	 * @post non_static_state_validators != null
	 * 
	 * @param object is the dynamic object whose state validators are to be updated.
	 * 
	 */
    @InstancePrivate
    private void updateStateValidatorsOf(Object object) {
    	assert Aspects.aspectOf(this.getClass(), object.getClass()) == this : "Instantiation model is wrong??!!";
        	
       	non_static_state_validators = new ArrayList<Method>();
        	    	
       	for(Method method : object.getClass().getDeclaredMethods())
       		if(method.isAnnotationPresent(StateValidator.class) && !Modifier.isStatic(method.getModifiers()))
       			non_static_state_validators.add(method);
    }
    
    /**
	 * Updates the class's <code>@StateValidator</code> methods list.
	 * 
	 * @pre target_class != null
	 * @post static_state_validators != null
	 * 
	 * @param target_class is the class whose static state validators are to be updated.
	 *  
	 */
    @InstancePrivate
    private void updateClassStateValidatorsOf(Class<?> target_class) {
    	assert Aspects.aspectOf(this.getClass(), target_class) == this : "Instantiation model is wrong??!!";
        	
       	static_state_validators = new ArrayList<Method>();
        	    	
       	for(Method method : target_class.getDeclaredMethods())
       		if(method.isAnnotationPresent(StateValidator.class) && Modifier.isStatic(method.getModifiers()))
       			static_state_validators.add(method);
    }
    
    /**
	 * Verifies if the given object is in a valid state.
	 * 
	 * @pre object != null
	 * @post non_static_state_validators != null
	 * 
	 * @param object is the object whose state is to be checked.
	 * 
	 * @return conjunction's result of StateValidator declared methods invokation
	 */ 
    @InstancePrivate
    private boolean stateIsValidOf(Object object) {
    	// Lazy evalutation of the object's StateValidor declared methods list.
    	// If state validators list for this object hasn't been set, set it,
    	// otherwise, update it.
    	if(non_static_state_validators == null)
    		updateStateValidatorsOf(object);
        
    	// Invoke all StateValidator methods and if any is false invalidate the object's state.
        try {
            for(Method is_state_valid : non_static_state_validators) {
                Object result = is_state_valid.invoke(object);
                assert result instanceof Boolean : "Stored @StateValidators should always return Boolean. Something is VERY wrong.";
                if(!(Boolean)result)
                    return false;
            }
        // Catch exceptions in the invocation of the StateValidator methods.
        } catch (Exception exception) {
        	assert false : exception;
        }

        return true;
    }
    
    /**
	 * Verifies if the given object is in a valid state.
	 * 
	 * @pre object != null
	 * @post non_static_state_validators != null
	 * 
	 * @param target_class is the class whose state is to be checked.
	 * 
	 * @return conjunction's result of StateValidator declared methods invokation
	 */ 
    @InstancePrivate
    private boolean classStateIsValidOf(Class<?> target_class) {
    	// Lazy evalutation of the class's StateValidor declared methods list.
    	// If state validators list for this object hasn't been set, set it,
    	// otherwise, update it.
    	if(static_state_validators == null)
    		updateClassStateValidatorsOf(target_class);
        
    	// Invoke all StateValidator methods and if any is false invalidate the class's state.
        try {
            for(Method is_state_valid : static_state_validators) {
                Object result = is_state_valid.invoke(null);
                assert result instanceof Boolean : "Stored @StateValidators should always return Boolean. Something is VERY wrong.";
                if(!(Boolean)result)
                    return false;
            }
        // Catch exceptions in the invocation of the StateValidator methods.
        } catch (Exception exception) {
        	assert false : exception;
        }

        return true;
    }
    

    
     	
    /*
	 * Attributes
	 */
    @InstancePrivate
    private List<Method> non_static_state_validators = null;
    
    @InstancePrivate
    private List<Method> static_state_validators = null;
    
    //For Debug purposes only
    private static final boolean DEBUG = false;
}