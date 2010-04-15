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

package pt.iscte.dsi.taa.policies.stack;

import java.util.Stack;

import org.aspectj.lang.JoinPoint;

/*******************************************************************************
 * 
 * This Aspect represents a replica of the Java Thread's Stack.
 * 
 * @version 1.0
 * @author Gustavo Cabral
 * @author Helena Monteiro
 * @author João Catarino
 * @author Tiago Moreiras
 */
public aspect StackReplica {

	/*
	 * General Pointcuts
	 */
	private pointcut none();
	private pointcut all() : !none();
	
	protected pointcut scope() : all();
		
	/*
	 * Exclude pointcuts inside the StackReplica.
	 */  
	private pointcut exclusions() : 
		within(StackReplica+) ||
		within(ThreadLocalStack+) ||
		within(pt.iscte.dsi.taa.policies.accessibility.classes.Enforcer+) ||
		within(pt.iscte.dsi.taa.policies.accessibility.instances.Enforcer+) ||
		within(pt.iscte.dsi.taa.policies.designbycontract.Enforcer+) ||
		within(pt.iscte.dsi.taa.policies.relationships.association.multiplicity.Enforcer+) || 
		within(pt.iscte.dsi.taa.policies.state.Enforcer+);
	
	
	/*
	 * Pointcuts
	 */
	
	/*
	 * Captures any execution
	 */
	private pointcut anyExecution() : 
		scope() && !exclusions() && execution(* *(..));
	
	
	/*
	 * Advices
	 */
	
	/*
	 * STACK
	 */
	
	/**
	 * <b>AdviceType:</b> Before
	 * <p>
	 * <b>Scope:</b> Captures any execution and push its StaticPart into the stack.
	 * <p>
	 * <b>Name:</b> pushExecutionStaticPartIntoStack
	 * <p>
	 * 
	 * Saves the JoinPoint information about the current execution into the stack.
	 * 
	 */	
	before() : anyExecution() {
		if(debug) System.out.println("(Push) " + thisJoinPointStaticPart);
		if(debug) System.out.println("{");
		stacksShown = false;
		
		thread_local_stack.get().push(thisJoinPoint);
				
		if(debug) System.out.println("}");
	}
	
	
	/**
	 * <b>AdviceType:</b> Before
	 * <p>
	 * <b>Scope:</b> Captures any execution and pops its StaticPart from the stack.
	 * <p>
	 * <b>Name:</b> popExecutionStaticPartFromStack
	 * <p>
	 * 
	 * Removes the JoinPoint information about the current execution of the stack.
	 * 
	 */
	after() : anyExecution() {
		if(debug) System.out.println("(Pop) " + thisJoinPointStaticPart);
		if(debug) System.out.println("{");
		stacksShown = false;
		
		// The StaticPart being popped from the stack must have the same signature as the one caught.
		assert thread_local_stack.get().lastElement().equals(thisJoinPoint) : 
			"Unexpected StaticPart '" + thisJoinPointStaticPart + "' popped from stack.\n" +
			" Expected '" + thread_local_stack.get().lastElement() + "'.";
		
		thread_local_stack.get().pop();

		// Do not use if(debug) System.out.println here, since its arguments are always calculated!
		if(debug) System.out.println("\tPopping '" + thisJoinPointStaticPart + "' from the stack.");
		if(debug) System.out.println("}");
	}

	
	/*
	 * Declared Warnings and Errors
	 */
	
	/*
	 * Warnings
	 */
	
	/*
	 * Errors
	 */
	
	
	/*
	 * Stack Debug
	 */
	
	// A heavy-weight tracer:
	/*before() : cflow(execution(* main(..))) && !exclusions() && if(debug) {
		System.out.out.println(thisJoinPointStaticPart + " {");
		//showAllParts();
		showStack();
		System.out.out.println("}");
	}*/
	
	
	/*
	 * Aspect Methods
	 */

	/*
	 * Debug purposes only
	 */
	
	/**
	 * Shows the current thread's stack replica.
	 */
	@SuppressWarnings("unused")
	private static void showStack() {
		if(stacksShown)
			return;
			
		stacksShown = true;
		
		System.out.println("\tCurrent thread stack [" + thread_local_stack.get().size() + "] {");
		for(JoinPoint join_point: thread_local_stack.get())
			System.out.println("\t\t" + join_point.getStaticPart());
			
		System.out.println("\t}");	
	}
	
	/**
	 * Makes and a copy of the current thread's stack replica and returns it.
	 * 
	 * @return a copy of the current thread's stack replica.
	 */
	public static Stack<JoinPoint> getStack()
	{
		Stack<JoinPoint> stack = new Stack<JoinPoint>();
		for(JoinPoint join_point : thread_local_stack.get())
			stack.push(join_point);
		return stack;
	}
	
	/**
	 * Dump thread's stack replica for debug purposes.
	 */
	public static void dumpStack()
	{
		System.out.println("Dumping Stack...");
		System.out.println("{");
		Stack<JoinPoint> stack = getStack();
		for(int i = stack.size()-1; i >= 0; --i)
			System.out.println(stack.get(i));
		System.out.println("}");
	}
	
	/*
	 * Aspect Attributes
	 */
	
	private static ThreadLocalStack thread_local_stack = new ThreadLocalStack();
		
	private static final boolean debug = false;
	private static boolean stacksShown = false;
	
	/**
	 * This private class allows us to have a different stack for each thread of the JVM.
	 */
	private static class ThreadLocalStack extends ThreadLocal<Stack<JoinPoint>>
	{
		/**
		 * If the thread's stack isn't already initialized when the user tries to get it this
		 * method is invoked to initialize it.
		 * 
		 * @return Thread's Stack initialization value.
		 */
		public Stack<JoinPoint> initialValue()
		{
			return new Stack<JoinPoint>();
		}
	}
}


