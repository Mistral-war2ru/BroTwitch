::TwitchDebug <- {
	ID = "mod_twitchdebug",
	Name = "Twitch Debug",
	Version = "4.0.1",
	
	//prepare
	PrepareCarefullyMode = false,
	PlayerDeploymentType = null,
	CurrentlySelectedBro = null,
	MaxVertical = 2,
	MaxHorizontal = 2,
	InvalidColor = this.createColor("#ff0000"),
	ValidColor = this.createColor("#00ff1d"),
	MinimalValidTiles = {
		AsString = [],
		AsTiles = [],
		Details = [],
	},
	ValidTiles = {
		AsString = [],
		AsTiles = [],
		Details = [],
	},
	ExtraValidTiles = {
		AsString = [],
		AsTiles = [],
		Details = [],
	},
	InvalidTraits = [
		//"trait.clubfooted",
		//"trait.clumsy",
		//"trait.hesitant",
		//"trait.fat",
		//"background.cripple",
	],
	ExtraValidTraits = [
		"trait.weasel",
		"trait.athletic",
		"trait.quick",
		"trait.sure_footing",
		"trait.impatient",
		"trait.swift",
		"background.poacher",
		"background.hunter",
		"background.thief",
	],
	// BRO DEPENDANT FUNCTIONS
	setCurrentlySelectedBro = function(_bro)
	{
		if (this.CurrentlySelectedBro != null)
			this.showSelectedArrow(this.CurrentlySelectedBro, false);
		this.showSelectedArrow(_bro, true);
		this.CurrentlySelectedBro = ::WeakTableRef(_bro);
		this.colorSpritesBasedOnValid(_bro);
	},

	colorSpritesBasedOnValid = function(_bro)
	{
		foreach (detail in this.ExtraValidTiles.Details)
		{
			detail.Visible = false;
		}
		local function iterateTiles(_tiles)
		{
			foreach (detail in _tiles)
			{
				detail.Visible = true;
			}
		}
		if (this.isInvalidBro(_bro))
			iterateTiles(this.MinimalValidTiles.Details);
		else if (this.isExtraValidBro(_bro))
			iterateTiles(this.ExtraValidTiles.Details);
		else
			iterateTiles(this.ValidTiles.Details);
	},
	
	isTileValidForBro = function(_tile, _bro)
	{
		local X = _tile.SquareCoords.X;
		local Y = _tile.SquareCoords.Y;
		local asString = X.tostring() + "." + Y.tostring();
		if (this.isInvalidBro(_bro))
		{
			return this.MinimalValidTiles.AsString.find(asString) != null
		}

		if (this.ValidTiles.AsString.find(asString) != null
			|| (this.isExtraValidBro(_bro) && this.ExtraValidTiles.AsString.find(asString) != null))
		{
			return true;
		}
		return false;
	},

	isInvalidBro = function(_bro)
	{
		local skills = _bro.getSkills();
		foreach (trait in this.InvalidTraits)
		{
			if (skills.hasSkill(trait))
				return true;
		}
		return false;
	},
	
	isExtraValidBro = function(_bro)
	{
		local skills = _bro.getSkills();
		foreach (trait in this.ExtraValidTraits)
		{
			if (skills.hasSkill(trait))
				return true;
		}
		return false;
	},

	showSelectedArrow = function( _bro, _v )
	{
		local arrow = _bro.getSprite("PrepareCarefullyArrow");
		if (_v)
		{
			arrow.Visible = true;
			arrow.fadeIn(100);
		}
		else
		{
			arrow.fadeOutAndHide(100);
		}
	},
	// END BRO FUNCTIONS
	
	getValidTiles = function()
	{
		local minX, maxX, minY, maxY, icon, tile, x, y, asString;
		local playerUnits = this.Tactical.Entities.getInstancesOfFaction(this.Const.Faction.Player);
		local playerDeploymentType = this.PlayerDeploymentType;
		local ambushMode = playerDeploymentType == this.Const.Tactical.DeploymentType.Circle || playerDeploymentType == this.Const.Tactical.DeploymentType.Center;
		foreach (bro in playerUnits)
		{
			tile = bro.getTile();
			x = tile.SquareCoords.X;
			y = tile.SquareCoords.Y;
			this.MinimalValidTiles.AsString.push(x + "." +  y);
			this.MinimalValidTiles.AsTiles.push(tile);

			if (minX == null || tile.SquareCoords.X < minX) minX = tile.SquareCoords.X;
			if (maxX == null || tile.SquareCoords.X > maxX) maxX = tile.SquareCoords.X;
			if (minY == null || tile.SquareCoords.Y < minY) minY = tile.SquareCoords.Y;
			if (maxY == null || tile.SquareCoords.Y > maxY) maxY = tile.SquareCoords.Y;
		}
		minX = minX - (ambushMode ? 1 : this.MaxHorizontal);
		maxX = maxX + (ambushMode ? 1 : 0);
		minY = minY - (ambushMode ? 1 : this.MaxVertical);
		maxY = maxY + (ambushMode ? 1 : this.MaxVertical);
		for( local x = minX; x != maxX + 1; x++ )
		{
			for( local y = minY; y != maxY + 1; y++ )
			{
				if (!this.Tactical.isValidTileSquare(x, y))
					continue;
				asString = x + "." +  y;
				this.ValidTiles.AsString.push(asString);
				tile = this.Tactical.getTileSquare(x, y);
				this.ValidTiles.AsTiles.push(tile);
				icon = tile.spawnDetail("mortar_target_02", this.Const.Tactical.DetailFlag.SpecialOverlay, false, false);
				icon.Color = this.ValidColor;
				icon.Saturation = 60;
				this.ValidTiles.Details.push(icon);
				if (this.MinimalValidTiles.AsString.find(asString) != null)
					this.MinimalValidTiles.Details.push(icon);
			}
		}

		this.ExtraValidTiles.AsString = clone this.ValidTiles.AsString;
		this.ExtraValidTiles.AsTiles = clone this.ValidTiles.AsTiles;
		this.ExtraValidTiles.Details = clone this.ValidTiles.Details;
		foreach (validTile in this.ValidTiles.AsTiles)
		{
			for( local j = 0; j < 6; j++ )
			{
				if (validTile.hasNextTile(j))
				{
					local neighbor = validTile.getNextTile(j);
					x = neighbor.SquareCoords.X;
					y = neighbor.SquareCoords.Y;
					asString = x.tostring() + "." + y.tostring();
					if (this.ExtraValidTiles.AsString.find(asString) == null)
					{
						this.ExtraValidTiles.AsString.push(asString);
						this.ExtraValidTiles.AsTiles.push(neighbor);
						if (this.ValidTiles.AsString.find(asString) == null)
						{
							icon = neighbor.spawnDetail("mortar_target_02", this.Const.Tactical.DetailFlag.SpecialOverlay, false, false);
							icon.Color = this.ValidColor;
							icon.Saturation = 60;
							icon.Visible = false;
							this.ExtraValidTiles.Details.push(icon);
						}
					}
				}
			}
		}
	},
	
	denyVisibility = function(_changeVisibilityFunction = true)
	{
		local tile;
		this.Tactical.clearVisibility();
		foreach (tile in this.ExtraValidTiles.AsTiles)
		{
			tile.addVisibilityForFaction(this.Const.Faction.Player);
		}

		if (_changeVisibilityFunction)
		{
			local playerUnits = this.Tactical.Entities.getInstancesOfFaction(this.Const.Faction.Player);
			foreach (bro in playerUnits)
			{
				bro.old_updateVisibility <- bro.updateVisibility;
				bro.updateVisibility = function(_tile, _vision, _faction)
				{
					return;
				}
			}
		}

	},
	
	onLeftClickPrepareCarefully = function(_mouseEvent)
	{
		local tile = this.Tactical.getTile(this.Tactical.screenToTile(_mouseEvent.getX(), _mouseEvent.getY()));
		if (!tile.IsEmpty && !tile.IsOccupiedByActor) return;
		local entity = tile.getEntity();
		if (entity != null)
		{
			if (entity.isPlayerControlled())
			{
				this.setCurrentlySelectedBro(entity);
			}
		}
		else if (this.CurrentlySelectedBro != null)
		{
			if(!this.isTileValidForBro(tile, this.CurrentlySelectedBro))
			{
				this.Tactical.getShaker().shake(this.CurrentlySelectedBro, tile, 1);
				return
			}
			this.Tactical.getNavigator().teleport(this.CurrentlySelectedBro, tile, null, null, false, 0.0);
		}
	},
	
	onRightClickPrepareCarefully = function(_mouseEvent)
	{
		local tile = this.Tactical.getTile(this.Tactical.screenToTile(_mouseEvent.getX(), _mouseEvent.getY()));
		if (!tile.IsEmpty && !tile.IsOccupiedByActor) return;
		local entity = tile.getEntity();
		if (entity != null && entity.isPlayerControlled())
		{
			if (this.CurrentlySelectedBro != null)
			{
				local valid = true;
				if (!this.isTileValidForBro(this.CurrentlySelectedBro.getTile(), entity))
				{
					this.Tactical.getShaker().shake(entity, tile, 1);
					valid = false;
				}
				if (!this.isTileValidForBro(tile, this.CurrentlySelectedBro))
				{
					this.Tactical.getShaker().shake(this.CurrentlySelectedBro, tile, 1);
					valid = false;
				}
				if (valid)
				{
					this.Tactical.getNavigator().switchEntities(entity, this.CurrentlySelectedBro, null, null, 1.0);
				}
			}
			else
			{
				this.setCurrentlySelectedBro(entity);
			}
		}
	},
	
	clearVariables = function()
	{
		this.PrepareCarefullyMode = false;
		if (this.CurrentlySelectedBro != null && !this.CurrentlySelectedBro.isNull())
		{
			this.showSelectedArrow(this.CurrentlySelectedBro, false);
		}
		this.CurrentlySelectedBro = null;
		this.PlayerDeploymentType = null;
		this.MinimalValidTiles = {
			AsString = [],
			AsTiles = [],
			Details = [],
		},
		this.ValidTiles = {
			AsString = [],
			AsTiles = [],
			Details = [],
		};
		this.ExtraValidTiles = {
			AsString = [],
			AsTiles = [],
			Details = [],
		};
		local playerUnits = ::World.getPlayerRoster().getAll();
		foreach (idx, bro in playerUnits)
		{
			if("old_updateVisibility" in bro)
			{
				bro.updateVisibility = bro.old_updateVisibility;
				delete bro.old_updateVisibility;
			}
		}
	},
}

::TwitchDebug.Hooks <- ::Hooks.register(::TwitchDebug.ID, ::TwitchDebug.Version, ::TwitchDebug.Name);
::TwitchDebug.Hooks.require("mod_msu(>=1.0.0-beta)");

::TwitchDebug.Hooks.queue(">mod_msu", function()
{
	::TwitchDebug.Mod <- ::MSU.Class.Mod(::TwitchDebug.ID, ::TwitchDebug.Version, ::TwitchDebug.Name);
	
	local page = ::TwitchDebug.Mod.ModSettings.addPage("Settings");
	
	page.addBooleanSetting("Sacrifice", true, "Sacrifice event", "Can event be called?");
	
	page.addDivider( "Div0" );
	
	local setting = page.addRangeSetting("Diff", 10, 1, 40, 1, "General difficulty", "Difficulty multiplier for ALL fights added from mod");
	setting.addCallback(function(_value)
	{
		local gt1 = this.getroottable();
		gt1.tnf_debug.diff = _value;
	});
	
	page.addDivider( "Div1" );
	
	setting = page.addRangeSetting("NerhHG", 20, 1, 200, 1, "Nerh - honor guard protector", "Multiplier % spawn");
	setting.addCallback(function(_value)
	{
		local gt1 = this.getroottable();
		gt1.tnf_debug.nerh_heavy_guard = _value;
	});
	setting = page.addRangeSetting("NerhHP", 30, 1, 200, 1, "Nerh - honor guard polearm", "Multiplier % spawn");
	setting.addCallback(function(_value)
	{
		local gt1 = this.getroottable();
		gt1.tnf_debug.nerh_heavy_poly = _value;
	});
	setting = page.addRangeSetting("NerhH", 30, 1, 200, 1, "Nerh - honor guard", "Multiplier % spawn");
	setting.addCallback(function(_value)
	{
		local gt1 = this.getroottable();
		gt1.tnf_debug.nerh_heavy = _value;
	});
	setting = page.addRangeSetting("NerhL", 115, 1, 200, 1, "Nerh - skeletons", "Multiplier % spawn");
	setting.addCallback(function(_value)
	{
		local gt1 = this.getroottable();
		gt1.tnf_debug.nerh_light = _value;
	});
	setting = page.addRangeSetting("NerhHV", 33, 1, 200, 1, "Nerh - vampires", "Multiplier % spawn");
	setting.addCallback(function(_value)
	{
		local gt1 = this.getroottable();
		gt1.tnf_debug.nerh_vamp = _value;
	});
	
	page.addDivider( "Div2" );
	
	setting = page.addRangeSetting("MikeD", 12, 1, 200, 1, "Mike - wild dog", "Multiplier % spawn");
	setting.addCallback(function(_value)
	{
		local gt1 = this.getroottable();
		gt1.tnf_debug.mike_dog = _value;
	});
	setting = page.addRangeSetting("MikeM", 95, 1, 200, 1, "Mike - barbarian", "Multiplier % spawn");
	setting.addCallback(function(_value)
	{
		local gt1 = this.getroottable();
		gt1.tnf_debug.mike_mar = _value;
	});
	setting = page.addRangeSetting("MikeC", 65, 1, 200, 1, "Mike - barbarian champion", "Multiplier % spawn");
	setting.addCallback(function(_value)
	{
		local gt1 = this.getroottable();
		gt1.tnf_debug.mike_ch = _value;
	});
	
	page.addDivider( "Div3" );
	
	setting = page.addRangeSetting("HopM", 98, 1, 200, 1, "Hopeless - mercenary", "Multiplier % spawn");
	setting.addCallback(function(_value)
	{
		local gt1 = this.getroottable();
		gt1.tnf_debug.hoples_merc = _value;
	});
	setting = page.addRangeSetting("HopMR", 70, 1, 200, 1, "Hopeless - ranged mercenary", "Multiplier % spawn");
	setting.addCallback(function(_value)
	{
		local gt1 = this.getroottable();
		gt1.tnf_debug.hoples_merr = _value;
	});
	setting = page.addRangeSetting("HopK", 75, 1, 200, 1, "Hopeless - knight", "Multiplier % spawn");
	setting.addCallback(function(_value)
	{
		local gt1 = this.getroottable();
		gt1.tnf_debug.hoples_kn = _value;
	});
	
	page.addDivider( "Div4" );
	
	setting = page.addRangeSetting("PashP", 25, 1, 200, 1, "Pavel - peon", "Multiplier % spawn");
	setting.addCallback(function(_value)
	{
		local gt1 = this.getroottable();
		gt1.tnf_debug.pasha_peon = _value;
	});
	setting = page.addRangeSetting("PashM", 25, 1, 200, 1, "Pavel - militia", "Multiplier % spawn");
	setting.addCallback(function(_value)
	{
		local gt1 = this.getroottable();
		gt1.tnf_debug.pasha_mil = _value;
	});
	setting = page.addRangeSetting("PashF", 80, 1, 200, 1, "Pavel - footman", "Multiplier % spawn");
	setting.addCallback(function(_value)
	{
		local gt1 = this.getroottable();
		gt1.tnf_debug.pasha_foot = _value;
	});
	setting = page.addRangeSetting("PashB", 40, 1, 200, 1, "Pavel - polearm", "Multiplier % spawn");
	setting.addCallback(function(_value)
	{
		local gt1 = this.getroottable();
		gt1.tnf_debug.pasha_bil = _value;
	});
	setting = page.addRangeSetting("PashS", 30, 1, 200, 1, "Pavel - swordmaster", "Multiplier % spawn");
	setting.addCallback(function(_value)
	{
		local gt1 = this.getroottable();
		gt1.tnf_debug.pasha_sword = _value;
	});
	setting = page.addRangeSetting("PashA", 30, 1, 200, 1, "Pavel - ranged", "Multiplier % spawn");
	setting.addCallback(function(_value)
	{
		local gt1 = this.getroottable();
		gt1.tnf_debug.pasha_arb = _value;
	});
	
	page.addDivider( "Div5" );
	
	setting = page.addRangeSetting("DesrtN", 100, 1, 200, 1, "Desert warrior - nomad", "Multiplier % spawn");
	setting.addCallback(function(_value)
	{
		local gt1 = this.getroottable();
		gt1.tnf_debug.nomad_nomad = _value;
	});
	setting = page.addRangeSetting("DesrtG", 50, 1, 200, 1, "Desert warrior  - guner", "Multiplier % spawn");
	setting.addCallback(function(_value)
	{
		local gt1 = this.getroottable();
		gt1.tnf_debug.nomad_gun = _value;
	});
	setting = page.addRangeSetting("DesrtS", 25, 1, 200, 1, "Desert warrior  - ranged", "Multiplier % spawn");
	setting.addCallback(function(_value)
	{
		local gt1 = this.getroottable();
		gt1.tnf_debug.nomad_sling = _value;
	});
	setting = page.addRangeSetting("DesrtC", 25, 1, 200, 1, "Desert warrior  - cutthroat", "Multiplier % spawn");
	setting.addCallback(function(_value)
	{
		local gt1 = this.getroottable();
		gt1.tnf_debug.nomad_cut = _value;
	});
	
	page.addDivider( "Div6" );
	
	setting = page.addRangeSetting("BeastW1", 40, 1, 200, 1, "Beastmaster - wolf", "Multiplier % spawn");
	setting.addCallback(function(_value)
	{
		local gt1 = this.getroottable();
		gt1.tnf_debug.beast_wolf1 = _value;
	});
	setting = page.addRangeSetting("BeastW2", 50, 1, 200, 1, "Beastmaster - strong wolf", "Multiplier % spawn");
	setting.addCallback(function(_value)
	{
		local gt1 = this.getroottable();
		gt1.tnf_debug.beast_wolf2 = _value;
	});
	setting = page.addRangeSetting("BeastG1", 40, 1, 200, 1, "Beastmaster - small ghoul", "Multiplier % spawn");
	setting.addCallback(function(_value)
	{
		local gt1 = this.getroottable();
		gt1.tnf_debug.beast_gul1 = _value;
	});
	setting = page.addRangeSetting("BeastG2", 30, 1, 200, 1, "Beastmaster - ghoul", "Multiplier % spawn");
	setting.addCallback(function(_value)
	{
		local gt1 = this.getroottable();
		gt1.tnf_debug.beast_gul2 = _value;
	});
	setting = page.addRangeSetting("BeastG3", 60, 1, 200, 1, "Beastmaster - big ghoul", "Multiplier % spawn");
	setting.addCallback(function(_value)
	{
		local gt1 = this.getroottable();
		gt1.tnf_debug.beast_gul3 = _value;
	});
	setting = page.addRangeSetting("BeastS", 60, 1, 200, 1, "Beastmaster - spider", "Multiplier % spawn");
	setting.addCallback(function(_value)
	{
		local gt1 = this.getroottable();
		gt1.tnf_debug.beast_sp = _value;
	});
	setting = page.addRangeSetting("BeastA", 50, 1, 200, 1, "Beastmaster - alp", "Multiplier % spawn");
	setting.addCallback(function(_value)
	{
		local gt1 = this.getroottable();
		gt1.tnf_debug.beast_alp = _value;
	});
	setting = page.addRangeSetting("BeastU", 70, 1, 200, 1, "Beastmaster - troll", "Multiplier % spawn");
	setting.addCallback(function(_value)
	{
		local gt1 = this.getroottable();
		gt1.tnf_debug.beast_unh = _value;
	});
	
	page.addDivider( "Div7" );
	
	setting = page.addRangeSetting("NekrG1", 36, 1, 200, 1, "Gachimartyr - small ghoul", "Multiplier % spawn");
	setting.addCallback(function(_value)
	{
		local gt1 = this.getroottable();
		gt1.tnf_debug.nekr_gul1 = _value;
	});
	setting = page.addRangeSetting("NekrG2", 20, 1, 200, 1, "Gachimartyr - ghoul", "Multiplier % spawn");
	setting.addCallback(function(_value)
	{
		local gt1 = this.getroottable();
		gt1.tnf_debug.nekr_gul2 = _value;
	});
	setting = page.addRangeSetting("NekrG3", 20, 1, 200, 1, "Gachimartyr - big ghoul", "Multiplier % spawn");
	setting.addCallback(function(_value)
	{
		local gt1 = this.getroottable();
		gt1.tnf_debug.nekr_gul3 = _value;
	});
	setting = page.addRangeSetting("NekrY", 20, 1, 200, 1, "Gachimartyr - zombie bandit", "Multiplier % spawn");
	setting.addCallback(function(_value)
	{
		local gt1 = this.getroottable();
		gt1.tnf_debug.nekr_yo = _value;
	});
	setting = page.addRangeSetting("NekrZ", 52, 1, 200, 1, "Gachimartyr - zombie", "Multiplier % spawn");
	setting.addCallback(function(_value)
	{
		local gt1 = this.getroottable();
		gt1.tnf_debug.nekr_z = _value;
	});
	setting = page.addRangeSetting("NekrN", 20, 1, 200, 1, "Gachimartyr - zombie nomad", "Multiplier % spawn");
	setting.addCallback(function(_value)
	{
		local gt1 = this.getroottable();
		gt1.tnf_debug.nekr_nom = _value;
	});
	setting = page.addRangeSetting("NekrGh", 25, 1, 200, 1, "Gachimartyr - ghost", "Multiplier % spawn");
	setting.addCallback(function(_value)
	{
		local gt1 = this.getroottable();
		gt1.tnf_debug.nekr_g = _value;
	});
	setting = page.addRangeSetting("NekrK", 50, 1, 200, 1, "Gachimartyr - zombie knight", "Multiplier % spawn");
	setting.addCallback(function(_value)
	{
		local gt1 = this.getroottable();
		gt1.tnf_debug.nekr_kn = _value;
	});
	
	page.addDivider( "Div8" );
	
	setting = page.addRangeSetting("SnakeL", 100, 1, 200, 1, "Snake charmer - lindwurm", "Multiplier % spawn");
	setting.addCallback(function(_value)
	{
		local gt1 = this.getroottable();
		gt1.tnf_debug.snake_wurm = _value;
	});
	setting = page.addRangeSetting("SnakeS", 140, 1, 200, 1, "Snake charmer - snake", "Multiplier % spawn");
	setting.addCallback(function(_value)
	{
		local gt1 = this.getroottable();
		gt1.tnf_debug.snake_snake = _value;
	});
	
	page.addDivider( "Div9" );
	
	setting = page.addRangeSetting("BskelHG", 30, 1, 200, 1, "Bonedance - honor guard protector", "Multiplier % spawn");
	setting.addCallback(function(_value)
	{
		local gt1 = this.getroottable();
		gt1.tnf_debug.bskelet_hg = _value;
	});
	setting = page.addRangeSetting("BskelH", 50, 1, 200, 1, "Bonedance - honor guard", "Multiplier % spawn");
	setting.addCallback(function(_value)
	{
		local gt1 = this.getroottable();
		gt1.tnf_debug.bskelet_h = _value;
	});
	setting = page.addRangeSetting("BskelHP", 25, 1, 200, 1, "Bonedance - honor guard polearm", "Multiplier % spawn");
	setting.addCallback(function(_value)
	{
		local gt1 = this.getroottable();
		gt1.tnf_debug.bskelet_hp = _value;
	});
	setting = page.addRangeSetting("BskelMP", 25, 1, 200, 1, "Bonedance - skeleton polearm", "Multiplier % spawn");
	setting.addCallback(function(_value)
	{
		local gt1 = this.getroottable();
		gt1.tnf_debug.bskelet_mp = _value;
	});
	setting = page.addRangeSetting("BskelL", 90, 1, 200, 1, "Bonedance - skeleton", "Multiplier % spawn");
	setting.addCallback(function(_value)
	{
		local gt1 = this.getroottable();
		gt1.tnf_debug.bskelet_l = _value;
	});
	setting = page.addRangeSetting("BskelV", 20, 1, 200, 1, "Bonedance - vampire", "Multiplier % spawn");
	setting.addCallback(function(_value)
	{
		local gt1 = this.getroottable();
		gt1.tnf_debug.bskelet_v = _value;
	});
	
	page.addDivider( "Div10" );
	
	setting = page.addRangeSetting("BarbD", 20, 1, 200, 1, "North Guardian - wild dog", "Multiplier % spawn");
	setting.addCallback(function(_value)
	{
		local gt1 = this.getroottable();
		gt1.tnf_debug.barb_dog = _value;
	});
	setting = page.addRangeSetting("BarbT", 92, 1, 200, 1, "North Guardian - thrall", "Multiplier % spawn");
	setting.addCallback(function(_value)
	{
		local gt1 = this.getroottable();
		gt1.tnf_debug.barb_th = _value;
	});
	setting = page.addRangeSetting("BarbB", 20, 1, 200, 1, "North Guardian - tamer", "Multiplier % spawn");
	setting.addCallback(function(_value)
	{
		local gt1 = this.getroottable();
		gt1.tnf_debug.barb_bst = _value;
	});
	setting = page.addRangeSetting("BarbU", 80, 1, 200, 1, "North Guardian - troll", "Multiplier % spawn");
	setting.addCallback(function(_value)
	{
		local gt1 = this.getroottable();
		gt1.tnf_debug.barb_unh = _value;
	});
	setting = page.addRangeSetting("BarbC", 80, 1, 200, 1, "North Guardian - champion", "Multiplier % spawn");
	setting.addCallback(function(_value)
	{
		local gt1 = this.getroottable();
		gt1.tnf_debug.barb_ch = _value;
	});
	
	//location spawns
	
	::TwitchDebug.Hooks.hook("scripts/factions/actions/build_unique_locations_action", function (q){
		q.m.BuildNerhMonolith <- true;
		q.m.BuildPashaCastle <- true;
		
		q.updateBuildings = @(__original) function() {
			__original();
			
			if (this.World.Assets.getOrigin().getID() != "scenario.twitch")
			{
				this.m.BuildNerhMonolith = false;
				this.m.BuildPashaCastle = false;
			}
			
			local locations = this.World.EntityManager.getLocations();

			foreach( v in locations )
			{
				if (v.getTypeID() == "location.nerh_monolith")
				{
					this.m.BuildNerhMonolith = false;
				}
				if (v.getTypeID() == "location.pasha_castle")
				{
					this.m.BuildPashaCastle = false;
				}
			}
		}
		
		q.onExecute = @(__original) function(_faction) {
		
			if (this.m.BuildNerhMonolith){
				local camp;
				local avoidTerrain = [
				this.Const.World.TerrainType.Mountains, 
				this.Const.World.TerrainType.Oasis
				]

				local tile = this.getTileToSpawnLocation(this.Const.Factions.BuildCampTries * 100, avoidTerrain, 8, 1000, 1000, 4, 4);

				if (tile != null)
				{
					camp = this.World.spawnLocation("scripts/entity/world/locations/nerh_monolith", tile.Coords);
				}
				if (camp != null)
				{
					camp.onSpawned();
					camp.setBanner("banner_13")
					
					this.World.uncoverFogOfWar(camp.getTile().Pos, 200);
					camp.setDiscovered(true);
					camp.getSprite("selection").Visible = true;
					camp.setVisibleInFogOfWar(true);
					
					this.World.Flags.set("spawnedLegendaryNerh", true);
					this.logInfo("Nerh Monolith spawned in build_unique_locations_action");
					
				}
			}
			
			if (this.m.BuildPashaCastle){
				local camp;
				local avoidTerrain = [
				this.Const.World.TerrainType.Mountains, 
				this.Const.World.TerrainType.Oasis
				]

				local tile = this.getTileToSpawnLocation(this.Const.Factions.BuildCampTries * 100, avoidTerrain, 8, 1000, 1000, 4, 4);

				if (tile != null)
				{
					camp = this.World.spawnLocation("scripts/entity/world/locations/pasha_castle", tile.Coords);
				}
				if (camp != null)
				{
					camp.onSpawned();
					camp.setBanner("banner_13")
					
					this.World.uncoverFogOfWar(camp.getTile().Pos, 200);
					camp.setDiscovered(true);
					camp.getSprite("selection").Visible = true;
					camp.setVisibleInFogOfWar(true);
					
					this.World.Flags.set("spawnedLegendaryPasha", true);
					this.logInfo("Pasha castle spawned in build_unique_locations_action");
					
				}
			}
			
			__original(_faction);
		}
	});
	
::TwitchDebug.Hooks.hook("scripts/states/world_state", function (q){
		q.onDeserialize = @(__original) function(_in) {
			__original(_in);
			
			if (this.World.Assets.getOrigin().getID() == "scenario.twitch")
			{
				if (!::World.Flags.get("spawnedLegendaryNerh"))
				{
					local f = ::World.FactionManager.getFactionOfType(::Const.FactionType.Zombies);
					local action = f.getAction("build_zombie_camp_action");
					local tile 
					//do
					{
						tile = action.getTileToSpawnLocation(::Const.Factions.BuildCampTries * 100, [
							::Const.World.TerrainType.Mountains,
							::Const.World.TerrainType.Oasis
						], 8, 1000, 1000, 4, 4, null);
					}
					//while (tile == null)
					
					if (tile != null)
					{
						local lair = ::World.spawnLocation("scripts/entity/world/locations/nerh_monolith", tile.Coords);

						if (lair != null)
						{
							::World.Flags.set("spawnedLegendaryNerh", true);
							lair.onSpawned();
							this.logInfo("Nerh Monolith spawned in world_state");
						}
					}
				}
				if (!::World.Flags.get("spawnedLegendaryPasha"))
				{
					local f = ::World.FactionManager.getFactionOfType(::Const.FactionType.Zombies);
					local action = f.getAction("build_zombie_camp_action");
					local tile 
					//do
					{
						tile = action.getTileToSpawnLocation(::Const.Factions.BuildCampTries * 100, [
							::Const.World.TerrainType.Mountains,
							::Const.World.TerrainType.Oasis
						], 8, 1000, 1000, 4, 4, null);
					}
					//while (tile == null)
					
					if (tile != null)
					{
						local lair = ::World.spawnLocation("scripts/entity/world/locations/pasha_castle", tile.Coords);

						if (lair != null)
						{
							::World.Flags.set("spawnedLegendaryPasha", true);
							lair.onSpawned();
							this.logInfo("Pasha castle spawned in world_state");
						}
					}
				}
			}
		}
        });
	//locations

	//prepare
	
	::Hooks.registerJS("ui/mods/PrepareCarefullyTwitch.js");
	::Hooks.registerCSS("ui/mods/PrepareCarefullyTwitch.css");
	
	::TwitchDebug.Hooks.hook("scripts/entity/tactical/actor", function (q)
	{
		q.onInit = @(__original) function() {
			__original();
			local arrow = this.addSprite("PrepareCarefullyArrow");
			this.setSpriteColorization("PrepareCarefullyArrow", false);
			arrow.setBrush("bust_arrow");
			arrow.Visible = false;
			arrow.Color = ::TwitchDebug.InvalidColor;
		}
	});
	
	::TwitchDebug.Hooks.hook("scripts/states/tactical_state", function (q){
		q.onFinish = @(__original) function() 
		{
			__original();
			::TwitchDebug.clearVariables();
		}

		q.initMap = @(__original) function() 
		{
			__original();
			::TwitchDebug.clearVariables();
			local properties = this.getStrategicProperties();
			::TwitchDebug.PrepareCarefullyMode = false;
			if (properties.CombatID == "TwitchLegendaryBossLoc")::TwitchDebug.PrepareCarefullyMode = true;
			::TwitchDebug.PlayerDeploymentType = properties.PlayerDeploymentType;
			if (::TwitchDebug.PrepareCarefullyMode)
			{
				::TwitchDebug.getValidTiles();
				//::TwitchDebug.denyVisibility();
			}
		}

		q.onMouseInput = @(__original) function(_mouseEvent) 
		{
			if (::TwitchDebug.PrepareCarefullyMode)
			{
				if (_mouseEvent.getID() == 1)
					return ::TwitchDebug.onLeftClickPrepareCarefully(_mouseEvent);
				else if (_mouseEvent.getID() == 2)
					return ::TwitchDebug.onRightClickPrepareCarefully(_mouseEvent);
				else return onMouseInput(_mouseEvent);
			}
			return __original(_mouseEvent);
		}

		q.topbar_round_information_onQueryRoundInformation = @(__original) function() 
		{
			local ret = __original();
			ret.PrepareCarefullyMode <- ::TwitchDebug.PrepareCarefullyMode;
			return ret;
		}

		q.setInputLocked = @(__original) function(_bool) 
		{
			if (::TwitchDebug.PrepareCarefullyMode)
				return __original(false);
			return __original(_bool);
		}


		q.updateCurrentEntity = @(__original) function() 
		{
			if(::TwitchDebug.PrepareCarefullyMode)
				return;

			return __original();
		}

		q.turnsequencebar_onNextRound = @(__original) function(_round) 
		{
			local ret = __original(_round);
			if (::TwitchDebug.PrepareCarefullyMode)
			{
				::TwitchDebug.denyVisibility(false);
				local playerUnits = this.Tactical.Entities.getInstancesOfFaction(this.Const.Faction.Player);
				foreach(bro in playerUnits)
				{
					bro.updateVisibilityForFaction()
				}
			}
		}
	});
	
	::TwitchDebug.Hooks.hook("scripts/camera/tactical_camera_director", function (q){
		q.isInputAllowed = @(__original) function() 
		{
			if(::TwitchDebug.PrepareCarefullyMode)
				return true;
			return __original();
		}
	});

	::TwitchDebug.Hooks.hook("scripts/ui/screens/tactical/tactical_screen", function (q){
		q.onPrepareCarefullyButtonPressed <- function()
		{
			foreach (tile in ::TwitchDebug.ExtraValidTiles.AsTiles)
			{
				tile.clear(this.Const.Tactical.DetailFlag.SpecialOverlay);
			}
			::TwitchDebug.clearVariables();
			this.Tactical.fillVisibility(this.Const.Faction.Player, false);
			foreach (bro in this.Tactical.Entities.getInstancesOfFaction(this.Const.Faction.Player))
			{
				bro.updateVisibilityForFaction();
			}
		}
	});

	::TwitchDebug.Hooks.hook("scripts/ui/screens/tactical/modules/turn_sequence_bar/turn_sequence_bar", function (q)
	{
		q.entityWaitTurn = @(__original) function(_entity) 
		{
			if (::TwitchDebug.PrepareCarefullyMode)
			{
				return true;
			}
			return __original(_entity);
		}
	});
	
	//prepare
});

local gt = this.getroottable();

local files = clone gt.tnf_debug.files;
gt.tnf_debug.fillFileList(files);
local purgedFiles = gt.tnf_debug.purgeFileList(files);

local IsDebugModeEnabled = false;
local virtualSpeed = 1.0;

//add contracts

//8 = noble house


//10 = settlements
gt.Const.FactionTrait.Actions[10].push("scripts/factions/contracts/twitch_beastmaster_boss_action");
gt.Const.FactionTrait.Actions[10].push("scripts/factions/contracts/twitch_nekr_boss_action");
gt.Const.FactionTrait.Actions[10].push("scripts/factions/contracts/twitch_barbarian_boss_action");
gt.Const.FactionTrait.Actions[10].push("scripts/factions/contracts/twitch_skeleton_boss_action");

//18 = nomad city
gt.Const.FactionTrait.Actions[18].push("scripts/factions/contracts/twitch_nomad_boss_action");
gt.Const.FactionTrait.Actions[18].push("scripts/factions/contracts/twitch_snake_boss_action");

//add contracts

local lastevent = 0;

local function replace(str, sub, rep)
{
  local s, i;
  for(i = 0; i < str.len(); )
  {
    local e = str.find(sub, i);
    if(e == null) break;
    if(s == null) s = "";
    s += str.slice(i, e) + rep;
    i = e + sub.len();
  }
  if(s == null) return str;
  return s + str.slice(i);
}

::Hooks.registerJS("ui/mods/tnf_debugMode.js");

::TwitchDebug.Hooks.hook("scripts/ui/screens/character/character_screen", function (q) {
  q.tnf_onGiveActiveCharacter <- function ( _data )
  {
    local bro = this.Tactical.getEntityByID(_data[0]);
    switch(_data[1]) {
      case "Level":
        bro.addXP(gt.Const.LevelXP[bro.getLevel()] - bro.getXP(), false);
        bro.updateLevel();
        break;
      case "Perk":
        bro.m.PerkPoints++;
        break;
      case "Stats":
        foreach (index, attribute in gt.tnf_debug.attributes)
        {
          bro.getBaseProperties()[attribute] += gt.Const.AttributesLevelUp[index].Max;
          bro.getCurrentProperties()[attribute] += gt.Const.AttributesLevelUp[index].Max;
        }
        bro.setHitpointsPct(1);
        break;
      case "Heal":
        bro.setHitpointsPct(1);
        bro.getSkills().removeByType(this.Const.SkillType.Injury);
        bro.getSkills().removeByID("trait.old");
        bro.getSkills().removeByID("trait.addict");
        bro.getSkills().removeByID("effects.hangover");
        bro.getSkills().removeByID("effects.exhausted");
        bro.getSprite("permanent_injury_1").Visible = false;
        bro.getSprite("permanent_injury_2").Visible = false;
        bro.getSprite("permanent_injury_3").Visible = false;
        bro.getSprite("permanent_injury_4").Visible = false;
        bro.improveMood(10.0, "Has enjoyed Vilain's debug mode");
        break;      
      case "Trait":
        local trait = gt.tnf_debug.positiveTraits[this.Math.rand(0, gt.tnf_debug.positiveTraits.len() - 1)];
        bro.getSkills().add(this.new("scripts/skills/traits/" + trait + "_trait"));
        break;
	  case "TraitB":
        local trait = gt.tnf_debug.negativeTraits[this.Math.rand(0, gt.tnf_debug.negativeTraits.len() - 1)];
        bro.getSkills().add(this.new("scripts/skills/traits/" + trait + "_trait"));
        break;
	  case "Dumb":
        local trait = "dumb";
        bro.getSkills().add(this.new("scripts/skills/traits/" + trait + "_trait"));
        break;
	  case "Cult":
	    local background = this.new("scripts/skills/backgrounds/cultist_background");
				bro.getSkills().removeByID(bro.getBackground().getID());
				bro.getSkills().add(background);
		background.buildDescription();
		background.onSetAppearance();
        break;
      case "RTrait":
        local traits = gt.tnf_debug.getTraits(bro);
        local trait = traits[traits.len() - 1];
        bro.getSkills().removeByID(trait);
        break;
	  case "Sex":
        if (bro.m.Bodies == this.Const.Bodies.AllFemale)
		{
			bro.m.Faces = this.Const.Faces.AllMale;
			bro.m.Hairs = this.Const.Hair.AllMale;
			bro.m.HairColors = this.Const.HairColors.Young;
			bro.m.Beards = this.Const.Beards.All;
			bro.m.BeardChance = 100;
			bro.m.Bodies = this.Const.Bodies.AllMale;
		}
		else
		{
			bro.m.Faces = this.Const.Faces.AllFemale;
			bro.m.Hairs = this.Const.Hair.AllFemale;
			bro.m.HairColors = this.Const.HairColors.Young;
			bro.m.Beards = null;
			bro.m.BeardChance = 0;
			bro.m.Bodies = this.Const.Bodies.AllFemale;
		}
		
			local actor = bro;
			local hairColor = actor.m.HairColors[this.Math.rand(0, actor.m.HairColors.len() - 1)];
			
			if (actor.m.Faces != null)
		{
			local sprite = actor.getSprite("head");
			sprite.setBrush(actor.m.Faces[this.Math.rand(0, actor.m.Faces.len() - 1)]);
			sprite.Color = this.createColor("#fbffff");
			sprite.varyColor(0.05, 0.05, 0.05);
			sprite.varySaturation(0.1);
			local body = actor.getSprite("body");
			body.Color = sprite.Color;
			body.Saturation = sprite.Saturation;
		}

		if (actor.m.Hairs != null && this.Math.rand(0, actor.m.Hairs.len()) != actor.m.Hairs.len())
		{
			local sprite = actor.getSprite("hair");
			sprite.setBrush("hair_" + hairColor + "_" + actor.m.Hairs[this.Math.rand(0, actor.m.Hairs.len() - 1)]);

			if (hairColor != "grey")
			{
				sprite.varyColor(0.1, 0.1, 0.1);
			}
			else
			{
				sprite.varyBrightness(0.1);
			}
		}

		if (actor.m.Beards != null && this.Math.rand(1, 100) <= actor.m.BeardChance)
		{
			local beard = actor.getSprite("beard");
			beard.setBrush("beard_" + hairColor + "_" + actor.m.Beards[this.Math.rand(0, actor.m.Beards.len() - 1)]);
			beard.Color = actor.getSprite("hair").Color;

			if (this.doesBrushExist(beard.getBrush().Name + "_top"))
			{
				local sprite = actor.getSprite("beard_top");
				sprite.setBrush(beard.getBrush().Name + "_top");
				sprite.Color = actor.getSprite("hair").Color;
			}
		}

		if (actor.m.Ethnicity == 1 && hairColor != "grey")
		{
			local hair = actor.getSprite("hair");
			hair.Saturation = 0.8;
			hair.setBrightness(0.4);
			local beard = actor.getSprite("beard");
			beard.Color = hair.Color;
			beard.Saturation = hair.Saturation;
			local beard_top = actor.getSprite("beard_top");
			beard_top.Color = hair.Color;
			beard_top.Saturation = hair.Saturation;
		}

		if (actor.m.Bodies != null)
		{
			local body = actor.m.Bodies[this.Math.rand(0, actor.m.Bodies.len() - 1)];
			actor.getSprite("body").setBrush(body);
			actor.getSprite("injury_body").setBrush(body + "_injured");
		}
		
        break;
    }
  };
});

::TwitchDebug.Hooks.hook("scripts/states/world/asset_manager", function (q) {
	
   q.updateFormation = @(__original) function( considerMaxBros = false ) 
   {
		__original(considerMaxBros);
		
		//local roster = this.World.getPlayerRoster().getAll();
		//foreach( b in roster ){if (b.getPlaceInFormation() == 255){b.setPlaceInFormation(26);}}
   };
});

local LogDay;
::TwitchDebug.Hooks.hook("scripts/states/world_state", function (q) {

q.updateDayTime = @(__original) function() 
{
  __original();
  
  if (LogDay != this.World.getTime().Days) this.logDebug("Twitch Day: " + this.World.getTime().Days);
  LogDay = this.World.getTime().Days;
  
  function canFireEvent()
	{
		if (this.World.State.getMenuStack().hasBacksteps() || this.LoadingScreen != null && (this.LoadingScreen.isAnimating() || this.LoadingScreen.isVisible()) || this.World.State.m.EventScreen.isVisible() || this.World.State.m.EventScreen.isAnimating())
		{
			return false;
		}

		if (("State" in this.Tactical) && this.Tactical.State != null)
		{
			return false;
		}

		if (this.World.Events.m.ActiveEvent != null)
		{
			return false;
		}

		if (this.Time.getVirtualTimeF() - this.World.Events.m.LastBattleTime < 1.0)
		{
			return false;
		}

		return true;
	}
  
  if (!this.isInCharacterScreen() && canFireEvent())
				{
					if(!this.m.MenuStack.hasBacksteps())
					{
						if (lastevent > 0)lastevent--;
						if (lastevent == 0)
						{
						
	local lastevent_time = 50;
						
	local scriptFiles = this.IO.enumerateFiles("twitch");
	if (scriptFiles != null)
	{
		foreach( scriptFile in scriptFiles )
		{
			if (lastevent == 0)
			{
			
			
			//this.logDebug("Twitch File: "+scriptFile);
			//twitch/!bro name
			local e = scriptFile.find("twitch/!bro ", 0);
			if (e!=null)
			{
				this.logDebug("Twitch File: "+scriptFile);
				local name = "" + scriptFile;
				name = replace(name, "twitch/!bro ", "");
				if (name.len() > 0)
				{
					local roster = this.World.getPlayerRoster();
					local bros = roster.getAll();          
					if (bros.len() < this.World.Assets.m.BrothersMax)
					{
						local found = 0;
						foreach( bro in bros )
						{
							if (bro.getNameOnly() == name)found = 1;
						}
						if (found == 0)
						{
							local backgrounds = clone purgedFiles.backgrounds;
							function slice(string) {return string.slice(gt.tnf_debug.directories.backgrounds.len());}
							backgrounds.apply(slice);
							
							local bro = roster.create("scripts/entity/tactical/player");
							bro.m.HireTime = this.Time.getVirtualTimeF();
							bro.setName(name);
							bro.setStartValuesEx(backgrounds);
							bro.getBackground().buildDescription(true);
							bro.m.Attributes = [];
							bro.fillAttributeLevelUpValues(this.Const.XP.MaxLevelWithPerkpoints - 1);
							bro.getSkills().update();
							this.World.Assets.updateFormation();
							
							//if (bro.getPlaceInFormation() == 255){bro.m.PlaceInFormation = 26;}
							
							local eventToFire;
							local events = this.World.Events.m.Events;
							for( local i = 0; i < events.len(); i = ++i )
							{
								if (events[i].getID() == "event.twitch_add_player")
								{
									eventToFire = events[i];
									eventToFire.m.Name = name;
								}
							}
							if (eventToFire != null)
							this.World.Events.fire(eventToFire.getID() "event.twitch_add_player");
							lastevent = lastevent_time;
						}
					}
				}
			}
			//twitch/!train name
			local e = scriptFile.find("twitch/!train ", 0);
			if (e!=null)
			{
				this.logDebug("Twitch File: "+scriptFile);
				local name = "" + scriptFile;
				name = replace(name, "twitch/!train ", "");
				if (name.len() > 0)
				{
					local MA = this.Math.rand(2, 4);
					local MD = this.Math.rand(2, 4);
					local RA = this.Math.rand(2, 4);
					local RD = this.Math.rand(2, 4);
					local II = this.Math.rand(3, 5);
					local FF = this.Math.rand(3, 5);
					local HP = this.Math.rand(3, 6);
					local BR = this.Math.rand(2, 5);
					
					local found = 0;
					local roster = this.World.getPlayerRoster();
					local bros = roster.getAll();          
						foreach( bro in bros )
						{
							if (bro.getNameOnly() == name)
							{
								found = 1;
							}
						}
					if (found == 1)
					{
							local eventToFire;
							local events = this.World.Events.m.Events;
							for( local i = 0; i < events.len(); i = ++i )
							{
								if (events[i].getID() == "event.twitch_train_player")
								{
									eventToFire = events[i];
									eventToFire.m.Name = name;
									eventToFire.m.MA = MA;
									eventToFire.m.MD = MD;
									eventToFire.m.RA = RA;
									eventToFire.m.RD = RD;
									eventToFire.m.II = II;
									eventToFire.m.FF = FF;
									eventToFire.m.HP = HP;
									eventToFire.m.BR = BR;
								}
							}
							if (eventToFire != null)
							this.World.Events.fire(eventToFire.getID() "event.twitch_train_player");
							lastevent = lastevent_time;
					}
				}
			}
			//twitch/!craft name
			local e = scriptFile.find("twitch/!craft ", 0);
			if (e!=null)
			{
				this.logDebug("Twitch File: "+scriptFile);
				local name = "" + scriptFile;
				name = replace(name, "twitch/!craft ", "");
				if (name.len() > 0)
				{
					local found = 0;
					local roster = this.World.getPlayerRoster();
					local bros = roster.getAll();          
						foreach( bro in bros )
						{
							if (bro.getNameOnly() == name)
							{
								found = 1;
							}
						}
					//if (found == 1)
					{
					local type1 = Math.rand(0, 3);
					local type = "named_weapons";
						if (type1 == 0)type = "named_armors";
						if (type1 == 1)type = "named_helmets";
						if (type1 == 2)type = "named_weapons";
						if (type1 == 3)type = "named_shields";
					local file = purgedFiles[type][this.Math.rand(0, purgedFiles[type].len() - 1)];
					local asset = this.new(file);
					local pref = "";
					local nm = "";
					local suf = "";
					if (asset.m.PrefixList.len()!=0)pref = asset.m.PrefixList[this.Math.rand(0, asset.m.PrefixList.len() - 1)];
					if (asset.m.NameList.len()!=0)nm = asset.m.NameList[this.Math.rand(0, asset.m.NameList.len() - 1)];
					if (asset.m.SuffixList.len()!=0)suf = asset.m.SuffixList[this.Math.rand(0, asset.m.SuffixList.len() - 1)];
					asset.m.Name = pref + " " + name + " " + nm + " " + suf;
					this.World.Assets.getStash().add(asset);
						
							local eventToFire;
							local events = this.World.Events.m.Events;
							for( local i = 0; i < events.len(); i = ++i )
							{
								if (events[i].getID() == "event.twitch_add_item")
								{
									eventToFire = events[i];
									eventToFire.m.Name = name;
									eventToFire.m.Name2 = pref + " " + nm + " " + suf;
									eventToFire.m.Icon = "ui/items/" + asset.getIcon();
								}
							}
							if (eventToFire != null)
							this.World.Events.fire(eventToFire.getID() "event.twitch_add_item");
							lastevent = lastevent_time;
					}
				}
			}
			//twitch/!craftw name
			local e = scriptFile.find("twitch/!craftw ", 0);
			if (e!=null)
			{
				this.logDebug("Twitch File: "+scriptFile);
				local name = "" + scriptFile;
				name = replace(name, "twitch/!craftw ", "");
				if (name.len() > 0)
				{
					local found = 0;
					local roster = this.World.getPlayerRoster();
					local bros = roster.getAll();          
						foreach( bro in bros )
						{
							if (bro.getNameOnly() == name)
							{
								found = 1;
							}
						}
					//if (found == 1)
					{
					local type = "named_weapons";
					local file = purgedFiles[type][this.Math.rand(0, purgedFiles[type].len() - 1)];
					local asset = this.new(file);
					local pref = "";
					local nm = "";
					local suf = "";
					if (asset.m.PrefixList.len()!=0)pref = asset.m.PrefixList[this.Math.rand(0, asset.m.PrefixList.len() - 1)];
					if (asset.m.NameList.len()!=0)nm = asset.m.NameList[this.Math.rand(0, asset.m.NameList.len() - 1)];
					if (asset.m.SuffixList.len()!=0)suf = asset.m.SuffixList[this.Math.rand(0, asset.m.SuffixList.len() - 1)];
					asset.m.Name = pref + " " + name + " " + nm + " " + suf;
					this.World.Assets.getStash().add(asset);
						
							local eventToFire;
							local events = this.World.Events.m.Events;
							for( local i = 0; i < events.len(); i = ++i )
							{
								if (events[i].getID() == "event.twitch_add_item")
								{
									eventToFire = events[i];
									eventToFire.m.Name = name;
									eventToFire.m.Name2 = pref + " " + nm + " " + suf;
									eventToFire.m.Icon = "ui/items/" + asset.getIcon();
								}
							}
							if (eventToFire != null)
							this.World.Events.fire(eventToFire.getID() "event.twitch_add_item");
							lastevent = lastevent_time;
					}
				}
			}
			//twitch/!crafta name
			local e = scriptFile.find("twitch/!crafta ", 0);
			if (e!=null)
			{
				this.logDebug("Twitch File: "+scriptFile);
				local name = "" + scriptFile;
				name = replace(name, "twitch/!crafta ", "");
				if (name.len() > 0)
				{
					local found = 0;
					local roster = this.World.getPlayerRoster();
					local bros = roster.getAll();          
						foreach( bro in bros )
						{
							if (bro.getNameOnly() == name)
							{
								found = 1;
							}
						}
					//if (found == 1)
					{
					local type = "named_armors";
					local file = purgedFiles[type][this.Math.rand(0, purgedFiles[type].len() - 1)];
					local asset = this.new(file);
					local pref = "";
					local nm = "";
					local suf = "";
					if (asset.m.PrefixList.len()!=0)pref = asset.m.PrefixList[this.Math.rand(0, asset.m.PrefixList.len() - 1)];
					if (asset.m.NameList.len()!=0)nm = asset.m.NameList[this.Math.rand(0, asset.m.NameList.len() - 1)];
					if (asset.m.SuffixList.len()!=0)suf = asset.m.SuffixList[this.Math.rand(0, asset.m.SuffixList.len() - 1)];
					asset.m.Name = pref + " " + name + " " + nm + " " + suf;
					this.World.Assets.getStash().add(asset);
						
							local eventToFire;
							local events = this.World.Events.m.Events;
							for( local i = 0; i < events.len(); i = ++i )
							{
								if (events[i].getID() == "event.twitch_add_item")
								{
									eventToFire = events[i];
									eventToFire.m.Name = name;
									eventToFire.m.Name2 = pref + " " + nm + " " + suf;
									eventToFire.m.Icon = "ui/items/" + asset.getIcon();
								}
							}
							if (eventToFire != null)
							this.World.Events.fire(eventToFire.getID() "event.twitch_add_item");
							lastevent = lastevent_time;
					}
				}
			}
			//twitch/!crafth name
			local e = scriptFile.find("twitch/!crafth ", 0);
			if (e!=null)
			{
				this.logDebug("Twitch File: "+scriptFile);
				local name = "" + scriptFile;
				name = replace(name, "twitch/!crafth ", "");
				if (name.len() > 0)
				{
					local found = 0;
					local roster = this.World.getPlayerRoster();
					local bros = roster.getAll();          
						foreach( bro in bros )
						{
							if (bro.getNameOnly() == name)
							{
								found = 1;
							}
						}
					//if (found == 1)
					{
					local type = "named_helmets";
					local file = purgedFiles[type][this.Math.rand(0, purgedFiles[type].len() - 1)];
					local asset = this.new(file);
					local pref = "";
					local nm = "";
					local suf = "";
					if (asset.m.PrefixList.len()!=0)pref = asset.m.PrefixList[this.Math.rand(0, asset.m.PrefixList.len() - 1)];
					if (asset.m.NameList.len()!=0)nm = asset.m.NameList[this.Math.rand(0, asset.m.NameList.len() - 1)];
					if (asset.m.SuffixList.len()!=0)suf = asset.m.SuffixList[this.Math.rand(0, asset.m.SuffixList.len() - 1)];
					asset.m.Name = pref + " " + name + " " + nm + " " + suf;
					this.World.Assets.getStash().add(asset);
						
							local eventToFire;
							local events = this.World.Events.m.Events;
							for( local i = 0; i < events.len(); i = ++i )
							{
								if (events[i].getID() == "event.twitch_add_item")
								{
									eventToFire = events[i];
									eventToFire.m.Name = name;
									eventToFire.m.Name2 = pref + " " + nm + " " + suf;
									eventToFire.m.Icon = "ui/items/" + asset.getIcon();
								}
							}
							if (eventToFire != null)
							this.World.Events.fire(eventToFire.getID() "event.twitch_add_item");
							lastevent = lastevent_time;
					}
				}
			}
			//twitch/!crafts name
			local e = scriptFile.find("twitch/!crafts ", 0);
			if (e!=null)
			{
				this.logDebug("Twitch File: "+scriptFile);
				local name = "" + scriptFile;
				name = replace(name, "twitch/!crafts ", "");
				if (name.len() > 0)
				{
					local found = 0;
					local roster = this.World.getPlayerRoster();
					local bros = roster.getAll();          
						foreach( bro in bros )
						{
							if (bro.getNameOnly() == name)
							{
								found = 1;
							}
						}
					//if (found == 1)
					{
					local type = "named_shields";
					local file = purgedFiles[type][this.Math.rand(0, purgedFiles[type].len() - 1)];
					local asset = this.new(file);
					local pref = "";
					local nm = "";
					local suf = "";
					if (asset.m.PrefixList.len()!=0)pref = asset.m.PrefixList[this.Math.rand(0, asset.m.PrefixList.len() - 1)];
					if (asset.m.NameList.len()!=0)nm = asset.m.NameList[this.Math.rand(0, asset.m.NameList.len() - 1)];
					if (asset.m.SuffixList.len()!=0)suf = asset.m.SuffixList[this.Math.rand(0, asset.m.SuffixList.len() - 1)];
					asset.m.Name = pref + " " + name + " " + nm + " " + suf;
					this.World.Assets.getStash().add(asset);
						
							local eventToFire;
							local events = this.World.Events.m.Events;
							for( local i = 0; i < events.len(); i = ++i )
							{
								if (events[i].getID() == "event.twitch_add_item")
								{
									eventToFire = events[i];
									eventToFire.m.Name = name;
									eventToFire.m.Name2 = pref + " " + nm + " " + suf;
									eventToFire.m.Icon = "ui/items/" + asset.getIcon();
								}
							}
							if (eventToFire != null)
							this.World.Events.fire(eventToFire.getID() "event.twitch_add_item");
							lastevent = lastevent_time;
					}
				}
			}
			//twitch/!craftm name
			local e = scriptFile.find("twitch/!craftm ", 0);
			if (e!=null)
			{
				this.logDebug("Twitch File: "+scriptFile);
				local name = "" + scriptFile;
				name = replace(name, "twitch/!craftm ", "");
				if (name.len() > 0)
				{
					local found = 0;
					local roster = this.World.getPlayerRoster();
					local bros = roster.getAll();          
						foreach( bro in bros )
						{
							if (bro.getNameOnly() == name)
							{
								found = 1;
							}
						}
					//if (found == 1)
					{
					local asset = this.new("scripts/items/big_named_polemace");
					//local pref = "";
					//local nm = "";
					//local suf = "";
					//if (asset.m.PrefixList.len()!=0)pref = asset.m.PrefixList[this.Math.rand(0, asset.m.PrefixList.len() - 1)];
					//if (asset.m.NameList.len()!=0)nm = asset.m.NameList[this.Math.rand(0, asset.m.NameList.len() - 1)];
					//if (asset.m.SuffixList.len()!=0)suf = asset.m.SuffixList[this.Math.rand(0, asset.m.SuffixList.len() - 1)];
					//asset.m.Name = pref + " " + name + " " + nm + " " + suf;
					asset.m.Name = name + " Big Dick";
					this.World.Assets.getStash().add(asset);
						
							local eventToFire;
							local events = this.World.Events.m.Events;
							for( local i = 0; i < events.len(); i = ++i )
							{
								if (events[i].getID() == "event.twitch_add_item_meme")
								{
									eventToFire = events[i];
									eventToFire.m.Name = name;
									//eventToFire.m.Name2 = pref + " " + nm + " " + suf;
									eventToFire.m.Name2 = "Big Dick";
									eventToFire.m.Icon = "ui/items/" + asset.getIcon();
								}
							}
							if (eventToFire != null)
							this.World.Events.fire(eventToFire.getID() "event.twitch_add_item_meme");
							lastevent = lastevent_time;
					}
				}
			}
			//twitch/!perk name
			local e = scriptFile.find("twitch/!perk ", 0);
			if (e!=null)
			{
				this.logDebug("Twitch File: "+scriptFile);
				local name = "" + scriptFile;
				name = replace(name, "twitch/!perk ", "");
				if (name.len() > 0)
				{
					local trait = gt.tnf_debug.positiveTraits[this.Math.rand(0, gt.tnf_debug.positiveTraits.len() - 1)];
					if (Math.rand(0, 1) == 1)
					trait = gt.tnf_debug.negativeTraits[this.Math.rand(0, gt.tnf_debug.negativeTraits.len() - 1)];
					local the_trait = this.new("scripts/skills/traits/" + trait + "_trait");
					local found = 0;
					local roster = this.World.getPlayerRoster();
					local bros = roster.getAll();          
						foreach( bro in bros )
						{
							if (bro.getNameOnly() == name)
							{
								found = 1;
								bro.getSkills().add(the_trait);
							}
						}
					if (found == 1)
					{
							local eventToFire;
							local events = this.World.Events.m.Events;
							for( local i = 0; i < events.len(); i = ++i )
							{
								if (events[i].getID() == "event.twitch_add_perk")
								{
									eventToFire = events[i];
									eventToFire.m.Name = name;
									eventToFire.m.Name2 = the_trait.m.Name;
									eventToFire.m.Icon = the_trait.m.Icon;
								}
							}
							if (eventToFire != null)
							this.World.Events.fire(eventToFire.getID() "event.twitch_add_perk");
							lastevent = lastevent_time;
					}
				}
			}
			//twitch/!schange name
			local e = scriptFile.find("twitch/!schange ", 0);
			if (e!=null)
			{
				this.logDebug("Twitch File: "+scriptFile);
				local name = "" + scriptFile;
				name = replace(name, "twitch/!schange ", "");
				if (name.len() > 0)
				{
					local found = 0;
					local roster = this.World.getPlayerRoster();
					local bros = roster.getAll();          
					foreach( bro in bros )
					{
						if (bro.getNameOnly() == name)
						{
							found = 1;
						}
					}
					if (found == 1)
					{
							local eventToFire;
							local events = this.World.Events.m.Events;
							for( local i = 0; i < events.len(); i = ++i )
							{
								if (events[i].getID() == "event.twitch_schange")
								{
									eventToFire = events[i];
									eventToFire.m.Name = name;
								}
							}
							if (eventToFire != null)
							this.World.Events.fire(eventToFire.getID() "event.twitch_schange");
							lastevent = lastevent_time;
					}
				}
			}
			//twitch/!craid
			local e = scriptFile.find("twitch/!craid", 0);
			if (e!=null)
			{
				this.logDebug("Twitch File: "+scriptFile);
				gt.tnf_debug.raiders = [];
			}
			//twitch/!raid name
			local e = scriptFile.find("twitch/!raid ", 0);
			if (e!=null)
			{
				this.logDebug("Twitch File: "+scriptFile);
				local name = "" + scriptFile;
				name = replace(name, "twitch/!raid ", "");
				if (name.len() > 0)
				{
					local found = 0;
					foreach( raider in gt.tnf_debug.raiders )
					{
						if (raider == name)
						{
							found = 1;
						}
					}
					if (found == 0)gt.tnf_debug.raiders.push(name);
				}
			}
			//twitch/!sraid
			local e = scriptFile.find("twitch/!sraid", 0);
			if (e!=null)
			{
				this.logDebug("Twitch File: "+scriptFile);
				
				if (gt.tnf_debug.raiders.len() > 0)
				{
					local eventToFire;
					local events = this.World.Events.m.Events;
					for( local i = 0; i < events.len(); i = ++i )
					{
						if (events[i].getID() == "event.twitch_raid")
						{
							eventToFire = events[i];
						}
					}
					if (eventToFire != null)
					this.World.Events.fire(eventToFire.getID() "event.twitch_raid");
					lastevent = lastevent_time;
				}
			}
			//twitch/!boss
			local e = scriptFile.find("twitch/!boss ", 0);
			if (e!=null)
			{
				this.logDebug("Twitch File: "+scriptFile);
				local name = "" + scriptFile;
				name = replace(name, "twitch/!boss ", "");
				if (name.len() > 0)
				{	
					local eventToFire;
					local events = this.World.Events.m.Events;
					for( local i = 0; i < events.len(); i = ++i )
					{
						if (events[i].getID() == "event.twitch_boss")
						{
							eventToFire = events[i];
							eventToFire.m.Name = name;
							gt.tnf_debug.BossName = name;
							eventToFire.m.ptype = this.Math.rand(0, 5);
							eventToFire.m.diff = gt.tnf_debug.calc_diff();
						}
					}
					if (eventToFire != null)
					this.World.Events.fire(eventToFire.getID() "event.twitch_boss");
					lastevent = lastevent_time;
				}
			}
			//twitch/!bossX
			for( local xxx = 0; xxx <= 5; xxx = ++xxx )
			{
				local e = scriptFile.find("twitch/!boss" + xxx + " ", 0);
				if (e!=null)
				{
					this.logDebug("Twitch File: "+scriptFile);
					local name = "" + scriptFile;
					name = replace(name, "twitch/!boss" + xxx + " ", "");
					if (name.len() > 0)
					{
						local eventToFire;
						local events = this.World.Events.m.Events;
						for( local i = 0; i < events.len(); i = ++i )
						{
							if (events[i].getID() == "event.twitch_boss")
							{
								eventToFire = events[i];
								eventToFire.m.Name = name;
								gt.tnf_debug.BossName = name;
								eventToFire.m.ptype = xxx;
								eventToFire.m.diff = gt.tnf_debug.calc_diff();
							}
						}
						if (eventToFire != null)
						this.World.Events.fire(eventToFire.getID() "event.twitch_boss");
						lastevent = lastevent_time;
					}
				}
			}
			//twitch/!sbossX
			for( local xxx = 0; xxx <= 8; xxx = ++xxx )
			{
				local e = scriptFile.find("twitch/!sboss" + xxx, 0);
				if (e!=null)
				{
					this.logDebug("Twitch File: "+scriptFile);
					
						local eventToFire;
						local events = this.World.Events.m.Events;
						for( local i = 0; i < events.len(); i = ++i )
						{
							if (events[i].getID() == "event.twitch_secret_boss")
							{
								eventToFire = events[i];
								eventToFire.m.ptype = xxx;
								eventToFire.m.diff = gt.tnf_debug.calc_diff();
							}
						}
						if (eventToFire != null)
						this.World.Events.fire(eventToFire.getID() "event.twitch_secret_boss");
						lastevent = lastevent_time;
				}
			}
			//twitch/!duel1
			local e = scriptFile.find("twitch/!duel1 ", 0);
			if (e!=null)
			{
				//this.logDebug("Twitch File: "+scriptFile);
				local name = "" + scriptFile;
				name = replace(name, "twitch/!duel1 ", "");
				if (name.len() > 0)
				{
					foreach( scriptFile2 in scriptFiles )
					{
						//twitch/!duel2
						local e2 = scriptFile2.find("twitch/!duel2 ", 0);
						if (e2!=null)
						{
							this.logDebug("Twitch File: "+scriptFile);
							this.logDebug("Twitch File: "+scriptFile2);
							local name2 = "" + scriptFile2;
							name2 = replace(name2, "twitch/!duel2 ", "");
							if (name2.len() > 0)
							{
								local found = 0;
								local found2 = 0;
								local roster = this.World.getPlayerRoster();
								local bros = roster.getAll();          
									foreach( bro in bros )
									{
										if (bro.getNameOnly() == name)
										{
											found = 1;
										}
										if (bro.getNameOnly() == name2)
										{
											found2 = 1;
										}
									}
							if ((found == 1) && (found2 == 1))
							{
								local eventToFire;
								local events = this.World.Events.m.Events;
								for( local i = 0; i < events.len(); i = ++i )
								{
									if (events[i].getID() == "event.twitch_duel")
									{
										eventToFire = events[i];
										eventToFire.m.Name = name;
										eventToFire.m.Name2 = name2;
									}
								}
								if (eventToFire != null)
								this.World.Events.fire(eventToFire.getID() "event.twitch_duel");
								
								lastevent = lastevent_time;
								break;
							}
						}
					}
					}
				}
			}
			//twitch/!pot name
			local e = scriptFile.find("twitch/!pot ", 0);
			if (e!=null)
			{
				this.logDebug("Twitch File: "+scriptFile);
				local name = "" + scriptFile;
				name = replace(name, "twitch/!pot ", "");
				if (name.len() > 0)
				{
					local found = 0;
					local roster = this.World.getPlayerRoster();
					local bros = roster.getAll();          
					foreach( bro in bros )
					{
						if (bro.getNameOnly() == name)
						{
							found = 1;
						}
					}
					if (found == 1)
					{
							local eventToFire;
							local events = this.World.Events.m.Events;
							for( local i = 0; i < events.len(); i = ++i )
							{
								if (events[i].getID() == "event.twitch_pot")
								{
									eventToFire = events[i];
									eventToFire.m.Name = name;
								}
							}
							if (eventToFire != null)
							this.World.Events.fire(eventToFire.getID() "event.twitch_pot");
							lastevent = lastevent_time;
					}
				}
			}
			
			//twitch/!event
			if (scriptFile == "twitch/!event")
			{
							//this.logDebug("Twitch File: "+scriptFile);
							
							local score = 0;
							local eventToFire;
							local events = this.World.Events.m.Events;
							
							for( local i = 0; i < events.len(); i = ++i )
							{
								events[i].clear();
								events[i].update();
							    //events[i].onClear();
							    //events[i].onUpdateScore();
								score = score + events[i].getScore();
							}
							
							local pick = this.Math.rand(1, score);
							//this.logInfo(pick);
							
							for( local i = 0; i < events.len(); i = ++i )
							{
								if (
									(events[i].getID() != "event.hidden_cache_forest")&&
									(events[i].getID() != "event.beat_up_old_man")&&
									(events[i].getID() != "event.drunk_nobleman")&&
									(events[i].getID() != "event.wild_dog_sounds_event")&&
									(events[i].getID() != "event.alp_nightmare1_event")
								)
								{
							  if (events[i].getScore() > 0) //this.logInfo(events[i].getID() + events[i].getScore());
							  {
								  if (pick <= events[i].getScore())
								  {
									eventToFire = events[i];
									//this.logInfo(eventToFire.getID());
									break;
								  }
								  pick = pick - events[i].getScore();
								  }
							  }
							}
							if (eventToFire == null)
							{
							  this.logDebug("tnf_debugMode | The pool of possible events has been emptied. No event left to fire!");
							}
							else
							{
								this.World.Events.fire(eventToFire.getID());
							}
							this.logDebug("Twitch File: "+scriptFile);
							lastevent = lastevent_time;
							
			}

			}
			}
			}
			}
			
		}
	}
	
}



q.helper_handleContextualKeyInput = @(__original) function(_key) 
{
  /* keyHandler(_key) will always return true in char screen */
  if (!this.isInCharacterScreen()) {if (__original(_key)) return;}  
  if (_key.getState() != 0) return; //key pressed and released
  
  if (_key.getKey() == 14 && _key.getModifier() == 2) //CTRL + D
  {
    IsDebugModeEnabled = !IsDebugModeEnabled;
    if (IsDebugModeEnabled)
    {
      this.logDebug("tnf_debugMode | *** DEBUG MODE ENABLED ***");
    }
    else
    {
      this.logDebug("tnf_debugMode | *** DEBUG MODE DISABLED ***");
    }
    return;
  }
  
  if (this.isInCharacterScreen())
  {
    switch(_key.getKey()) {
    
      // DEFAULT HOTKEYS //
      
			case 11:
			case 48:
				this.m.CharacterScreen.switchToPreviousBrother();
				break;

			case 38:
			case 14:
			case 50:
				this.m.CharacterScreen.switchToNextBrother();
				break;

			case 19:
			case 13:
			case 41:
				this.toggleCharacterScreen();
				break;
    }
  }
  
  if (!IsDebugModeEnabled) return;
  
  //------------------//
  // CHARACTER SCREEN //
  //------------------//
  
  if (this.isInCharacterScreen())
  {
    switch(_key.getKey()) {
    
      // HOTKEYS USED: A, C, D, I //
      
      case 12: //B for BODY ARMOR (Named)
        local type = "named_armors";
        local file = purgedFiles[type][this.Math.rand(0, purgedFiles[type].len() - 1)];
        this.World.Assets.getStash().add(this.new(file));
        this.m.CharacterScreen.loadStashList();
        return;
        
      case 15: //E for ELIXIRS
        this.World.Assets.getStash().add(this.new("scripts/items/accessory/antidote_item"));
        this.World.Assets.getStash().add(this.new("scripts/items/accessory/cat_potion_item"));
        this.World.Assets.getStash().add(this.new("scripts/items/accessory/iron_will_potion_item"));
        this.World.Assets.getStash().add(this.new("scripts/items/accessory/lionheart_potion_item"));
        this.World.Assets.getStash().add(this.new("scripts/items/accessory/night_vision_elixir_item"));
        this.World.Assets.getStash().add(this.new("scripts/items/accessory/recovery_potion_item"));
        this.World.Assets.getStash().add(this.new("scripts/items/accessory/spider_poison_item"));
        this.World.Assets.getStash().add(this.new("scripts/items/misc/potion_of_knowledge_item"));
        this.World.Assets.getStash().add(this.new("scripts/items/tools/acid_flask_item"));
        this.World.Assets.getStash().add(this.new("scripts/items/tools/holy_water_item"));
        this.m.CharacterScreen.loadStashList();
        return;        
        
      case 16: //F for FOOD
        this.World.Assets.getStash().add(this.new("scripts/items/supplies/fermented_unhold_heart_item"));
        this.m.CharacterScreen.loadStashList();
        return;
        
      case 17: //G for GIFTED (Super)
        if (this.m.CharacterScreen.m.JSDataSourceHandle != null)
        {
          this.m.CharacterScreen.m.JSDataSourceHandle.asyncCall("tnf_giveActiveCharacter", "Stats");
        }
        this.m.CharacterScreen.loadBrothersList();
        return;
        
      case 18: //H for HEAD ARMOR (Named)
        local type = "named_helmets";
        local file = purgedFiles[type][this.Math.rand(0, purgedFiles[type].len() - 1)];
        this.World.Assets.getStash().add(this.new(file));
        this.m.CharacterScreen.loadStashList();
        return;
        
      case 20: //J for JUNK
      local inventory = this.World.Assets.getStash().getItems();
      for (local slot = inventory.len() - 1; slot != 0; slot--)
      {
        if (inventory[slot] == null) continue;
        this.World.Assets.getStash().removeByIndex(slot);
        break;
      }
      this.m.CharacterScreen.loadStashList();
      return;
      
      case 22: //L for LEVEL
        if (this.m.CharacterScreen.m.JSDataSourceHandle != null)
        {
          this.m.CharacterScreen.m.JSDataSourceHandle.asyncCall("tnf_giveActiveCharacter", "Level");
        }
        this.m.CharacterScreen.loadBrothersList();
        return;
        
      case 23: //M for MULE
        this.World.Assets.getStash().resize(this.World.Assets.getStash().getCapacity() + 9);
        this.m.CharacterScreen.loadData();
        return;
      
      case 24: //N for NECKLACES
        this.World.Assets.getStash().add(this.new("scripts/items/accessory/goblin_trophy_item"));
        this.World.Assets.getStash().add(this.new("scripts/items/accessory/orc_trophy_item"));
        this.World.Assets.getStash().add(this.new("scripts/items/accessory/sergeant_badge_item"));
        this.World.Assets.getStash().add(this.new("scripts/items/accessory/undead_trophy_item"));
        this.m.CharacterScreen.loadStashList();
        return;
        
      case 25: //O for OBLIVION
		if (_key.getModifier() == 1)
			this.World.Assets.getStash().add(this.new("scripts/items/diff_tester"));
		else
			this.World.Assets.getStash().add(this.new("scripts/items/misc/potion_of_oblivion_item"));
        this.m.CharacterScreen.loadStashList();
        return;
        
      case 26: //P for PERK
        if (this.m.CharacterScreen.m.JSDataSourceHandle != null)
        {
          this.m.CharacterScreen.m.JSDataSourceHandle.asyncCall("tnf_giveActiveCharacter", "Perk");
        }
        this.m.CharacterScreen.loadBrothersList();
        return;
        
      case 27: //Q for QUIT TRAIT
        if (this.m.CharacterScreen.m.JSDataSourceHandle != null)
        {
          this.m.CharacterScreen.m.JSDataSourceHandle.asyncCall("tnf_giveActiveCharacter", "RTrait");
        }
        this.m.CharacterScreen.loadBrothersList();
        return;
        
      case 28: //R for REPAIR
        local inventory = this.World.Assets.getStash().getItems();
        local roster = this.World.getPlayerRoster().getAll();
        foreach (item in inventory)
        {
          if (item == null) continue;
          if (item.getCondition() < item.getConditionMax()) item.setCondition(item.getConditionMax());
        }
        foreach(bro in roster)
        {
          foreach (item in bro.getItems().getAllItems())
          {
            if (item.getCondition() < item.getConditionMax()) item.setCondition(item.getConditionMax());
            if (item.isItemType(this.Const.Items.ItemType.Ammo) && item.getAmmo() < item.getAmmoMax())
              item.setAmmo(item.getAmmoMax());
          }
        }
        this.m.CharacterScreen.loadData();
        return;
        
      case 29: //S for SHIELD (Named)
        local type = "named_shields";
        local file = purgedFiles[type][this.Math.rand(0, purgedFiles[type].len() - 1)];
        this.World.Assets.getStash().add(this.new(file));
        this.m.CharacterScreen.loadStashList();
        return;
        
      case 30: //T for TRAIT
		local kmod = _key.getModifier();
		if (kmod == 0)
		{
			if (this.m.CharacterScreen.m.JSDataSourceHandle != null)
			{
			  this.m.CharacterScreen.m.JSDataSourceHandle.asyncCall("tnf_giveActiveCharacter", "Trait");
			}
			this.m.CharacterScreen.loadBrothersList();
		}
		if (kmod == 1)
		{
			if (this.m.CharacterScreen.m.JSDataSourceHandle != null)
			{
			  this.m.CharacterScreen.m.JSDataSourceHandle.asyncCall("tnf_giveActiveCharacter", "TraitB");
			}
			this.m.CharacterScreen.loadBrothersList();
		}
		if (kmod == 2)
		{
			if (this.m.CharacterScreen.m.JSDataSourceHandle != null)
			{
			  this.m.CharacterScreen.m.JSDataSourceHandle.asyncCall("tnf_giveActiveCharacter", "Dumb");
			}
			this.m.CharacterScreen.loadBrothersList();
		}
		if (kmod == 4)
		{
			if (this.m.CharacterScreen.m.JSDataSourceHandle != null)
			{
			  this.m.CharacterScreen.m.JSDataSourceHandle.asyncCall("tnf_giveActiveCharacter", "Cult");
			}
			this.m.CharacterScreen.loadBrothersList();
		}
        return;
      
      case 31: //U for UPGRADES
        this.World.Assets.getStash().add(this.new("scripts/items/armor_upgrades/additional_padding_upgrade"));
        this.World.Assets.getStash().add(this.new("scripts/items/armor_upgrades/bone_platings_upgrade"));
        this.World.Assets.getStash().add(this.new("scripts/items/armor_upgrades/direwolf_pelt_upgrade"));
        this.World.Assets.getStash().add(this.new("scripts/items/armor_upgrades/light_padding_replacement_upgrade"));
        this.World.Assets.getStash().add(this.new("scripts/items/armor_upgrades/lindwurm_scales_upgrade"));
        this.World.Assets.getStash().add(this.new("scripts/items/armor_upgrades/protective_runes_upgrade"));
        this.World.Assets.getStash().add(this.new("scripts/items/armor_upgrades/unhold_fur_upgrade"));
        this.World.Assets.getStash().add(this.new("scripts/items/misc/wardog_heavy_armor_upgrade_item"));
        this.m.CharacterScreen.loadStashList();
        return;
        
      case 32: //V for VIGOR & VITALITY
        local playerRoster = this.World.getPlayerRoster().getAll();
        if (this.m.CharacterScreen.m.JSDataSourceHandle != null)
        {
          this.m.CharacterScreen.m.JSDataSourceHandle.asyncCall("tnf_giveActiveCharacter", "Heal");
		  this.m.CharacterScreen.m.JSDataSourceHandle.asyncCall("tnf_giveActiveCharacter", "Sex");
        }
        this.m.CharacterScreen.loadBrothersList();
        return;
        
      case 33: //W for WEAPON (Named)
        local type = "named_weapons";
        local file = purgedFiles[type][this.Math.rand(0, purgedFiles[type].len() - 1)];
        this.World.Assets.getStash().add(this.new(file));
		//local asset = this.new(file);
		//local pref = "";
		//local nm = "";
		//local suf = "";
		//if (asset.m.PrefixList.len()!=0)pref = asset.m.PrefixList[this.Math.rand(0, asset.m.PrefixList.len() - 1)];
		//if (asset.m.NameList.len()!=0)nm = asset.m.NameList[this.Math.rand(0, asset.m.NameList.len() - 1)];
		//if (asset.m.SuffixList.len()!=0)suf = asset.m.SuffixList[this.Math.rand(0, asset.m.SuffixList.len() - 1)];
		//asset.m.Name = pref+ " " + "ed_gorod" + " " + nm + " " + suf;
		//this.World.Assets.getStash().add(asset);
        this.m.CharacterScreen.loadStashList();
        return;
        
      case 36: //Z for ZERO
        local backgrounds = clone purgedFiles.backgrounds;
        function slice(string) {return string.slice(gt.tnf_debug.directories.backgrounds.len());}
        backgrounds.apply(slice); //file name
        
        local roster = this.World.getPlayerRoster();
        local bros = roster.getAll();          
        if (bros.len() >= this.World.Assets.m.BrothersMax) return;
        
        local bro = roster.create("scripts/entity/tactical/player");
        bro.m.HireTime = this.Time.getVirtualTimeF();
        bro.setName(this.Const.Strings.CharacterNames[this.Math.rand(0, this.Const.Strings.CharacterNames.len() - 1)]);
        bro.setStartValuesEx(backgrounds); //array of backgrounds
        bro.getBackground().buildDescription(true);
        bro.m.Attributes = [];
        bro.fillAttributeLevelUpValues(this.Const.XP.MaxLevelWithPerkpoints - 1);
        bro.getSkills().update();
        this.World.Assets.updateFormation();
        this.m.CharacterScreen.loadBrothersList();
        return;        
    }
  }

  //-----------//
  // WORLD MAP //
  //-----------//
  
  /* No default hotkey for this key, key pressed and released and not in a menu */
  if(!this.m.MenuStack.hasBacksteps())
  {
    switch (_key.getKey()) {
    
      //WORLD SPEED SETTINGS//      
      case 3:
        this.setPause(false);
				this.World.setSpeedMult(4.0);
        this.logDebug("tnf_debugMode | World Speed set to x4.0");
        return;
        
      case 4:
        this.setPause(false);
				this.World.setSpeedMult(8.0);
        this.logDebug("tnf_debugMode | World Speed set to x8.0");
        return;

      case 5:
        this.setPause(false);
				this.World.setSpeedMult(16.0);
        this.logDebug("tnf_debugMode | World Speed set to x16.0");
        return;

      case 6:
        this.setPause(false);
				this.World.setSpeedMult(32.0);
        this.logDebug("tnf_debugMode | World Speed set to x32.0");
        return;

      case 7:
        this.setPause(false);
				this.World.setSpeedMult(64.0);
        this.logDebug("tnf_debugMode | World Speed set to x64.0");
        return;

      case 8:
        this.setPause(false);
				this.World.setSpeedMult(128.0);
        this.logDebug("tnf_debugMode | World Speed set to x128.0");
        return;

      case 9:
        this.setPause(false);
				this.World.setSpeedMult(256.0);
        this.logDebug("tnf_debugMode | World Speed set to x256.0");
        return;
        
      //case 11: //A (Movement FR)
      
      case 12: //B for BOX OF SUPPLIES
        local difficulty = this.World.Assets.getEconomicDifficulty();
        local maxResources = gt.Const.Difficulty.MaxResources;
        this.World.Assets.m.ArmorParts = maxResources[difficulty].ArmorParts;
        this.World.Assets.m.Medicine = maxResources[difficulty].Medicine;
        this.World.Assets.m.Ammo = maxResources[difficulty].Ammo;
        this.updateTopbarAssets();
        return;
        
      //case 13: //C (CharacterScreen)
      //case 14: //D (right)

      case 15: //E for EVENT
        local score = 0;
        local eventToFire;
        local events = this.World.Events.m.Events;
        
        for( local i = 0; i < events.len(); i = ++i )
        {
			events[i].onClear();
            events[i].update();
            //events[i].onClear();
            //events[i].onUpdateScore();
            score = score + events[i].getScore();
        }
        
        local pick = this.Math.rand(1, score);
        //this.logInfo(pick);
        
        for( local i = 0; i < events.len(); i = ++i )
        {
		if (
			(events[i].getID() != "event.hidden_cache_forest")&&
			(events[i].getID() != "event.beat_up_old_man")&&
			(events[i].getID() != "event.drunk_nobleman")
		)
		  {
          //if (events[i].getScore() > 0) this.logInfo(events[i].getID() + events[i].getScore());
          if (pick <= events[i].getScore())
          {
            eventToFire = events[i];
            //this.logInfo(eventToFire.getID());
            break;
          }
          pick = pick - events[i].getScore();
		  }
        }
        if (eventToFire == null)
        {
          this.logDebug("tnf_debugMode | The pool of possible events has been emptied. No event left to fire!");
          return;
        }
		this.World.Events.fire(eventToFire.getID());
        return;

      //case 16: //F (Follow Tracks)

      case 17: //G for GLORY (Renown)
        this.World.Assets.addBusinessReputation(500);
        return;

      case 18: //H for HUNGRY OR NOT
        this.World.Assets.setConsumingAssets(!this.World.Assets.isConsumingAssets());
        if (this.World.Assets.isConsumingAssets())
        {
          this.logDebug("tnf_debugMode | Player is consuming assets.");
        }
        else
        {
          this.logDebug("tnf_debugMode | Player is NOT consuming assets.");
        }
        return;
        
      //case 19: //I (CharacterScreen)
      
      case 20: //J for JUMP
        if (this.m.LastTileHovered != null)
        {
          local tilePos = this.m.LastTileHovered.Pos;
          this.World.State.getPlayer().setPos(tilePos);
          this.World.setPlayerPos(tilePos);
        }
        return;

      case 21: //K for KILL
        if (this.m.LastEntityHovered != null)
        {
          local e = this.m.LastEntityHovered;
          if (e.isLocation())
          {
            if (e.m.LocationType == this.Const.World.LocationType.Settlement)
            {
              this.logDebug("tnf_debugMode | Settlement destroyed");
              e.destroy();
            }
            else if (e.m.LocationType == this.Const.World.LocationType.AttachedLocation)
            {
              this.logDebug("tnf_debugMode | Attached location destroyed");
              e.setActive(false);
            }
            else
            {
              this.logDebug("tnf_debugMode | Enemy location destroyed");
              e.onCombatLost();
            }
          }
          else
          {
            this.logDebug("tnf_debugMode | Party destroyed");
            e.onCombatLost();
          }
        }
        return;
      
      case 22: //L for LOVE (Relations)
        local factionTypes = {
          villages = this.World.FactionManager.getFactionsOfType(this.Const.FactionType.Settlement),
          nobleHouses = this.World.FactionManager.getFactionsOfType(this.Const.FactionType.NobleHouse)
        };
        local reason = "Used Vilain's debug mode with discretion";
        foreach(factionType, factions in factionTypes)
        {
          foreach(faction in factions) {faction.addPlayerRelation(10, reason);}
        }
        return;

      case 23: //M for MONEY
        this.World.Assets.addMoney(10000);
        this.updateTopbarAssets();
        return;
        
      case 24: //N for ENEMIES (Orcs)
        if (this.m.LastTileHovered != null)
        {
          local faction = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Orcs);
          local party = faction.spawnEntity(this.m.LastTileHovered, "Orc Marauders", false, this.Const.World.Spawn.OrcRaiders, 200);
          party.getSprite("banner").setBrush("banner_orcs_04");
          party.setDescription("A band of menacing orcs, greenskinned and towering any man.");
          local c = party.getController();
          local ambush = this.new("scripts/ai/world/orders/ambush_order");
          c.addOrder(ambush);
          return;
        }
        
      //case 25: //O (Obituary)
      //case 26: //P (Pause)
      //case 27: //Q (Movement FR)
      //case 28: //R (Relations screen)
      //case 29: //S (Movement)
      //case 30: //T (Camp)
      
      case 31: //U for UN-KILLABLE
        this.m.Player.setAttackable(!this.m.Player.isAttackable());
        if (this.m.Player.isAttackable())
        {
          this.logDebug("tnf_debugMode | Player can now be attacked.");
        }
        else
        {
          this.logDebug("tnf_debugMode | Player can NOT be attacked.");
        }
        return;
        
      case 32: //V for VELOCITY
        if (this.World.State.getPlayer().m.BaseMovementSpeed > 1000)
        {
          if (this.World.Assets.getOrigin().getID() == "scenario.rangers")
          {
            this.World.State.getPlayer().m.BaseMovementSpeed = 111;
          }
          else
          {
            this.World.State.getPlayer().m.BaseMovementSpeed = 105;
          }
          return;
        }
        this.World.State.getPlayer().m.BaseMovementSpeed *= 2;
        return;

      //case 33: //W (Movement)
      //case 34: //X (Lock camera)
        
      case 35: //Y for YMPORTANT YNFO
        gt.tnf_debug.logSeedFertility();
        return;
        
      //case 36: //Z (Movement FR)
      
      case 71: //F1 for FOG
        this.World.setFogOfWar(!this.World.isUsingFogOfWar());
        if (this.World.isUsingFogOfWar())
        {
          this.logDebug("tnf_debugMode | Fog Of War activated.");
        }
        else
        {
          this.logDebug("tnf_debugMode | Fog Of War deactivated.");
        }
        return;
      
      //case 75: //F5 (Quick save)
      //case 79: //F9 (Quick load)
    }
  }
}
});

::TwitchDebug.Hooks.hook("scripts/states/tactical_state", function (q){
q.updateCurrentEntity = @(__original) function() 
{
  __original();
  if (this.Time.getVirtualSpeed != virtualSpeed) this.Time.setVirtualSpeed(virtualSpeed);
}

q.helper_handleContextualKeyInput = @(__original) function(_key) 
{
  /* keyHandler(_key) will always return true in char screen */
  /* or if input is ignored (enemy turn) */
  
  if (!this.isInputLocked()) {if (__original(_key)) return;}
  if (_key.getState() != 0) return; //key pressed and released
  
  if (_key.getKey() == 14 && _key.getModifier() == 2) //CTRL + D
  {
    IsDebugModeEnabled = !IsDebugModeEnabled;
    if (IsDebugModeEnabled)
    {
      this.logDebug("tnf_debugMode | *** DEBUG MODE ENABLED ***");
    }
    else
    {
      this.logDebug("tnf_debugMode | *** DEBUG MODE DISABLED ***");
    }
    return;
  }
    
  if (!IsDebugModeEnabled || this.m.MenuStack.hasBacksteps()) return;

  local kkey = _key.getKey();
  local kmod = _key.getModifier();
  //this.logDebug("the KEY = " + kkey+" the MOD = " + kmod);
  switch (kkey) {
  
    //SPEED SETTINGS//
    case 71:
      virtualSpeed = 1.0;
      this.logDebug("tnf_debugMode | Virtual Speed set to x1.0");
      return;
    case 72:
      virtualSpeed = 2.0;
      this.logDebug("tnf_debugMode | Virtual Speed set to x2.0");
      return;
      
    case 73:
      virtualSpeed = 3.0;
      this.logDebug("tnf_debugMode | Virtual Speed set to x3.0");
      return;
      
    case 74:
      virtualSpeed = 4.0;
      this.logDebug("tnf_debugMode | Virtual Speed set to x4.0");
      return;

    case 75:
      virtualSpeed = 5.0;
      this.logDebug("tnf_debugMode | Virtual Speed set to x5.0");
      return;

    case 76:
      virtualSpeed = 6.0;
      this.logDebug("tnf_debugMode | Virtual Speed set to x6.0");
      return;

    case 77:
      virtualSpeed = 7.0;
      this.logDebug("tnf_debugMode | Virtual Speed set to x7.0");
      return;

    case 78:
      virtualSpeed = 8.0;
      this.logDebug("tnf_debugMode | Virtual Speed set to x8.0");
      return;

    case 79:
      virtualSpeed = 9.0;
      this.logDebug("tnf_debugMode | Virtual Speed set to x9.0");
      return;

    case 80:
      virtualSpeed = 10.0;
      this.logDebug("tnf_debugMode | Virtual Speed set to x10.0");
      return;

    case 81:
      virtualSpeed = 11.0;
      this.logDebug("tnf_debugMode | Virtual Speed set to x11.0");
      return;
      
    ///////////////////////////////////
    //  HOTKEYS TAKEN: C, F, I, R, T //
    //  MVT: AZQSDW                  //
    ///////////////////////////////////
    
    //case 12: //B (Blocked tiles)
    
    case 14: //D (Movement)
	return;

    case 15: //E for EXPLORE
      this.m.IsFogOfWarVisible = !this.m.IsFogOfWarVisible;
      if (this.m.IsFogOfWarVisible)
      {
        this.Tactical.fillVisibility(this.Const.Faction.Player, false);        
        local heroes = this.Tactical.Entities.getInstancesOfFaction(this.Const.Faction.Player);
        foreach (i, hero in heroes) hero.updateVisibilityForFaction();         
        local activeEntity = this.Tactical.TurnSequenceBar.getActiveEntity();
        if (activeEntity != null) activeEntity.updateVisibilityForFaction();
      }
      else {this.Tactical.fillVisibility(this.Const.Faction.Player, true);}
      return;
      
    case 17: //G for GREENSKIN
      if (this.m.LastTileHovered != null && this.m.LastTileHovered.IsEmpty)
			{
        local faction = ((kmod == 1) || (kmod == 4)) ? "Orcs" : "Goblins";
        local actor = gt.tnf_debug.getRandomActor(faction);
        local script = this.Const.World.Spawn.Troops[actor[1]].Script;
				local entity = this.Tactical.spawnEntity(script);
				if ((kmod == 2) || (kmod == 4))
					entity.setFaction(this.Const.Faction.PlayerAnimals)
				else
					entity.setFaction(this.World.FactionManager.getFactionOfType(this.Const.FactionType[faction]).getID());
				entity.assignRandomEquipment();
			}
      return;
      
    case 18: //H for HEAL
      local instances = this.Tactical.Entities.getAllInstancesAsArray();
      foreach (actor in instances)
      {
        if (actor.isAlive() && actor.isPlayerControlled())
        {
          actor.setHitpointsPct(1);
          actor.setActionPoints(9);
          actor.setFatigue(0);
          actor.setMoraleState(this.Const.MoraleState.Confident);
          local skills = actor.getSkills();
          skills.removeByType(this.Const.SkillType.Injury);
          foreach (effect in gt.tnf_debug.negativeStatusEffects)
          {
            if (!skills.hasSkill("effects." + effect)) continue;
            if (effect == "bleeding")
            {
              while (skills.hasSkill("effects.bleeding")) {skills.removeByID("effects.bleeding");}
              continue;
            }
            skills.removeByID("effects." + effect);
          }
          foreach(item in actor.getItems().getAllItems())
          {
            if (item.getCondition() < item.getConditionMax()) item.setCondition(item.getConditionMax());
            if (item.isItemType(this.Const.Items.ItemType.Ammo) && item.getAmmo() < item.getAmmoMax())
              item.setAmmo(item.getAmmoMax());
					}
          this.Tactical.TurnSequenceBar.updateEntity(actor.getID());
        }
      }
      return;
      
    case 20: //J for JUMP
      local tile = this.m.LastTileHovered;
      if (tile != null && tile.IsEmpty)
      {
        local entity = this.Tactical.TurnSequenceBar.getActiveEntity();
        this.Tactical.getNavigator().teleport(entity, tile, null, null, false, 0.0);
      }
      return;
      
    case 21: //K for KILL
      if (this.m.LastTileHovered != null && !this.m.LastTileHovered.IsEmpty)
      {
        local entity = this.m.LastTileHovered.getEntity();
        if (entity != null && this.isKindOf(entity, "actor"))
        {
          if (entity == this.Tactical.TurnSequenceBar.getActiveEntity()) {this.cancelEntityPath(entity);}
          entity.kill();
        }
      }
      return;
      
    case 22: //L for LEAVE
      //this.Tactical.Entities.makeAllHostilesRetreat();
      //this.Tactical.Entities.setLastCombatResult(this.Const.Tactical.CombatResult.EnemyRetreated);
      //this.Tactical.Entities.checkCombatFinished(true);
			//L for Nomads
	  if (this.m.LastTileHovered != null && this.m.LastTileHovered.IsEmpty)
			{
        local actor = gt.tnf_debug.getRandomActor("OrientalBandits");
        local script = this.Const.World.Spawn.Troops[actor[1]].Script;
				local entity = this.Tactical.spawnEntity(script);
				if (kmod == 1)
					entity.setFaction(this.Const.Faction.PlayerAnimals)
				else
					entity.setFaction(this.World.FactionManager.getFactionOfType(this.Const.FactionType.OrientalBandits).getID());
				entity.assignRandomEquipment();
			}
      return;
    
    case 23: //M for MONSTER   
      if (this.m.LastTileHovered != null && this.m.LastTileHovered.IsEmpty)
			{
        local actor = gt.tnf_debug.getRandomActor("Beasts");
		if (kmod == 2)actor = ["Beasts", "Lindwurm"];
		if (kmod == 4)actor = ["Beasts", "Hexe"];
        local script = this.Const.World.Spawn.Troops[actor[1]].Script;
				local entity = this.Tactical.spawnEntity(script);
				if (kmod == 1)
					entity.setFaction(this.Const.Faction.PlayerAnimals)
				else
					entity.setFaction(this.World.FactionManager.getFactionOfType(this.Const.FactionType.Beasts).getID());
				entity.assignRandomEquipment();
			}
      return;
    
    case 24: //N for NAMED CHAMPION
		if (this.m.LastTileHovered != null && this.m.LastTileHovered.IsEmpty)
		{
		  local actors = gt.Const.World.Spawn.Troops;
		  local champions = [];
		  foreach (actor, properties in actors)
		  {
			if (
			(properties.Variant > 0) 
			&& (properties.ID != this.Const.EntityType.Oathbringer)
			&& (properties.ID != this.Const.EntityType.Officer)
			&& (properties.ID != this.Const.EntityType.Executioner)
			&& (properties.ID != this.Const.EntityType.DesertDevil)
			&& (properties.ID != this.Const.EntityType.Gladiator)
			&& (properties.ID != this.Const.EntityType.DesertStalker)
			&& (properties.ID != this.Const.EntityType.NomadLeader)
			)
				champions.push([actor, properties]);
		  }
		  local champion = champions[this.Math.rand(0, champions.len() - 1)];
		  local name = gt.Const.World.Common.generateName(champion[1].NameList);
		  name += champion[1].TitleList != null ? " " + champion[1].TitleList[this.Math.rand(0, champion[1].TitleList.len() - 1)] : "";
		  local entity = this.Tactical.spawnEntity(champion[1].Script);
		  local faction = gt.tnf_debug.getActorFaction(champion[0]);
		  (faction == "Settlement" || faction == "NobleHouse") ? entity.setFaction(this.Const.Faction.Enemy): entity.setFaction(this.World.FactionManager.getFactionOfType(this.Const.FactionType[faction]).getID());
		  entity.setName(name);
		  entity.makeMiniboss();
		  entity.assignRandomEquipment();
		  if (kmod == 1)
			entity.setFaction(this.Const.Faction.PlayerAnimals);
	  }
      return;
      
    case 25: //O for OBLITERATE
	/*
      local factions = this.Tactical.Entities.m.Instances;
      for (local f = this.Const.Faction.Player + 1; f != factions.len(); f++)
      {
      	if (factions[f].len() != 0 && !this.World.FactionManager.isAlliedWithPlayer(f))
      	{
      		local instances = clone factions[f];      
      		foreach (e in instances) {e.kill();}
      	}
      }
      return;
	*/
	//O for UNDEAD ally
	  if (this.m.LastTileHovered != null && this.m.LastTileHovered.IsEmpty)
			{
		local faction = "Undead";
		if (kmod == 1)
		{
			faction = "Zombies";
		}
		if (kmod == 2)
		{
			faction = "Vampires";
		}
        local actor = gt.tnf_debug.getRandomActor(faction);
        local script = this.Const.World.Spawn.Troops[actor[1]].Script;
				local entity = this.Tactical.spawnEntity(script);
				entity.setFaction(this.Const.Faction.PlayerAnimals)
				entity.assignRandomEquipment();
			}
      return;
      
    case 26: //P for PIRATES      
      if (this.m.LastTileHovered != null && this.m.LastTileHovered.IsEmpty)
			{
		local faction = ((kmod == 1) || (kmod == 4)) ? "Barbarians" : "Bandits";
        local actor = gt.tnf_debug.getRandomActor(faction);
        local script = this.Const.World.Spawn.Troops[actor[1]].Script;
				local entity = this.Tactical.spawnEntity(script);
				if ((kmod == 2) || (kmod == 4))
					entity.setFaction(this.Const.Faction.PlayerAnimals)
				else
					entity.setFaction(this.World.FactionManager.getFactionOfType(this.Const.FactionType[faction]).getID());
				entity.assignRandomEquipment();
			}
      return;
      
    case 28: //R (Mass Pass Turn)    
    case 29: //S (Movement)
	return;
    
    case 31: //U for UNDEAD
      if (this.m.LastTileHovered != null && this.m.LastTileHovered.IsEmpty)
			{
		local faction = "Undead";
		if (kmod == 1)
		{
			faction = "Zombies";
		}
		if (kmod == 2)
		{
			faction = "Vampires";
		}
		if (kmod == 4)
		{
			local rn = this.Math.rand(0,2);
			if (rn == 0)faction = "Undead";
			if (rn == 1)faction = "Zombies";
			if (rn == 2)faction = "Vampires";
		}
        local actor = gt.tnf_debug.getRandomActor(faction);
		if (faction == "Vampires")faction = "Undead";
        local script = this.Const.World.Spawn.Troops[actor[1]].Script;
				local entity = this.Tactical.spawnEntity(script);
				if (kmod == 4)
					entity.setFaction(this.Const.Faction.PlayerAnimals)
				else
					entity.setFaction(this.World.FactionManager.getFactionOfType(this.Const.FactionType[faction]).getID());
				entity.assignRandomEquipment();
			}
      return;
      
    case 32: //V for VETERANS
      if (this.m.LastTileHovered != null && this.m.LastTileHovered.IsEmpty)
			{
		local faction = "NobleHouse";
		if ((kmod == 0) || (kmod == 2))
		{
			faction = "NobleHouse";
		}
		if ((kmod == 1) || (kmod == 4))
		{
			faction = "Settlement";
		}
        local actor = gt.tnf_debug.getRandomActor(faction);
        local script = this.Const.World.Spawn.Troops[actor[1]].Script;
				local entity = this.Tactical.spawnEntity(script);
				if ((kmod == 2) || (kmod == 4))
					entity.setFaction(this.World.FactionManager.getFactionOfType(this.Const.FactionType[faction]).getID());
				else
					entity.setFaction(this.Const.Faction.Enemy);
				entity.assignRandomEquipment();
			}
      return;
    
    case 34: //X for CROSSBOW
      if (this.m.LastTileHovered != null && this.m.LastTileHovered.IsEmpty)
      {
        local e = this.Tactical.spawnEntity("scripts/entity/tactical/player");
        this.World.getGuestRoster().add(e);
        e.setFaction(this.Const.Faction.Player);
        e.setScenarioValues();
        e.setName(this.Const.Strings.CharacterNames[this.Math.rand(0, this.Const.Strings.CharacterNames.len() - 1)]);
        e.assignRandomRangedEquipment();
      }
      return;
      
	case 35: //Y for BOSS    
      if (this.m.LastTileHovered != null && this.m.LastTileHovered.IsEmpty)
			{
        local faction = "Bosses";
        //local actor = gt.tnf_debug.getRandomActor(faction);
		local actor = "TricksterGod";
		if (kmod == 1)
		{
			faction = "Bosses";
			actor = "Kraken";
		}
		if (kmod == 2)
		{
			faction = "Zombies";
			actor = "ZombieBoss";
		}
		if (kmod == 4)
		{
			faction = "Undead";
			actor = "SkeletonBoss";
		}
        local script = this.Const.World.Spawn.Troops[actor].Script;
		local entity = this.Tactical.spawnEntity(script);
		if (faction == "Bosses")faction = "Beasts";
		entity.setFaction(this.World.FactionManager.getFactionOfType(this.Const.FactionType[faction]).getID());
		entity.assignRandomEquipment();
			}
      return;
  }
}
});

/******************************

*************
*    KEYS   *
*************

1 > 0 = 1 > 10
A > Z = 11 > 36

backspace = 37
tab = 38
enter = 39
space = 40
escape = 41
page down/up = 46/47
left, up, right, down arrows = 48 > 51
del = 54

F1 > F12 = 71 > 82

shift = 96 as modifier = 1
ctrl = 95 as modifier = 2
ctrl+shift = 3
alt = 97 as modifier = 4
alt+shift = 5
alt gr = 95 + 97 as modifier = 6


numpad0-9 = 55-64
numpad* = 66
numpad/ = 70


******************************/