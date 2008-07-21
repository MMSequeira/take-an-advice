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

package pt.iscte.dcti.policies.accessibility.instances;

import pt.iscte.dcti.qualifiers.InstancePrivate;

import pt.iscte.dcti.policies.Idiom;
import pt.iscte.dcti.policies.stack.*;

import java.lang.reflect.Method;

import java.util.Stack;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.aspectj.lang.JoinPoint;

/*******************************************************************************
 * 
 * This Aspect represents the Accessibility Instances Policy Enforcer.
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
	 * Exclude pointcuts inside the Policy Enforcer.
	 */  
	private pointcut exclusions() : within(Enforcer+);
	
	/*
	 * Pointcuts
	 */
	
	/*
	 * Auxiliar Pointcuts
	 */
	
	// Call
	private pointcut callToInstancePrivateMethod() : call(@InstancePrivate * *(..));
	private pointcut callToNonInstancePrivateMethod() : call(!@InstancePrivate * *(..));
	
	private pointcut callToStaticInstancePrivateMethod() :
		Idiom.callToStaticMethod() && callToInstancePrivateMethod();
	
	private pointcut callToNonStaticInstancePrivateMethod() :
		Idiom.callToNonStaticMethod() && callToInstancePrivateMethod();
	private pointcut callToNonStaticNonPrivateInstancePrivateMethod() :
		Idiom.callToNonStaticNonPrivateMethod() && callToInstancePrivateMethod();
		
	
	// Execution
	private pointcut executionOfInstancePrivateMethod() : execution(@InstancePrivate * *(..));
	private pointcut executionOfNonInstancePrivateMethod() : execution(!@InstancePrivate * *(..));

	private pointcut executionOfStaticInstancePrivateMethod() :
		Idiom.executionOfStaticMethod() && executionOfInstancePrivateMethod();
	
	private pointcut executionOfNonStaticInstancePrivateMethod() :
		Idiom.executionOfNonStaticMethod() && executionOfInstancePrivateMethod();
	private pointcut executionOfNonStaticNonPrivateInstancePrivateMethod() :
		Idiom.executionOfNonStaticNonPrivateMethod() && executionOfInstancePrivateMethod();

	
	// Get
	private pointcut getOfInstancePrivateField() : get(@InstancePrivate * *);
	private pointcut getOfNonInstancePrivateField() : get(!@InstancePrivate * *);
	
	private pointcut getOfStaticInstancePrivateField() :
		Idiom.getOfStaticField() && getOfInstancePrivateField();
	
	private pointcut getOfNonStaticInstancePrivateField() :
		Idiom.getOfNonStaticField() && getOfInstancePrivateField();
	private pointcut getOfNonStaticNonPrivateInstancePrivateField() :
		Idiom.getOfNonStaticNonPrivateField() && getOfInstancePrivateField();
		

	// Set
	private pointcut setOfInstancePrivateField() : set(@InstancePrivate * *);
	private pointcut setOfNonInstancePrivateField() : set(!@InstancePrivate * *);
	
	private pointcut setOfStaticInstancePrivateField() :
		Idiom.setOfStaticField() && setOfInstancePrivateField();
	
	private pointcut setOfNonStaticInstancePrivateField() :
		Idiom.setOfNonStaticField() && setOfInstancePrivateField();
	private pointcut setOfNonStaticNonPrivateInstancePrivateField() :
		Idiom.setOfNonStaticNonPrivateField() && setOfInstancePrivateField();
	
	
	// Access (Get or Set)
	private pointcut accessToInstancePrivateField() :
		getOfInstancePrivateField() || setOfInstancePrivateField();
	
	private pointcut accessToNonStaticInstancePrivateField() :
		getOfNonStaticInstancePrivateField() || setOfNonStaticInstancePrivateField();
	private pointcut accessToNonStaticNonPrivateInstancePrivateField() :
		getOfNonStaticNonPrivateInstancePrivateField() || setOfNonStaticNonPrivateInstancePrivateField();
	
	private pointcut accessToNonStaticInstancePrivateFeatureFromStaticMethod() :
		(callToNonStaticInstancePrivateMethod() || accessToNonStaticInstancePrivateField()) && withinCodeOfStaticMethod();	
	
	private pointcut accessToStaticPrivateFeatureFromNonStaticMethod() :
		(Idiom.callToStaticPrivateMethod() || Idiom.accessToStaticPrivateField()) && withinCodeOfNonStaticMethod();

	
	// Within Code
	private pointcut withinCodeOfNonStaticInstancePrivateMethod() : withincode(@InstancePrivate !static * *(..));
	private pointcut withinCodeOfStaticMethod() : withincode(static * *(..));
	private pointcut withinCodeOfNonStaticMethod() : withincode(!static * *(..));
	
	
	// Control Flow (cflow)
	private pointcut inTheControlFlowOfDynamicCallToMethod() : cflow(call(* Method.invoke(..)));
	
	
	/*
	 * Advice's Pointcuts
	 */
	private pointcut callToNonStaticInstancePrivateAnnotatedMethod() :
		scope() && !exclusions() &&
		callToNonStaticInstancePrivateMethod();
	
	private pointcut executionOfNonStaticInstancePrivateAnnotatedMethod() :
		scope() && !exclusions() &&
		executionOfNonStaticInstancePrivateMethod();
	
	private pointcut accessToInstancePrivateAnnotatedField() :
		scope() && !exclusions() &&
		accessToNonStaticInstancePrivateField();
	
	private pointcut thisAndTargetAreNotEqual(Object this_object, Object target_object) : 
		this(this_object) && target(target_object) && if(this_object != target_object);
	
	
	/*
	 * Advices
	 */
	
	/**
	 * <b>AdviceType:</b> Before
	 * <p>
	 * <b>Scope:</b> Calls to methods or accesses to attributes declared as <code>@InstancePrivate</code>.
	 * <p>
	 * <b>Name:</b> instanceMethodsAndAttributesAccessEnforcer
	 * <p>
	 * This advice verifies if the annotated methods or attributes are accessed only by the
	 * instance itself.
	 * 
	 * @throws IllegalAccess if the method is accessed by other instances.
	 */	
	before (Object this_object, Object target_object) :
		(callToNonStaticInstancePrivateAnnotatedMethod() || accessToNonStaticInstancePrivateField()) &&
		thisAndTargetAreNotEqual(this_object, target_object)
	{
		throw new IllegalAccess("\n\tAccess to a declared instance private feature." +
			"\n\tInvalid access from " + thisEnclosingJoinPointStaticPart.toString() +
			"\n\tto " + thisJoinPointStaticPart.toString() + ".");
	}
	
	
	/**
	 * <b>AdviceType:</b> Before
	 * <p>
	 * <b>Scope:</b> Accesses to non private methods annotated with
	 *         <code>@InstancePrivate</code> through dynamic method invocation.
	 * <p>
	 * <b>Name:</b> instanceMethodsDynamicInvocationAccessEnforcer
	 * <p>
	 * This advice verifies if the annotated private methods dynamically invoked
	 * are accessed by a different instance.
	 * 
	 * @throws IllegalAccess if the method is accessed by other instances.
	 */	
	before () : inTheControlFlowOfDynamicCallToMethod() &&
				executionOfNonStaticInstancePrivateAnnotatedMethod()
	{		
		if(StackReplica.getStack().size() >= 2)
		{
			Stack<JoinPoint> stack = StackReplica.getStack();
			Object this_object =  stack.get(stack.size()-2).getThis();
			Object target_object =  stack.lastElement().getThis();
			
			if(this_object != target_object)
				throw new IllegalAccess("\n\tAccess to declared instance private method through dynamic method invocation." +
					"\n\tInvalid access from " + stack.get(stack.size()-2).toString() +
					"\n\tto call(" + thisJoinPointStaticPart.getSignature() + ").");
		} else
			assert false : "Unexpected Stack State.";
	}
	
	
	/**
	 * <b>AdviceType:</b> Before
	 * <p>
	 * <b>Scope:</b> Executions of methods annotated with <code>@InstancePrivate</code>.
	 * <p>
	 * <b>Name:</b> instanceMethodsDynamicInvocationAccessEnforcer
	 * <p>
	 * This advice verifies the signatures of the executed methods checking if
	 * they override a superclass method and strengthen its precondition.
	 * 
	 * @throws InvalidMethodDefinition if the accessor class has restricted access.
	 */	
	before () : executionOfNonStaticInstancePrivateAnnotatedMethod(){
		Class<?> accessed_class = thisJoinPointStaticPart.getSignature().getDeclaringType();
		
		// Obtains called method
		// Call Signature
		String long_signature = thisJoinPointStaticPart.getSignature().toLongString();
		long_signature = long_signature.replaceAll(", ", ",");
		
		// Class methods list
		Method[] methods = accessed_class.getDeclaredMethods();
		Method method_test = null;
		// Foreach method in the list check if the signature equals the one of
		// the invoked method
		for(Method method : methods){
			if(method.toString().equals(long_signature))
				method_test = method;
		}
		
		if(methodStrengthensSuperclassMethodAccessControl(accessed_class, method_test))
			throw new InvalidMethodDefinition("\n\tCannot reduce the accessibility of the inherited method '" +
				thisJoinPointStaticPart.getSignature() + "'\n\tfrom '" +
				methodAccessControlWeakenedSuperclass(accessed_class, method_test) + "'");		
	}
	
	
		
	/*
	 * Declared Warnings and Errors
	 */
	
	/*
	 * Errors
	 */
	
	/*
	 * Static features declared as <code>InstancePrivate</code>.
	 */
	// Definition of a static method declared as <code>InstancePrivate</code>.
	declare error : scope() && !exclusions() && executionOfStaticInstancePrivateMethod()
		: "A static method can't be declared as InstancePrivate.";

	// Call to a static method declared as <code>InstancePrivate</code>.
	declare error : scope() && !exclusions() && callToStaticInstancePrivateMethod()
		: "The static method being called can't be declared as InstancePrivate.";

	// Access to a private attribute declared as <code>InstancePrivate</code>.
	declare error : scope() && !exclusions() && getOfStaticInstancePrivateField()
		: "The static attribute being gotten can't be declared as InstancePrivate.";

	// Access to a private attribute declared as <code>InstancePrivate</code>.
	declare error : scope() && !exclusions() && setOfStaticInstancePrivateField()
		: "The static attribute being set can't be declared as InstancePrivate.";
		
	
	
	/*
	 * A simple checker. Checks for illegal access to non static features from static methods.
	 */
	// Access to non static instance private feature from static method.
	declare error : scope() && !exclusions() && accessToNonStaticInstancePrivateFeatureFromStaticMethod()
		: "Promiscuous access from class, non-instance method, to instance private feature.";

	// Access to static private feature from non static method.
	declare error : scope() && !exclusions() && accessToStaticPrivateFeatureFromNonStaticMethod()
		: "Promiscuous access from instance method to class, non-instance, private feature.";
	
	
	
	/*
	 * Warnings
	 */
	
	/*
	 * Public, protected or package private features declared as <code>InstancePrivate</code> .
	 */
	// Definition of a non private method with the InstancePrivate qualifier.
	declare warning : scope() && !exclusions() && executionOfNonStaticNonPrivateInstancePrivateMethod()
		: "A method declared as instance private should have private accessibility.";

	// Call to a non private method with the InstancePrivate qualifier.
	declare warning : scope() && !exclusions() && callToNonStaticNonPrivateInstancePrivateMethod()
		: "The method being called is declared as instance private having non private accessibility.";

	// Access to a non private attribute with the InstancePrivate qualifier.
	declare warning : scope() && !exclusions() && getOfNonStaticNonPrivateInstancePrivateField()
		: "The private attribute being gotten is declared as instance private having non private accessibility.";

	// Access to a non private attribute with the InstancePrivate qualifier.
	declare warning : scope() && !exclusions() && setOfNonStaticNonPrivateInstancePrivateField()
		: "The private attribute being set is declared as instance private having non private accessibility.";
	
	
	
	/*
	 * Features, outside of scope, declared as <code>InstancePrivate</code>.
	 */
	// Definition of a non static method with the InstancePrivate qualifier, outside the scope.
	declare warning : !scope() && !exclusions() && executionOfNonStaticInstancePrivateMethod()
		: "Definition of method declared as instance private in a class outside the scope of the enforcement.";

	// Call to a non static method with the InstancePrivate qualifier, outside the scope.
	declare warning : !scope() && !exclusions() && callToNonStaticInstancePrivateMethod()
		: "The method being called is declared as instance private in a class outside the scope of the enforcement.";

	// Access to a non static attribute with the InstancePrivate qualifier, outside the scope.
	declare warning : !scope() && !exclusions() && setOfNonStaticInstancePrivateField()
		: "The attribute being set is declared as instance private in a class outside the scope of the enforcement.";

	// Access to a non static attribute with the InstancePrivate qualifier, outside the scope.
	declare warning : !scope() && !exclusions() && getOfNonStaticInstancePrivateField()
		: "The attribute being gotten is declared as instance private in a class outside the scope of the enforcement.";
	
	
	
	/*
	 * Aspect Methods
	 */
	
	/**
	 * Verifies if the accessibility specified in the class method strengthens the
	 * accessibility of an overriden superclass method. According to the Liskov
	 * substitution principle an override method must never strengthen the
	 * pre-condition of the one overriden.
	 * <p>
	 * This function is used when the annotation is applied in sub-class.
	 * 
	 * @pre method != null
	 * @post true
	 * 
	 * @param method_class class where the <code>method</code> is supposed to be.
	 * @param method method to check.
	 * 
	 * @return true if it strengthens, false otherwise.
	 * 
	 * @see {@link http://en.wikipedia.org/wiki/Liskov_substitution_principle}
	 */
	@InstancePrivate
	private boolean methodStrengthensSuperclassMethodAccessControl(Class<?> method_class, Method method)
	{
		if(method_class == null)
			return false;
		else
		{
			String method_signature = "";
			String method_pattern = "(?<=\\.)\\w*\\(.*\\)";
			Pattern pattern = Pattern.compile(method_pattern);
			Matcher matcher = pattern.matcher(method.toString());
			if (matcher.find()) {
				int start = matcher.start();
				int end = matcher.end();
				method_signature = method.toString().substring(start, end);
			}
			
			for(Method other_method : method_class.getDeclaredMethods()){
				String other_method_signature = "";
				matcher = pattern.matcher(other_method.toString());
				if (matcher.find()) {
					int start = matcher.start();
					int end = matcher.end();
					other_method_signature = other_method.toString().substring(start, end);
				}
							
				if(other_method_signature.equals(method_signature))
					if(!other_method.isAnnotationPresent(InstancePrivate.class))
						return true;
			}
				
			Class superclass = method_class.getSuperclass();
			if(methodStrengthensSuperclassMethodAccessControl(superclass, method))
				return true;
			
			
			Class[] interfaces_inherited = method_class.getInterfaces();
			for(Class interface_inherited : interfaces_inherited)
				if(methodStrengthensSuperclassMethodAccessControl(interface_inherited, method))
					return true;
				
			return false;		
		}
	}
	
	/**
	 * Returns the class or interface where the overriden method is defined.
	 * 
	 * @pre method != null
	 * @post true
	 * 
	 * @param method_class class where the <code>method</code> is supposed to be.
	 * @param method method to check.
	 * 
	 * @return enclosing class if it strengthens, own class otherwise.
	 */
	@InstancePrivate
	private Class methodAccessControlWeakenedSuperclass(Class<?> method_class, Method method)
	{
		Class superclass = method_class.getSuperclass();
		if(methodStrengthensSuperclassMethodAccessControl(superclass, method))
			return superclass;
		
		Class[] interfaces_inherited = method_class.getInterfaces();
		for(Class interface_inherited : interfaces_inherited)
			if(methodStrengthensSuperclassMethodAccessControl(interface_inherited, method))
				return interface_inherited;
		
		return method_class;		
	}
}
