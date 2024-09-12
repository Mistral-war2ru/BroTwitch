this.mad_axe <- this.inherit("scripts/items/weapons/weapon", {
	m = {},
	function create()
	{
		this.weapon.create();
		this.m.ID = "weapon.mad_axe";
		this.m.Name = "Heavy Rusty Axe";
		this.m.Description = "";
		this.m.Categories = "Heavy axe";
		//this.m.IconLarge = "weapons/melee/wildmen_09.png";
		//this.m.Icon = "weapons/melee/wildmen_09_70x70.png";
		this.m.SlotType = this.Const.ItemSlot.Mainhand;
		this.m.BlockedSlotType = this.Const.ItemSlot.Offhand;
		this.m.ItemType = this.Const.Items.ItemType.Weapon | this.Const.Items.ItemType.MeleeWeapon | this.Const.Items.ItemType.TwoHanded;
		this.m.IsAgainstShields = true;
		this.m.IsIndestructible = true;
		this.m.IsAoE = true;
		this.m.AddGenericSkill = true;
		this.m.IsDroppedAsLoot = true;
		this.m.ShowQuiver = false;
		this.m.ShowArmamentIcon = true;
		//this.m.ArmamentIcon = "icon_wildmen_09";
		this.m.Value = 2000;
		this.m.ShieldDamage = 36;
		this.m.Condition = 96.0;
		this.m.ConditionMax = 96.0;
		this.m.StaminaModifier = -16;
		this.m.RegularDamage = 90;
		this.m.RegularDamageMax = 115;
		this.m.ArmorDamageMult = 1.5;
		this.m.DirectDamageMult = 0.4;
		this.m.DirectDamageAdd = 0.1;
		this.m.ChanceToHitHead = 0;
		
		this.m.IconLarge = "weapons/melee/mad_axe.png";
		this.m.Icon = "weapons/melee/mad_axe_70x70.png";
		this.m.ArmamentIcon = "mad_axe";
	}

	function onEquip()
	{
		this.weapon.onEquip();
		local skill = this.new("scripts/skills/actives/split_man");
		skill.m.Icon = "skills/active_187.png";
		skill.m.IconDisabled = "skills/active_187_sw.png";
		skill.m.Overlay = "active_187";
		this.addSkill(skill);
		local skill = this.new("scripts/skills/actives/round_swing");
		skill.m.Icon = "skills/active_188.png";
		skill.m.IconDisabled = "skills/active_188_sw.png";
		skill.m.Overlay = "active_188";
		this.addSkill(skill);
		skill = this.new("scripts/skills/actives/split_shield");
		skill.setApplyAxeMastery(true);
		skill.setFatigueCost(skill.getFatigueCostRaw() + 5);
		this.addSkill(skill);
	}

});

