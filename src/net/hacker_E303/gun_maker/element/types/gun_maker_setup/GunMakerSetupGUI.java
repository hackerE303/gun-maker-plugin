package net.hacker_E303.gun_maker.element.types.gun_maker_setup;


import net.hacker_E303.gun_maker.Launcher;
import net.hacker_E303.gun_maker.general.GenericElementGUI;
import net.hacker_E303.gun_maker.helpers.InterfaceUtils;
import net.mcreator.ui.MCreator;
import net.mcreator.workspace.elements.ModElement;

public final class GunMakerSetupGUI extends GenericElementGUI<GunMakerSetupElement> {

    public GunMakerSetupGUI(MCreator mcreator, ModElement element, boolean editingMode) {
        super(mcreator, element, editingMode);
        
        this.initGUI();
        super.finalizeGUI();
    }

    @Override
    public String id() {
        return "gun_maker_setup";
    }
 
    @Override
    public GunMakerSetupElement element() {
        return new GunMakerSetupElement(modElement);
    }

    @Override
    public String[] texts() {

        final String TITLE_0        = "title_0";
        final String DESCRIPTION_0  = "description_line_0";
        final String DESCRIPTION_1  = "description_line_1";
        final String TITLE_1        = "title_1";
        final String FIELD_0        = "gun_pose";
        final String FIELD_1        = "gun_pose_active";
        final String FIELD_2        = "disable_swing";
        final String FIELD_3        = "notifications";

        String[] array = {TITLE_0, DESCRIPTION_0, DESCRIPTION_1, TITLE_1, FIELD_0, FIELD_1, FIELD_2, FIELD_3};
        return array;
    }

    @Override
    protected void initGUI() {

        InterfaceUtils.createPanel(this, (panel) -> {

            int staleWidth          = 240;
            int widthPostFields     = 270;

            int descriptionHeight   = 120;
            int configurationHeight = 240;
            
            // title of description
            panel.add(InterfaceUtils.createText(this, panel, 0, 24, staleWidth, descriptionHeight));

            descriptionHeight += 35;
            InterfaceUtils.createText(this, panel ,1, 15, staleWidth, descriptionHeight);

            descriptionHeight += 18;
            InterfaceUtils.createText(this, panel ,2, 15, staleWidth, descriptionHeight);
            
            //title of configuration
            InterfaceUtils.createText(this, panel ,3, 24, staleWidth, configurationHeight);

            // notify updates
            InterfaceUtils.createText(this, panel ,7, 18, widthPostFields + 215, configurationHeight + 6);

            CONTENTS.setField("notifications", InterfaceUtils.createInfo(this, 7,
                InterfaceUtils.createBoolean(panel, true, staleWidth + 215, configurationHeight + 6)
            ));

            // enable gun pose
            configurationHeight += 70;
            InterfaceUtils.createText(this, panel ,4, 18, widthPostFields, configurationHeight);

            CONTENTS.setField("gun_pose", InterfaceUtils.createInfo(this, 4,
                InterfaceUtils.createBoolean(panel, false, staleWidth, configurationHeight)
            ));

            // decide when gun pose should be active
            InterfaceUtils.createText(this, panel ,5, 18, widthPostFields + 215, configurationHeight);

            CONTENTS.setField("gun_pose_active", InterfaceUtils.createInfo(this, 5,
                InterfaceUtils.createBoolean(panel, false, staleWidth + 215, configurationHeight)
            ));

            // disable swing animation
            configurationHeight += 30;
            InterfaceUtils.createText(this, panel ,6, 18, widthPostFields, configurationHeight);

            CONTENTS.setField("no_swing", InterfaceUtils.createInfo(this, 6,
                InterfaceUtils.createBoolean(panel, false, staleWidth, configurationHeight)
            ));

        }, "Setup");
    }
    
    @Override
    protected void onInteraction(boolean opening) {

        if (opening) return;
        Launcher.updateNotificationSetting((boolean) CONTENTS.getValue("notifications"));
    }
}