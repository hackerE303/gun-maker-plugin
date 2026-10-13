<#include "mcitems.ftl">
if (!world.isClientSide()) {

    GunMaker.GunUtils mg = null;  
    LivingEntity living = (LivingEntity) ${input$entity};

    if (living.getMainHandItem() == ${input$item}) {

        ItemStack stack = ${input$item};
        <#if field$creative == "TRUE">
            
        if (living instanceof ServerPlayer serverPlayer && serverPlayer.gameMode.getGameModeForPlayer() != GameType.CREATIVE) {
            </#if>

            AtomicReference<IItemHandler> iitemhandlerref = new AtomicReference<>();
            ${input$entity}.getCapability(ForgeCapabilities.ITEM_HANDLER, null).ifPresent(iitemhandlerref::set);

            if (iitemhandlerref.get() != null) {
                for (int idx = 0; idx < iitemhandlerref.get().getSlots(); idx++) {

                    ItemStack result;
                    ItemStack stackIterator = iitemhandlerref.get().getStackInSlot(idx);

                    if (${mappedMCItemToItem(input$magazine)} == stackIterator.getItem()) {

                        int ammoBefore = (int) mg.getValue(stack, mg.AMMO_NUMBER);
                        int spaceLeft = (int) ${input$max_ammo} - ammoBefore;
                        int ammoAvailable = stackIterator.getMaxDamage() - stackIterator.getDamageValue();
                        int ammoToReload = Math.min(spaceLeft, ammoAvailable);

                        int ammoNow = ammoBefore + ammoToReload;
                        mg.setValue(stack, mg.AMMO_NUMBER, ammoNow);

                        result = stackIterator.copy();
                        RandomSource random = RandomSource.create();
                        if (result.hurt(ammoToReload, random, null)) {
                            result.shrink(1);
                            result.setDamageValue(0);
                        }

                        final int slotId = idx;
                        living.getCapability(ForgeCapabilities.ITEM_HANDLER, null).ifPresent(cap -> {
                            if (cap instanceof IItemHandlerModifiable modHandlerEntSetSlot) modHandlerEntSetSlot.setStackInSlot(slotId, result);
                        });

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