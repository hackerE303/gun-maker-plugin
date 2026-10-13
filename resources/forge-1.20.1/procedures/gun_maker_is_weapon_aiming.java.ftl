(new Object() {
    public boolean isAiming(ItemStack stack) {

        GunMaker.GunUtils mg = null;
        return (boolean) mg.getValue(stack, mg.IS_AIMING);
    }
}.isAiming(${input$item}))