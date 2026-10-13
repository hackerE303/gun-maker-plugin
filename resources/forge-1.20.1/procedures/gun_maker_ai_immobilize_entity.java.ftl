{
        if (!${input$entity}.getPersistentData().contains("frozen")) {
                ${input$entity}.getPersistentData().putBoolean("frozen", true);
                ${input$entity}.getPersistentData().putFloat("frozenYaw", ${input$entity}.getYRot());
                ${input$entity}.getPersistentData().putFloat("frozenPitch", ${input$entity}.getXRot());
        }

        if (${input$entity}.getPersistentData().getBoolean("frozen")) {
                Vec3 vel = ${input$entity}.getDeltaMovement();
                ${input$entity}.setDeltaMovement(0, vel.y, 0);

                float frozenYaw = ${input$entity}.getPersistentData().getFloat("frozenYaw");
                float frozenPitch = ${input$entity}.getPersistentData().getFloat("frozenPitch");

                ${input$entity}.setYRot(frozenYaw);
                ${input$entity}.setXRot(frozenPitch);

                if (${input$entity} instanceof LivingEntity le) {
                        le.yBodyRot = frozenYaw;
                        le.yHeadRot = frozenYaw;
                }

                if (${input$entity} instanceof PathfinderMob pm) {
                        pm.getNavigation().stop();
                }
        } else {
                ${input$entity}.getPersistentData().remove("frozenYaw");
                ${input$entity}.getPersistentData().remove("frozenPitch");
        }
}