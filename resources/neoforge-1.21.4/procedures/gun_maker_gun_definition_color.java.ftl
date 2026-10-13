{
    GunMaker mg = null;
    try {
        Class<?> procedureClass = ${name}Procedure.class;
        Field itemColor = procedureClass.getDeclaredField("ITEM_COLOR");
        
        itemColor.setAccessible(true);
        itemColor.set(null, "${field$color}");

    } catch(Exception e) {

        mg.printError(1);
    }
}