((Supplier<Integer>) (() -> {
    GunMaker.GunUtils mg = null;
    return (int) mg.getValue(${input$item}, mg.MAX_AMMO_NUMBER);
})).get()
