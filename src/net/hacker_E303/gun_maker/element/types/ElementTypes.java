package net.hacker_E303.gun_maker.element.types;

import net.hacker_E303.gun_maker.element.types.gun_maker_setup.GunMakerSetupElement;
import net.hacker_E303.gun_maker.element.types.gun_maker_setup.GunMakerSetupGUI;
import net.mcreator.element.ModElementType;
import static net.mcreator.element.ModElementTypeLoader.register;

public class ElementTypes {
    
    public static ModElementType<?> GUN_MAKER_SETUP;

    public static void load() {
        GUN_MAKER_SETUP = register(new ModElementType<>("gun_maker_setup", (Character) null,  GunMakerSetupGUI::new, GunMakerSetupElement.class));
    }
}