<#include "procedures.java.ftl">
@EventBusSubscriber(value = Dist.CLIENT, modid = "${modid}")
public class ${name}Procedure {

    private static int 		AMMO_NUMBER;
    private static int 		MAX_AMMO_NUMBER;
    private static double 	DAMAGE;
	
    private static String 	ITEM_NAME;
    private static String 	ITEM_COLOR;
    private static String 	ITEM_RANGE;
    private static String 	ITEM_ABILITY;

    private static String 	MAGAZINE_NAME;
    private static String 	ADVANTAGE;
    private static boolean 	CAN_UPGRADE;
    
	@SubscribeEvent
	public static void onItemTooltip(ItemTooltipEvent event) {
		
		<#assign dependenciesCode><#compress>
			<@procedureDependenciesCode dependencies, {
            "world": "event.getEntity().level()",
			"x": "event.getEntity().getX()",
			"y": "event.getEntity().getY()",
			"z": "event.getEntity().getZ()",
			"entity": "event.getEntity()",
			"itemstack": "event.getItemStack()"
			}/>
		</#compress></#assign>

		ItemStack stack = event.getItemStack();
		Entity entity = event.getEntity();
		
		if (entity == null || stack == null) return;
		execute(null<#if dependenciesCode?has_content>, </#if>${dependenciesCode});
		      
		if (ITEM_NAME == null || ITEM_NAME.isEmpty()) return;
		String displayedName = stack.getHoverName().getString().trim().toLowerCase();

		if (!displayedName.contains(ITEM_NAME.trim().toLowerCase())) return;
						
		GunMaker.GunUtils mg = null;
		mg.setValue(stack, mg.MAX_AMMO_NUMBER, MAX_AMMO_NUMBER);

		List<Component> tooltip = event.getToolTip();
		stack.set(DataComponents.CUSTOM_NAME, Component.literal(ITEM_COLOR + ITEM_NAME));

		tooltip.add(Component.literal("§8Damage: " + DAMAGE));
		tooltip.add(Component.literal("§8Current Ammo: " + AMMO_NUMBER + "/" + MAX_AMMO_NUMBER));
		            
		if (Screen.hasShiftDown()) {
		    tooltip.add(Component.literal("§8Range: " + ITEM_RANGE + " Range"));
		    tooltip.add(Component.literal("§8Magazine: " + MAGAZINE_NAME));

		    if (ITEM_ABILITY != null && !ITEM_ABILITY.isEmpty()) tooltip.add(Component.literal("§8Ability: " + ITEM_ABILITY));
		    if (ADVANTAGE != null && !ADVANTAGE.isEmpty()) tooltip.add(Component.literal("§8Damage Bonus: §a" + ADVANTAGE));
		    if (CAN_UPGRADE) tooltip.add(Component.literal("§6Level: " + ((int) mg.getValue(stack, mg.LEVEL) + 1)));

		} else tooltip.add(Component.literal("§7Press Shift for more info"));
	}