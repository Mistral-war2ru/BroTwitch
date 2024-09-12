this.fire_slash <- this.inherit("scripts/skills/skill", {
	m = {},
	function create()
	{
		this.m.ID = "actives.fire_slash";
		this.m.Name = "Fire strike";
		this.m.Description = "A Strike of All-Consuming Flame!";
		this.m.KilledString = "Burned to crisp!";
		this.m.Icon = "skills/active_202.png";
		this.m.IconDisabled = "skills/active_202_sw.png";
		this.m.Overlay = "active_202";
		this.m.SoundOnUse = [
			"sounds/combat/dlc6/fire_lance_01.wav",
			"sounds/combat/dlc6/fire_lance_02.wav",
			"sounds/combat/dlc6/fire_lance_03.wav",
			"sounds/combat/dlc6/fire_lance_04.wav"
		];
		this.m.SoundOnHit = [
			"sounds/combat/dlc6/fire_hit_01.wav",
			"sounds/combat/dlc6/fire_hit_02.wav",
			"sounds/combat/dlc6/fire_hit_03.wav",
			"sounds/combat/dlc6/fire_hit_04.wav",
			"sounds/combat/dlc6/fire_hit_05.wav",
			"sounds/combat/dlc6/fire_hit_06.wav"
		];
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.OffensiveTargeted;
		this.m.IsSerialized = false;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsStacking = false;
		this.m.IsAttack = true;
		this.m.IsWeaponSkill = true;
		this.m.InjuriesOnBody = this.Const.Injury.CuttingBody;
		this.m.InjuriesOnHead = this.Const.Injury.CuttingHead;
		this.m.HitChanceBonus = 20;
		this.m.DirectDamageMult = 0.33;
		this.m.ActionPointCost = 4;
		this.m.FatigueCost = 14;
		this.m.MinRange = 1;
		this.m.MaxRange = 1;
		this.m.ChanceDecapitate = 0;
		this.m.ChanceDisembowel = 0;
		this.m.ChanceSmash = 0;
	}

	function getTooltip()
	{
		local ret = this.getDefaultTooltip();
		ret.extend([
			{
				id = 6,
				type = "text",
				icon = "ui/icons/hitchance.png",
				text = "Have [color=" + this.Const.UI.Color.PositiveValue + "]+20%[/color] hit chance"
			}
		]);
		return ret;
	}

	function onAfterUpdate( _properties )
	{
		this.m.FatigueCostMult = _properties.IsSpecializedInSwords ? this.Const.Combat.WeaponSpecFatigueMult : 1.0;
	}
	
	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
		if (_skill == this)
		{
			_properties.MeleeSkill += 20;
		}
	}

	function onUse( _user, _targetTile )
	{
		this.spawnAttackEffect(_targetTile, this.Const.Tactical.AttackEffectSlash);
		local hit = this.attackEntity(_user, _targetTile.getEntity());
		if (hit)
		{
			local tag = {
				User = _user,
				TargetTile = _targetTile
			};
			this.Time.scheduleEvent(this.TimeUnit.Virtual, 500, this.onDelayedEffect.bindenv(this), tag);
		}
		return hit;
	}
	
	function burn_tile(tile, user)
	{
			local p = {
				Type = "fire",
				Tooltip = "All-consuming flame",
				IsPositive = false,
				IsAppliedAtRoundStart = false,
				IsAppliedAtTurnEnd = true,
				IsAppliedOnMovement = false,
				IsAppliedOnEnter = false,
				IsByPlayer = user.isPlayerControlled(),
				Timeout = this.Time.getRound() + 2,
				Callback = this.Const.Tactical.Common.onApplyFire,
				function Applicable( _a )
				{
					return true;
				}

			};
		
				if (tile.Properties.Effect != null && tile.Properties.Effect.Type == "fire")
				{
					tile.Properties.Effect.Timeout = this.Time.getRound() + 2;
				}
				else
				{
					if (tile.Properties.Effect != null)
					{
						this.Tactical.Entities.removeTileEffect(tile);
					}

					tile.Properties.Effect = clone p;
					local particles = [];

					for( local i = 0; i < this.Const.Tactical.FireParticles.len(); i = ++i )
					{
						particles.push(this.Tactical.spawnParticleEffect(true, this.Const.Tactical.FireParticles[i].Brushes, tile, this.Const.Tactical.FireParticles[i].Delay, this.Const.Tactical.FireParticles[i].Quantity, this.Const.Tactical.FireParticles[i].LifeTimeQuantity, this.Const.Tactical.FireParticles[i].SpawnRate, this.Const.Tactical.FireParticles[i].Stages));
					}

					this.Tactical.Entities.addTileEffect(tile, tile.Properties.Effect, particles);
					tile.clear(this.Const.Tactical.DetailFlag.Scorchmark);
					tile.spawnDetail("impact_decal", this.Const.Tactical.DetailFlag.Scorchmark, false, true);
				}
				
			if (tile.IsOccupiedByActor)
			{
				this.Const.Tactical.Common.onApplyFire(tile, tile.getEntity());
			}
	}
	
	function onDelayedEffect( _tag )
	{
		local user = _tag.User;
		local targetTile = _tag.TargetTile;
		local myTile = user.getTile();
		local dir = myTile.getDirectionTo(targetTile);

		if (myTile.IsVisibleForPlayer)
		{
			if (user.isAlliedWithPlayer())
			{
				for( local i = 0; i < this.Const.Tactical.FireLanceRightParticles.len(); i = ++i )
				{
					local effect = this.Const.Tactical.FireLanceRightParticles[i];
					this.Tactical.spawnParticleEffect(false, effect.Brushes, myTile, effect.Delay, effect.Quantity, effect.LifeTimeQuantity, effect.SpawnRate, effect.Stages, this.createVec(0, 0));
				}
			}
			else
			{
				for( local i = 0; i < this.Const.Tactical.FireLanceLeftParticles.len(); i = ++i )
				{
					local effect = this.Const.Tactical.FireLanceLeftParticles[i];
					this.Tactical.spawnParticleEffect(false, effect.Brushes, myTile, effect.Delay, effect.Quantity, effect.LifeTimeQuantity, effect.SpawnRate, effect.Stages, this.createVec(0, 0));
				}
			}
		}
		
		local targets = [];

		if (targetTile.IsOccupiedByActor && targetTile.getEntity().isAttackable())
		{
			targets.push(targetTile.getEntity());
			burn_tile(targetTile, user);
		}

		if (targetTile.hasNextTile(dir))
		{
			local nextTile = targetTile.getNextTile(dir);

			if (nextTile.IsOccupiedByActor && nextTile.getEntity().isAttackable() && this.Math.abs(nextTile.Level - myTile.Level) <= 1)
			{
				targets.push(nextTile.getEntity());
				burn_tile(nextTile, user);
			}
		}

		this.Sound.play(this.m.SoundOnHit[this.Math.rand(0, this.m.SoundOnHit.len() - 1)], 1.0, user.getPos());
		local tag = {
			User = user,
			Targets = targets
		};
		this.Time.scheduleEvent(this.TimeUnit.Virtual, 200, this.applyEffectToTargets.bindenv(this), tag);
		return true;
	}
	
	function applyEffectToTargets( _tag )
	{
		local user = _tag.User;
		local targets = _tag.Targets;

		foreach( t in targets )
		{
			if (!t.isAlive() || t.isDying())
			{
				continue;
			}
			
			local success = this.attackEntity(user, t, false);

			if (success && t.isAlive() && !t.isDying() && t.getTile().IsVisibleForPlayer)
			{
				for( local i = 0; i < this.Const.Tactical.BurnParticles.len() - 1; i = ++i )
				{
					local effect = this.Const.Tactical.BurnParticles[i];
					this.Tactical.spawnParticleEffect(false, effect.Brushes, t.getTile(), effect.Delay, effect.Quantity * 0.1, effect.LifeTimeQuantity * 0.1, effect.SpawnRate * 0.1, effect.Stages, this.createVec(0, 0));
				}
			}
		}
	}

});

