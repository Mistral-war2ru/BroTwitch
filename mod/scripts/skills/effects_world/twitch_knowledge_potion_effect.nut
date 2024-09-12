this.twitch_knowledge_potion_effect <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "effects.twitch_knowledge_potion";
		this.m.Name = "Duel";
		this.m.Description = "The duel participant learns combat skills faster.";
		this.m.Icon = "skills/status_effect_76.png";
		this.m.Type = this.m.Type | this.Const.SkillType.StatusEffect | this.Const.SkillType.DrugEffect;
	}

	function getTooltip()
	{
		local ret = [
			{
				id = 1,
				type = "title",
				text = this.getName()
			},
			{
				id = 2,
				type = "description",
				text = this.getDescription()
			},
			{
				id = 13,
				type = "text",
				icon = "ui/icons/xp_received.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+200%[/color] more EXP"
			}
		];
		return ret;
	}

	function onUpdate( _properties )
	{
		_properties.XPGainMult *= 4.0;
	}

	function onCombatFinished()
	{
		this.removeSelf();
	}

	function onSerialize( _out )
	{
		this.skill.onSerialize(_out);
		_out.writeU16(this.m.Battles);
	}

	function onDeserialize( _in )
	{
		this.skill.onDeserialize(_in);
		this.m.Battles = _in.readU16();
	}

});

