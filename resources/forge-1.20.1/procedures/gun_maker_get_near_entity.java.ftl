((Supplier<Entity>) (() -> {
    if (${input$entity} == null || ${input$entity}.level() == null) return null;

    Entity source = ${input$entity};
    Level level = source.level();

    double maxDistance = (double) ${input$index};
    double projectileRadius = (double) ${input$size};
    
    Vec3 start = source.getEyePosition(1f);
    Vec3 look = source.getViewVector(1f).normalize();

    Entity nearest = null;
    double nearestForward = Double.POSITIVE_INFINITY;

    List<Entity> candidates = level.getEntities(source, source.getBoundingBox().inflate(maxDistance));

    for (Entity candidate : candidates) {
        if (candidate == source) continue;
        if (!candidate.isPickable()) continue;

        AABB box = candidate.getBoundingBox();
        Vec3 boxCenter = new Vec3((box.minX + box.maxX) / 2.0, (box.minY + box.maxY) / 2.0, (box.minZ + box.maxZ) / 2.0);

        Vec3 toCenter = boxCenter.subtract(start);
        double forwardProj = toCenter.dot(look);

        if (forwardProj <= 0) continue;
        if (forwardProj > maxDistance) continue;

        Vec3 pointOnLine = start.add(look.scale(forwardProj));

        double cx = Math.max(box.minX, Math.min(box.maxX, pointOnLine.x));
        double cy = Math.max(box.minY, Math.min(box.maxY, pointOnLine.y));
        double cz = Math.max(box.minZ, Math.min(box.maxZ, pointOnLine.z));
        Vec3 closestPointOnBox = new Vec3(cx, cy, cz);

        double lateralDist = closestPointOnBox.subtract(pointOnLine).length();

        if (lateralDist <= projectileRadius) {
            double forwardForCandidate = forwardProj;

            if (forwardForCandidate < nearestForward) {
                nearestForward = forwardForCandidate;
                nearest = candidate;
            }
        } else {

            double tMin = Math.max(0.0, forwardProj - 1.0);
            double tMax = Math.min(maxDistance, forwardProj + 1.0);

            boolean intersects = false;
            int samples = 5;
            for (int i = 0; i <= samples; i++) {
                double t = tMin + (tMax - tMin) * i / (double)samples;
                Vec3 p = start.add(look.scale(t));
                double px = Math.max(box.minX, Math.min(box.maxX, p.x));
                double py = Math.max(box.minY, Math.min(box.maxY, p.y));
                double pz = Math.max(box.minZ, Math.min(box.maxZ, p.z));
                Vec3 cp = new Vec3(px, py, pz);
                double lat = cp.subtract(p).length();
                if (lat <= projectileRadius) {
                    intersects = true;
                    if (t < nearestForward) {
                        nearestForward = t;
                        nearest = candidate;
                    }
                    break;
                }
            }
            if (intersects) continue;
        }
    } return nearest;
})).get()