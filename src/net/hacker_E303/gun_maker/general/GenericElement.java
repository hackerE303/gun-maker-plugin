package net.hacker_E303.gun_maker.general;

import net.hacker_E303.gun_maker.variables.Content;
import net.hacker_E303.gun_maker.variables.Contents;
import net.hacker_E303.gun_maker.variables.values.BooleanValue;
import net.hacker_E303.gun_maker.variables.values.NumberValue;
import net.hacker_E303.gun_maker.variables.values.StringValue;
import net.mcreator.element.NamespacedGeneratableElement;
import net.mcreator.generator.template.IAdditionalTemplateDataProvider;
import net.mcreator.workspace.elements.ModElement;

/**
 * Abstract base class for all gun maker elements that provides content management and backup functionality.
 * Extends MCreator's NamespacedGeneratableElement to support generatable mod elements with custom content.
 */
public abstract class GenericElement extends NamespacedGeneratableElement {
    
    // Backup string to store content in a serialized format
    private String BACKUP;

    /**
     * Constructs a GenericElement with the given ModElement.
     * @param element the ModElement associated with this instance
     */
    public GenericElement(ModElement element) {
        super(element);
    }

    /**
     * Deserializes and returns the contents from the backup string.
     * @return the deserialized contents, or null if there's no backup or deserialization fails
     */
    public final Contents contents() {

        if (!hasBackup()) return null;
        Contents contents = new Contents();
        try {
            String[] entries = BACKUP.split("\\|");
            for (String entry : entries) {

                String[] parts = entry.split(":");
                if (parts.length < 3) continue;

                String varName = parts[0];
                String varType = parts[1];
                String varValue = entry.substring(varName.length() + varType.length() + 2);
                    
                Content<?> genericValue = getGenericValue(varName, varType, varValue);
                if (genericValue != null) contents.add(genericValue);
            }
        } catch (Exception e) {
            return null;
        }
        return contents;
    }

    /**
     * Serializes and stores the contents as a backup string.
     * @param contents the contents to serialize
     */
    public final void writeBackup(Contents contents) {

        StringBuilder buildier = new StringBuilder();
        for (Content<?> value : contents.all()) {

            if (value == null || value.isField()) continue;
            if (buildier.length() > 0) buildier.append("|");

            String type = getType(value);
            buildier.append(value.name()).append(":").append(type).append(":").append(value.get());
        }
        BACKUP = buildier.toString();
    }

    /**
     * Checks if a backup exists.
     * @return true if backup exists and is not empty, false otherwise
     */
    public final boolean hasBackup() {
        return BACKUP != null && !BACKUP.isEmpty();
    }

    /**
     * Returns the raw backup string.
     * @return the backup string
     */
    public final String readBackup() {
        return BACKUP;
    }

    /**
     * Determines the type string for a Content item.
     * @param value the Content item to check
     * @return type string ("number", "string", "boolean"), or null if unknown
     */
    private String getType(Content<?> value) {

        if (value instanceof NumberValue)       return "number";
        else if (value instanceof StringValue)  return "string";
        else if (value instanceof BooleanValue) return "boolean";
        return null;
    }

    /**
     * Creates a Content item from type string and value string.
     * @param name the name of the content item
     * @param type the type string ("number", "string", "boolean")
     * @param value the string representation of the value
     * @return the created Content item, or null if type is unknown
     */
    private Content<?> getGenericValue(String name, String type, String value) {

        switch (type) {
            case "boolean" -> { return new BooleanValue(name, Boolean.valueOf(value)); }
            case "string"  -> { return new StringValue(name, String.valueOf(value));   }
            case "number"  -> {
                if (value.contains(".")) {

                    if (value.toLowerCase().contains("f")) return new NumberValue(name, Float.valueOf(value)); 
                    return new NumberValue(name, Double.valueOf(value));

                } else return new NumberValue(name, Integer.valueOf(value));
            }
            default -> { return null; }
        }
    }

    /**
     * Provides additional template data for code generation.
     * Adds all contents to the template context.
     * 
     * @return IAdditionalTemplateDataProvider that adds all contents to the context
     */
    @Override
    public final IAdditionalTemplateDataProvider getAdditionalTemplateData() {

        return (data) -> {
            Contents contents = contents();
            for (Content<?> content : contents.all()) {

                if (!content.isField()) {
                    data.put(content.name(), content.get());
                }
            }
        };
    }
}
