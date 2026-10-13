<#if field$goal_remove == "FALSE">

${input$entity}.getPersistentData().putBoolean("borderPatrol", true);
if (!${input$entity}.getPersistentData().getBoolean("borderPatrolCall")) {
	${input$entity}.getPersistentData().putBoolean("borderPatrolCall", true);
	${input$entity}.getPersistentData().putBoolean("borderPatrol", false);
	${input$entity}.getPersistentData().putBoolean("borderPatrolCanBeStopped", false);
	if (${input$entity} instanceof PathfinderMob mob) {
    	mob.goalSelector.addGoal(
        	${input$priority},
        	new ${field$class}Procedure.BorderPatrolGoal(
            	mob,
            	(double) ${input$radius},
            	(double) ${input$speed},
            	(int) ${input$tick_interval}
        	)
    	);
	}
}

<#else>

${input$entity}.getPersistentData().putBoolean("forceStopBorderPatrol", false);
${input$entity}.getPersistentData().putBoolean("borderPatrolCanBeStopped", true);
if (${input$entity} instanceof PathfinderMob mob) {
    	mob.goalSelector.addGoal(
        	${input$priority},
        	new ${field$class}Procedure.BorderPatrolGoal(
            	mob,
            	(double) ${input$radius},
            	(double) ${input$speed},
            	(int) ${input$tick_interval}
        	)
    	);
	}

</#if>