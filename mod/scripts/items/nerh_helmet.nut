this.nerh_helmet <- this.inherit("scripts/items/helmets/helmet", {
	m = {},
	function create()
	{
		this.helmet.create();
		this.m.ID = "armor.head.nerh_helmet";
		this.m.Name = "Ancient Laurels";
		this.m.Description = "";
		this.m.ShowOnCharacter = true;
		this.m.IsDroppedAsLoot = false;
		this.m.HideHair = true;
		this.m.HideBeard = true;
		this.m.ReplaceSprite = true;
		this.m.IsIndestructible = true;
		local variants = [
			153
		];
		this.m.Variant = variants[this.Math.rand(0, variants.len() - 1)];
		this.updateVariant();
		
		this.m.Sprite = "";
		this.m.SpriteDamaged = "";
		this.m.SpriteCorpse = "";
		this.m.IconLarge = "";
		this.m.Icon = "";
		
		this.m.Icon = "helmets/ancient_laurels_boss.png";
		this.m.ImpactSound = this.Const.Sound.ArmorChainmailImpact;
		this.m.InventorySound = this.Const.Sound.ArmorChainmailImpact;
		this.m.Value = 5000;
		this.m.Condition = 200;
		this.m.ConditionMax = 200;
		this.m.StaminaModifier = 5;
		this.m.Vision = 1;
	}
	
	function getTooltip()
	{
		local result = this.helmet.getTooltip();
		return result;
	}

});

