((Supplier<Boolean>) (() -> {
    GunMaker.GunUtils mg = null;
    return (boolean) mg.getValue(${input$item}, mg.IS_SHOOTING);
})).get()