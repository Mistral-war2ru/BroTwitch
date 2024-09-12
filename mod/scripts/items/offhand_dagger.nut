this.offhand_dagger <- this.inherit("scripts/items/shields/named/named_shield", {
	m = {},
	function create()
	{
		this.named_shield.create();
		this.m.Variant = 1;
		this.updateVariant();
		this.m.ID = "shield.offhand_dagger";
		this.m.NameList = this.Const.Strings.DaggerNames;
		this.m.Description = "";
		this.m.AddGenericSkill = true;
		this.m.ShowOnCharacter = true;
		this.m.IsDroppedAsLoot = false;
		this.m.Value = 1800;
		this.m.MeleeDefense = 20;
		this.m.RangedDefense = 25;
		this.m.StaminaModifier = 10;
		this.m.Condition = 68;
		this.m.ConditionMax = 68;
		this.randomizeValues();
	}

	function updateVariant()
	{
		this.m.Sprite = "offhand_dagger1";
		this.m.SpriteDamaged = "offhand_dagger1";
		this.m.ShieldDecal = "offhand_dagger1";
		
		this.m.IconLarge = "weapons/melee/dagger_named_0" + this.m.Variant + ".png";
	}

	function onEquip()
	{
		this.named_shield.onEquip();
		this.addSkill(this.new("scripts/skills/actives/shieldwall"));
		this.addSkill(this.new("scripts/skills/actives/knock_back"));
	}

});

