(new Object() {
    public int getRecoveryTime(ItemStack stack) {

        GunMaker.GunUtils mg = null;
        return (int) mg.getValue(stack, mg.RECOVERY_TIME);
    }
}.getRecoveryTime(${input$item}))