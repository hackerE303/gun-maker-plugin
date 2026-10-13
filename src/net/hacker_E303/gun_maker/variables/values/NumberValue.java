package net.hacker_E303.gun_maker.variables.values;

import net.hacker_E303.gun_maker.variables.Content;
import net.hacker_E303.gun_maker.variables.fields.NumberField;

/**
 * A Content implementation that represents a numeric value with type tracking and conversion support.
 * Associates a name with a Number value, tracks its type, and provides methods to get, set, and convert values.
 * Supports creating a field representation for UI display and has default value support.
 */
public class NumberValue extends Content<Number> implements Value<Number, NumberField> {

    // The stored numeric value
    private Number value;
    
    // The type of the stored numeric value
    private Class<? extends Number> type;

    /**
     * Constructs a NumberValue with the given name and initial value.
     * @param name the name associated with this value
     * @param value the initial Number value
     */
    public NumberValue(String name, Number value) {
        super(name);
        this.value = value;
        this.type = value.getClass();
    }

    /**
     * Retrieves the type of the stored Number.
     * @return the type class of the stored value
     */
    public Class<? extends Number> type() {
        return type;
    }

	/**
	 * Dynamically changes the type of this NumberValue.
	 * The current value is automatically converted to the new type.
	 * @param newType the new numeric type class (Integer.class, Double.class, Float.class are supported)
	 */
    public void change(Class<? extends Number> newType) {

        if (newType == Integer.class)     this.value = this.value.intValue();
        else if (newType == Double.class) this.value = this.value.doubleValue();
        else if (newType == Float.class)  this.value = this.value.floatValue();
	    else System.err.println("Unsupported type " + newType + " for NumberValue '" + name() + "'");

        this.type = newType;
    }

    /**
     * Retrieves the default Number value based on the current type.
     * @return 0 for integer types, 0.0d for double, 0.0f for float
     */
    @Override
    public Number def() {
        if (type == Double.class) return 0d;
        if (type == Float.class) return 0f;
        return 0;
    }
    
    /**
     * Retrieves the current numeric value.
     * @return the stored Number
     */
    @Override
    public Number get() {
        return value;
    }

    /**
     * Updates the stored numeric value, converting to the current type if necessary.
     * @param value the new Number value
     */
    @Override
    public void set(Number value) {
        if (type == Double.class) this.value = value.doubleValue();
        if (type == Float.class) this.value = value.floatValue();
        this.value = value;
    }

    /**
     * Creates a field representation for this numeric value.
     * @return a new NumberField instance for this value
     */
    @Override
    public NumberField field() {
        return new NumberField(name());
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
