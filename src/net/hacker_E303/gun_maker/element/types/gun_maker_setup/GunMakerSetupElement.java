package net.hacker_E303.gun_maker.element.types.gun_maker_setup;

import net.hacker_E303.gun_maker.general.GenericElement;
import net.hacker_E303.gun_maker.variables.Contents;
import net.hacker_E303.gun_maker.variables.values.BooleanValue;
import net.mcreator.workspace.elements.ModElement;

public class GunMakerSetupElement extends GenericElement {

    public GunMakerSetupElement(ModElement element) {
        super(element);
        
        if (!hasBackup()) writeBackup(new Contents(
            new BooleanValue("gun_pose", true), new BooleanValue("gun_pose_active", false), new BooleanValue("no_swing", true), new BooleanValue("notifications", true)));
    }
}
