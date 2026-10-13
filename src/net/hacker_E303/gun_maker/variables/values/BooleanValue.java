package net.hacker_E303.gun_maker.variables.values;

import net.hacker_E303.gun_maker.variables.Content;
import net.hacker_E303.gun_maker.variables.fields.BooleanField;

/**
 * A Content implementation that represents a boolean value with default value support.
 * Associates a name with a Boolean value and provides methods to get and set its value,
 * as well as create a field representation for UI display.
 */
public class BooleanValue extends Content<Boolean> implements Value<Boolean, BooleanField> {

    // The stored boolean value
    private Boolean value;

    /**
     * Constructs a BooleanValue with the given name and initial value.
     * @param name the name associated with this value
     * @param value the initial boolean value
     */
    public BooleanValue(String name, Boolean value) {
        super(name);
        this.value = value;
    }

    /**
     * Retrieves the current boolean value.
     * @return the stored boolean value
     */
    @Override
    public Boolean get() {
        return value;
    }

    /**
     * Updates the stored boolean value.
     * @param value the new boolean value
     */
    @Override
    public void set(Boolean value) {
        this.value = value;
    }

    /**
     * Creates a field representation for this boolean value.
     * @return a new BooleanField instance for this value
     */
    @Override
    public BooleanField field() {
        return new BooleanField(name());
    }

    /**
     * Returns the default boolean value (false).
     * @return the default value false
     */
    @Override
    public Boolean def() {
        return false;
    }

    /**
     * Indicates that this content item does not support field-based representation.
     * @return false, as this is a value implementation
     */
    @Override
    public boolean isField() {
        return false;
    }
}
