this.twitch_train_player_event <- this.inherit("scripts/events/event", {
	m = {
		Name = "test",
		MA = 3,
		MD = 3,
		RA = 3,
		RD = 3,
		II = 3,
		FF = 3,
		HP = 3,
		BR = 3
	},
	function create()
	{
		this.m.ID = "event.twitch_train_player";
		this.m.Title = "During the break...";
		this.m.Cooldown = 1;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_05.png[/img]{You walk through the camp and see %dude% behind a tent getting ready to train. Looks like he needs some advice from an experienced commander.}"
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "You should work harder on your physical fitness!",
					function getResult( _event )
					{
						return "B";
					}

				},
				{
					Text = "You should sharpen your fighting skills!",
					function getResult( _event )
					{
						return "C";
					}

				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_05.png[/img]{%dude% trains hard.}"
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Keep it up!",
					function getResult( _event )
					{
						local roster = this.World.getPlayerRoster();
						local bros = roster.getAll();          
						foreach( bro in bros )
						{
							if (bro.getNameOnly() == _event.m.Name)
							{
								bro.getBaseProperties()["MeleeSkill"] += _event.m.MA;
								bro.getCurrentProperties()["MeleeSkill"] += _event.m.MA;
								bro.getBaseProperties()["MeleeDefense"] += _event.m.MD;
								bro.getCurrentProperties()["MeleeDefense"] += _event.m.MD;
								bro.getBaseProperties()["RangedSkill"] += _event.m.RA;
								bro.getCurrentProperties()["RangedSkill"] += _event.m.RA;
								bro.getBaseProperties()["RangedDefense"] += _event.m.RD;
								bro.getCurrentProperties()["RangedDefense"] += _event.m.RD;
								bro.getBaseProperties()["Initiative"] += _event.m.II;
								bro.getCurrentProperties()["Initiative"] += _event.m.II;
								bro.getBaseProperties()["Stamina"] += _event.m.FF;
								bro.getCurrentProperties()["Stamina"] += _event.m.FF;
								bro.getBaseProperties()["Hitpoints"] += _event.m.HP;
								bro.getCurrentProperties()["Hitpoints"] += _event.m.HP;
								bro.getBaseProperties()["Bravery"] += _event.m.BR;
								bro.getCurrentProperties()["Bravery"] += _event.m.BR;
								bro.setHitpointsPct(1);
							}
						}
						return 0;
					}

				}
			],
			function start( _event )
			{
				local roster = this.World.getPlayerRoster();
				local bros = roster.getAll();          
				foreach( bro in bros )
				{
					if (bro.getNameOnly() == _event.m.Name)
					{
						this.Characters.push(bro.getImagePath());
					}
				}
				
				this.List = [
					{
						id = 16,
						icon = "ui/icons/melee_skill.png",
						text = "[color=" + this.Const.UI.Color.PositiveEventValue + "]+" + _event.m.MA + "[/color] Attack"
					},
					{
						id = 17,
						icon = "ui/icons/melee_defense.png",
						text = "[color=" + this.Const.UI.Color.PositiveEventValue + "]+" + _event.m.MD + "[/color] Defence"
					},
					{
						id = 18,
						icon = "ui/icons/ranged_skill.png",
						text = "[color=" + this.Const.UI.Color.PositiveEventValue + "]+" + _event.m.RA + "[/color] Accuracy"
					},
					{
						id = 19,
						icon = "ui/icons/ranged_defense.png",
						text = "[color=" + this.Const.UI.Color.PositiveEventValue + "]+" + _event.m.RD + "[/color] Ranged Defence"
					},
					{
						id = 20,
						icon = "ui/icons/health.png",
						text = "[color=" + this.Const.UI.Color.PositiveEventValue + "]+" + _event.m.HP + "[/color] HP"
					},
					{
						id = 21,
						icon = "ui/icons/fatigue.png",
						text = "[color=" + this.Const.UI.Color.PositiveEventValue + "]+" + _event.m.FF + "[/color] Stamina"
					},
					{
						id = 22,
						icon = "ui/icons/bravery.png",
						text = "[color=" + this.Const.UI.Color.PositiveEventValue + "]+" + _event.m.BR + "[/color] Bravery"
					},
					{
						id = 23,
						icon = "ui/icons/initiative.png",
						text = "[color=" + this.Const.UI.Color.PositiveEventValue + "]+" + _event.m.II + "[/color] Initiative"
					},
				];
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_05.png[/img]{%dude% deepens the mastery of his skills.}"
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Keep it up!",
					function getResult( _event )
					{
						local roster = this.World.getPlayerRoster();
						local bros = roster.getAll();          
						foreach( bro in bros )
						{
							if (bro.getNameOnly() == _event.m.Name)
							{
								bro.m.PerkPoints += 1;
							}
						}
						return 0;
					}

				}
			],
			function start( _event )
			{
				local roster = this.World.getPlayerRoster();
				local bros = roster.getAll();          
				foreach( bro in bros )
				{
					if (bro.getNameOnly() == _event.m.Name)
					{
						this.Characters.push(bro.getImagePath());
					}
				}
				
				this.List = [
					{
						id = 16,
						icon = "ui/icons/leveled_up.png",
						text = "[color=" + this.Const.UI.Color.PositiveEventValue + "]+1[/color] skill point"
					}
				];
			}

		});
	}

	function onUpdateScore()
	{
		this.m.Score = -100;
	}

	function onPrepare(){}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"dude",
			this.m.Name
		]);
	}

	function onClear(){}
});