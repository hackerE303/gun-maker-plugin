{
    GunMaker.GunUtils mg = null;
    CompoundTag tag = ${input$item}.getOrCreateTag();
    
    if (${input$shoot_cond}) tag.putString("geckoAnim", ${input$shoot_animation});
    else if (${input$reload_cond}) tag.putString("geckoAnim", ${input$reload_animation});
    else if ((int) mg.getValue(${input$item}, mg.RECOVERY_TIME) == 0) tag.putString("geckoAnim", ${input$idle});
}