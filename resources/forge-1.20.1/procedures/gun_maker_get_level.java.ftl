(new Object() {
    public int getLevel(ItemStack stack) {

        GunMaker.GunUtils mg = null;
        return (int) mg.getValue(${input$item}, mg.LEVEL);
    }
}.getLevel(${input$item}))