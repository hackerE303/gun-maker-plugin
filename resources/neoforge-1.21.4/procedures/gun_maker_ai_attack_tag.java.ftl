if (${input$entity} instanceof Mob _mob) {
    if (!(_mob.getTarget() instanceof LivingEntity) 
        || !((LivingEntity) _mob.getTarget()).isAlive()) {
        try {
            GoalSelector _targetSelector = _mob.targetSelector;

            NearestAttackableTargetGoal<LivingEntity> _goal =
                new NearestAttackableTargetGoal<>(
                    _mob,
                    LivingEntity.class,
                    10,
                    true,
                    false,
                    e -> ${field$tag_state}e.getType().is(
                            TagKey.create(Registries.ENTITY_TYPE, 
                                new ResourceLocation(${input$tag}))
                        ) && !e.getType().is(
                            TagKey.create(Registries.ENTITY_TYPE, 
                                new ResourceLocation("minecraft:no_entities"))
                        )
                );

            _targetSelector.addGoal((int) ${input$priority}, _goal);
        } catch (Exception ignored) {
        }
    }
}