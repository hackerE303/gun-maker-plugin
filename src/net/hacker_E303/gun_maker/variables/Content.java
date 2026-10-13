package net.hacker_E303.gun_maker.variables;

/**
 * An abstract class representing a named content item with a generic type.
 * Subclasses implement specific types of content with get/set functionality
 * and field support detection.
 */
public abstract class Content<V> {

    // The name associated with this content item
    private final String name;

    /**
     * Constructs a Content instance with the given name.
     * @param name the name to associate with this content item
     */
    public Content(String name) {
        this.name = name;
    }

    /**
     * Returns the name associated with this content item.
     * @return the name as a String
     */
    public String name() {
        return this.name;
    }

    /**
     * Retrieves the stored value.
     * Subclasses must provide the implementation.
     * @return the value of type V
     */
    public abstract V get();

    /**
     * Updates the stored value.
     * Subclasses must provide the implementation.
     * @param value the new value to store
     */
    public abstract void set(V value);

    /**
     * Determines if this content item supports field-based representation.
     * @return true if this content item can be represented as a UI field
     */
    public abstract boolean isField();

    /**
     * Returns a string representation of the Content,
     * showing both its name and current value.
     * @return a string in the format "Name: <name> - Value: <value>"
     */
    @Override
    public String toString() {
        return "Name: " + name + " - Value: " + get();
    }
}
