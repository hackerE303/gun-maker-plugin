(new Object() {
    public int getAmmo(ItemStack stack) {

        GunMaker.GunUtils mg = null;
        return (int) mg.getValue(stack, mg.AMMO_NUMBER);
    }
}.getAmmo(${input$item}))