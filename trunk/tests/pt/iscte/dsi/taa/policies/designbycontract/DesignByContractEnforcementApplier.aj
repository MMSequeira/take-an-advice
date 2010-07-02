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

package pt.iscte.dsi.taa.tests.designbycontract;

//import org.aspectj.lang.JoinPoint.StaticPart;

import pt.iscte.dsi.taa.policies.designbycontract.Enforcer;

// TODO Try to do this using LTW (Load time weaving).

public /*abstract*/ aspect DesignByContractEnforcementApplier extends Enforcer {
	// TODO Report this as a bug? Is it already a bug?
//    declare @method: boolean Rational.stateIsValid() : @StateValidator;
//    declare @type: Rational : @StateValidated;
	
	//TODO confirmar se é isto que se pretende e tirar o (Applier)
//	@Override
//    public void errorHandler(final Object target, StaticPart static_part){
//    	assert stateIsValidOf(target) : "(Applier) \n\tState invalid before execution of " +
//    	EclipseConsoleHelper.convertToHyperlinkFormat(static_part);
//    }
}

