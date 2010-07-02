/*
 * This file is part of Take an Advice. Take an Advice is free software: you can
 * redistribute it and/or modify it under the terms of the GNU Lesser General
 * Public License as published by the Free Software Foundation, either version 3
 * of the License, or (at your option) any later version. Take an Advice is
 * distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
 * without even the implied warranty of MERCHANTABILITY or FITNESS FOR A
 * PARTICULAR PURPOSE. See the GNU Lesser General Public License for more
 * details. You should have received a copy of the GNU General Public License
 * along with Take an Advice. If not, see <http://www.gnu.org/licenses/>.
 */

package pt.iscte.dsi.taa.policies.state;

import java.lang.reflect.Method;
import java.lang.reflect.Modifier;
import java.util.Collection;
import java.util.HashMap;
import java.util.LinkedList;
import java.util.Map;
import java.util.WeakHashMap;

import org.aspectj.lang.JoinPoint;
import org.aspectj.lang.Signature;
import org.aspectj.lang.JoinPoint.StaticPart;
import org.aspectj.lang.annotation.SuppressAjWarnings;
import org.aspectj.lang.reflect.MethodSignature;

import pt.iscte.dsi.taa.helpers.EclipseConsoleHelper;
import pt.iscte.dsi.taa.policies.Pointcuts;
import pt.iscte.dsi.taa.policies.stack.StackReplica;
import pt.iscte.dsi.taa.qualifiers.ContainerOfParts;
import pt.iscte.dsi.taa.qualifiers.InstancePrivate;
import pt.iscte.dsi.taa.qualifiers.NonState;
import pt.iscte.dsi.taa.qualifiers.Part;
import pt.iscte.dsi.taa.qualifiers.PureFunction;
import pt.iscte.dsi.taa.qualifiers.StateModifier;

/*****************************************************************************************
 * This Aspect represents the State Policy Enforcer.
 * 
 * @version 1.0
 * @author Gustavo Cabral
 * @author Helena Monteiro
 * @author João Catarino
 * @author Tiago Moreiras
 */
@SuppressWarnings("unchecked")
public abstract aspect Enforcer {

    /*
     * Pointcuts
     */
    protected pointcut scope() : Pointcuts.all();

    /*
     * The pointcut within(Enforcer+) is redundant relative to
     * cflow(within(Enforcer+)). However, since it does not use the cflow
     * designator, it is a static pointcut. This allows Eclipse to remove
     * annoying advice markers from the code of the aspect itself.
     */
    private pointcut exclusions() :
		within(Enforcer+) ||
		within(pt.iscte.dsi.taa.policies.stack.StackReplica+) ||
		within(pt.iscte.dsi.taa.policies.accessibility.classes.Enforcer+) ||
		within(pt.iscte.dsi.taa.policies.accessibility.instances.Enforcer+) ||
		within(pt.iscte.dsi.taa.policies.designbycontract.Enforcer+) ||
		within(pt.iscte.dsi.taa.policies.relationships.association.multiplicity.Enforcer+) ||
		within(pt.iscte.dsi.taa.policies.relationships.association.ordered.Enforcer+) ||
		within(pt.iscte.dsi.taa.policies.relationships.association.unique.Enforcer+);

    /*
     * Since the target being obtained as part of the context, it is redundant,
     * though expressive, to say that only sets (calls) to non-static attributes
     * (methods) are included in the pointcuts:
     */

    /*
     * Auxiliar Pointcuts
     */

    // Call
    private pointcut callToPureFunctionMethod() : call(@PureFunction * *(..));

    private pointcut callToStateModifierMethod() : call(@StateModifier * *(..));

    private pointcut callToStaticStateModifierMethod() : Pointcuts.callToStaticMethod() && callToStateModifierMethod();

    private pointcut callToNonStaticStateModifierMethod() : Pointcuts.callToNonStaticMethod() && callToStateModifierMethod();

    private pointcut callToNonStaticPureFunctionMethod() : Pointcuts.callToNonStaticMethod() && callToPureFunctionMethod();

    private pointcut callToNonPureFunctionMethod() : call(!@PureFunction * *(..));

    private pointcut callToNonStaticNonPureFunctionMethod() : Pointcuts.callToNonStaticMethod() && callToNonPureFunctionMethod();

    // Execution
    private pointcut executionOfNonStateModifierMethod() : execution(!@StateModifier * *(..));

    private pointcut executionOfStateModifierMethod() : execution(@StateModifier * *(..));

    private pointcut executionOfPureFunctionMethod() : execution(@PureFunction * *(..));

    private pointcut executionOfStaticStateModifierMethod() : Pointcuts.executionOfStaticMethod() && executionOfStateModifierMethod();

    private pointcut executionOfStaticNonStateModifierMethod() : Pointcuts.executionOfStaticMethod() && executionOfNonStateModifierMethod();

    private pointcut executionOfNonStaticStateModifierMethod() : Pointcuts.executionOfNonStaticMethod() && executionOfStateModifierMethod();

    private pointcut executionOfNonStaticNonStateModifierMethod() : Pointcuts.executionOfNonStaticMethod() && executionOfNonStateModifierMethod();

    private pointcut executionOfNonStaticPureFunctionMethod() : Pointcuts.executionOfNonStaticMethod() && executionOfPureFunctionMethod();

    // Get
    private pointcut getOfFinalField() : get(final * *);

    private pointcut getOfNonFinalField() : get(!final * *);

    private pointcut getOfPrimitiveField() : get(!(Object+) *);

    private pointcut getOfArrayField() : get(*[] *);

    private pointcut getOfMapField() : get(Map+ *);

    private pointcut getOfCollectionField() : get(Collection+ *);

    private pointcut getOfPartField() : get(@Part * *);

    private pointcut getOfNonStateField() : get(@NonState * *);

    private pointcut getOfContainerOfPartsField() : get(@ContainerOfParts * *);

    private pointcut getOfNonInstancePrivateField() : get(!@InstancePrivate * *);

    private pointcut getOfPrimitivePartField() : getOfPrimitiveField() && getOfPartField();

    private pointcut getOfPrimitiveContainerOfPartsField() : getOfPrimitiveField() && getOfContainerOfPartsField();

    private pointcut getOfNonEligibleContainerOfPartsField() : getOfContainerOfPartsField() &&
		!getOfArrayField() && !getOfMapField() && !getOfCollectionField();

    private pointcut getOfNonPrivatePartField(): Pointcuts.getOfNonPrivateField() && getOfPartField();

    private pointcut getOfNonPrivateContainerOfPartsField(): Pointcuts.getOfNonPrivateField() && getOfContainerOfPartsField();

    private pointcut getOfNonFinalNonPrivateField() : getOfNonFinalField() && Pointcuts.getOfNonPrivateField();

    private pointcut getOfStaticNonStateField() : Pointcuts.getOfStaticField() && getOfNonStateField();

    private pointcut getOfStaticPartField() : Pointcuts.getOfStaticField() && getOfPartField();

    private pointcut getOfStaticPrimitivePartField() : Pointcuts.getOfStaticField() && getOfPartField() && getOfPrimitiveField();

    private pointcut getOfNonStaticNonStateField() : Pointcuts.getOfNonStaticField() && getOfNonStateField();

    private pointcut getOfNonStaticPartField() : Pointcuts.getOfNonStaticField() && getOfPartField();

    private pointcut getOfNonStaticPrimitivePartField() : Pointcuts.getOfNonStaticField() && getOfPartField() && getOfPrimitiveField();

    private pointcut getOfNonStaticNonFinalPrivateNonInstancePrivateField() :
		Pointcuts.getOfNonStaticPrivateField() && getOfNonFinalField() && getOfNonInstancePrivateField();

    private pointcut getOfNonStaticNonInstancePrivatePartField(): Pointcuts.getOfNonStaticField() &&
		getOfNonInstancePrivateField() && getOfPartField();

    private pointcut getOfNonStaticNonInstancePrivateContainerOfPartsField(): Pointcuts.getOfNonStaticField() &&
		getOfNonInstancePrivateField() && getOfContainerOfPartsField();

    // Set
    private pointcut setOfFinalField() : set(final * *);

    private pointcut setOfNonFinalField() : set(!final * *);

    private pointcut setOfPrimitiveField() : set(!(Object+) *);

    private pointcut setOfArrayField() : set(*[] *);

    private pointcut setOfMapField() : set(Map+ *);

    private pointcut setOfCollectionField() : set(Collection+ *);

    private pointcut setOfStateField() : set(!@NonState * *);

    private pointcut setOfNonStateField() : set(@NonState * *);

    private pointcut setOfPartField() : set(@Part * *);

    private pointcut setOfContainerOfPartsField() : set(@ContainerOfParts * *);

    private pointcut setOfNonInstancePrivateField() : set(!@InstancePrivate * *);

    private pointcut setOfPrimitivePartField() : setOfPrimitiveField() && setOfPartField();

    private pointcut setOfPrimitiveContainerOfPartsField() : setOfPrimitiveField() && setOfContainerOfPartsField();

    private pointcut setOfNonEligibleContainerOfPartsField() : setOfContainerOfPartsField() &&
		!setOfArrayField() && !setOfMapField() && !setOfCollectionField();

    private pointcut setOfNonPrivatePartField(): Pointcuts.setOfNonPrivateField() && setOfPartField();

    private pointcut setOfNonPrivateContainerOfPartsField(): Pointcuts.setOfNonPrivateField() && setOfContainerOfPartsField();

    private pointcut setOfNonFinalNonPrivateField() : setOfNonFinalField() && Pointcuts.setOfNonPrivateField();

    private pointcut setOfStaticStateField() : Pointcuts.setOfStaticField() && setOfStateField();

    private pointcut setOfStaticNonStateField() : Pointcuts.setOfStaticField() && setOfNonStateField();

    private pointcut setOfStaticPartField() : Pointcuts.setOfStaticField() && setOfPartField();

    private pointcut setOfStaticPrimitivePartField() : Pointcuts.setOfStaticField() && setOfPartField() && setOfPrimitiveField();

    private pointcut setOfStaticContainerOfPartsArrayField() :
		Pointcuts.setOfStaticField() && setOfContainerOfPartsField() && setOfArrayField();

    private pointcut setOfStaticContainerOfPartsMapField() :
		Pointcuts.setOfStaticField() && setOfContainerOfPartsField() && setOfMapField();

    private pointcut setOfStaticContainerOfPartsCollectionField() :
		Pointcuts.setOfStaticField() && setOfContainerOfPartsField() && setOfCollectionField();

    private pointcut setOfNonStaticStateField() : Pointcuts.setOfNonStaticField() && setOfStateField();

    private pointcut setOfNonStaticNonStateField() : Pointcuts.setOfNonStaticField() && setOfNonStateField();

    private pointcut setOfNonStaticPartField() : Pointcuts.setOfNonStaticField() && setOfPartField();

    private pointcut setOfNonStaticPrimitivePartField() : Pointcuts.setOfNonStaticField() && setOfPartField() && setOfPrimitiveField();

    private pointcut setOfNonStaticContainerOfPartsArrayField() :
		Pointcuts.setOfNonStaticField() && setOfContainerOfPartsField() && setOfArrayField();

    private pointcut setOfNonStaticContainerOfPartsMapField() :
		Pointcuts.setOfNonStaticField() && setOfContainerOfPartsField() && setOfMapField();

    private pointcut setOfNonStaticContainerOfPartsCollectionField() :
		Pointcuts.setOfNonStaticField() && setOfContainerOfPartsField() && setOfCollectionField();

    private pointcut setOfNonStaticNonFinalPrivateNonInstancePrivateField() :
		Pointcuts.setOfNonStaticPrivateField() && setOfNonFinalField() && setOfNonInstancePrivateField();

    private pointcut setOfNonStaticNonInstancePrivatePartField(): Pointcuts.setOfNonStaticField() &&
		setOfNonInstancePrivateField() && setOfPartField();

    private pointcut setOfNonStaticNonInstancePrivateContainerOfPartsField(): Pointcuts.setOfNonStaticField() &&
		setOfNonInstancePrivateField() && setOfContainerOfPartsField();

    // Within Code
    private pointcut withinCodeOfNonStaticNonStateModifierMethod() : withincode(!@StateModifier !static * *(..));

    private pointcut withinCodeOfStaticNonStateModifierMethod() : withincode(!@StateModifier static * *(..));

    private pointcut withinCodeOfNonStaticPureFunctionMethod() : withincode(@PureFunction !static * *(..));

    private pointcut withinCodeOfPureFunctionMethod() : withincode(@PureFunction * *(..));

    /*
     * Advice's Pointcuts
     */

    /*
     * Non-Static State Checker Pointcuts
     */

    // Changer Set
    private pointcut nonStaticStateChangerSet(Object changer,
                                              Object to_be_changed) :
		scope() && !exclusions() &&
		setOfNonStaticStateField() &&
		this(changer) && target(to_be_changed);

    // Changer Call
    private pointcut nonStaticStateChangerCall(Object changer,
                                               Object to_be_changed) :
		scope() && !exclusions() &&
		callToNonStaticStateModifierMethod() && 
		this(changer) && target(to_be_changed);

    // Changer Set or Call
    private pointcut nonStaticStateChange(Object to_be_changed) : 
		scope() && !exclusions() &&
		(setOfNonStaticStateField() || callToNonStaticStateModifierMethod()) && 
		target(to_be_changed);

    // Suspicious Set
    private pointcut nonStaticSuspiciousSet(Object changer, Object to_be_changed) :
		scope() && !exclusions() &&
		withinCodeOfNonStaticNonStateModifierMethod() && 
		nonStaticStateChangerSet(changer, to_be_changed);

    // Suspicious Call
    private pointcut nonStaticSuspiciousCall(Object changer,
                                             Object to_be_changed) : 
		scope() && !exclusions() &&
		withinCodeOfNonStaticNonStateModifierMethod() && 
		nonStaticStateChangerCall(changer, to_be_changed);

    // Suspicious Set or Call
    private pointcut nonStaticSuspiciousStateChange(Object changer,
                                                    Object to_be_changed) : 
		scope() && !exclusions() &&
		withinCodeOfNonStaticNonStateModifierMethod() && 
		(nonStaticStateChangerSet(changer, to_be_changed) || nonStaticStateChangerCall(changer, to_be_changed));

    // Illegal State Change (Self)
    private pointcut nonStaticIllegalStateChange(Object changer,
                                                 Object to_be_changed) :
		scope() && !exclusions() &&
		nonStaticSuspiciousStateChange(changer, to_be_changed) &&
		if(changer == to_be_changed);

    // Primitive Part Set
    private pointcut nonStaticPrimitivePartSet() :
		scope() && !exclusions() &&
		setOfNonStaticPrimitivePartField();

    // Primitive Part Get
    private pointcut nonStaticPrimitivePartGet() :
		scope() && !exclusions() &&
		getOfNonStaticPrimitivePartField();

    // Part Set
    private pointcut nonStaticPartSet() :
		scope() && !exclusions() &&
		setOfNonStaticPartField();

    // Part Get
    private pointcut nonStaticPartGet() :
		scope() && !exclusions() &&
		getOfNonStaticPartField();

    /*
     * Capture any set of normal parts (singular multiplicity)
     */
    private pointcut nonStaticNormalPartSet(Object object, Object part) :
		scope() && !exclusions() &&
		nonStaticPartSet() &&
		target(object) && args(part);

    /*
     * Capture any set of complex parts, containers of parts (plural
     * multiplicity)
     */
    private pointcut nonStaticContainerOfPartsArraySet(Object object,
                                                       Object[] part_array) :
		scope() && !exclusions() &&
		setOfNonStaticContainerOfPartsArrayField() &&
		target(object) && args(part_array);

    private pointcut nonStaticContainerOfPartsMapSet(Object object, Map part_map) :
		scope() && !exclusions() &&
		setOfNonStaticContainerOfPartsMapField() &&
		target(object) && args(part_map);

    private pointcut nonStaticContainerOfPartsCollectionSet(Object object,
                                                            Collection part) :
		scope() && !exclusions() && 
		setOfNonStaticContainerOfPartsCollectionField() &&
		target(object) && args(part);

    /*
     * Static State Checker Pointcuts
     */

    // Changer Set
    private pointcut staticStateChangerSet() :
		scope() && !exclusions() &&
		setOfStaticStateField();

    // Changer Call
    private pointcut staticStateChangerCall() :
		scope() && !exclusions() &&
		callToStaticStateModifierMethod();

    // Changer Set or Call
    private pointcut staticStateChange() : 
		scope() && !exclusions() &&
		(setOfStaticStateField() || callToStaticStateModifierMethod());

    // Suspicious Set
    private pointcut staticSuspiciousSet() : 
		scope() && !exclusions() &&
		withinCodeOfStaticNonStateModifierMethod();

    // Suspicious Call
    private pointcut staticSuspiciousCall() : 
		scope() && !exclusions() &&
		withinCodeOfStaticNonStateModifierMethod() && 
		staticStateChangerCall();

    // Suspicious Set or Call
    private pointcut staticSuspiciousStateChange() : 
		scope() && !exclusions() &&
		withinCodeOfStaticNonStateModifierMethod() && 
		(staticStateChangerSet() || staticStateChangerCall());

    // Illegal State Change (Self)
    private pointcut staticIllegalStateChange() :
		scope() && !exclusions() &&
		staticSuspiciousStateChange();

    // Primitive Part Set
    private pointcut staticPrimitivePartSet() :
		scope() && !exclusions() &&
		setOfStaticPrimitivePartField();

    // Primitive Part Get
    private pointcut staticPrimitivePartGet() :
		scope() && !exclusions() &&
		getOfStaticPrimitivePartField();

    // Part Set
    private pointcut staticPartSet() :
		scope() && !exclusions() &&
		setOfStaticPartField();

    // Part Get
    private pointcut staticPartGet() :
		scope() && !exclusions() &&
		getOfStaticPartField();

    /*
     * Capture any set of normal parts (singular multiplicity)
     */
    private pointcut staticNormalPartSet(Object part) :
		scope() && !exclusions() &&
		staticPartSet() &&
		args(part);

    /*
     * Capture any set of complex parts, containers of parts (plural
     * multiplicity)
     */
    private pointcut staticContainerOfPartsArraySet(Object[] part_array) :
		scope() && !exclusions() &&
		setOfStaticContainerOfPartsArrayField() &&
		args(part_array);

    private pointcut staticContainerOfPartsMapSet(Map part_map) :
		scope() && !exclusions() &&
		setOfStaticContainerOfPartsMapField() &&
		args(part_map);

    private pointcut staticContainerOfPartsCollectionSet(Collection part) :
		scope() && !exclusions() && 
		setOfStaticContainerOfPartsCollectionField() &&
		args(part);

    /*
     * Advices
     */

    /*
     * Non-Static PARTS
     */

    /**
     * <b>AdviceType:</b> Before
     * <p>
     * <b>Scope:</b> Set of object normal parts, declared as <code>@Part</code>.
     * <p>
     * <b>Name:</b> setOfObjectNormalPart
     * <p>
     * Captures any normal part set and saves the object part in the aspect's
     * object maps.
     */
    @SuppressAjWarnings("adviceDidNotMatch")
    before(Object object, Object part) : nonStaticNormalPartSet(object, part) {
        if (debug)
            System.out.println("(Register) "
                               + thisJoinPointStaticPart
                               + " within "
                               + thisEnclosingJoinPointStaticPart
                               + " {");
        if (debug)
            System.out.println("\tRegistring normal part for "
                               + thisJoinPointStaticPart.getSignature()
                                                        .toLongString() + ".");

        // In the first time a object's part is captured an object's map for
        // parts is created.
        if (!instance_parts.containsKey(object)) {
            parts_shown = false;
            instance_parts.put(object, new HashMap<Signature, Object>());
        }

        // Extracts static part signature from context and saves object's part
        // reference in the map.
        final Signature signature = thisJoinPointStaticPart.getSignature();
        if (!instance_parts.get(object).containsKey(signature)
            || instance_parts.get(object).get(signature) != part) {
            parts_shown = false;
            instance_parts.get(object).put(signature, part);
        }

        if (isPartAssignedToMoreThanOneWhole(part))
            throw new InvalidRelationshipException("\n\tInvalid invocation of state modifier method on a part assigned to more than one whole."
                                                   + "\n\tA whole/part relationship is one to one, i.e., One part can only belong to one whole.");

        if (debug)
            System.out.println("}");
    }

    /**
     * <b>AdviceType:</b> Before
     * <p>
     * <b>Scope:</b> Set of object container of parts map, declared as
     * <code>@CollectionOfParts</code>.
     * <p>
     * <b>Name:</b> setOfMapContainerOfParts
     * <p>
     * Captures any map container of parts set and saves it in the aspect's
     * object maps.
     */
    @SuppressAjWarnings("adviceDidNotMatch")
    before(Object object, Map part_map) : nonStaticContainerOfPartsMapSet(object, part_map) {
        if (debug)
            System.out.println("(Register) "
                               + thisJoinPointStaticPart
                               + " within "
                               + thisEnclosingJoinPointStaticPart
                               + " {");
        if (debug)
            System.out.println("\tRegistring part map for "
                               + thisJoinPointStaticPart.getSignature()
                                                        .toLongString() + ".");

        if (!maps_containers_of_instance_parts.containsKey(object)) {
            parts_shown = false;
            maps_containers_of_instance_parts.put(object,
                                                  new HashMap<Signature, Map>());
        }

        final Signature signature = thisJoinPointStaticPart.getSignature();

        if (!maps_containers_of_instance_parts.get(object)
                                              .containsKey(signature)
            || maps_containers_of_instance_parts.get(object).get(signature) != part_map) {
            parts_shown = false;
            maps_containers_of_instance_parts.get(object).put(signature,
                                                              part_map);
        }

        if (debug)
            System.out.println("}");
    }

    /**
     * <b>AdviceType:</b> Before
     * <p>
     * <b>Scope:</b> Set of object container of parts collection, declared as
     * <code>@CollectionOfParts</code>.
     * <p>
     * <b>Name:</b> setOfCollectionContainerOfParts
     * <p>
     * Captures any collection container of parts set and saves it in the
     * aspect's object maps.
     */
    @SuppressAjWarnings("adviceDidNotMatch")
    before(Object object, Collection part_collection) : nonStaticContainerOfPartsCollectionSet(object, part_collection) {
        if (debug)
            System.out.println("(Register) "
                               + thisJoinPointStaticPart
                               + " within "
                               + thisEnclosingJoinPointStaticPart
                               + " {");
        if (debug)
            System.out.println("\tRegistring part collection for "
                               + thisJoinPointStaticPart.getSignature()
                                                        .toLongString() + ".");

        if (!collections_containers_of_instance_parts.containsKey(object)) {
            parts_shown = false;
            collections_containers_of_instance_parts.put(object,
                                                         new HashMap<Signature, Collection>());
        }

        final Signature signature = thisJoinPointStaticPart.getSignature();

        if (!collections_containers_of_instance_parts.get(object)
                                                     .containsKey(signature)
            || collections_containers_of_instance_parts.get(object)
                                                       .get(signature) != part_collection) {
            parts_shown = false;
            collections_containers_of_instance_parts.get(object)
                                                    .put(signature,
                                                         part_collection);
        }

        if (debug)
            System.out.println("}");
    }

    /**
     * <b>AdviceType:</b> Before
     * <p>
     * <b>Scope:</b> Set of object container of parts array, declared as
     * <code>@CollectionOfParts</code>.
     * <p>
     * <b>Name:</b> setOfArrayContainerOfParts
     * <p>
     * Captures any array container of parts set and saves it in the aspect's
     * object maps.
     */
    @SuppressAjWarnings("adviceDidNotMatch")
    before(Object object, Object[] part_array) : nonStaticContainerOfPartsArraySet(object, part_array) {
        if (debug)
            System.out.println("(Register) "
                               + thisJoinPointStaticPart
                               + " within "
                               + thisEnclosingJoinPointStaticPart
                               + " {");
        if (debug)
            System.out.println("\tRegistring part array for "
                               + thisJoinPointStaticPart.getSignature()
                                                        .toLongString() + ".");

        if (!arrays_containers_of_instance_parts.containsKey(object)) {
            parts_shown = false;
            arrays_containers_of_instance_parts.put(object,
                                                    new HashMap<Signature, Object[]>());
        }

        final Signature signature = thisJoinPointStaticPart.getSignature();

        if (!arrays_containers_of_instance_parts.get(object)
                                                .containsKey(signature)
            || arrays_containers_of_instance_parts.get(object).get(signature) != part_array) {
            parts_shown = false;
            arrays_containers_of_instance_parts.get(object).put(signature,
                                                                part_array);
        }

        if (debug)
            System.out.println("}");
    }

    /*
     * Non-Static State Verifiers
     */

    /**
     * <b>AdviceType:</b> Before
     * <p>
     * <b>Scope:</b> Any state changer field set or method call.
     * <p>
     * <b>Name:</b> simpleNonStaticStateChange
     * <p>
     * A limited, though simple, checker. Checks only for illegal self
     * modifications. Redundant.
     */
    @SuppressAjWarnings("adviceDidNotMatch")
    before(Object a, Object b) : nonStaticIllegalStateChange(a, b) {
        throw new IllegalStateModificationException("\n\t(Self/Shallow) Illegal state modification"
                                                    + " at "
                                                    + thisJoinPoint.getStaticPart()
                                                    + " within "
                                                    + thisEnclosingJoinPointStaticPart
                                                    + "\n\tCaptured at "
                                                    + EclipseConsoleHelper.convertToHyperlinkFormat(thisJoinPointStaticPart)
                                                    + "\n\twithin "
                                                    + EclipseConsoleHelper.convertToHyperlinkFormat(thisEnclosingJoinPointStaticPart)
                                                    + "."
                                                    + "\n\tNon-@StateModifier origin at "
                                                    + EclipseConsoleHelper.convertToHyperlinkFormat(thisEnclosingJoinPointStaticPart)
                                                    + ".");
    }

    /**
     * <b>AdviceType:</b> Before
     * <p>
     * <b>Scope:</b> Any state changer field set or method call.
     * <p>
     * <b>Name:</b> complexNonStaticStateChange
     * <p>
     * A full state checker advice. Checks all the object parts and containers
     * of parts. Checks for, both, shallow and deep modifications.
     */
    @SuppressAjWarnings("adviceDidNotMatch")
    before(Object possible_part) : nonStaticStateChange(possible_part) {

        if (isPartAssignedToMoreThanOneWhole(possible_part))
            throw new InvalidRelationshipException("\n\tInvalid invocation of state modifier method on a part assigned to more than one whole."
                                                   + "\n\tA whole/part relationship is one to one, i.e., One part can only belong to one whole.");

        verifyNonStaticParts(possible_part,
                             thisJoinPoint,
                             thisEnclosingJoinPointStaticPart);
        verifyStaticPartsForNonStaticExecutions(possible_part,
                                                thisJoinPoint,
                                                thisEnclosingJoinPointStaticPart);
    }

    /*
     * Static PARTS
     */

    /**
     * <b>AdviceType:</b> Before
     * <p>
     * <b>Scope:</b> Set of object normal parts, declared as <code>@Part</code>.
     * <p>
     * <b>Name:</b> setOfObjectNormalPart
     * <p>
     * Captures any normal part set and saves the object part in the aspect's
     * object maps.
     */
    @SuppressAjWarnings("adviceDidNotMatch")
    before(Object part) : staticNormalPartSet(part) {
        if (debug)
            System.out.println("(Register) "
                               + thisJoinPointStaticPart
                               + " within "
                               + thisEnclosingJoinPointStaticPart
                               + " {");
        if (debug)
            System.out.println("\tRegistring normal part for "
                               + thisJoinPointStaticPart.getSignature()
                                                        .toLongString() + ".");

        Class target_class = thisJoinPointStaticPart.getSignature()
                                                    .getDeclaringType();

        if (!class_parts.containsKey(target_class)) {
            parts_shown = false;
            class_parts.put(target_class, new HashMap<Signature, Object>());
        }

        final Signature signature = thisJoinPointStaticPart.getSignature();

        if (!class_parts.get(target_class).containsKey(signature)
            || class_parts.get(target_class).get(signature) != part) {
            parts_shown = false;
            class_parts.get(target_class).put(signature, part);
        }

        // Verifies if one part is already assigned to other object.
        if (isPartAssignedToMoreThanOneWhole(part))
            throw new InvalidRelationshipException("\n\tInvalid invocation of state modifier method on a part assigned to more than one whole."
                                                   + "\n\tA whole/part relationship is one to one, i.e., One part can only belong to one whole.");

        if (debug)
            System.out.println("}");
    }

    /**
     * <b>AdviceType:</b> Before
     * <p>
     * <b>Scope:</b> Set of object container of parts map, declared as
     * <code>@CollectionOfParts</code>.
     * <p>
     * <b>Name:</b> setOfMapContainerOfParts
     * <p>
     * Captures any map container of parts set and saves it in the aspect's
     * object maps.
     */
    @SuppressAjWarnings("adviceDidNotMatch")
    before(Map part_map) : staticContainerOfPartsMapSet(part_map) {
        if (debug)
            System.out.println("(Register) "
                               + thisJoinPointStaticPart
                               + " within "
                               + thisEnclosingJoinPointStaticPart
                               + " {");
        if (debug)
            System.out.println("\tRegistring part map for "
                               + thisJoinPointStaticPart.getSignature()
                                                        .toLongString() + ".");

        Class target_class = thisJoinPointStaticPart.getSignature()
                                                    .getDeclaringType();

        if (!maps_containers_of_class_parts.containsKey(target_class)) {
            parts_shown = false;
            maps_containers_of_class_parts.put(target_class,
                                               new HashMap<Signature, Map>());
        }

        final Signature signature = thisJoinPointStaticPart.getSignature();

        if (!maps_containers_of_class_parts.get(target_class)
                                           .containsKey(signature)
            || maps_containers_of_class_parts.get(target_class).get(signature) != part_map) {
            parts_shown = false;
            maps_containers_of_class_parts.get(target_class).put(signature,
                                                                 part_map);
        }

        if (debug)
            System.out.println("}");
    }

    /**
     * <b>AdviceType:</b> Before
     * <p>
     * <b>Scope:</b> Set of object container of parts collection, declared as
     * <code>@CollectionOfParts</code>.
     * <p>
     * <b>Name:</b> setOfCollectionContainerOfParts
     * <p>
     * Captures any collection container of parts set and saves it in the
     * aspect's object maps.
     */
    @SuppressAjWarnings("adviceDidNotMatch")
    before(Collection part_collection) : staticContainerOfPartsCollectionSet(part_collection) {
        if (debug)
            System.out.println("(Register) "
                               + thisJoinPointStaticPart
                               + " within "
                               + thisEnclosingJoinPointStaticPart
                               + " {");
        if (debug)
            System.out.println("\tRegistring part collection for "
                               + thisJoinPointStaticPart.getSignature()
                                                        .toLongString() + ".");

        Class target_class = thisJoinPointStaticPart.getSignature()
                                                    .getDeclaringType();

        if (!collections_containers_of_class_parts.containsKey(target_class)) {
            parts_shown = false;
            collections_containers_of_class_parts.put(target_class,
                                                      new HashMap<Signature, Collection>());
        }

        final Signature signature = thisJoinPointStaticPart.getSignature();

        if (!collections_containers_of_class_parts.get(target_class)
                                                  .containsKey(signature)
            || collections_containers_of_class_parts.get(target_class)
                                                    .get(signature) != part_collection) {
            parts_shown = false;
            collections_containers_of_class_parts.get(target_class)
                                                 .put(signature,
                                                      part_collection);
        }

        if (debug)
            System.out.println("}");
    }

    /**
     * <b>AdviceType:</b> Before
     * <p>
     * <b>Scope:</b> Set of object container of parts array, declared as
     * <code>@CollectionOfParts</code>.
     * <p>
     * <b>Name:</b> setOfArrayContainerOfParts
     * <p>
     * Captures any array container of parts set and saves it in the aspect's
     * object maps.
     */
    @SuppressAjWarnings("adviceDidNotMatch")
    before(Object[] part_array) : staticContainerOfPartsArraySet(part_array) {
        if (debug)
            System.out.println("(Register) "
                               + thisJoinPointStaticPart
                               + " within "
                               + thisEnclosingJoinPointStaticPart
                               + " {");
        if (debug)
            System.out.println("\tRegistring part array for "
                               + thisJoinPointStaticPart.getSignature()
                                                        .toLongString() + ".");

        Class target_class = thisJoinPointStaticPart.getSignature()
                                                    .getDeclaringType();

        if (!arrays_containers_of_class_parts.containsKey(target_class)) {
            parts_shown = false;
            arrays_containers_of_class_parts.put(target_class,
                                                 new HashMap<Signature, Object[]>());
        }

        final Signature signature = thisJoinPointStaticPart.getSignature();

        if (!arrays_containers_of_class_parts.get(target_class)
                                             .containsKey(signature)
            || arrays_containers_of_class_parts.get(target_class)
                                               .get(signature) != part_array) {
            parts_shown = false;
            arrays_containers_of_class_parts.get(target_class).put(signature,
                                                                   part_array);
        }

        if (debug)
            System.out.println("}");
    }

    /*
     * Static State Verifiers
     */

    /**
     * <b>AdviceType:</b> Before
     * <p>
     * <b>Scope:</b> Any state changer field set or method call.
     * <p>
     * <b>Name:</b> simpleStaticStateChange
     * <p>
     * A limited, though simple, checker. Checks only for illegal self
     * modifications. Redundant.
     */
    @SuppressAjWarnings("adviceDidNotMatch")
    before() : staticIllegalStateChange() {
        Class target_class = thisJoinPointStaticPart.getSignature()
                                                    .getDeclaringType();
        Class this_class = thisEnclosingJoinPointStaticPart.getSignature()
                                                           .getDeclaringType();

        if (this_class.equals(target_class))
            throw new IllegalStateModificationException("\n\t(Self/Shallow) Illegal state modification"
                                                        + " at "
                                                        + thisJoinPoint.getStaticPart()
                                                        + " within "
                                                        + thisEnclosingJoinPointStaticPart
                                                        + "\n\tCaptured at "
                                                        + EclipseConsoleHelper.convertToHyperlinkFormat(thisJoinPointStaticPart)
                                                        + "\n\twithin "
                                                        + EclipseConsoleHelper.convertToHyperlinkFormat(thisEnclosingJoinPointStaticPart)
                                                        + "."
                                                        + "\n\tNon-@StateModifier origin at "
                                                        + EclipseConsoleHelper.convertToHyperlinkFormat(thisEnclosingJoinPointStaticPart)
                                                        + ".");
    }

    /**
     * <b>AdviceType:</b> Before
     * <p>
     * <b>Scope:</b> Any state changer field set or method call.
     * <p>
     * <b>Name:</b> complexStaticStateChange
     * <p>
     * A full state checker advice. Checks all the object parts and containers
     * of parts. Checks for, both, shallow and deep modifications.
     */
    @SuppressAjWarnings("adviceDidNotMatch")
    before() : staticStateChange() {
        verifyStaticPartsForStaticExecutions(thisJoinPoint,
                                             thisEnclosingJoinPointStaticPart);
    }

    /*
     * Declared Warnings and Errors
     */

    /*
     * Warnings
     */

    /*
     * Methods, outside of scope, declared as <code>@PureFunction</code>.
     */
    // Definition of a method declared as <code>@PureFunction</code>, outside
    // the scope.
    declare warning : !scope() && !exclusions() && executionOfPureFunctionMethod()
		: "Definition of method declared as @PureFunction outside the scope of the enforcement.";

    // Invocation of a method declared as <code>@PureFunction</code>, outside
    // the scope.
    declare warning : !scope() && !exclusions() && callToPureFunctionMethod()
		: "The method being called is declared as @PureFunction outside the scope of the enforcement.";

    /**
     * Methods, outside of scope, declared as <code>@StateModifier</code>.
     */
    // Definition of a method declared as <code>@StateModifier</code>, outside
    // the scope.
    declare warning : !scope() && !exclusions() && executionOfStateModifierMethod()
		: "Definition of method declared as @StateModifier outside the scope of the enforcement.";

    // Invocation of a method declared as <code>@StateModifier</code>, outside
    // the scope.
    declare warning : !scope() && !exclusions() && callToStateModifierMethod()
		: "The method being called is declared as @StateModifier outside the scope of the enforcement.";

    /*
     * Fields, outside of scope, declared as <code>@Part</code>.
     */
    // Get of field declared as <code>@Part</code> outside the scope of the
    // enforcement.
    declare warning : !scope() && !exclusions() && getOfPartField()
		: "The attribute being gotten is declared as @Part outside the scope of the enforcement.";

    // Get of field declared as <code>@Part</code> outside the scope of the
    // enforcement.
    declare warning : !scope() && !exclusions() && setOfPartField()
		: "The attribute being set is declared as @Part outside the scope of the enforcement.";

    /*
     * Fields, outside of scope, declared as <code>@ContainerOfParts</code>.
     */
    // Get of field declared as <code>@ContainerOfParts</code> outside the scope
    // of the enforcement.
    declare warning : !scope() && !exclusions() && getOfContainerOfPartsField()
		: "The attribute being gotten is declared as @ContainerOfParts outside the scope of the enforcement.";

    // Get of field declared as <code>@ContainerOfParts</code> outside the scope
    // of the enforcement.
    declare warning : !scope() && !exclusions() && setOfContainerOfPartsField()
		: "The attribute being set is declared as @ContainerOfParts outside the scope of the enforcement.";

    /*
     * Fields, outside of scope, declared as <code>@NonState</code>.
     */
    // Get of field declared as <code>@NonState</code> outside the scope of the
    // enforcement.
    declare warning : !scope() && !exclusions() && getOfNonStateField()
		: "The attribute being gotten is declared as @NonState outside the scope of the enforcement.";

    // Get of field declared as <code>@NonState</code> outside the scope of the
    // enforcement.
    declare warning : !scope() && !exclusions() && setOfNonStateField()
		: "The attribute being set is declared as @NonState outside the scope of the enforcement.";

    /*
     * Errors
     */

    /*
     * Set of a field or call to non <code>@PureFunction</code> method
     * "withincode" of a method declared as <code>@PureFunction</code>.
     */
    // Set of a field within a method declared as <code>@PureFunction</code>.
    declare error : 
		scope() && !exclusions() && withinCodeOfPureFunctionMethod() && Pointcuts.setOfField()
		: "A @PureFunction method cannot set any field.";

    // Call to a non-<code>@PureFunction</code> method within a method declared
    // as <code>@PureFunction</code>.
    declare error : 
		scope() && !exclusions() && withinCodeOfPureFunctionMethod() && callToNonPureFunctionMethod()
		: "A @PureFunction method can only call other @PureFunction methods.";

    /*
     * Methods simultaneously declared as <code>@StateModifier</code> and
     * <code>@PureFunction</code>
     */
    // Call to method simultaneously declared as <code>@StateModifier</code> and
    // <code>@PureFunction</code>.
    declare error : scope() && !exclusions() && callToStateModifierMethod() && callToPureFunctionMethod()
		: "The method being called can't be declared simultaneously as @StateModifier and @PureFunction.";

    // Definition of method simultaneously as <code>@StateModifier</code> and
    // <code>@PureFunction</code>.
    declare error : scope() && !exclusions() && executionOfStateModifierMethod() &&  executionOfPureFunctionMethod()
		: "A method can't be declared simultaneously as @StateModifier and @PureFunction.";

    /*
     * Declarations of fields not eligible to be declared as <code>@Part</code>
     */
    // Set of primitive field declared as <code>@Part</code>.
    declare error : scope() && !exclusions() && setOfPrimitivePartField()
		: "The attribute being set is primitive and thus can not be declared as a @Part.";

    // Set of field simultaneously declared as <code>@NonState</code> and
    // <code>@Part</code>.
    declare error : scope() && !exclusions() && setOfPartField() && setOfNonStateField()
		: "The attribute being set is simultaneously @NonState and @Part.";

    // Set of field declared as @Part being non private.
    declare error : scope() && !exclusions() && setOfNonPrivatePartField()
		: "The attribute being set is declared as @Part, thus must have private accessibility.";

    // Set of non-static field declared as @Part being non
    // <code>@InstancePrivate</code>.
    declare error : scope() && !exclusions() && setOfNonStaticNonInstancePrivatePartField()
		: "The attribute being set is declared as @Part, thus must be declared also as @InstancePrivate.";

    // Get of primitive field declared as <code>@Part</code>.
    declare error : scope() && !exclusions() && getOfPrimitivePartField() 
		: "The attribute being gotten is primitive and thus can not be declared as a @Part.";

    // Get of field simultaneously declared as <code>@NonState</code> and
    // <code>@Part</code>.
    declare error : scope() && !exclusions() && getOfPartField() && getOfNonStateField()
		: "The attribute being gotten is simultaneously @NonState and @Part.";

    // Get of field declared as @Part being non private.
    declare error : scope() && !exclusions() && getOfNonPrivatePartField()
		: "The attribute being gotten is declared as @Part, thus must have private accessibility.";

    // Get of non-static field declared as @Part being non
    // <code>@InstancePrivate</code>.
    declare error : scope() && !exclusions() && getOfNonStaticNonInstancePrivatePartField()
		: "The attribute being gotten is declared as @Part, thus must be declared also as @InstancePrivate.";

    /*
     * Declarations of fields not eligible to be declared as
     * <code>@ContainerOfParts</code>
     */
    // Set of primitive field declared as <code>@ContainerOfParts</code>.
    declare error : scope() && !exclusions() && setOfPrimitiveContainerOfPartsField()
		: "The attribute being set is primitive and thus can not be declared as a @ContainerOfParts.";

    // Set of field simultaneously declared as <code>@NonState</code> and
    // <code>@ContainerOfParts</code>.
    declare error : scope() && !exclusions() && setOfContainerOfPartsField() && setOfNonStateField()
		: "The attribute being set is simultaneously @NonState and @ContainerOfParts.";

    // Set of field declared as <code>@ContainerOfParts</code> and not being an
    // Array([]), Collection or Map.
    declare error : scope() && !exclusions() && setOfNonEligibleContainerOfPartsField()
		: "The attribute being set is not eligible to be a @ContainerOfParts. Only Arrays([]), Collections or Maps are supported.";

    // Set of field declared as @ContainerOfParts being non private.
    declare error : scope() && !exclusions() && setOfNonPrivateContainerOfPartsField()
		: "The attribute being set is declared as @ContainerOfParts, thus must have private accessibility.";

    // Set of non-static field declared as @ContainerOfParts being non
    // <code>@InstancePrivate</code>.
    declare error : scope() && !exclusions() && setOfNonStaticNonInstancePrivateContainerOfPartsField()
		: "The attribute being set is declared as @ContainerOfParts, thus must be declared also as @InstancePrivate.";

    // Get of primitive field declared as <code>@ContainerOfParts</code>.
    declare error : scope() && !exclusions() && getOfPrimitiveContainerOfPartsField() 
		: "The attribute being gotten is primitive and thus can not be declared as a @ContainerOfParts.";

    // Get of field simultaneously declared as <code>@NonState</code> and
    // <code>@ContainerOfParts</code>.
    declare error : scope() && !exclusions() && getOfContainerOfPartsField() && getOfNonStateField()
		: "The attribute being gotten is simultaneously @NonState and @ContainerOfParts.";

    // Get of field declared as <code>@ContainerOfParts</code> and not being an
    // Array([]), Collection or Map.
    declare error : scope() && !exclusions() && getOfNonEligibleContainerOfPartsField()
		: "The attribute being gotten is not eligible to be a @ContainerOfParts. Only Arrays([]), Collections or Maps are supported.";

    // Get of field declared as @ContainerOfParts being non private.
    declare error : scope() && !exclusions() && getOfNonPrivateContainerOfPartsField()
		: "The attribute being gotten is declared as @ContainerOfParts, thus must have private accessibility.";

    // Get of non-static field declared as @ContainerOfParts being non
    // <code>@InstancePrivate</code>.
    declare error : scope() && !exclusions() && getOfNonStaticNonInstancePrivateContainerOfPartsField()
		: "The attribute being gotten is declared as @ContainerOfParts, thus must be declared also as @InstancePrivate.";

    /*
     * Declarations of fields that must declared as <code>@NonState</code>
     */
    // Set of !static !final private field !<code>@InstancePrivate</code>, thus
    // must be declared as <code>@NonState</code>.
    declare error : scope() && !exclusions() && setOfNonStaticNonFinalPrivateNonInstancePrivateField() && !setOfNonStateField()
		: "The attribute being set is !static !final private and isn't declared as @InstancePrivate, thus must be declared as @NonState.";

    // Set of !static !private field, thus must be declared as
    // <code>@NonState</code>.
    declare error : scope() && !exclusions() && setOfNonFinalNonPrivateField() && !setOfNonStateField()
		: "The attribute being set is !final and !private, thus must be declared as @NonState.";

    // Get of !static !final private field !<code>@InstancePrivate</code>, thus
    // must be declared as <code>@NonState</code>.
    declare error : scope() && !exclusions() && getOfNonStaticNonFinalPrivateNonInstancePrivateField() && !getOfNonStateField()
		: "The attribute being gotten is !static !final private and isn't declared as @InstancePrivate, thus must be declared as @NonState.";

    // Get of !static !private field, thus must be declared as
    // <code>@NonState</code>.
    declare error : scope() && !exclusions() && getOfNonFinalNonPrivateField() && !getOfNonStateField()
		: "The attribute being gotten is !final and !private, thus must be declared as @NonState.";

    /*
     * Aspect Methods
     */

    /**
     * Verifies if in all of the whole/part relationships exists a part assigned
     * to more than on whole.
     * 
     * @pre possible_part != null
     * @post true
     * @param possible_part is the part to be checked for duplicate assignment.
     * @return true if one part is assigned to more than one whole.
     */
    private static boolean isPartAssignedToMoreThanOneWhole(Object possible_part) {
        int number_of_part_occurences = 0;

        /*
         * Non-Static
         */

        // Normal Parts Modification
        for (Object instance : instance_parts.keySet())
            if (instance_parts.get(instance).containsValue(possible_part))
                number_of_part_occurences++;

        // Parts in Map Container of Parts Modification
        for (Object instance : maps_containers_of_instance_parts.keySet())
            for (Map part_map : maps_containers_of_instance_parts.get(instance)
                                                                 .values())
                if (part_map.containsValue(possible_part))
                    number_of_part_occurences++;

        // Parts in Collection Container of Parts Modification
        for (Object instance : collections_containers_of_instance_parts.keySet())
            for (Collection part_collection : collections_containers_of_instance_parts.get(instance)
                                                                                      .values())
                for (Object object : part_collection)
                    if (object == possible_part)
                        number_of_part_occurences++;

        // Parts in Array Container of Parts Modification
        for (Object instance : arrays_containers_of_instance_parts.keySet())
            for (Object[] part_array : arrays_containers_of_instance_parts.get(instance)
                                                                          .values())
                for (Object part : part_array)
                    if (part == possible_part)
                        number_of_part_occurences++;

        /*
         * Static
         */

        // Normal Parts Modification
        for (Class target_class : class_parts.keySet())
            if (class_parts.get(target_class).containsValue(possible_part))
                number_of_part_occurences++;

        // Parts in Map Container of Parts Modification
        for (Class target_class : maps_containers_of_class_parts.keySet())
            for (Map part_map : maps_containers_of_instance_parts.get(target_class)
                                                                 .values())
                if (part_map.containsValue(possible_part))
                    number_of_part_occurences++;

        // Parts in Collection Container of Parts Modification
        for (Class target_class : collections_containers_of_class_parts.keySet())
            for (Collection part_collection : collections_containers_of_instance_parts.get(target_class)
                                                                                      .values())
                if (part_collection.contains(possible_part))
                    number_of_part_occurences++;

        // Parts in Array Container of Parts Modification
        for (Class target_class : arrays_containers_of_class_parts.keySet())
            for (Object[] part_array : arrays_containers_of_instance_parts.get(target_class)
                                                                          .values())
                for (Object part : part_array)
                    if (part == possible_part)
                        number_of_part_occurences++;

        return number_of_part_occurences >= 2;
    }

    /**
     * FOR DEBUG PURPOSES ONLY. Shows the parts of all the objects in the
     * aspect's maps.
     * 
     * @pre true
     * @post true
     */
    @SuppressWarnings("unused")
    private static void showAllParts() {
        if (parts_shown)
            return;

        parts_shown = true;

        System.out.println("\tAll parts of all objects {");
        for (Object object : instance_parts.keySet()) {
            System.out.println("\t\tObject '" + object + "' parts {");
            for (Signature part_signature : instance_parts.get(object).keySet())
                System.out.println("\t\t\t"
                                   + part_signature
                                   + " = "
                                   + instance_parts.get(object)
                                                   .get(part_signature));
            System.out.println("\t\t}");
        }
        System.out.println("\t}");
    }

    /**
     * Returns the <code>JoinPoint</code>s objects of all non static non
     * modifier executions retained in the <code>StackReplica</code> Aspect.
     * 
     * @pre true
     * @post true
     * @return <code>LinkedList</code>list containing all non modifier
     *         executions <code>JoinPoint</code>s.
     */
    private static LinkedList<JoinPoint> nonStaticNonModifierExecutionsJoinPoints() {
        LinkedList<JoinPoint> execution_join_points = new LinkedList<JoinPoint>();
        for (JoinPoint join_point : StackReplica.getStack()) {
            Signature signature = join_point.getSignature();
            // TODO criar mensagem de erro
            assert signature instanceof MethodSignature : "Bla bla! Não pode ocorrer";
            MethodSignature method_signature = (MethodSignature) signature;
            Method executed_method = method_signature.getMethod();

            if (!executed_method.isAnnotationPresent(StateModifier.class)
                && !Modifier.isStatic(executed_method.getModifiers()))
                execution_join_points.add(join_point);
        }

        return execution_join_points;
    }

    /**
     * Returns the <code>JoinPoint</code>s objects of all static non modifier
     * executions retained in the <code>StackReplica</code> Aspect.
     * 
     * @pre true
     * @post true
     * @return <code>LinkedList</code>list containing all non modifier
     *         executions <code>JoinPoint</code>s.
     */
    private static LinkedList<JoinPoint> staticNonModifierExecutionsJoinPoints() {
        LinkedList<JoinPoint> execution_join_points = new LinkedList<JoinPoint>();
        for (JoinPoint join_point : StackReplica.getStack()) {
            Signature signature = join_point.getSignature();
            // TODO criar mensagem de erro
            assert signature instanceof MethodSignature : "Bla bla! Não pode ocorrer";
            MethodSignature method_signature = (MethodSignature) signature;
            Method executed_method = method_signature.getMethod();

            if (!executed_method.isAnnotationPresent(StateModifier.class)
                && Modifier.isStatic(executed_method.getModifiers()))
                execution_join_points.add(join_point);
        }

        return execution_join_points;
    }

    /**
     * Verify the state of non static parts to check if they are being changed.
     * 
     * @pre true
     * @post true
     * @param possible_part is the target_object susceptible of change.
     * @param this_join_point is the JoinPoint of the current call or set.
     * @param this_enclosing_join_point_static_part is the JointPoint execution
     *            enclosing the JoinPoint.
     */
    private static void verifyNonStaticParts(Object possible_part,
                                             JoinPoint this_join_point,
                                             StaticPart this_enclosing_join_point_static_part) {
        LinkedList<JoinPoint> stack = nonStaticNonModifierExecutionsJoinPoints();

        for (JoinPoint join_point : stack) {
            // Target Object subject of modification
            Object object = join_point.getTarget();

            // Self Modification
            if (object == possible_part)
                throw new IllegalStateModificationException("\n\t(Self) Illegal state modification"
                                                            + errorMessageForIllegalStateModifications(join_point,
                                                                                                       this_join_point,
                                                                                                       this_enclosing_join_point_static_part));

            // Normal Parts Modification
            if (instance_parts.containsKey(object))
                if (instance_parts.get(object).containsValue(possible_part))
                    throw new IllegalStateModificationException("\n\t(Deep) Illegal state modification"
                                                                + errorMessageForIllegalStateModifications(stack.getFirst(),
                                                                                                           this_join_point,
                                                                                                           this_enclosing_join_point_static_part));

            // Parts in Map Container of Parts Modification
            if (maps_containers_of_instance_parts.containsKey(object))
                for (Map part_map : maps_containers_of_instance_parts.get(object)
                                                                     .values())
                    if (part_map.containsValue(possible_part))
                        throw new IllegalStateModificationException("\n\t(Deep/Map) Illegal state modification"
                                                                    + errorMessageForIllegalStateModifications(join_point,
                                                                                                               this_join_point,
                                                                                                               this_enclosing_join_point_static_part));

            // Parts in Collection Container of Parts Modification
            if (collections_containers_of_instance_parts.containsKey(object))
                for (Collection part_collection : collections_containers_of_instance_parts.get(object)
                                                                                          .values())
                    if (part_collection.contains(possible_part))
                        throw new IllegalStateModificationException("\n\t(Deep/Collection) Illegal state modification"
                                                                    + errorMessageForIllegalStateModifications(join_point,
                                                                                                               this_join_point,
                                                                                                               this_enclosing_join_point_static_part));

            // Parts in Array Container of Parts Modification
            if (arrays_containers_of_instance_parts.containsKey(object))
                for (Object[] part_array : arrays_containers_of_instance_parts.get(object)
                                                                              .values())
                    for (Object part : part_array)
                        if (part == possible_part)
                            throw new IllegalStateModificationException("\n\t(Deep/Array) Illegal state modification"
                                                                        + errorMessageForIllegalStateModifications(join_point,
                                                                                                                   this_join_point,
                                                                                                                   this_enclosing_join_point_static_part));

        }
    }

    /**
     * Verify the state of static parts to check if they are being changed.
     * 
     * @pre true
     * @post true
     * @param possible_part is the target_object susceptible of change.
     * @param this_join_point is the JoinPoint of the current call or set.
     * @param this_enclosing_join_point_static_part is the JointPoint execution
     *            enclosing the JoinPoint.
     */
    private static void verifyStaticPartsForNonStaticExecutions(Object possible_part,
                                                                JoinPoint this_join_point,
                                                                StaticPart this_enclosing_join_point_static_part) {
        LinkedList<JoinPoint> stack = staticNonModifierExecutionsJoinPoints();

        for (JoinPoint join_point : stack) {
            Class target_class = join_point.getStaticPart()
                                           .getSignature()
                                           .getDeclaringType();

            // Normal Parts Modification
            if (class_parts.containsKey(target_class))
                if (class_parts.get(target_class).containsValue(possible_part))
                    throw new IllegalStateModificationException("\n\t(Deep) Illegal static state modification"
                                                                + errorMessageForIllegalStateModifications(join_point,
                                                                                                           this_join_point,
                                                                                                           this_enclosing_join_point_static_part));

            // Parts in Map Container of Parts Modification
            if (maps_containers_of_class_parts.containsKey(target_class))
                for (Map part_map : maps_containers_of_class_parts.get(target_class)
                                                                  .values())
                    if (part_map.containsValue(possible_part))
                        throw new IllegalStateModificationException("\n\t(Deep/Map) Illegal static state modification"
                                                                    + errorMessageForIllegalStateModifications(join_point,
                                                                                                               this_join_point,
                                                                                                               this_enclosing_join_point_static_part));

            // Parts in Collection Container of Parts Modification
            if (collections_containers_of_class_parts.containsKey(target_class))
                for (Collection part_collection : collections_containers_of_class_parts.get(target_class)
                                                                                       .values())
                    if (part_collection.contains(possible_part))
                        throw new IllegalStateModificationException("\n\t(Deep/Collection) Illegal static state modification"
                                                                    + errorMessageForIllegalStateModifications(join_point,
                                                                                                               this_join_point,
                                                                                                               this_enclosing_join_point_static_part));

            // Parts in Array Container of Parts Modification
            if (arrays_containers_of_class_parts.containsKey(target_class))
                for (Object[] part_array : arrays_containers_of_class_parts.get(target_class)
                                                                           .values())
                    for (Object part : part_array)
                        if (part == possible_part)
                            throw new IllegalStateModificationException("\n\t(Deep/Array) Illegal static state modification"
                                                                        + errorMessageForIllegalStateModifications(join_point,
                                                                                                                   this_join_point,
                                                                                                                   this_enclosing_join_point_static_part));

        }
    }

    /**
     * Verify the state of static parts to check if they are being changed.
     * 
     * @pre true
     * @post true
     * @param this_join_point is the JoinPoint of the current call or set.
     * @param this_enclosing_join_point_static_part is the JointPoint execution
     *            enclosing the JoinPoint.
     */
    private static void verifyStaticPartsForStaticExecutions(JoinPoint this_join_point,
                                                             StaticPart this_enclosing_join_point_static_part) {
        Class target_class = this_join_point.getStaticPart()
                                            .getSignature()
                                            .getDeclaringType();

        LinkedList<JoinPoint> stack = staticNonModifierExecutionsJoinPoints();

        for (JoinPoint join_point : stack) {
            // Target Class subject of modification
            Class stack_class = join_point.getSignature().getDeclaringType();

            // Self Modification
            if (stack_class.equals(target_class))
                throw new IllegalStateModificationException("\n\t(Self) Illegal static state modification"
                                                            + errorMessageForIllegalStateModifications(join_point,
                                                                                                       this_join_point,
                                                                                                       this_enclosing_join_point_static_part));
        }
    }

    /**
     * Builds the error string when an illegal state modification occurs.
     * 
     * @pre true
     * @post true
     * @param join_point is a susceptible of change target_object's JoinPoint.
     * @param this_join_point is the JoinPoint of the current call or set.
     * @param this_enclosing_join_point_static_part is the JointPoint execution
     *            enclosing the JoinPoint.
     * @return error string when an illegal state modification occurs.
     */
    private static String errorMessageForIllegalStateModifications(JoinPoint join_point,
                                                                   JoinPoint this_join_point,
                                                                   StaticPart this_enclosing_join_point_static_part) {
        String error_message = " at "
                               + this_join_point.getStaticPart()
                               + " within "
                               + this_enclosing_join_point_static_part
                               + "\n\tCaptured at "
                               + EclipseConsoleHelper.convertToHyperlinkFormat(this_join_point.getStaticPart())
                               + "\n\twithin "
                               + EclipseConsoleHelper.convertToHyperlinkFormat(this_enclosing_join_point_static_part)
                               + "."
                               + "\n\tNon-@StateModifier origin at "
                               + EclipseConsoleHelper.convertToHyperlinkFormat(join_point.getStaticPart())
                               + ".";

        return error_message;
    }

    /*
     * Aspect Attributes
     */

    // Non-Static
    private static WeakHashMap<Object, HashMap<Signature, Object>> instance_parts = new WeakHashMap<Object, HashMap<Signature, Object>>();
    private static WeakHashMap<Object, HashMap<Signature, Map>> maps_containers_of_instance_parts = new WeakHashMap<Object, HashMap<Signature, Map>>();
    private static WeakHashMap<Object, HashMap<Signature, Collection>> collections_containers_of_instance_parts = new WeakHashMap<Object, HashMap<Signature, Collection>>();
    private static WeakHashMap<Object, HashMap<Signature, Object[]>> arrays_containers_of_instance_parts = new WeakHashMap<Object, HashMap<Signature, Object[]>>();

    // Static
    private static WeakHashMap<Class, HashMap<Signature, Object>> class_parts = new WeakHashMap<Class, HashMap<Signature, Object>>();
    private static WeakHashMap<Class, HashMap<Signature, Map>> maps_containers_of_class_parts = new WeakHashMap<Class, HashMap<Signature, Map>>();
    private static WeakHashMap<Class, HashMap<Signature, Collection>> collections_containers_of_class_parts = new WeakHashMap<Class, HashMap<Signature, Collection>>();
    private static WeakHashMap<Class, HashMap<Signature, Object[]>> arrays_containers_of_class_parts = new WeakHashMap<Class, HashMap<Signature, Object[]>>();

    // FOR DEBUG PURPOSES ONLY.
    private static final boolean debug = false;
    private static boolean parts_shown = false;
}
