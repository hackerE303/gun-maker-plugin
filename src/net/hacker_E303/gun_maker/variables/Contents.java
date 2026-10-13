package net.hacker_E303.gun_maker.variables;

import java.util.Collection;
import java.util.LinkedHashMap;
import java.util.Map;
import java.util.Objects;
import java.util.stream.Collectors;

import javax.swing.JCheckBox;
import javax.swing.JComponent;
import javax.swing.JSpinner;
import javax.swing.JTextField;

import net.hacker_E303.gun_maker.variables.fields.BooleanField;
import net.hacker_E303.gun_maker.variables.fields.Field;
import net.hacker_E303.gun_maker.variables.fields.NumberField;
import net.hacker_E303.gun_maker.variables.fields.StringField;
import net.hacker_E303.gun_maker.variables.values.BooleanValue;
import net.hacker_E303.gun_maker.variables.values.NumberValue;
import net.hacker_E303.gun_maker.variables.values.StringValue;
import net.hacker_E303.gun_maker.variables.values.Value;

/**
 * Represents a collection of named Content items, maintaining insertion order.
 * Provides methods to add, remove, retrieve, and manipulate content items, including type-safe
 * access, merging with other Contents, computing differences, and creating copies.
 */
public class Contents {

    // Stores the collection of Content objects, maintaining insertion order
    private final Map<String, Content<?>> values = new LinkedHashMap<>();

    /**
     * Constructor that initializes the Contents with an array of Content objects.
     * Each content item is stored in the map with its name as the key.
     */
    public Contents(Content<?>... values) {
        for (Content<?> v : values) {
            this.values.put(v.name(), v);
        }
    }

    /**
     * Checks if the collection is empty.
     * @return true if there are no content items stored, false otherwise
     */
    public boolean isEmpty() {
        return values.isEmpty();
    }

    /**
     * Checks if a content item with the given name exists in the collection.
     * @param name the name of the content item to check
     * @return true if the content item exists, false otherwise
     */
    public boolean contains(String name) {
        return values.containsKey(name);
    }

    /**
     * Returns the number of content items stored in the collection.
     * @return the size of the collection
     */
    public int size() {
        return values.size();
    }

    /**
     * Removes all content items from the collection.
     */
    public void clear() {
        values.clear();
    }

    /**
     * Adds a new Content item to the collection, replacing any existing item with the same name.
     * @param value the Content item to add
     */
    public void add(Content<?> value) {
        values.put(value.name(), value);
    }

    /**
     * Removes the content item with the specified name from the collection.
     * @param name the name of the content item to remove
     */
    public void remove(String name) {
        values.remove(name);
    }

    /**
     * Merges another Contents object into this one.
     * Existing content items with the same name are overwritten.
     * @param other the Contents object to merge
     */
    public void merge(Contents other) {
        values.putAll(other.values);
    }

    /**
     * Retrieves the Content item associated with the given name.
     * @param name the name of the content item to retrieve
     * @return the Content item, or null if not found
     */
    public Content<?> get(String name) {
        return values.get(name);
    }

    /**
     * Returns a collection of all Content objects in the Contents.
     * @return collection of all content items
     */
    public Collection<Content<?>> all() {
        return values.values();
    }

    /**
     * Creates a shallow copy of this Contents object.
     * @return a new Contents object containing the same content items
     */
    public Contents copy() {
        return new Contents(values.values().toArray(new Content<?>[values.size()]));
    }

    /**
     * Retrieves the value stored under the given name, cast to the specified type.
     * @param name the name of the content item
     * @param <T> the type parameter
     * @return the value cast to type T, or a default value if missing or null
     */
	@SuppressWarnings("unchecked")
    public <T> T getValue(String name) {

    	Content<?> value = values.get(name);
    	if (value == null) {
        	printError(name, 0);
    	    return null;
    	}
    	Object obj = value.get();
    	if (obj != null) return (T) obj;

        if (value instanceof Value v) return (T) v.def();
        return null;
	}

    /**
     * Retrieves the field component stored under the given name, cast to the specified type.
     * @param name the name of the content item
     * @param <T> the type parameter
     * @return the field component cast to type T, or null if missing or not a field
     */
	@SuppressWarnings("unchecked")
    public <T> T getField(String name) {

    	Content<?> field = values.get(name);
    	if (field == null) {
        	printError(name, 0);
    	    return null;
    	}
        if (!field.isField()) {
            printError(name, 1);
            return null;
        }
    	if (field instanceof Field f) return (T) f.getField();
        return null;
	}

    /**
     * Sets the value of an existing Content item in the collection, if it exists and matches the specified type.
     * @param name the name of the content item to set
     * @param obj the new value
     */
    @SuppressWarnings("unchecked")
    public void setValue(String name, Object obj) {

    	Content<?> value = values.get(name);
    	if (value == null) {
        	printError(name, 0);
        	return;
    	}
    	if (value instanceof BooleanValue && !(obj instanceof Boolean)) {
            printError(name, 3);
            return;
        }
    	else if (value instanceof NumberValue && !(obj instanceof Number)) {
            printError(name, 6);
            return;
        }
    	else if (value instanceof StringValue && !(obj instanceof String)) {
            printError(name, 9);
            return;
        }
        ((Content<Object>) value).set(obj);
	}

    /**
     * Sets the field component of an existing Content item in the collection, if it exists and matches the specified type.
     * @param name the name of the content item to set
     * @param obj the new field component
     */
    @SuppressWarnings("unchecked")
    public void setField(String name, Object obj) {

    	Content<?> field = values.get(name);
    	if (field == null) {
        	printError(name, 0);
        	return;
    	}
        if (!field.isField()) {
            printError(name, 1);
            return;
        }
    	if (field instanceof BooleanField && !(obj instanceof JCheckBox)) {
            printError(name, 2);
            return; 
        }
        if (field instanceof NumberField && !(obj instanceof JSpinner)) {
            printError(name, 4);
            return;
        }
        if (field instanceof StringField && !(obj instanceof JTextField)) {
            printError(name, 8);
            return;
        }
    	if (field instanceof Field f && obj instanceof JComponent c) f.setField(c);
	}

    /**
     * Computes the difference between this Contents and another.
     * Values that are missing or different in the other Contents are included in the result.
     * @param other the Contents to compare with
     * @return a new Contents object containing only the differing content items
     */
    public Contents difference(Contents other) {

        Contents result = new Contents();
        for (Content<?> v : values.values()) {

            Content<?> otherValue = other.get(v.name());
            if (otherValue == null || !Objects.equals(v.get(), otherValue.get())) result.add(v);
        }
        for (Content<?> otherValue : other.values.values()) if (!values.containsKey(otherValue.name())) result.add(otherValue);
        return result;
    }

    /**
     * Returns a string representation of the Contents object.
     * Each content item is converted to a string and separated by new lines.
     * @return string representation of all content items
     */
    @Override
    public String toString() {
        return values.values().stream().map(Object::toString).collect(Collectors.joining("\n"));
    }

    /**
     * Prints an error message to standard error based on the provided error index.
         * Maps specific error codes to descriptive messages about value/field type mismatches
     * or missing values in the gun maker system.
     *
     * @param name  the name of the value or field that caused the error
     * @param index the error code identifying the specific error type:
     *              <ul>
     *                <li>0 - Missing value with the specified name</li>
     *                <li>1 - Value exists but is not a field type</li>
     *                <li>2 - Type mismatch: expected JCheckBox for BooleanField</li>
     *                <li>3 - Type mismatch: expected Boolean for BooleanValue</li>
     *                <li>4 - Type mismatch: expected JSpinner for NumberField</li>
     *                <li>6 - Type mismatch: expected Number for NumberValue</li>
     *                <li>8 - Type mismatch: expected JLabel for StringField</li>
     *                <li>9 - Type mismatch: expected String for StringValue</li>
     *                <li>default - Unknown or undefined error code</li>
     *              </ul>
     */
    private static void printError(String name, int index) {
        
        switch (index) {
            case 0 -> System.err.println("Missing value named '" + name + "'");
            case 1 -> System.err.println("Value '" + name + "' is not a field");
            case 3 -> System.err.println("Cannot assign non-Boolean value to BooleanValue '" + name + "'");
            case 6 -> System.err.println("Cannot assign non-Number value to NumberValue '"   + name + "'");
            case 9 -> System.err.println("Cannot assign non-String value to StringValue '"   + name + "'");
            case 2 -> System.err.println("Cannot assign non-JCheckBox value to BooleanField '" + name + "'");
            case 4 -> System.err.println("Cannot assign non-JSpinner value to NumberField '"   + name + "'");
            case 8 -> System.err.println("Cannot assign non-JLabel value to StringField '"     + name + "'");
            default -> System.err.println("Error message not found for index '" + index + "'");
        }
    }
}
