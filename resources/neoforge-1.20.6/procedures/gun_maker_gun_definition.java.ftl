{
    GunMaker mg = null;
    try {
        Class<?> procedureClass = ${name}Procedure.class;
    
        Field ammoNumber = procedureClass.getDeclaredField("AMMO_NUMBER");
        ammoNumber.setAccessible(true);
        ammoNumber.set(null, (int) GunMaker.GunUtils.getValue(${input$item}, GunMaker.GunUtils.AMMO_NUMBER));
    
        Field maxAmmoNumber = procedureClass.getDeclaredField("MAX_AMMO_NUMBER");
        maxAmmoNumber.setAccessible(true);
        maxAmmoNumber.set(null, ${input$max_ammo});
    
        Field damage = procedureClass.getDeclaredField("DAMAGE");
        damage.setAccessible(true);
        damage.set(null, ${input$damage});
    
        Field magazineName = procedureClass.getDeclaredField("MAGAZINE_NAME");
        magazineName.setAccessible(true);
        magazineName.set(null, ${input$ammo_type});
    
        Field itemName = procedureClass.getDeclaredField("ITEM_NAME");
        itemName.setAccessible(true);
        itemName.set(null, ${input$item_name});
    
        Field itemRange = procedureClass.getDeclaredField("ITEM_RANGE");
        itemRange.setAccessible(true);
        itemRange.set(null, "${field$range}");
    
        Field itemAbility = procedureClass.getDeclaredField("ITEM_ABILITY");
        itemAbility.setAccessible(true);
        itemAbility.set(null, ${input$ability});
    
        Field advantage = procedureClass.getDeclaredField("ADVANTAGE");
        advantage.setAccessible(true);
        advantage.set(null, ${input$advantage});
    
        Field canUpgrade = procedureClass.getDeclaredField("CAN_UPGRADE");
        canUpgrade.setAccessible(true);
        canUpgrade.set(null, <#if field$level == "TRUE"> true <#else> false </#if>);
    
    } catch(Exception e) {

        mg.printError(1);
    }
}