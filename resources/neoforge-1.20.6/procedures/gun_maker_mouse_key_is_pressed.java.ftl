((Supplier<Boolean>) (() -> {
    GunMaker.GunUtils mg = null;
    return (boolean) mg.getValue(${input$entity}, mg.MOUSE_${field$button?upper_case});
})).get()