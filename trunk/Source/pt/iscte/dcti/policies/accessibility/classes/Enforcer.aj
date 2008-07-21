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

package pt.iscte.dcti.policies.accessibility.classes;

import org.aspectj.lang.JoinPoint;

import java.lang.reflect.Method;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import java.util.Stack;

import pt.iscte.dcti.policies.Idiom;

import pt.iscte.dcti.qualifiers.AccessibleFrom;
import pt.iscte.dcti.qualifiers.InstancePrivate;

import pt.iscte.dcti.policies.stack.*;

/**
 *  
 * This Aspect represents the Accessibility Classes Policy Enforcer.
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
	private pointcut callToAccessibleFromMethod() : call(@AccessibleFrom * *(..));
	private pointcut callToNonPrivateAccessibleFromMethod() :
		Idiom.callToNonPrivateMethod() && callToAccessibleFromMethod();
	private pointcut callToPrivateAccessibleFromMethod() :
		Idiom.callToPrivateMethod() && callToAccessibleFromMethod();
	
	// Execution
	private pointcut executionOfAccessibleFromMethod() : execution(@AccessibleFrom * *(..));
	private pointcut executionOfNonPrivateAccessibleFromMethod() :
		Idiom.executionOfNonPrivateMethod() && executionOfAccessibleFromMethod();
	private pointcut executionOfPrivateAccessibleFromMethod() :
		Idiom.executionOfPrivateMethod() && executionOfAccessibleFromMethod();
	
	// Get
	private pointcut getOfAccessibleFromField() : get(@AccessibleFrom * *);
	private pointcut getOfNonPrivateAccessibleFromField() :
		Idiom.getOfNonPrivateField() && getOfAccessibleFromField();
	private pointcut getOfPrivateAccessibleFromField() :
		Idiom.getOfPrivateField() && getOfAccessibleFromField();
	
	// Set
	private pointcut setOfAccessibleFromField() : set(@AccessibleFrom * *);
	private pointcut setOfNonPrivateAccessibleFromField() :
		Idiom.setOfNonPrivateField() && setOfAccessibleFromField();
	private pointcut setOfPrivateAccessibleFromField() :
		Idiom.setOfPrivateField() && setOfAccessibleFromField();
	
	// Access (Get or Set)
	private pointcut accessToAccessibleFromField() :
		getOfAccessibleFromField() || setOfAccessibleFromField();
	private pointcut accessToNonPrivateAccessibleFromField() :
		getOfNonPrivateAccessibleFromField() || setOfNonPrivateAccessibleFromField();
	
	// Control Flow (cflow)
	private pointcut inTheControlFlowOfDynamicCallToMethod() : cflow(call(* Method.invoke(..)));
		
	/*
	 * Advice's Pointcuts
	 */
	
	private pointcut callToAccessibleFromAnnotatedMethod(AccessibleFrom annotation) :
		scope() && !exclusions() &&
		callToAccessibleFromMethod() &&
		@annotation(annotation);
	
	private pointcut callToNonPrivateAccessibleFromAnnotatedMethod(AccessibleFrom annotation) :
		scope() && !exclusions() &&
		callToNonPrivateAccessibleFromMethod() &&
		@annotation(annotation);
	
	private pointcut executionOfAccessibleFromAnnotatedMethod(AccessibleFrom annotation) :
		scope() && !exclusions() &&
		executionOfAccessibleFromMethod() &&
		@annotation(annotation);
	
	private pointcut executionOfNonPrivateAccessibleFromAnnotatedMethod(AccessibleFrom annotation) :
		scope() && !exclusions() &&
		executionOfNonPrivateAccessibleFromMethod() &&
		@annotation(annotation);
	
	private pointcut accessToNonPrivateField() :
		scope() && !exclusions() &&
		Idiom.accessToNonPrivateField();
	
	private pointcut accessToAccessibleFromAnnotatedField(AccessibleFrom annotation) :
		scope() && !exclusions() &&
		accessToAccessibleFromField() &&
		@annotation(annotation);
	
	private pointcut accessToNonPrivateAccessibleFromAnnotatedField(AccessibleFrom annotation) :
		scope() && !exclusions() &&
		accessToNonPrivateAccessibleFromField() &&
		@annotation(annotation);
	
		
	/*
	 * Advices
	 */
	
	/**
	 * <b>AdviceType:</b> Before
	 * <p>
	 * <b>Scope:</b> Calls to non private methods annotated with <code>@AccessibleFrom</code>.
	 * <p>
	 * <b>Name:</b> nonPrivateMethodsAccessEnforcer
	 * <p>
	 * This advice verifies if the annotated private methods are accessed by an
	 * allowed class. The class itself and its specializations have access and 
	 * if the accessor class doesn't belong to the annotation's given set of
	 * classes the access is restricted and an exception thrown.
	 *  
	 * @throws IllegalAccess if the accessor class has restricted access.
	 * 
	 */	
	before (AccessibleFrom annotation) : callToNonPrivateAccessibleFromAnnotatedMethod(annotation) {
		System.out.println("Passei aqui");
		Class<?> accessorClass = thisEnclosingJoinPointStaticPart.getSignature().getDeclaringType();
		Class<?> accessedClass = thisJoinPointStaticPart.getSignature().getDeclaringType();
		
		// The declaring class and its specializations always have access to the
		// method:
		boolean accessIsValid = accessorClass == accessedClass || accessedClass.isAssignableFrom(accessorClass);
		
		if(!accessIsValid){
			for(Class<?> valid_class : annotation.value())
				if(accessorClass == valid_class) 
					accessIsValid = true;
						
			
			if(!accessIsValid)
				throw new IllegalAccess("\n\tAccess to an access restricted method." +
					"\n\tInvalid access from " + thisEnclosingJoinPointStaticPart.toString() +
					"\n\tto " + thisJoinPointStaticPart.toString() + ".");
		}		
	}
	
	/**
	 * <b>AdviceType:</b> Before
	 * <p>
	 * <b>Scope:</b> Accesses to non private attributes annotated with <code>@AccessibleFrom</code>.
	 * <p>
	 * <b>Name:</b> nonPrivateAttributesAccessEnforcer
	 * <p>
	 * This advice verifies if the annotated private attributes are accessed by
	 * an allowed class. Just the class itself and its specializations have access and 
	 * if the accessor class doesn't belong to the annotation's given set of
	 * classes the access is restricted and an exception thrown.
	 * 
	 * @throws IllegalAccess if the accessor class has restricted access.
	 * 
	 */	
	before (AccessibleFrom annotation) : accessToNonPrivateAccessibleFromAnnotatedField(annotation){
		
		Class<?> accessorClass = thisEnclosingJoinPointStaticPart.getSignature().getDeclaringType();
		Class<?> accessedClass = thisJoinPointStaticPart.getSignature().getDeclaringType();
		
		// The declaring class and its specializations always have access to the
		// method:
		boolean accessIsValid = accessorClass == accessedClass || accessedClass.isAssignableFrom(accessorClass);

		if(!accessIsValid){
			// Search through the given class set
			for(Class<?> valid_class : annotation.value())
				if(accessorClass == valid_class) 
					accessIsValid = true;
			
			if(!accessIsValid)
				throw new IllegalAccess("\n\tAccess to an access restricted attribute." +
					"\n\tInvalid access from " + thisEnclosingJoinPointStaticPart.toString() +
					"\n\tto " + thisJoinPointStaticPart.toString() + ".");		
		}
	}
	
	
	/**
	 * <b>AdviceType:</b> Before
	 * <p>
	 * <b>Scope:</b> Accesses to non private methods annotated with
	 * 		<code>@AccessibleFrom</code> through dynamic method invocation.
	 * <p>
	 * <b>Name:</b> nonPrivateMethodsAccessThroughDynamicInvocationEnforcer
	 * <p>
	 * This advice verifies if the annotated private methods dynamically invoked
	 * are accessed by an allowed class. The class itself and its specializations
	 * have access and if the accessor class doesn't belong to the annotation's
	 * given set of classes the access is restricted and an exception thrown.
	 * 
	 * @throws IllegalAccess if the accessor class has restricted access.
	 * 
	 */	
	before (AccessibleFrom annotation) : 
		inTheControlFlowOfDynamicCallToMethod() &&
		executionOfNonPrivateAccessibleFromAnnotatedMethod(annotation){
		
		if(StackReplica.getStack().size() >= 2)
		{
			Stack<JoinPoint> stack = StackReplica.getStack();
			
			Class<?> accessorClass = stack.get(stack.size()-2).getSignature().getDeclaringType();
			Class<?> accessedClass = thisJoinPointStaticPart.getSignature().getDeclaringType();
			
			// The declaring class and its specializations always have access to the
			// method:
			boolean accessIsValid = accessorClass == accessedClass || accessedClass.isAssignableFrom(accessorClass);
			
			if(!accessIsValid){
				for(Class<?> valid_class : annotation.value())
					if(accessorClass == valid_class) 
						accessIsValid = true;
								
				if(!accessIsValid)
					throw new IllegalAccess("\n\tAccess to an access restricted method through dynamic method invocation." +
						"\n\tInvalid access from " + stack.get(stack.size()-2).toString() +
						"\n\tto call(" + thisJoinPointStaticPart.getSignature() + ").");
			}	
		} else
			assert false : "Unexpected Stack State.";
	}	
	
	
	/**
	 * <b>AdviceType:</b> Before
	 * <p>
	 * <b>Scope:</b> Accesses to methods that may strengthen the inherited access control.
	 * <p>
	 * <b>Name:</b> methodStrengthensSuperclassAccessControl
	 * <p>
	 * This advice verifies if the methods that are accessed strengthens the inherited access control.
	 * 
	 * @throws InvalidMethodDefinition if the method itself reduce the accessibility of the inherited method.
	 * 
	 */	
	before (AccessibleFrom annotation) : callToAccessibleFromAnnotatedMethod(annotation){
		
		Class<?> accessed_class = thisJoinPointStaticPart.getSignature().getDeclaringType();
		
		// Called Method Signature
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
	 * Warnings
	 */
	
	/*
	 * Warnings related to accessibility restrictions in private features.
	 */	
	// Definition of a private method, which have restricted accessibility, with the AccessibleFrom qualifier.
	declare warning : scope() && !exclusions() && executionOfPrivateAccessibleFromMethod() 
		: "Definition of method simultaneously private and declared to have restricted accessibility.";

	// Call to a private method, which have restricted accessibility, with the AccessibleFrom qualifier.
	declare warning : scope() && !exclusions() && callToPrivateAccessibleFromMethod() 
		: "The private method being called was simultaneously declared to have restricted accessibility.";

	// Access to a private attribute, which have restricted accessibility, with the AccessibleFrom qualifier.
	declare warning : scope() && !exclusions() && getOfPrivateAccessibleFromField()
		: "The private attribute being gotten was simultaneously declared to have restricted accessibility.";

	// Access to a private attribute, which have restricted accessibility, with  the AccessibleFrom qualifier.
	declare warning : scope() && !exclusions() && setOfPrivateAccessibleFromField()
		: "The private attribute being set was simultaneously declared to have restricted accessibility.";
	
	
	/*
	 * Use of the <code>@AccessibleFrom</code> qualifier outside the scope of the enforcement.
	 */	
	// Definition of a private method, which have restricted accessibility, with the AccessibleFrom qualifier.
	declare warning : !scope() && !exclusions() && executionOfAccessibleFromMethod() 
		: "Definition of method declared with the @AccessibleFrom qualifier outside the scope of the enforcement.";

	// Call to a private method, which have restricted accessibility, with the AccessibleFrom qualifier.
	declare warning : !scope() && !exclusions() && callToAccessibleFromMethod() 
		: "The method being called is declared with the @AccessibleFrom qualifier outside the scope of the enforcement.";

	// Access to a private attribute, which have restricted accessibility, with the AccessibleFrom qualifier.
	declare warning : !scope() && !exclusions() && getOfAccessibleFromField()
		: "The private attribute being gotten is declared with the @AccessibleFrom qualifier outside the scope of the enforcement.";

	// Access to a private attribute, which have restricted accessibility, with  the AccessibleFrom qualifier.
	declare warning : !scope() && !exclusions() && setOfAccessibleFromField()
		: "The private attribute being set is declared with the @AccessibleFrom qualifier outside the scope of the enforcement.";
	
	
	
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
			// Compare in the Own Class
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
			
				// Own class
				if(other_method_signature.equals(method_signature)){
					Class[] effective_class_method_annotation_value = 
						method.getAnnotation(AccessibleFrom.class).value();
					
					if(!other_method.isAnnotationPresent(AccessibleFrom.class))
						return true;
					else{
						Class[] possible_accessed_class_method_annotation_value = 
							other_method.getAnnotation(AccessibleFrom.class).value();
						
						if(!isSubsetOf(possible_accessed_class_method_annotation_value,
								effective_class_method_annotation_value))
							return true;
					}
				}
			}
			
			// Superclass
			Class<?> superclass = method_class.getSuperclass();
				if(methodStrengthensSuperclassMethodAccessControl(superclass, method))
							return true;
			
			// Interface
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
	
	/**
	 * Verifies if the first is a subset of the second.
	 * 
	 * @pre subset != null
	 * @post true
	 * 
	 * @param subset supposed subset of the given <code>set</code>.
	 * @param set set of objects to check.
	 * 
	 * @return true if it is a subset, false otherwise.
	 */
	@InstancePrivate
	private  boolean isSubsetOf(Object[] subset, Object[] set) {
		if(set == null)
			return false;
		else{
			for(int i = 0; i < subset.length; ++i)
				if(!contains(set, subset[i]))
					return false;
			
			return true;
		}
	}
	
	/**
	 * Verifies if a set contains the element received.
	 * 
	 * @pre set != null && element != null
	 * @post true
	 * 
	 * @param set set of elements to check.
	 * @param element element contained, or not, in the <code>set</code>.
	 * 
	 * @return true if it contains, false otherwise.
	 */
	@InstancePrivate
	private boolean contains(Object[] set, Object element)
	{
		for(int i = 0; i < set.length; ++i)
			if(set[i].equals(element))
				return true;
		
		return false;
	}
}
