this.epic_lute <- this.inherit("scripts/items/weapons/weapon", {
	m = {
		StunChance = 60
	},
	function create()
	{
		this.weapon.create();
		this.m.ID = "weapon.epic_lute";
		this.m.Name = "epic lute";
		this.m.Description = "";
		this.m.Categories = "Musical Instrument, Two-Handed";
		this.m.IconLarge = "weapons/melee/lute_01.png";
		this.m.Icon = "weapons/melee/lute_01_70x70.png";
		this.m.BreakingSound = "sounds/combat/lute_break_01.wav";
		this.m.SlotType = this.Const.ItemSlot.Mainhand;
		this.m.BlockedSlotType = this.Const.ItemSlot.Offhand;
		this.m.ItemType = this.Const.Items.ItemType.Weapon | this.Const.Items.ItemType.MeleeWeapon | this.Const.Items.ItemType.TwoHanded;
		this.m.IsDoubleGrippable = true;
		this.m.IsDroppedAsLoot = false;
		this.m.AddGenericSkill = true;
		this.m.ShowQuiver = false;
		this.m.ShowArmamentIcon = true;
		this.m.ArmamentIcon = "icon_lute";
		this.m.Value = 120;
		this.m.Condition = 200.0;
		this.m.ConditionMax = 200.0;
		this.m.StaminaModifier = 4;
		this.m.RegularDamage = 50;
		this.m.RegularDamageMax = 70;
		this.m.ArmorDamageMult = 1.0;
		this.m.DirectDamageMult = 0.5;
	}

	function onEquip()
	{
		this.weapon.onEquip();
		local s = this.new("scripts/skills/actives/hammer");
		s.m.Icon = "skills/active_88.png";
		s.m.IconDisabled = "skills/active_88_sw.png";
		s.m.Overlay = "active_88";
		this.addSkill(s);
	}

	function onUpdateProperties( _properties )
	{
		this.weapon.onUpdateProperties(_properties);
	}

});

