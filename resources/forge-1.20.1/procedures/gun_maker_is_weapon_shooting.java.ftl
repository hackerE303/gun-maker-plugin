(new Object() {
    public boolean isShooting(ItemStack stack) {

        GunMaker.GunUtils mg = null;
        return (boolean) mg.getValue(stack, mg.IS_SHOOTING);
    }
}.isShooting(${input$item}))