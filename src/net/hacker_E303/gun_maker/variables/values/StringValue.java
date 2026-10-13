package net.hacker_E303.gun_maker.variables.values;

import net.hacker_E303.gun_maker.variables.Content;
import net.hacker_E303.gun_maker.variables.fields.StringField;

/**
 * A Content implementation that represents a string value with default value support.
 * Associates a name with a String value and provides methods to get and set its value,
 * as well as create a field representation for UI display.
 */
public class StringValue extends Content<String> implements Value<String, StringField> {

    // The stored string value
    private String value;

    /**
     * Constructs a StringValue with the given name and initial value.
     * @param name the name associated with this value
     * @param value the initial string value
     */
    public StringValue(String name, String value) {
        super(name);
        this.value = value;
    }

    /**
     * Returns the default string value (empty string).
     * @return the default value ""
     */
    @Override
    public String def() {
        return "";
    }

    /**
     * Retrieves the current string value.
     * @return the stored string value
     */
    @Override
    public String get() {
        return value;
    }

    /**
     * Updates the stored string value.
     * @param value the new string value
     */
    @Override
    public void set(String value) {
        this.value = value;
    }

    /**
     * Creates a field representation for this string value.
     * @return a new StringField instance for this value
     */
    @Override
    public StringField field() {
        return new StringField(name());
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
