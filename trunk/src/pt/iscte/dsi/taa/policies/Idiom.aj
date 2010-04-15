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

package pt.iscte.dsi.taa.policies;

/**
 * The Idiom aspect aggregates the most common pointcuts used in the Project's Enforcers.
 * 
 * @version 1.0
 * @author Gustavo Cabral
 * @author Helena Monteiro
 * @author João Catarino
 * @author Tiago Moreiras
 */
public aspect Idiom
{
	/*
	 * Call to method
	 */
	
	// Call to Method (ALL)
	public static final pointcut callToMethod() : call (* *(..));
	
	
	// Call to Static or Non-Static Methods
	public static final pointcut callToPrivateMethod() : call(private * *(..));
	public static final pointcut callToProtectedMethod() : call(protected * *(..));
	public static final pointcut callToPublicMethod() : call(public * *(..));
	public static final pointcut callToPackagePrivateMethod() :
		callToMethod() && !callToPrivateMethod() &&
		!callToProtectedMethod() && !callToPublicMethod();
		
	public static final pointcut callToNonPrivateMethod() : call(!private * *(..));
	public static final pointcut callToNonProtectedMethod() : call(!protected * *(..));
	public static final pointcut callToNonPublicMethod() : call(!public * *(..));
	public static final pointcut callToNonPackagePrivateMethod() :
		callToPrivateMethod() || callToProtectedMethod() || callToPublicMethod();
	
	
	// Call to Static and Non-Static Methods
	public static final pointcut callToStaticMethod() : call(static * *(..));
	public static final pointcut callToNonStaticMethod() : call(!static * *(..));
	
	
	// Call to Static Methods
	public static final pointcut callToStaticPrivateMethod() : call(static private * *(..));
	public static final pointcut callToStaticProtectedMethod() : call(static protected * *(..));
	public static final pointcut callToStaticPublicMethod() : call(static public * *(..));
	public static final pointcut callToStaticPackagePrivateMethod() :
		callToStaticMethod() && !callToStaticPrivateMethod() &&
		!callToStaticProtectedMethod() && !callToStaticPublicMethod();
		
	public static final pointcut callToStaticNonPrivateMethod() : call(static !private * *(..));
	public static final pointcut callToStaticNonProtectedMethod() : call(static !protected * *(..));
	public static final pointcut callToStaticNonPublicMethod() : call(static !public * *(..));
	public static final pointcut callToStaticNonPackagePrivateMethod() :
		callToStaticPrivateMethod() || callToStaticProtectedMethod() || callToStaticPublicMethod();
	
		
	// Call to Non-Static Methods
	public static final pointcut callToNonStaticPrivateMethod() : call(!static private * *(..));
	public static final pointcut callToNonStaticProtectedMethod() : call(!static protected * *(..));
	public static final pointcut callToNonStaticPublicMethod() : call(!static public * *(..));
	public static final pointcut callToNonStaticPackagePrivateMethod() :
		callToNonStaticMethod() && !callToNonStaticPrivateMethod() &&
		!callToNonStaticProtectedMethod() && !callToNonStaticPublicMethod();
		
	public static final pointcut callToNonStaticNonPrivateMethod() : call(!static !private * *(..));
	public static final pointcut callToNonStaticNonProtectedMethod() : call(!static !protected * *(..));
	public static final pointcut callToNonStaticNonPublicMethod() : call(!static !public * *(..));
	public static final pointcut callToNonStaticNonPackagePrivateMethod() :
		callToNonStaticPrivateMethod() || callToNonStaticProtectedMethod() || callToNonStaticPublicMethod();
	
	
	// Call to Constructors
	public static final pointcut callToConstructor() : call(new(..));
	public static final pointcut callToPrivateConstructor() : call(private new(..));
	public static final pointcut callToProtectedConstructor() : call(protected new(..));
	public static final pointcut callToPublicConstructor() : call(public new(..));
	public static final pointcut callToPackagePrivateConstructor() :
		callToConstructor() && !callToPrivateConstructor() &&
		!callToProtectedConstructor() && !callToPublicConstructor();
	
	public static final pointcut callToNonPrivateConstructor() : call(!private new(..));
	public static final pointcut callToNonProtectedConstructor() : call(!protected new(..));
	public static final pointcut callToNonPublicConstructor() : call(!public new(..));
	public static final pointcut callToNonPackagePrivateConstructor() :
		callToPrivateConstructor() || callToProtectedConstructor() || callToPublicConstructor();
	
	
	// Call to Destructors
	public static final pointcut callToDesctructor() : call (void finalize());
	
	
	
	
	/*
	 * Execution of method
	 */

	// Execution of Method (ALL)
	public static final pointcut executionOfMethod() : execution (* *(..));

	
	// Execution of Static or Non-Static Methods
	public static final pointcut executionOfPrivateMethod() : execution(private * *(..));
	public static final pointcut executionOfProtectedMethod() : execution(protected * *(..));
	public static final pointcut executionOfPublicMethod() : execution(public * *(..));
	public static final pointcut executionOfPackagePrivateMethod() :
		executionOfMethod() && !executionOfPrivateMethod() &&
		!executionOfProtectedMethod() && !executionOfPublicMethod();

	public static final pointcut executionOfNonPrivateMethod() : execution(!private * *(..));
	public static final pointcut executionOfNonProtectedMethod() : execution(!protected * *(..));
	public static final pointcut executionOfNonPublicMethod() : execution(!public * *(..));
	public static final pointcut executionOfNonPackagePrivateMethod() :
		executionOfPrivateMethod() || executionOfProtectedMethod() || executionOfPublicMethod();
	
	
	// Execution of Static and Non-Static Methods
	public static final pointcut executionOfStaticMethod() : execution(static * *(..));
	public static final pointcut executionOfNonStaticMethod() : execution(!static * *(..));
	
	
	// Execution of Static Methods
	public static final pointcut executionOfStaticPrivateMethod() : execution(static private * *(..));
	public static final pointcut executionOfStaticProtectedMethod() : execution(static protected * *(..));
	public static final pointcut executionOfStaticPublicMethod() : execution(static public * *(..));
	public static final pointcut executionOfStaticPackagePrivateMethod() :
		executionOfStaticMethod() && !executionOfStaticPrivateMethod() &&
		!executionOfStaticProtectedMethod() && !executionOfStaticPublicMethod();
		
	public static final pointcut executionOfStaticNonPrivateMethod() : execution(static !private * *(..));
	public static final pointcut executionOfStaticNonProtectedMethod() : execution(static !protected * *(..));
	public static final pointcut executionOfStaticNonPublicMethod() : execution(static !public * *(..));
	public static final pointcut executionOfStaticNonPackagePrivateMethod() :
		executionOfStaticPrivateMethod() || executionOfStaticProtectedMethod() || executionOfStaticPublicMethod();
	
	
	// Execution of Non-Static Methods
	public static final pointcut executionOfNonStaticPrivateMethod() : execution(!static private * *(..));
	public static final pointcut executionOfNonStaticProtectedMethod() : execution(!static protected * *(..));
	public static final pointcut executionOfNonStaticPublicMethod() : execution(!static public * *(..));
	public static final pointcut executionOfNonStaticPackagePrivateMethod() :
		executionOfNonStaticMethod() && !executionOfNonStaticPrivateMethod() &&
		!executionOfNonStaticProtectedMethod() && !executionOfNonStaticPublicMethod();
		
	public static final pointcut executionOfNonStaticNonPrivateMethod() : execution(!static !private * *(..));
	public static final pointcut executionOfNonStaticNonProtectedMethod() : execution(!static !protected * *(..));
	public static final pointcut executionOfNonStaticNonPublicMethod() : execution(!static !public * *(..));
	public static final pointcut executionOfNonStaticNonPackagePrivateMethod() :
		executionOfNonStaticPrivateMethod() || executionOfNonStaticProtectedMethod() || executionOfNonStaticPublicMethod();
	
	
	// Execution of Constructors
	public static final pointcut executionOfConstructor() : execution(new(..));
	public static final pointcut executionOfPrivateConstructor() : execution(private new(..));
	public static final pointcut executionOfProtectedConstructor() : execution(protected new(..));
	public static final pointcut executionOfPublicConstructor() : execution(public new(..));
	public static final pointcut executionOfPackagePrivateConstructor() :
		executionOfConstructor() && !executionOfPrivateConstructor() &&
		!executionOfProtectedConstructor() && !executionOfPublicConstructor();
	
	public static final pointcut executionOfNonPrivateConstructor() : execution(!private new(..));
	public static final pointcut executionOfNonProtectedConstructor() : execution(!protected new(..));
	public static final pointcut executionOfNonPublicConstructor() : execution(!public new(..));
	public static final pointcut executionOfNonPackagePrivateConstructor() :
		executionOfPrivateConstructor() || executionOfProtectedConstructor() || executionOfPublicConstructor();
	
	
	// Execution of Destructors
	public static final pointcut executionOfDestructor() : execution(void finalize());
	
	
	
	
	/*
	 * Get of Field
	 */
	
	// Get of Field
	public static final pointcut getOfField() : get (* *);

	
	// Get of Static or Non-Static Field
	public static final pointcut getOfPrivateField() : get(private * *);
	public static final pointcut getOfProtectedField() : get(protected * *);
	public static final pointcut getOfPublicField() : get(public * *);
	public static final pointcut getOfPackagePrivateField() :
		getOfField() && !getOfPrivateField() &&
		!getOfProtectedField() && !getOfPublicField();
		
	public static final pointcut getOfNonPrivateField() : get(!private * *);
	public static final pointcut getOfNonProtectedField() : get(!protected * *);
	public static final pointcut getOfNonPublicField() : get(!public * *);
	public static final pointcut getOfNonPackagePrivateField() :
		getOfPrivateField() || getOfProtectedField() || getOfPublicField();
	

	// Get of Static and Non-Static Field
	public static final pointcut getOfStaticField() : get(static * *);
	public static final pointcut getOfNonStaticField() : get(!static * *);
	
	
	// Get of Static Field
	public static final pointcut getOfStaticPrivateField() : get(static private * *);
	public static final pointcut getOfStaticProtectedField() : get(static protected * *);
	public static final pointcut getOfStaticPublicField() : get(static public * *);
	public static final pointcut getOfStaticPackagePrivateField() :
		getOfStaticField() && !getOfStaticPrivateField() &&
		!getOfStaticProtectedField() && !getOfStaticPublicField();
		
	public static final pointcut getOfStaticNonPrivateField() : get(static !private * *);
	public static final pointcut getOfStaticNonProtectedField() : get(static !protected * *);
	public static final pointcut getOfStaticNonPublicField() : get(static !public * *);
	public static final pointcut getOfStaticNonPackagePrivateField() :
		getOfStaticPrivateField() || getOfStaticProtectedField() || getOfStaticPublicField();
	
	
	// Get of Non-Static Field
	public static final pointcut getOfNonStaticPrivateField() : get(!static private * *);
	public static final pointcut getOfNonStaticProtectedField() : get(!static protected * *);
	public static final pointcut getOfNonStaticPublicField() : get(!static public * *);
	public static final pointcut getOfNonStaticPackagePrivateField() :
		getOfNonStaticField() && !getOfNonStaticPrivateField() &&
		!getOfNonStaticProtectedField() && !getOfNonStaticPublicField();
		
	public static final pointcut getOfNonStaticNonPrivateField() : get(!static !private * *);
	public static final pointcut getOfNonStaticNonProtectedField() : get(!static !protected * *);
	public static final pointcut getOfNonStaticNonPublicField() : get(!static !public * *);
	public static final pointcut getOfNonStaticNonPackagePrivateField() :
		getOfNonStaticPrivateField() || getOfNonStaticProtectedField() || getOfNonStaticPublicField();
	
	
	
	
	/*
	 * Set of Field
	 */
	
	// Set of Field
	public static final pointcut setOfField() : set (* *);
	
	
	// Set of Static or Non-Static Field
	public static final pointcut setOfPrivateField() : set(private * *);
	public static final pointcut setOfProtectedField() : set(protected * *);
	public static final pointcut setOfPublicField() : set(public * *);
	public static final pointcut setOfPackagePrivateField() :
		setOfField() && !setOfPrivateField() &&
		!setOfProtectedField() && !setOfPublicField();
	
	public static final pointcut setOfNonPrivateField() : set(!private * *);
	public static final pointcut setOfNonProtectedField() : set(!protected * *);
	public static final pointcut setOfNonPublicField() : set(!public * *);
	public static final pointcut setOfNonPackagePrivateField() :
		setOfPrivateField() || setOfProtectedField() || setOfPublicField();
	
	
	// Set of Static and Non-Static Field
	public static final pointcut setOfStaticField() : set(static * *);
	public static final pointcut setOfNonStaticField() : set(!static * *);
	
	
	// Set of Static Field
	public static final pointcut setOfStaticPrivateField() : set(static private * *);
	public static final pointcut setOfStaticProtectedField() : set(static protected * *);
	public static final pointcut setOfStaticPublicField() : set(static public * *);
	public static final pointcut setOfStaticPackagePrivateField() :
		setOfStaticField() && !setOfStaticPrivateField() &&
		!setOfStaticProtectedField() && !setOfStaticPublicField();
	
	public static final pointcut setOfStaticNonPrivateField() : set(static !private * *);
	public static final pointcut setOfStaticNonProtectedField() : set(static !protected * *);
	public static final pointcut setOfStaticNonPublicField() : set(static !public * *);
	public static final pointcut setOfStaticNonPackagePrivateField() :
		setOfStaticPrivateField() || setOfStaticProtectedField() || setOfStaticPublicField();
	
	
	// Set of Non-Static Field
	public static final pointcut setOfNonStaticPrivateField() : set(!static private * *);
	public static final pointcut setOfNonStaticProtectedField() : set(!static protected * *);
	public static final pointcut setOfNonStaticPublicField() : set(!static public * *);
	public static final pointcut setOfNonStaticPackagePrivateField() :
		setOfNonStaticField() && !setOfNonStaticPrivateField() &&
		!setOfNonStaticProtectedField() && !setOfNonStaticPublicField();
	
	public static final pointcut setOfNonStaticNonPrivateField() : set(!static !private * *);
	public static final pointcut setOfNonStaticNonProtectedField() : set(!static !protected * *);
	public static final pointcut setOfNonStaticNonPublicField() : set(!static !public * *);
	public static final pointcut setOfNonStaticNonPackagePrivateField() :
		setOfNonStaticPrivateField() || setOfNonStaticProtectedField() || setOfNonStaticPublicField();
	
	
	
	
	/*
	 * Access To Field
	 */
	
	// Access to Field
	public static final pointcut accessToField() : getOfField() || setOfField();
	
	
	// Access to Static or Non-Static Field
	public static final pointcut accessToPrivateField() :
		getOfPrivateField() || setOfPrivateField();
	public static final pointcut accessToProtectedField() :
		getOfProtectedField() || setOfProtectedField();
	public static final pointcut accessToPublicField() :
		getOfPublicField() || setOfPublicField();
	public static final pointcut accessToPackagePrivateField() :
		accessToField() && !accessToPrivateField() &&
		!accessToProtectedField() && !accessToPublicField();
		
	public static final pointcut accessToNonPrivateField() :
		getOfNonPrivateField() || setOfNonPrivateField();
	public static final pointcut accessToNonProtectedField() :
		getOfNonProtectedField() || setOfNonProtectedField();
	public static final pointcut accessToNonPublicField() :
		getOfNonPublicField() || setOfNonPublicField();
	public static final pointcut accessToNonPackagePrivateField() :
		accessToPrivateField() || accessToProtectedField() || accessToPublicField();
	
	
	// Access to Static and Non-Static Field
	public static final pointcut accessToStaticField() :
		getOfStaticField() || setOfStaticField();
	public static final pointcut accessToNonStaticField() :
		getOfNonStaticField() || setOfNonStaticField();
	
	
	// Access to Static Field
	public static final pointcut accessToStaticPrivateField() :
		getOfStaticPrivateField() || setOfStaticPrivateField();
	public static final pointcut accessToStaticProtectedField() :
		getOfStaticProtectedField() || setOfStaticProtectedField();
	public static final pointcut accessToStaticPublicField() :
		getOfStaticPublicField() || setOfStaticPublicField();
	public static final pointcut accessToStaticPackagePrivateField() :
		accessToStaticField() && !accessToStaticPrivateField() &&
		!accessToStaticProtectedField() && !accessToStaticPublicField();
	
	public static final pointcut accessToStaticNonPrivateField() :
		getOfStaticNonPrivateField() || setOfStaticNonPrivateField();
	public static final pointcut accessToStaticNonProtectedField() :
		getOfStaticNonProtectedField() || setOfStaticNonProtectedField();
	public static final pointcut accessToStaticNonPublicField() :
		getOfStaticNonPublicField() || setOfStaticNonPublicField();
	public static final pointcut accessToStaticNonPackagePrivateField() :
		accessToStaticPrivateField() || accessToStaticProtectedField() || accessToStaticPublicField();
	
	
	// Access to Non-Static Field
	public static final pointcut accessToNonStaticPrivateField() :
		getOfNonStaticPrivateField() || setOfNonStaticPrivateField();
	public static final pointcut accessToNonStaticProtectedField() :
		getOfNonStaticProtectedField() || setOfNonStaticProtectedField();
	public static final pointcut accessToNonStaticPublicField() :
		getOfNonStaticPublicField() || setOfNonStaticPublicField();;
	public static final pointcut accessToNonStaticPackagePrivateField() :
		accessToNonStaticField() && !accessToNonStaticPrivateField() &&
		!accessToNonStaticProtectedField() && !accessToNonStaticPublicField();

	public static final pointcut accessToNonStaticNonPrivateField() :
		getOfNonStaticNonPrivateField() || setOfNonStaticNonPrivateField();
	public static final pointcut accessToNonStaticNonProtectedField() :
		getOfNonStaticNonProtectedField() || setOfNonStaticNonProtectedField();
	public static final pointcut accessToNonStaticNonPublicField() :
		getOfNonStaticNonPublicField() || setOfNonStaticNonPublicField();;
	public static final pointcut accessToNonStaticNonPackagePrivateField() :
		accessToNonStaticPrivateField() || accessToNonStaticProtectedField() || accessToNonStaticPublicField();
}