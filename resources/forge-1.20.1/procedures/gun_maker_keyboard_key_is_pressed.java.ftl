(new Object() {
    public boolean isKeyPressed() {

        Minecraft mc = Minecraft.getInstance();
        return InputConstants.isKeyDown(mc.getWindow().getWindow(), GLFW.GLFW_KEY_${field$letter});
    }
}.isKeyPressed())