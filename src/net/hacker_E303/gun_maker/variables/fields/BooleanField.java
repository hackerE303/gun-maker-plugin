package net.hacker_E303.gun_maker.variables.fields;

import javax.swing.JCheckBox;

import net.hacker_E303.gun_maker.variables.Content;

/**
 * A Content implementation that represents a boolean field using a JCheckBox.
 * Associates a name with a JCheckBox and provides methods to get and set its value
 * and field component.
 */
public class BooleanField extends Content<Boolean> implements Field<JCheckBox> {

    // The underlying JCheckBox component
    private JCheckBox field;

    /**
     * Constructs a BooleanField with the given name.
     * @param name the name associated with this field
     */
    public BooleanField(String name) {
        super(name);
    }

    /**
     * Retrieves the current boolean value from the JCheckBox.
     * @return true if the checkbox is selected, false otherwise
     */
    @Override
    public Boolean get() {
        return field.isSelected();
    }

    /**
     * Updates the boolean value by setting the checkbox selection state.
     * @param value the new boolean value
     */
    @Override
    public void set(Boolean value) {
        field.setSelected(value);
    }
    
    /**
     * Retrieves the underlying JCheckBox component.
     * @return the JCheckBox wrapped by this field
     */
    @Override
    public JCheckBox getField() {
        return field;
    }

    /**
     * Sets the underlying JCheckBox component.
     * @param field the JCheckBox to wrap
     */
    @Override
    public void setField(JCheckBox field) {
        this.field = field;
    }

    /**
     * Indicates that this content item supports field-based representation.
     * @return true, as this is a field implementation
     */
    @Override
    public boolean isField() {
        return true;
    }
}
