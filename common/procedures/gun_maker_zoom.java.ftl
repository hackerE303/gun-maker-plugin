{
    Minecraft mc = Minecraft.getInstance();

    mc.options.fov().set((int) ${input$index});
    mc.options.save();
}