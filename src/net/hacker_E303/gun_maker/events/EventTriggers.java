package net.hacker_E303.gun_maker.events;

import java.awt.BorderLayout;
import java.awt.Component;
import java.awt.Dimension;
import java.awt.GridLayout;
import java.util.List;

import javax.annotation.Nullable;
import javax.swing.BorderFactory;
import javax.swing.JButton;
import javax.swing.JLabel;
import javax.swing.JPanel;
import javax.swing.JScrollPane;
import javax.swing.Timer;

import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import com.google.gson.JsonSyntaxException;

import net.hacker_E303.gun_maker.Launcher;
import net.mcreator.io.net.WebIO;
import net.mcreator.plugin.Plugin;
import net.mcreator.plugin.PluginUpdateInfo;
import net.mcreator.ui.MCreatorApplication;
import net.mcreator.ui.component.util.PanelUtils;
import net.mcreator.ui.dialogs.MCreatorDialog;
import net.mcreator.ui.init.L10N;
import net.mcreator.util.DesktopUtils;

public class EventTriggers {

   public static void info(@Nullable boolean notifies) {

      if (!notifies) {
          Launcher.PLUGIN_LOGGER.debug("Gun Maker plugin has notifications disabled!");
          return;
      }
      PluginUpdateInfo pluginUpdateInfo = checkUpdates();
      
      if (pluginUpdateInfo == null) {
         Launcher.PLUGIN_LOGGER.error("Plugin Info is null!");
         return;
      }
      Timer timer = new Timer(500, null);
      timer.addActionListener(e -> {
         try {
            L10N.t("dialog.plugin_update_notify.update_title");
              
            timer.stop();
              
            JPanel pan = new JPanel(new BorderLayout(10, 15));
            JPanel plugins = new JPanel(new GridLayout(0, 1, 10, 10));

         pan.add("North", new JScrollPane(PanelUtils.pullElementUp(plugins)));

         pan.setBorder(BorderFactory.createEmptyBorder(10, 10, 10, 10));
         pan.setPreferredSize(new Dimension(560, 250));

         StringBuilder usb = new StringBuilder(L10N.t("dialog.plugin_update_notify.version_message",
            new Object[]{pluginUpdateInfo.plugin().getInfo().getName(), pluginUpdateInfo.plugin().getInfo().getVersion(), pluginUpdateInfo.newVersion()}));

         if (pluginUpdateInfo.recentChanges() != null) {
            usb.append("<br>").append(L10N.t("dialog.plugin_update_notify.changes_message", new Object[0])).append("<ul>");

            List<String> list = pluginUpdateInfo.recentChanges();
            if (list != null)
               for (String change : list) usb.append("<li>").append(change).append("</li>");
         }

         JLabel label = new JLabel(usb.toString());
         JButton update = L10N.button("dialog.plugin_update_notify.update", new Object[0]);

         update.addActionListener((event) -> {
            DesktopUtils.browseSafe("https://mcreator.net/node/" + pluginUpdateInfo.plugin().getInfo().getPluginPageID());
         });

         plugins.add(PanelUtils.westAndEastElement(label, PanelUtils.join(new Component[]{update})));

         MCreatorDialog dialog = new MCreatorDialog(null, L10N.t("dialog.plugin_update_notify.update_title", new Object[0]));

         dialog.setSize(700, 200);
         dialog.setLocationRelativeTo(null);
         dialog.setModal(true);

         JButton close = L10N.button("dialog.plugin_update_notify.close", new Object[0]);
         close.addActionListener((ev) -> { dialog.setVisible(false); });

         dialog.add("Center", PanelUtils.centerAndSouthElement(pan, PanelUtils.join(new Component[]{close})));
         dialog.setVisible(true);
              
         } catch (Exception ex) {
         }
      });
      timer.setRepeats(true);
      timer.start();
   }

   @Nullable
   private static PluginUpdateInfo checkUpdates() {

      if (MCreatorApplication.isInternet) {
         Plugin plugin = Launcher.PLUGIN_INSTANCE.getPlugin();
         try {
            String updateJSON = WebIO.readURLToString(plugin.getInfo().getUpdateJSONURL());
            JsonObject obj0 = JsonParser.parseString(updateJSON).getAsJsonObject();

            if (obj0.has(plugin.getID())) {
               JsonObject obj1 = obj0.getAsJsonObject(plugin.getID());
                
               if (obj1.has("latest")) {

                  String lastVersionStr    = obj1.get("latest").getAsString();
                  String currentVersionStr = plugin.getPluginVersion();

                  if (hasUpdate(lastVersionStr, currentVersionStr)) 
                     return new PluginUpdateInfo(plugin, lastVersionStr, obj1.get("changes").getAsJsonArray().asList().stream().map(JsonElement::getAsString).toList());
               }
            }
         } catch (JsonSyntaxException e) {
            Launcher.PLUGIN_LOGGER.error("The update.json has something wrong!");
         }
      } else Launcher.PLUGIN_LOGGER.error("Cannot search for new updates becouse of no internet connection!");
      return null;
   }

   private static int[] parseVersion(String version) {

      String[] parts = version.split("\\.");
      int[] parsed = new int[3];

      for (int i = 0; i < Math.min(parts.length, 3); i++) {
         try {
            parsed[i] = Integer.parseInt(parts[i].replaceAll("[^0-9]", ""));
         } catch (NumberFormatException e) {
            parsed[i] = 0;
         }
      }
      return parsed;
   }

   private static boolean hasUpdate(String latestVersion, String currentVersion) {

      int[] latest   = parseVersion(latestVersion);
      int[] current  = parseVersion(currentVersion);

      for (int i = 0; i < 3; i++) {
         if (latest[i] > current[i]) return true;
         else if (latest[i] < current[i]) return false;
      }
      return false;
   }
}