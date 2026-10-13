((Supplier<Integer>) (() -> {
    GunMaker.GunUtils mg = null;
    return (int) mg.getValue(${input$item}, mg.RECOVERY_TIME);
})).get()
