this.fruto_mad_trait <- this.inherit("scripts/skills/traits/character_trait", {
	m = {
	lvl = 1
	},
	function create()
	{
		this.character_trait.create();
		this.m.ID = "trait.fruto_mad";
		this.m.Name = "Fruit worship";
		this.m.Icon = "ui/traits/trait_icon_fruto.png";
		this.m.Description = "This character became a true follower of the fruit god.";
		this.m.Order = this.Const.SkillOrder.Trait - 1;
	}

	function getTooltip()
	{
		local List = [];
		List.push({
				id = 1,
				type = "title",
				text = this.getName()
			});
		List.push({
				id = 2,
				type = "description",
				text = this.getDescription()
			});
		List.push({
				id = 3,
				type = "text",
				icon = "ui/icons/level.png",
				text = "Level of fanaticism [color=" + this.Const.UI.Color.PositiveValue + "]"+this.m.lvl+"[/color]"
			});
		List.push({
				id = 11,
				type = "text",
				icon = "ui/icons/health.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+"+(3*this.m.lvl)+"[/color] HP"
			});
		List.push({
				id = 10,
				type = "text",
				icon = "ui/icons/bravery.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+"+(2*this.m.lvl)+"[/color] Bravery"
			});
		List.push({
				id = 11,
				type = "text",
				icon = "ui/icons/melee_defense.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+"+(this.m.lvl)+"[/color] Defence"
			});
		List.push({
				id = 11,
				type = "text",
				icon = "ui/icons/ranged_defense.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+"+(this.m.lvl)+"[/color] Ranged Defence"
			});
		if (this.m.lvl>=9)
		{
			List.push({
				id = 11,
				type = "text",
				icon = "ui/icons/fatigue.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+4[/color] Stamina"
			});
		}
		else if (this.m.lvl>=6)
		{
			List.push({
				id = 11,
				type = "text",
				icon = "ui/icons/fatigue.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+2[/color] Stamina"
			});
		}
		else if (this.m.lvl>=3)
		{
			List.push({
				id = 11,
				type = "text",
				icon = "ui/icons/fatigue.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+1[/color] Stamina"
			});
		}
		if (this.m.lvl>=2)
		{
			List.push({
				id = 10,
				type = "text",
				icon = "ui/icons/morale.png",
				text = "Death of allies does not affect morale"
			});
		}
		if (this.m.lvl>=4)
		{
			List.push({
				id = 10,
				type = "text",
				icon = "ui/icons/damage_received.png",
				text = "Losing health does not affect morale"
			});
		}
		if (this.m.lvl>=6)
		{
			List.push({
				id = 11,
				type = "text",
				icon = "ui/icons/xp_received.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "] +50%[/color] EXP"
			});
			List.push({
				id = 10,
				type = "text",
				icon = "ui/icons/asset_money.png",
				text = "Fresh injuries do not affect morale"
			});
		}
		if (this.m.lvl>=8)
		{
			List.push({
				id = 10,
				type = "text",
				icon = "ui/icons/special.png",
				text = "No payment required"
			});
		}
		
		
		return List;
	}

	function onUpdate( _properties )
	{
		if (this.m.lvl>=2)_properties.IsAffectedByDyingAllies = false;
		if (this.m.lvl>=4)_properties.IsAffectedByLosingHitpoints = false;
		if (this.m.lvl>=6)
		{
		_properties.IsAffectedByFreshInjuries = false;
		_properties.XPGainMult *= 1.5;
		}
		if (this.m.lvl>=8)_properties.DailyWageMult *= 0.0;
		
		_properties.Hitpoints += 3*this.m.lvl;
		_properties.Bravery += 2*this.m.lvl;
		
		_properties.MeleeDefense += this.m.lvl;
		_properties.RangedDefense += this.m.lvl;
		
		if (this.m.lvl>=9)_properties.FatigueRecoveryRate += 4;
		if (this.m.lvl>=6)_properties.FatigueRecoveryRate += 2;
		else if (this.m.lvl>=3)_properties.FatigueRecoveryRate += 1;
	}

});

