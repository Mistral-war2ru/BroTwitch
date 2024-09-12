this.mad_helmet <- this.inherit("scripts/items/helmets/helmet", {
	m = {},
	function create()
	{
		this.helmet.create();
		this.m.ID = "armor.head.mad_helmet";
		this.m.Name = "Mad helmet";
		this.m.Description = "This helmet exudes an aura of madness...";
		this.m.ShowOnCharacter = true;
		this.m.IsDroppedAsLoot = true;
		this.m.HideHair = true;
		this.m.HideBeard = true;
		this.m.HideCharacterHead = true;
		this.m.IsIndestructible = true;
		local variants = [
			194
		];
		this.m.Variant = variants[this.Math.rand(0, variants.len() - 1)];
		this.updateVariant();
		
		this.m.Sprite = "mad_helmet";
		this.m.SpriteDamaged = "mad_helmet_damaged";
		this.m.SpriteCorpse = "mad_helmet_dead";
		this.m.IconLarge = "";
		this.m.Icon = "helmets/mad_helmet.png";
		
		this.m.ImpactSound = this.Const.Sound.ArmorHalfplateImpact;
		this.m.InventorySound = this.Const.Sound.ArmorHalfplateImpact;
		this.m.Value = 3300;
		this.m.Condition = 200;
		this.m.ConditionMax = 200;
		this.m.StaminaModifier = -10;
		this.m.Vision = 1;
	}
	
	function updateVariant()
	{
		this.m.Sprite = "mad_helmet";
		this.m.SpriteDamaged = "mad_helmet_damaged";
		this.m.SpriteCorpse = "mad_helmet_dead";
		this.m.IconLarge = "";
		this.m.Icon = "helmets/mad_helmet.png";
	}

});

