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
    public static String convertToHyperlinkFormat(StaticPart static_part)
	{
    	String[] splitted_signature = static_part.getSignature().toString().split(" ");
		String hyperlink = splitted_signature[splitted_signature.length - 1].split("\\(")[0];
		
		// Reflection API
		SourceLocation location = static_part.getSourceLocation();
		
		if(SignatureHandlerHelper.isConstructor(static_part.getSignature()))
			hyperlink += ".<init>";
		hyperlink += "(" + location.getFileName() + ":" + location.getLine() + ")";
		
		return hyperlink;
	}
}
