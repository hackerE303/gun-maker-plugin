<#if field$goal_remove == "FALSE">

${input$entity}.getPersistentData().putBoolean("simpleFormation", true);
if (!${input$entity}.getPersistentData().getBoolean("simpleFormationCall")) {
	${input$entity}.getPersistentData().putBoolean("simpleFormationCall", true);
	${input$entity}.getPersistentData().putBoolean("simpleFormation", false);
	${input$entity}.getPersistentData().putBoolean("simpleFormationCanBeStopped", false);
	if (${input$entity} instanceof PathfinderMob mob && (${input$commander} != null && ${input$commander} instanceof PathfinderMob commander)) {
    	mob.goalSelector.addGoal(
        	${input$priority},
        	new ${field$class}Procedure.SimpleFormationGoal(
            	mob,
            	commander,
            	(int) ${input$max_units},
            	(double) ${input$spacing} * 3.0D,
            	(double) ${input$speed}
        	)
    	);
	}
}

<#else>

${input$entity}.getPersistentData().putBoolean("forceStopSimpleFormation", false);
${input$entity}.getPersistentData().putBoolean("simpleFormationCanBeStopped", true);
if (${input$entity} instanceof PathfinderMob mob && (${input$commander} != null && ${input$commander} instanceof PathfinderMob commander)) {
    	mob.goalSelector.addGoal(
        	${input$priority},
        	new ${field$class}Procedure.SimpleFormationGoal(
            	mob,
            	commander,
            	(int) ${input$max_units},
            	(double) ${input$spacing} * 3.0D,
            	(double) ${input$speed}
        )
    );
}

</#if>