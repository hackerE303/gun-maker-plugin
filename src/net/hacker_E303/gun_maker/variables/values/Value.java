package net.hacker_E303.gun_maker.variables.values;

import net.hacker_E303.gun_maker.variables.fields.Field;

/**
 * Interface representing a value type that has a default value and can create a field representation.
 * @param <D> the type of the default value
 * @param <F> the type of field this value can create
 */
public interface Value<D extends Object, F extends Field<?>> {
    
    /**
     * Returns the default value for this type.
     * @return the default value
     */
    public abstract D def();
    
    /**
     * Creates a field representation for this value type.
     * @return a new field instance for this value type
     */
    public abstract F field();
}
