(new Object() {
    public boolean isReloading(ItemStack stack) {

        GunMaker.GunUtils mg = null;
        boolean boly = (boolean) mg.getValue(${input$item}, mg.IS_RELOADING);

        mg.setValue(${input$item}, mg.IS_RELOADING, false);
        return boly;
    }
}.isReloading(${input$item}))