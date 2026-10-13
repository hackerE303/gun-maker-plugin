package net.hacker_E303.gun_maker.variables.fields;

import javax.swing.JSpinner;

import net.hacker_E303.gun_maker.variables.Content;

/**
 * A Content implementation that represents a numeric field using a JSpinner.
 * Associates a name with a JSpinner and provides methods to get and set its value
 * and field component.
 */
public class NumberField extends Content<Number> implements Field<JSpinner> {

    // The underlying JSpinner component
    private JSpinner field;

    /**
     * Constructs a NumberField with the given name.
     * @param name the name associated with this field
     */
    public NumberField(String name) {
        super(name);
    }

    /**
     * Retrieves the current numeric value from the JSpinner.
     * @return the numeric value from the spinner
     */
    @Override
    public Number get() {
        return (Number) field.getValue();
    }

    /**
     * Updates the numeric value by setting the spinner value.
     * @param value the new numeric value
     */
    @Override
    public void set(Number value) {
        field.setValue(value);
    }

    /**
     * Indicates that this content item supports field-based representation.
     * @return true, as this is a field implementation
     */
    @Override
    public boolean isField() {
        return true;
    }

    /**
     * Retrieves the underlying JSpinner component.
     * @return the JSpinner wrapped by this field
     */
    @Override
    public JSpinner getField() {
        return field;
    }

    /**
     * Sets the underlying JSpinner component.
     * @param field the JSpinner to wrap
     */
    @Override
    public void setField(JSpinner field) {
        this.field = field;
    }
}
