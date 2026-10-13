package net.hacker_E303.gun_maker.helpers;

import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.util.function.Consumer;

import javax.swing.JCheckBox;
import javax.swing.JComponent;
import javax.swing.JLabel;
import javax.swing.JPanel;
import javax.swing.JSpinner;
import javax.swing.JTextField;
import javax.swing.SpinnerNumberModel;

import net.hacker_E303.gun_maker.Launcher;
import net.hacker_E303.gun_maker.general.GenericElementGUI;
import net.mcreator.ui.init.L10N;
import net.mcreator.ui.validation.ValidationGroup;

/**
 * Utility class for creating and configuring Swing UI components for the gun maker plugin.
 * Provides methods to create panels, labels, spinners, and checkboxes with predefined configurations.
 */
public class InterfaceUtils {

    /**
     * Creates a new panel and adds it to the GUI with the given name.
     * @param gui the GenericElementGUI instance to add the panel to
     * @param actions consumer function to configure the panel
     * @param panelName the name of the panel
     * @param <T> type parameter extending GenericElementGUI
     */
    public static <T extends GenericElementGUI<?>> void createPanel(T gui, Consumer<JPanel> actions, String name) {
        if (actions == null) return;

        JPanel panel = new JPanel();
        actions.accept(panel);
        panel.setLayout(null);

        try {
            Method addPage = gui.getClass().getMethod("addPage", String.class, JComponent.class);
            Object page = addPage.invoke(gui, name, panel);
            
            if (page != null) {
                Method validate = page.getClass().getMethod("validate", ValidationGroup.class);
                validate.invoke(page, new ValidationGroup());
            }
            
        } catch (NoSuchMethodException | IllegalAccessException | InvocationTargetException e) {
            Launcher.PLUGIN_LOGGER.error("Unable to add page to panel named '" + name + "'", e);
        }
    }
    
    /**
     * Creates a localized JLabel with the specified text size and position.
     * @param gui the GenericElementGUI instance
     * @param panel the panel to add the label to
     * @param textIndex index of the text in the GUI's texts array
     * @param textSize font size of the text
     * @param x x-coordinate of the label
     * @param y y-coordinate of the label
     * @param <T> type parameter extending GenericElementGUI
     * @return the created JLabel instance
     */
    public static<T extends GenericElementGUI<?>> JLabel createText(T gui, JPanel panel, int textIndex, int textSize, int x, int y) {

        String textSearched = "Failed to load text!";
        try { textSearched = L10N.t("elementgui." + gui.id() + "." + gui.texts()[textIndex]); }
        catch (Exception e) {}
        
        JLabel label = new JLabel(textSearched);

        label.setFont(label.getFont().deriveFont((float) textSize));
        label.setSize(label.getPreferredSize());
        label.setLocation(x, y);

        panel.add(label);
        return label;
    }
    
    /**
     * Creates a JSpinner with the specified range and position.
     * @param panel the panel to add the spinner to
     * @param defaultValue initial value of the spinner
     * @param minValue minimum value of the spinner
     * @param maxValue maximum value of the spinner
     * @param x x-coordinate of the spinner
     * @param y y-coordinate of the spinner
     * @return the created JSpinner instance
     */
    public static JSpinner createNumber(JPanel panel, int defaultValue, int minValue, int maxValue, int x, int y) {

        SpinnerNumberModel model = new SpinnerNumberModel(defaultValue, minValue, maxValue, 1);
        JSpinner spinner = new JSpinner(model);
        spinner.setSize(100, 25);
        spinner.setLocation(x, y);

        panel.add(spinner);
        return spinner;
    }

    /**
     * Creates a JCheckBox with the specified default state and position.
     * @param panel the panel to add the checkbox to
     * @param defaultValue initial selected state of the checkbox
     * @param x x-coordinate of the checkbox
     * @param y y-coordinate of the checkbox
     * @return the created JCheckBox instance
     */
    public static JCheckBox createBoolean(JPanel panel, boolean defaultValue, int x, int y) {

        JCheckBox checkBox = new JCheckBox();
        checkBox.setSelected(defaultValue);
        checkBox.setSize(25, 25);
        checkBox.setLocation(x, y + 3);

        panel.add(checkBox);
        return checkBox;
    }

    /**
     * Creates a JTextField with the specified default text and position.
     * @param panel the panel to add the text field to
     * @param defaultValue initial text of the text field
     * @param width width of the text field
     * @param height height of the text field
     * @param x x-coordinate of the text field
     * @param y y-coordinate of the text field
     * @return the created JTextField instance
     */
    public static JTextField createString(JPanel panel, String defaultValue, int width, int height, int x, int y) {

        JTextField textField = new JTextField(defaultValue);
        textField.setSize(width, height);
        textField.setLocation(x, y);

        panel.add(textField);
        return textField;
    }

    /**
     * Sets a tooltip (informational message) for a Swing component.
     * The tooltip is displayed when the user hovers over the component with the mouse.
     * 
     * @param component the Swing component to add the tooltip to
     * @param gui the GenericElementGUI instance
     * @param textIndex index of the tooltip text in the GUI's texts array
     * @param <T> type parameter extending GenericElementGUI
     */
    public static<T extends GenericElementGUI<?>, J extends JComponent> J createInfo(T gui, int textIndex, J component) {

        String tooltipText = "Failed to load tooltip!";
        try { tooltipText = L10N.t("elementgui." + gui.id() + "." + gui.texts()[textIndex] + "_info"); }
        catch (Exception e) {}
        
        component.setToolTipText(tooltipText);
        return component;
    }
}
