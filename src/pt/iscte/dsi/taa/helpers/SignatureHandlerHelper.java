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

package pt.iscte.dsi.taa.helpers;

import java.lang.reflect.Constructor;
import java.lang.reflect.Method;

import org.aspectj.lang.Signature;

public class SignatureHandlerHelper {
	/**
	 * Check if a <code>Signature</code> is a constructor's signature.
	 * 
	 * @pre signature != null
	 * @post true
	 * 
	 * @param signature is the signature to analyse.
	 * 
	 * @return true if the signature represents a constructor, false otherwise.
	 */
	public static boolean isConstructor(final Signature signature)
	{
		String long_signature = signature.toLongString().replaceAll(", ", ",");
						
		// Class methods list
		Constructor[] constructors = signature.getDeclaringType().getDeclaredConstructors();
		// Foreach method in the list check if the signature equals it
		for(Constructor constructor : constructors)
			if(constructor.toString().equals(long_signature))
				return true;
				
		return false;
	}
	
	
	/**
	 * Analyses the given <code>Signature</code> and translates it to the respective <code>Method</code> object. 
	 * 
	 * @pre signature != null
	 * @post true
	 * 
	 * @param signature is the signature of the method to return. 
	 * 
	 * @return respective method if found, null otherwise.
	 */
	public static Method getMethodOf(final Signature signature)
	{
		String long_signature = signature.toLongString().replaceAll(", ", ",");
						
		// Class methods list
		Method[] methods = signature.getDeclaringType().getDeclaredMethods();
		// Foreach method in the list check if the signature equals it
		for(Method method : methods){
			if(method.toString().equals(long_signature))
				return method;
		}
		
		return null;
	}
}
