this.crumble_big_ed_skill <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "actives.crumble_big_ed";
		this.m.Name = "big ed";
		this.m.Description = "";
		this.m.KilledString = "Smashed";
		this.m.Icon = "skills/active_205.png";
		this.m.IconDisabled = "skills/active_205_sw.png";
		this.m.Overlay = "active_205";
		this.m.SoundOnUse = [
			"sounds/combat/dlc6/crumble_01.wav",
			"sounds/combat/dlc6/crumble_02.wav",
			"sounds/combat/dlc6/crumble_03.wav",
			"sounds/combat/dlc6/crumble_04.wav"
		];
		this.m.SoundOnHit = [
			"sounds/combat/dlc6/crumble_hit_01.wav",
			"sounds/combat/dlc6/crumble_hit_02.wav",
			"sounds/combat/dlc6/crumble_hit_03.wav",
			"sounds/combat/dlc6/crumble_hit_04.wav"
		];
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.OffensiveTargeted;
		this.m.IsSerialized = false;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsStacking = false;
		this.m.IsAttack = true;
		this.m.IsRanged = false;
		this.m.IsTooCloseShown = true;
		this.m.IsWeaponSkill = true;
		this.m.InjuriesOnBody = this.Const.Injury.BluntBody;
		this.m.InjuriesOnHead = this.Const.Injury.BluntHead;
		this.m.DirectDamageMult = 0.5;
		this.m.HitChanceBonus = 0;
		this.m.ActionPointCost = 2;
		this.m.FatigueCost = 1;
		this.m.MinRange = 1;
		this.m.MaxRange = 10;
		this.m.ChanceDecapitate = 0;
		this.m.ChanceDisembowel = 0;
		this.m.ChanceSmash = 50;
	}

	function getTooltip()
	{
		local ret = this.getDefaultTooltip();
		return ret;
	}

	function onAfterUpdate( _properties )
	{
		this.m.FatigueCostMult = _properties.IsSpecializedInMaces ? this.Const.Combat.WeaponSpecFatigueMult : 1.0;
	}

	function onUse( _user, _targetTile )
	{
		this.spawnAttackEffect(_targetTile, this.Const.Tactical.AttackEffectBash);
		this.spawnAttackEffect(_targetTile, this.Const.Tactical.AttackEffectSwing);
		this.spawnAttackEffect(_targetTile, this.Const.Tactical.AttackEffectSplitShield);
		return this.attackEntity(_user, _targetTile.getEntity());
	}

	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
		if (_skill == this)
		{
			this.m.HitChanceBonus = 10;
		}
	}

});

