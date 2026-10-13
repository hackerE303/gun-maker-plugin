((Supplier<Integer>) (() -> {
    GunMaker.GunUtils mg = null;
    return (int) mg.getValue(${input$item}, mg.LEVEL);
})).get()
