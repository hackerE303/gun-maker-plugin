(new Object() {
    public boolean isPressed(Entity entity) {

        GunMaker.GunUtils mg = null;
        return (boolean) mg.getValue(entity, mg.MOUSE_${field$button?upper_case});
    }
}.isPressed(${input$entity}))