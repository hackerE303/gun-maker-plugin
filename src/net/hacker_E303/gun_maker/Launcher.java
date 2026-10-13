package net.hacker_E303.gun_maker;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.util.Properties;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import net.hacker_E303.gun_maker.element.types.ElementTypes;
import net.hacker_E303.gun_maker.events.EventTriggers;
import net.hacker_E303.gun_maker.variables.Contents;
import net.hacker_E303.gun_maker.variables.values.BooleanValue;
import net.mcreator.plugin.JavaPlugin;
import net.mcreator.plugin.Plugin;
import net.mcreator.plugin.events.PreGeneratorsLoadingEvent;
import net.mcreator.plugin.events.workspace.MCreatorLoadedEvent;
import net.mcreator.workspace.Workspace;

public class Launcher extends JavaPlugin {

    public static Launcher PLUGIN_INSTANCE;
    public static Workspace CURRENT_WORKSPACE;
    public static final Logger PLUGIN_LOGGER = LogManager.getLogger("Gun Maker Plugin");

    public static final String VAR_00 = "notifications";
    public static Contents CONTENTS = new Contents(new BooleanValue(VAR_00, true));

    private static final Properties STORAGE = new Properties();
    private static final File STORAGE_FILE = new File(System.getProperty("user.home") + File.separator + "MCreatorWorkspaces", "gun_maker_plugin.settings");

    public Launcher(Plugin plugin) {
        super(plugin);

        PLUGIN_INSTANCE = this;

        addListener(PreGeneratorsLoadingEvent.class, event -> {
            ElementTypes.load();
        });

        addListener(MCreatorLoadedEvent.class, event -> {

            updateNitificationSetting(event.getMCreator().getWorkspace());
            EventTriggers.info(CONTENTS.getValue(VAR_00));
        });
        PLUGIN_LOGGER.info("Gun Maker Plugin was loaded successfully!");
    }

    // HELPERS -----------------------------------------------------------------------------------------------------

    private static void loadData() {
        if (!STORAGE_FILE.exists()) return;

        try (FileInputStream fis = new FileInputStream(STORAGE_FILE)) {
            STORAGE.load(fis);
            CONTENTS.setValue(VAR_00, Boolean.valueOf(STORAGE.getProperty(nofigications(), "true")));

        } catch (Exception e) {
            PLUGIN_LOGGER.warn("Unable to load saved data!", e);
        }
    }
    
    private static void saveData() {
        STORAGE.setProperty(nofigications(), String.valueOf((boolean) CONTENTS.getValue(VAR_00)));
        
        try (FileOutputStream fos = new FileOutputStream(STORAGE_FILE)) {
            STORAGE.store(fos, "Gun Maker Plugin Settings");

        } catch (Exception e) {
            PLUGIN_LOGGER.warn("Unable to save data!", e);
        }
    }

    private static String nofigications() {
        return CURRENT_WORKSPACE.toString() + "_" + VAR_00;
    }

    private static void updateNitificationSetting(Workspace workspace) {

        CURRENT_WORKSPACE = workspace;
        loadData();
            
        CURRENT_WORKSPACE.getModElements().stream().filter(modElement -> modElement.getType() == ElementTypes.GUN_MAKER_SETUP)
        .findFirst().ifPresent(element -> {

            if (element.getMetadata("gun_maker_settings") instanceof String backup)
                try {
                    String[] entries = backup.split("\\|");
                    for (String entry : entries) {

                        String[] parts = entry.split(":");
                        if (parts.length > 2 && VAR_00.equals(parts[0])) {

                            CONTENTS.setValue(VAR_00, Boolean.valueOf(parts[2]));
                            saveData();
                        }
                    }
                } catch (Exception e) {
                    PLUGIN_LOGGER.warn("Unable to read Gun Maker Setup settings!", e);
                }
        });
    }

    public static void updateNotificationSetting(boolean shouldNotify) {
        
        CONTENTS.setValue(VAR_00, shouldNotify);
        saveData();
    }
}