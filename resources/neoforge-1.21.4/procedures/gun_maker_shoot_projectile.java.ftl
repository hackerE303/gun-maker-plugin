{
    GunMaker.GunUtils mg = null;
    int recovery_time = (int) mg.getValue(${input$item}, mg.RECOVERY_TIME);
    boolean has_shooted = (boolean) mg.getValue(${input$item}, mg.HAS_SHOOTED);

    if (recovery_time > 0) recovery_time--;
    double acc_inaccuracy = (double) mg.getValue(${input$item}, mg.ACCUMULATED_INACCURACY);

    if (acc_inaccuracy > 0.0) {

        acc_inaccuracy -= acc_inaccuracy * 0.75;
        if (acc_inaccuracy < 0.0) acc_inaccuracy = 0.0;
    }

    ItemStack hand = ${input$entity} instanceof LivingEntity living ? living.getMainHandItem() : ItemStack.EMPTY;

    int current_ammo = (int) mg.getValue(${input$item}, mg.AMMO_NUMBER);
    int shooted_ammo = (int) mg.getValue(${input$item}, mg.SHOOTED_ROUNDS);

    boolean should_shoot = (boolean) mg.getValue(${input$item}, mg.SHOULD_SHOOT);

    <#if field$shoot_mode != "MACHINE_GUN_MODE">

        if (!should_shoot && has_shooted) {
            mg.setValue(${input$item}, mg.HAS_SHOOTED, false);
            has_shooted = false;
        }
    </#if>

    mg.setValue(${input$item}, mg.IS_SHOOTING, false);
    if (hand == ${input$item} && mg.isGun(${input$item})) {

        if (current_ammo > 0 && recovery_time <= 0
            <#if 
                field$shoot_mode != "MACHINE_GUN_MODE"> && should_shoot && !has_shooted
            <#else>
                && (should_shoot || shooted_ammo != 0)
            </#if>) {

            Entity shooter = ${input$entity};
            Level projectileLevel = shooter.level();

            final float final_acc_inaccuracy = (float) acc_inaccuracy;
            var shoot = new Object() {
                public void act(ItemStack s, Entity e, double a) {

                    if (projectileLevel.isClientSide) return;
                    Projectile projectile = ${input$projectile};

                    projectile.setPos(shooter.getX(), shooter.getEyeY() - 0.25, shooter.getZ());
                    projectile.shoot(shooter.getLookAngle().x, shooter.getLookAngle().y, shooter.getLookAngle().z, (float) ${input$speed}, (float) (a + final_acc_inaccuracy));
                    projectileLevel.addFreshEntity(projectile);
                }
            };

            <#if field$shoot_mode == "SHOTGUN_MODE">
                for (int index = 0; index < ${input$repeat}; index++) shoot.act(hand, shooter, 10.0);

                mg.setValue(${input$item}, mg.IS_SHOOTING, true);
                mg.setValue(${input$item}, mg.HAS_SHOOTED, true);
                if (projectileLevel.isClientSide()) shooter.setXRot(shooter.getXRot() - (float) ${input$recoil});

                current_ammo--;
                acc_inaccuracy = (double) ${input$shot_inaccuracy};

            <#elseif field$shoot_mode == "MACHINE_GUN_MODE">
                if (shooted_ammo < ${input$repeat}) {
                        
                    shooted_ammo++;
                    shoot.act(hand, shooter, 2.0);

                    mg.setValue(${input$item}, mg.IS_SHOOTING, true);
                    if (projectileLevel.isClientSide()) shooter.setXRot(shooter.getXRot() - (float) ${input$recoil});

                    current_ammo--;
                    acc_inaccuracy += (double) ${input$shot_inaccuracy};

                } else {
                    recovery_time = (int) ${input$recovery};
                    shooted_ammo = 0;
                }

            <#else>
                shoot.act(hand, shooter, 1.0);

                mg.setValue(${input$item}, mg.IS_SHOOTING, true);
                mg.setValue(${input$item}, mg.HAS_SHOOTED, true);
                if (projectileLevel.isClientSide()) shooter.setXRot(shooter.getXRot() - (float) ${input$recoil});

                current_ammo--;
                acc_inaccuracy += (double) ${input$shot_inaccuracy};
            </#if>

            <#if field$shoot_mode != "MACHINE_GUN_MODE">
                recovery_time = (int) ${input$recovery};
            </#if>
        }
    }
    mg.setValue(${input$item}, mg.RECOVERY_TIME, recovery_time);
    mg.setValue(${input$item}, mg.ACCUMULATED_INACCURACY, acc_inaccuracy);

    mg.setValue(${input$item}, mg.AMMO_NUMBER, current_ammo);
    mg.setValue(${input$item}, mg.SHOOTED_ROUNDS, shooted_ammo);
}