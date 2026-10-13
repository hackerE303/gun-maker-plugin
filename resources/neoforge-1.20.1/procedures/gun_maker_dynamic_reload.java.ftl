<#include "mcitems.ftl">
if (!world.isClientSide()) {

    GunMaker.GunUtils mg = null;
    LivingEntity living = (LivingEntity) ${input$entity};

    if (living.getMainHandItem() == ${input$item}) {

        ItemStack stack = ${input$item};
        <#if field$creative == "TRUE">

        if (living instanceof ServerPlayer serverPlayer && serverPlayer.gameMode.getGameModeForPlayer() != GameType.CREATIVE) {
            </#if>

            IItemHandler iitemhandler = living.getCapability(Capabilities.ItemHandler.ENTITY);

            if (iitemhandler != null) {
                for (int idx = 0; idx < iitemhandler.getSlots(); idx++) {

                    ItemStack stackIterator = iitemhandler.getStackInSlot(idx);

                    if (${mappedMCItemToItem(input$magazine)} == stackIterator.getItem()) {

                        int ammoBefore = (int) mg.getValue(stack, mg.AMMO_NUMBER);
                        int spaceLeft = (int) ${input$max_ammo} - ammoBefore;
                        int ammoAvailable = stackIterator.getMaxDamage() - stackIterator.getDamageValue();
                        int ammoToReload = Math.min(spaceLeft, ammoAvailable);

                        int ammoNow = ammoBefore + ammoToReload;
                        mg.setValue(stack, mg.AMMO_NUMBER, ammoNow);

                        ItemStack result = stackIterator.copy();
                        RandomSource random = RandomSource.create();
                        if (result.hurt(ammoToReload, random, null)) {
                            result.shrink(1);
                            result.setDamageValue(0);
                        }

                        if (iitemhandler instanceof IItemHandlerModifiable modHandler) {
                            modHandler.setStackInSlot(idx, result);
                        }

                        <#if field$durability == "TRUE">

                        ItemStack setStack = stack.copy();
                        setStack.setDamageValue(setStack.getMaxDamage() - (${field$multiplier} * ammoNow + 1));

                        living.setItemInHand(InteractionHand.MAIN_HAND, setStack);
                        if (living instanceof Player player) player.getInventory().setChanged();

                        </#if>

                        mg.setValue(stack, mg.RECOVERY_TIME, ${input$recovery});
                        mg.setValue(stack, mg.IS_RELOADING, true);
                        break;
                    }
                }
            }
        <#if field$creative == "TRUE">

        } else {

            <#if field$durability == "TRUE">

            ItemStack setStack = stack.copy();
            setStack.setDamageValue(setStack.getMaxDamage() - (${field$multiplier} * ${input$max_ammo} + 1));

            living.setItemInHand(InteractionHand.MAIN_HAND, setStack);
            if (living instanceof Player player) player.getInventory().setChanged();

            </#if>

            mg.setValue(stack, mg.SHOOTED_ROUNDS, 0);
            mg.setValue(stack, mg.IS_RELOADING, true);

            mg.setValue(stack, mg.AMMO_NUMBER,     ${input$max_ammo});
            mg.setValue(stack, mg.RECOVERY_TIME,   ${input$recovery});

        }

        </#if>
    }
}