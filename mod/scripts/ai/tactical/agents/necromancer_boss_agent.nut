this.necromancer_boss_agent <- this.inherit("scripts/ai/tactical/agent", {
	m = {},
	function create()
	{
		this.agent.create();
		this.m.ID = this.Const.AI.Agent.ID.Necromancer;
		this.m.Properties.OverallMagnetismMult = 3.0;
		
		this.m.Properties.BehaviorMult[this.Const.AI.Behavior.ID.Defend] = 0.5;
		this.m.Properties.TargetPriorityHitchanceMult = 0.5;
		this.m.Properties.TargetPriorityHitpointsMult = 0.25;
		this.m.Properties.TargetPriorityRandomMult = 0.0;
		this.m.Properties.TargetPriorityDamageMult = 0.25;
		this.m.Properties.TargetPriorityFleeingMult = 0.5;
		this.m.Properties.TargetPriorityHittingAlliesMult = 0.1;
		this.m.Properties.TargetPriorityFinishOpponentMult = 3.0;
		this.m.Properties.TargetPriorityCounterSkillsMult = 0.5;
		this.m.Properties.TargetPriorityArmorMult = 0.75;
		this.m.Properties.OverallDefensivenessMult = 0.75;
		this.m.Properties.OverallFormationMult = 0.75;
		this.m.Properties.EngageFlankingMult = 1.25;
		this.m.Properties.EngageTargetMultipleOpponentsMult = 1.25;
		this.m.Properties.EngageTargetAlreadyBeingEngagedMult = 0.5;
	}

	function onAddBehaviors()
	{
		this.addBehavior(this.new("scripts/ai/tactical/behaviors/ai_flee"));
		this.addBehavior(this.new("scripts/ai/tactical/behaviors/ai_break_free"));
		this.addBehavior(this.new("scripts/ai/tactical/behaviors/ai_attack_default"));
		this.addBehavior(this.new("scripts/ai/tactical/behaviors/ai_attack_puncture"));
		this.addBehavior(this.new("scripts/ai/tactical/behaviors/ai_raise_undead"));
		this.addBehavior(this.new("scripts/ai/tactical/behaviors/ai_possess_undead"));
		this.addBehavior(this.new("scripts/ai/tactical/behaviors/ai_engage_ranged"));
		
		this.addBehavior(this.new("scripts/ai/tactical/behaviors/ai_engage_melee"));
		this.addBehavior(this.new("scripts/ai/tactical/behaviors/ai_defend"));
		
		this.addBehavior(this.new("scripts/ai/tactical/behaviors/ai_attack_necro_axe"));
	}

	function onTurnStarted()
	{
		this.agent.onTurnStarted();
		local allies = this.Tactical.Entities.getInstancesOfFaction(this.getActor().getFaction());
		local myTile = this.getActor().getTile();
		local nearest = 9999;

		foreach( a in allies )
		{
			if (a.getID() == this.getActor().getID())
			{
				continue;
			}

			local d = a.getTile().getDistanceTo(myTile);

			if (d < nearest)
			{
				nearest = d;
			}
		}

		if (nearest >= 10)
		{
			this.m.Properties.BehaviorMult[this.Const.AI.Behavior.ID.EngageRanged] = 1.0;
		}
		else
		{
			this.m.Properties.BehaviorMult[this.Const.AI.Behavior.ID.EngageRanged] = 0.0;
		}
	}

});

