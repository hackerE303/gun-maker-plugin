package net.hacker_E303.gun_maker.variables.fields;

import javax.swing.JTextField;

import net.hacker_E303.gun_maker.variables.Content;

/**
 * A Content implementation that represents a string field using a JTextField.
 * Associates a name with a JTextField and provides methods to get and set its value
 * and field component.
 */
public class StringField extends Content<String> implements Field<JTextField> {

    // The underlying JTextField component
    private JTextField field;

    /**
     * Constructs a StringField with the given name.
     * @param name the name associated with this field
     */
    public StringField(String name) {
        super(name);
    }

    /**
     * Retrieves the current string value from the JTextField.
     * @return the text from the label
     */
    @Override
    public String get() {
        return field.getText();
    }

    /**
     * Updates the string value by setting the label text.
     * @param value the new string value
     */
    @Override
    public void set(String value) {
        field.setText(value);
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
     * Retrieves the underlying JTextField component.
     * @return the JTextField wrapped by this field
     */
    @Override
    public JTextField getField() {
        return field;
    }

    /**
     * Sets the underlying JTextField component.
     * @param field the JTextField to wrap
     */
    @Override
    public void setField(JTextField field) {
        this.field = field;
    }
}
