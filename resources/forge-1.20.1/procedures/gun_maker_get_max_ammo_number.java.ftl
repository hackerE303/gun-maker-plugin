(new Object() {
    public int getMaxAmmo(ItemStack stack) {

        GunMaker.GunUtils mg = null;
        return (int) mg.getValue(stack, mg.MAX_AMMO_NUMBER);
    }
}.getMaxAmmo(${input$item}))