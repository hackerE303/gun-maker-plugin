(new Object() {
    public double getAccumuledInaccuracy(ItemStack stack) {

        GunMaker.GunUtils mg = null;
        return (double) mg.getValue(${input$item}, mg.ACCUMULATED_INACCURACY);
    }
}.getAccumuledInaccuracy(${input$item}))