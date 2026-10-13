((Supplier<Boolean>) (() -> {
    GunMaker.GunUtils mg = null;
    return (boolean) mg.getValue(stack, mg.IS_AIMING);
})).get()
