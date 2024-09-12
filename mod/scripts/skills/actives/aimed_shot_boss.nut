this.aimed_shot_boss <- this.inherit("scripts/skills/skill", {
	m = {},
	function onItemSet()
	{
	}

	function create()
	{
		this.m.ID = "actives.aimed_shot_boss";
		this.m.Name = "Spirit arrow";
		this.m.Description = "Using the life force of the owner, the bow forms a spiritual arrow that ignores armor and always hits the target.";
		this.m.KilledString = "Shot";
		this.m.Icon = "skills/active_18.png";
		this.m.IconDisabled = "skills/active_18_sw.png";
		this.m.Overlay = "active_18";
		this.m.SoundOnUse = [
			"sounds/combat/aimed_shot_01.wav",
			"sounds/combat/aimed_shot_02.wav",
			"sounds/combat/aimed_shot_03.wav"
		];
		this.m.SoundOnHit = [
			"sounds/combat/arrow_hit_01.wav",
			"sounds/combat/arrow_hit_02.wav",
			"sounds/combat/arrow_hit_03.wav"
		];
		this.m.SoundOnHitShield = [
			"sounds/combat/shield_hit_arrow_01.wav",
			"sounds/combat/shield_hit_arrow_02.wav",
			"sounds/combat/shield_hit_arrow_03.wav"
		];
		this.m.SoundOnMiss = [
			"sounds/combat/arrow_miss_01.wav",
			"sounds/combat/arrow_miss_02.wav",
			"sounds/combat/arrow_miss_03.wav"
		];
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.OffensiveTargeted;
		this.m.Delay = 1000;
		this.m.IsSerialized = false;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsStacking = false;
		this.m.IsAttack = true;
		this.m.IsRanged = true;
		this.m.IsWeaponSkill = true;
		this.m.IsIgnoredAsAOO = true;
		this.m.IsShowingProjectile = true;
		this.m.IsDoingForwardMove = false;
		this.m.InjuriesOnBody = this.Const.Injury.PiercingBody;
		this.m.InjuriesOnHead = this.Const.Injury.PiercingHead;
		this.m.DirectDamageMult = 2.0;
		this.m.ActionPointCost = 7;
		this.m.FatigueCost = 25;
		this.m.MinRange = 1;
		this.m.MaxRange = 7;
		this.m.MaxLevelDifference = 4;
		this.m.ProjectileType = this.Const.ProjectileType.Arrow;
	}

	function getTooltip()
	{
		local ret = this.getDefaultTooltip();
		ret.extend([
			{
				id = 6,
				type = "text",
				icon = "ui/icons/vision.png",
				text = "Distance [color=" + this.Const.UI.Color.PositiveValue + "]" + this.getMaxRange() + "[/color] tiles"
			}
		]);
		
		ret.push({
				id = 9,
				type = "text",
				icon = "ui/tooltips/warning.png",
				text = "Absorb [color=" + this.Const.UI.Color.NegativeValue + "]7[/color] hit points of user"
			});

		if (this.Tactical.isActive() && this.getContainer().getActor().getTile().hasZoneOfControlOtherThan(this.getContainer().getActor().getAlliedFactions()))
		{
			ret.push({
				id = 9,
				type = "text",
				icon = "ui/tooltips/warning.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]Target is too close![/color]"
			});
		}

		return ret;
	}

	function isUsable()
	{
		return !this.Tactical.isActive() || this.skill.isUsable() && !this.getContainer().getActor().getTile().hasZoneOfControlOtherThan(this.getContainer().getActor().getAlliedFactions());
	}

	function onAfterUpdate( _properties )
	{
		this.m.MaxRange = this.m.Item.getRangeMax() + (_properties.IsSpecializedInBows ? 1 : 0);
		this.m.FatigueCostMult = _properties.IsSpecializedInBows ? this.Const.Combat.WeaponSpecFatigueMult : 1.0;
	}

	function onUse( _user, _targetTile )
	{
		if (!_user.isHiddenToPlayer() || _targetTile.IsVisibleForPlayer)
		{
			this.getContainer().setBusy(true);
			local tag = {
				Skill = this,
				User = _user,
				TargetTile = _targetTile
			};
			this.Time.scheduleEvent(this.TimeUnit.Virtual, this.m.Delay, this.onPerformAttack, tag);

			if (!_user.isPlayerControlled() && _targetTile.getEntity().isPlayerControlled())
			{
				_user.getTile().addVisibilityForFaction(this.Const.Faction.Player);
			}

			return true;
		}
		else
		{
			return this.attackEntity(_user, _targetTile.getEntity());
		}
	}

	function onPerformAttack( _tag )
	{
		_tag.Skill.getContainer().setBusy(false);
		
		local tag1 = {
					Attacker = _tag.User,
					Skill = _tag.Skill,
					HitInfo = clone this.Const.Tactical.HitInfo
				};
				tag1.HitInfo.DamageRegular = 7;
				tag1.HitInfo.DamageDirect = 1.0;
				tag1.HitInfo.BodyPart = this.Const.BodyPart.Body;
				tag1.HitInfo.BodyDamageMult = 1.0;
				tag1.HitInfo.FatalityChanceMult = 0;
		_tag.User.onDamageReceived(_tag.User, _tag.Skill, tag1.HitInfo);
		
		local tag2 = {
					Attacker = _tag.User,
					Skill = _tag.Skill,
					HitInfo = clone this.Const.Tactical.HitInfo
				};
				tag2.HitInfo.DamageRegular = 2 * this.Math.rand(10, 16);
				tag2.HitInfo.DamageDirect = 1.0;
				tag2.HitInfo.BodyPart = this.Const.BodyPart.Body;
				tag2.HitInfo.BodyDamageMult = 1.0;
				tag2.HitInfo.FatalityChanceMult = 0;
		_tag.TargetTile.getEntity().onDamageReceived(_tag.User, _tag.Skill, tag2.HitInfo);
		
		return true;
	}

});

