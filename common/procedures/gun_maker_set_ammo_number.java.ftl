{
    GunMaker.GunUtils mg = null;
    mg.setValue(${input$item}, mg.AMMO_NUMBER, ${input$index});

    <#if field$reload == "TRUE">
        mg.setValue(${input$item}, mg.IS_RELOADING, true);
    </#if>
}