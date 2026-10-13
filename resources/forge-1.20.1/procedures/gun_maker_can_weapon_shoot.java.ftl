(new Object() {
    public boolean canShoot(ItemStack stack) {

        GunMaker.GunUtils mg = null;
        return (int) mg.getValue(stack, mg.AMMO_NUMBER) > 0 && (int) mg.getValue(stack, mg.RECOVERY_TIME) <= 0 &&
            (boolean) mg.getValue(stack, mg.SHOULD_SHOOT);
    }
}.canShoot(${input$item}))