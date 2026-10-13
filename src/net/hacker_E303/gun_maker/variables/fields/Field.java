package net.hacker_E303.gun_maker.variables.fields;

import javax.swing.JComponent;

/**
 * Interface representing a UI field component wrapper.
 * Provides methods to get and set the underlying Swing component.
 * @param <F> the type of Swing component this field wraps
 */
public interface Field<F extends JComponent> {
    
    /**
     * Retrieves the underlying Swing component for this field.
     * @return the Swing component wrapped by this field
     */
    public F getField();
    
    /**
     * Sets the underlying Swing component for this field.
     * @param field the Swing component to wrap
     */
    public void setField(F field);
}
