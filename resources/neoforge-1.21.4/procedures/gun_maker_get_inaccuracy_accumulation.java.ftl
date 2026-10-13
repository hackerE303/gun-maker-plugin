((Supplier<Double>) (() -> {
    GunMaker.GunUtils mg = null;
    return (double) mg.getValue(${input$item}, mg.ACCUMULATED_INACCURACY);
})).get()
