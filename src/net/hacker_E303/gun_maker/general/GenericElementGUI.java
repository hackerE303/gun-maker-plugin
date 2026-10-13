package net.hacker_E303.gun_maker.general;

import java.net.URI;
import java.net.URISyntaxException;

import javax.swing.event.AncestorEvent;
import javax.swing.event.AncestorListener;

import net.hacker_E303.gun_maker.variables.Content;
import net.hacker_E303.gun_maker.variables.Contents;
import net.hacker_E303.gun_maker.variables.fields.BooleanField;
import net.hacker_E303.gun_maker.variables.fields.NumberField;
import net.hacker_E303.gun_maker.variables.fields.StringField;
import net.hacker_E303.gun_maker.variables.values.Value;
import net.mcreator.ui.MCreator;
import net.mcreator.ui.MCreatorApplication;
import net.mcreator.ui.modgui.ModElementGUI;
import net.mcreator.ui.validation.AggregatedValidationResult;
import net.mcreator.workspace.elements.ModElement;

/**
 * Abstract base class for all gun maker element GUIs that provides content management and GUI initialization.
 * Extends MCreator's ModElementGUI to support custom mod element GUI implementations.
 * @param <T> the type of GenericElement this GUI manages
 */
public abstract class GenericElementGUI<T extends GenericElement> extends ModElementGUI<T> {

    /**
     * Constructs a GenericElementGUI with the given parameters.
     * @param mcreator the MCreator instance
     * @param element the ModElement associated with this GUI
     * @param editingMode true if the GUI is in editing mode
     */
    public GenericElementGUI(MCreator mcreator, ModElement element, boolean editingMode) {
        super(mcreator, element, editingMode);

        addAncestorListener(new AncestorListener() {

            boolean opening = true;

            @Override
            public void ancestorAdded(AncestorEvent event) {
            }
            
            @Override
            public void ancestorRemoved(AncestorEvent event) {       
                onInteraction(opening);
                opening = false;
            }
            
            @Override
            public void ancestorMoved(AncestorEvent event) {
            }
        });
    }

    /**
     * Callback method invoked when the GUI lifecycle state changes.
     * This method is automatically called when the GUI is first opened and when it is closed.
     * 
     * @param opening {@code true} when the GUI is being opened for the first time,
     *                {@code false} when the GUI is being closed / unloaded from view
     */
    protected void onInteraction(boolean opening) {
    }

    /**
     * Returns the unique ID of this element type.
     * @return the element type ID
     */
    public abstract String id();

    /**
     * Returns a new instance of the associated GenericElement.
     * @return a new element instance
     */
    public abstract T element();
    
    /**
     * Returns the array of text keys used for localization.
     * @return the text keys array
     */
    public abstract String[] texts();

    /**
     * Central container holding all GUI field components {@link BooleanField}, {@link NumberField}, 
     * {@link StringField} mapped to their corresponding value names.
     * 
     * Initialized lazily by scanning the element's contents
     * and creating appropriate GUI fields for each non-field value.
     * The mapping preserves the bidirectional relationship between data and UI:
     */
    public Contents CONTENTS = initContents();

    /**
     * Loads existing element data into the GUI when in editing mode.
     * @param element the element to edit
     */
    @Override
    public void openInEditingMode(GenericElement element) {

        for (Content<?> content : CONTENTS.all()) {
            String name = content.name();

            if (element.contents().contains(name)) {

                if (content instanceof BooleanField b)  b.set(element.contents().getValue(name));
                if (content instanceof NumberField n)   n.set(element.contents().getValue(name));
                if (content instanceof StringField s)   s.set(element.contents().getValue(name));
            }
        }
    }

    /**
     * Retrieves the element from the GUI data.
     * @return the element populated with GUI data
     */
    @Override
    public final T getElementFromGUI() {

        T element = element();
        Contents contents = element.contents();
        
        for (Content<?> content : CONTENTS.all()) {
            String name = content.name();
            
            if (contents.contains(name)) {

                if (content instanceof BooleanField b) contents.setValue(name, b.get());
                if (content instanceof NumberField n)  contents.setValue(name, n.get());
                if (content instanceof StringField s)  contents.setValue(name, s.get());
            }
        }
        element.writeBackup(contents);
        return element;
    }

    /**
     * Returns the context URL for the GUI editor.
     * @return the context URL
     * @throws URISyntaxException if the URL is invalid
     */
    @Override
    public final URI contextURL() throws URISyntaxException {
        return new URI(MCreatorApplication.SERVER_DOMAIN + "/wiki/gui-editor");
    }

    /**
     * Validates the GUI pages. Currently returns an empty validation result.
     * @param arg0 the page number to validate
     * @return the validation result
     */
    @Deprecated
    public final AggregatedValidationResult validatePage(int arg0) {
        AggregatedValidationResult result = new AggregatedValidationResult();
        return result;
    }

    /**
     * Initializes the GUI fields from the element's contents.
     * @return the initialized contents container with fields
     */
    private Contents initContents() {

        Contents contents = new Contents();
        for (Content<?> value : element().contents().all()) {

            if (value == null || value.isField()) continue;
            if (value instanceof Value v) contents.add((Content<?>) v.field());
        }
        return contents;
    }
}
