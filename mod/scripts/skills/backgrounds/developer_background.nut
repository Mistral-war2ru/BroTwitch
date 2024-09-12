this.developer_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.developer";
		this.m.Name = "Developer";
		this.m.Icon = "ui/backgrounds/background_developer.png";
		this.m.BackgroundDescription = "The coolest developer of this mod.";
		this.m.GoodEnding = "%name%";
		this.m.BadEnding = "%name";
		this.m.HiringCost = 1;
		this.m.DailyCost = 1;
		this.m.Excluded = [
			"trait.weasel",
			"trait.teamplayer",
			"trait.fear_undead",
			"trait.fear_beasts",
			"trait.fear_greenskins",
			"trait.fear_undead",
			"trait.fear_beasts",
			"trait.hate_beasts",
			"trait.clubfooted",
			"trait.short_sighted",
			"trait.insecure",
			"trait.hesitant",
			"trait.craven",
			"trait.fainthearted",
			"trait.dumb",
			"trait.superstitious",
			"trait.drunkard"
		];
		this.m.Faces = this.Const.Faces.AllMale;
		this.m.Hairs = this.Const.Hair.CommonMale;
		this.m.HairColors = this.Const.HairColors.All;
		this.m.Beards = this.Const.Beards.All;
		this.m.Bodies = this.Const.Bodies.Muscular;
		this.m.Level = 1;
		this.m.IsCombatBackground = true;
	}

	function getTooltip()
	{
		return [
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
				id = 14,
				type = "text",
				icon = "ui/icons/bravery.png",
				text = "[color=" + this.Const.UI.Color.PositiveValue + "]+50[/color] Bravery for all morale checks"
			}
		];
	}

	function onBuildDescription()
	{
		return "%name%";
	}

	function onSetAppearance()
	{
		local actor = this.getContainer().getActor();
		local tattoo_body = actor.getSprite("tattoo_body");
		local tattoo_head = actor.getSprite("tattoo_head");

		if (this.Math.rand(1, 100) <= 25)
		{
			local body = actor.getSprite("body");
			tattoo_body.setBrush("scar_02_" + body.getBrush().Name);
			tattoo_body.Visible = true;
		}

		if (this.Math.rand(1, 100) <= 25)
		{
			tattoo_head.setBrush("scar_02_head");
			tattoo_head.Visible = true;
		}
	}

	function updateAppearance()
	{
		local actor = this.getContainer().getActor();
		local tattoo_body = actor.getSprite("tattoo_body");

		if (tattoo_body.HasBrush)
		{
			local body = actor.getSprite("body");
			tattoo_body.setBrush("scar_02_" + body.getBrush().Name);
		}
	}

	function onChangeAttributes()
	{
		local c = {
			Hitpoints = [
				40,
				45
			],
			Bravery = [
				30,
				35
			],
			Stamina = [
				30,
				40
			],
			MeleeSkill = [
				20,
				30
			],
			RangedSkill = [
				10,
				12
			],
			MeleeDefense = [
				10,
				15
			],
			RangedDefense = [
				10,
				15
			],
			Initiative = [
				20,
				40
			]
		};
		return c;
	}

	function onAdded()
	{
		this.character_background.onAdded();
		this.getContainer().getActor().setTitle("Big Dick");
	}

	function onAddEquipment()
	{
		local items = this.getContainer().getActor().getItems();
		
		items.equip(this.new("scripts/items/armor/wizard_robe"));
	}

	function onUpdate( _properties )
	{
		this.character_background.onUpdate(_properties);
		_properties.MoraleCheckBravery[1] += 50;
	}

});

