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

import org.aspectj.lang.Signature;
import org.aspectj.lang.JoinPoint.StaticPart;
import org.aspectj.lang.reflect.SourceLocation;

public class EclipseConsoleHelper {
	/**
	 * Converts the static part's signature of a joinPoint into the hyperlink format that eclipse uses in its console.
	 * 
	 * @pre signature != null
	 * @post true
	 * 
	 * @param static_part is a static part of the given AspectJ <code>JoinPoin</code> <code>StaticPart</code>. 
	 * 
	 * @return jointPoint's signature in eclipse's hyperlink code format.
	 */
    public static String convertToHyperlinkFormat(StaticPart static_part){
    	String[] splitted_signature = static_part.getSignature().toString().split(" ");
		String hyperlink = splitted_signature[splitted_signature.length - 1].split("\\(")[0];
		
		// Reflection API
		SourceLocation location = static_part.getSourceLocation();
		
		if(isConstructor(static_part.getSignature()))
			hyperlink += ".<init>";
		hyperlink += "(" + location.getFileName() + ":" + location.getLine() + ")";
		
		return hyperlink;
	}
    
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
	public static boolean isConstructor(final Signature signature){
		//TODO ver se aceitamos os metodos privados por reflexao para executar e ver se conseguimos fazer algo parecido à solução do prof do metodo, so e usado no helper
		String long_signature = signature.toLongString().replaceAll(", ", ",");
						
		// Class methods list
		Constructor<?>[] constructors = signature.getDeclaringType().getDeclaredConstructors();
		// Foreach method in the list check if the signature equals it
		for(Constructor<?> constructor : constructors)
			if(constructor.toString().equals(long_signature))
				return true;
				
		return false;
	}
}
