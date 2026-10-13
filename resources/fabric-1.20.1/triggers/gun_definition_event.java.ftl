<#include "procedures.java.ftl">
public class ${name}Procedure {

    private static int AMMO_NUMBER;
    private static int MAX_AMMO_NUMBER;
    private static double DAMAGE;

    private static String ITEM_NAME;
    private static String ITEM_COLOR;
    private static String ITEM_RANGE;
    private static String ITEM_ABILITY;

    private static String MAGAZINE_NAME;
    private static String ADVANTAGE;
    private static boolean CAN_UPGRADE;

    public static void register() {
        ItemStackTooltipCallback.EVENT.register((stack, context, lines) -> {

            MinecraftClient client = MinecraftClient.getInstance();
            if (client.player == null || stack == null) return;
            
            <#assign dependenciesCode><#compress>
                <@procedureDependenciesCode dependencies, {
                "world": "client.world",
                "x": "client.player.getX()",
                "y": "client.player.getY()",
                "z": "client.player.getZ()",
                "entity": "client.player",
                "itemstack": "stack"
                }/>
            </#compress></#assign>
            
            execute(null<#if dependenciesCode?has_content>, </#if>${dependenciesCode});

            if (ITEM_NAME == null || ITEM_NAME.isEmpty()) return;
            String displayedName = stack.getName().getString().trim().toLowerCase();

            if (!displayedName.contains(ITEM_NAME.trim().toLowerCase())) return;
            
            GunMaker.GunUtils mg = null;
            mg.setValue(stack, mg.MAX_AMMO_NUMBER, MAX_AMMO_NUMBER);
            
            stack.setCustomName(Text.literal(ITEM_COLOR + ITEM_NAME));

            lines.add(Text.literal("§8Damage: " + DAMAGE));
            lines.add(Text.literal("§8Current Ammo: " + AMMO_NUMBER + "/" + MAX_AMMO_NUMBER));
            
            if (Screen.hasShiftDown()) {
                lines.add(Text.literal("§8Range: " + ITEM_RANGE + " Range"));
                lines.add(Text.literal("§8Magazine: " + MAGAZINE_NAME));

                if (ITEM_ABILITY != null && !ITEM_ABILITY.isEmpty()) lines.add(Text.literal("§8Ability: " + ITEM_ABILITY));
                if (ADVANTAGE != null && !ADVANTAGE.isEmpty()) lines.add(Text.literal("§8Damage Bonus: §a" + ADVANTAGE));
                if (CAN_UPGRADE) lines.add(Text.literal("§6Level: " + ((int) mg.getValue(stack, mg.LEVEL) + 1)));

            } else lines.add(Text.literal("§7Press Shift for more info"));
        });
    }