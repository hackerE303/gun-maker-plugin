((Supplier<Boolean>) (() -> {
    if (${input$entity} == null || ${input$looked_entity} == null) return false;

    Level level = ${input$entity}.level();
    if (level == null) return false;

    Vec3 start = ${input$entity}.getEyePosition(1f);
    Vec3 end = ${input$looked_entity}.getEyePosition(1f);

    ClipContext context = new ClipContext(start, end, ClipContext.Block.COLLIDER, ClipContext.Fluid.NONE, ${input$entity});

    BlockHitResult hit = level.clip(context);
    if (hit.getType() == HitResult.Type.MISS) return true;

    return hit.getLocation().distanceToSqr(start) >= end.distanceToSqr(start);
})).get()