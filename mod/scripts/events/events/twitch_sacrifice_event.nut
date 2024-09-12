this.twitch_sacrifice_event <- this.inherit("scripts/events/event", {
	m = {
		Sacrifice = null,
		Sacrifice1 = null,
		Sacrifice2 = null,
		Sacrifice3 = null,
		Sacrifice4 = null,
		Sacrifice5 = null
	},
	function create()
	{
		this.m.ID = "event.twitch_sacrifice";
		this.m.Title = "During the break...";
		this.m.Cooldown = 20.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_140.png[/img]{At first everything went as usual, but towards evening the whole squad began to understand what was going to happen today. Yes, this is it! The Fruit God demands a sacrifice again. It must be made! This night!}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "%sac1% should be interred.",
					function getResult( _event )
					{
						_event.m.Sacrifice = _event.m.Sacrifice1;
						return "B";
					}

				},
				{
					Text = "%sac2% should be interred.",
					function getResult( _event )
					{
						_event.m.Sacrifice = _event.m.Sacrifice2;
						return "B";
					}

				},
				{
					Text = "%sac3% should be interred.",
					function getResult( _event )
					{
						_event.m.Sacrifice = _event.m.Sacrifice3;
						return "B";
					}

				},
				{
					Text = "%sac4% should be interred.",
					function getResult( _event )
					{
						_event.m.Sacrifice = _event.m.Sacrifice4;
						return "B";
					}

				},
				{
					Text = "%sac5% should be interred.",
					function getResult( _event )
					{
						_event.m.Sacrifice = _event.m.Sacrifice5;
						return "B";
					}

				},
				{
					Text = "Buy off with gold (8000)",
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
			Text = "[img]gfx/ui/events/event_140.png[/img]{As night fell, %sacrifice% was ceremoniously placed on a ritual fire surrounded by huge piles of various fruits. The fire blazed while the entire squad danced around it. And then the feast began. They drank fruit wine and ate fried fruits from the ritual fire. And finally, by morning, the squad leader pulled the main dish out of the smoldering fire - %sacrifice%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "In Praise of the Fruit God",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Sacrifice.getImagePath());
				local dead = _event.m.Sacrifice;
				local fallen = {
					Name = dead.getName(),
					Time = this.World.getTime().Days,
					TimeWithCompany = this.Math.max(1, dead.getDaysWithCompany()),
					Kills = dead.getLifetimeStats().Kills,
					Battles = dead.getLifetimeStats().Battles,
					KilledBy = "Sacrificed to the fruit god",
					Expendable = dead.getBackground().getID() == "background.slave"
				};
				this.World.Statistics.addFallen(fallen);
				this.List.push({
					id = 13,
					icon = "ui/icons/kills.png",
					text = _event.m.Sacrifice.getName() + " died"
				});
				_event.m.Sacrifice.getItems().transferToStash(this.World.Assets.getStash());
				this.World.getPlayerRoster().remove(_event.m.Sacrifice);
				
				local brothers = this.World.getPlayerRoster().getAll();
				foreach( bro in brothers )
				{
					
						bro.improveMood(2.0, "Rejoiced in the name of the fruit god");

						if (bro.getMoodState() >= this.Const.MoodState.Neutral)
						{
							this.List.push({
								id = 10,
								icon = this.Const.MoodStateIcon[bro.getMoodState()],
								text = bro.getName() + this.Const.MoodStateEvent[bro.getMoodState()]
							});
						}

					if (this.Math.rand(1, 100) > 50)
					{
						local skills = bro.getSkills();
						local skill;

						if (skills.hasSkill("trait.fruto_mad"))
						{
							skills.getSkillByID("trait.fruto_mad").m.lvl += 1;
							
							this.List.push({
								id = 11,
								icon = skills.getSkillByID("trait.fruto_mad").getIcon(),
								text = bro.getName() + " now worships the fruit god even more devotedly"
							});
						}
						else
						{
							skill = this.new("scripts/skills/traits/fruto_mad_trait");
							skills.add(skill);
							
							this.List.push({
								id = 11,
								icon = skill.getIcon(),
								text = bro.getName() + " now a devoted worshiper of the fruit god"
							});
						}
					}

				}
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_140.png[/img]{With all the gold you've collected, you buy mountains of fruit and hold a fruit festival in honor of the fruit god. He grumbles a little, but still allows you to postpone the sacrifice for a few days.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Let's continue our journey",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.World.Assets.addMoney(-8000);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Spend [color=" + this.Const.UI.Color.NegativeEventValue + "]8000[/color] moneys"
				});
			}

		});
	}

	function onUpdateScore()
	{
		if (this.World.Assets.getOrigin().getID() != "scenario.twitch")
		{
			return;
		}
		
		if (::TwitchDebug.Mod.ModSettings.getSetting("Sacrifice").getValue() == false)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();

		if (brothers.len() < 5)
		{
			return;
		}
		
		local r = this.Math.rand(0, brothers.len() - 1);
		this.m.Sacrifice1 = brothers[r];
		brothers.remove(r);
		
		r = this.Math.rand(0, brothers.len() - 1);
		this.m.Sacrifice2 = brothers[r];
		brothers.remove(r);
		
		r = this.Math.rand(0, brothers.len() - 1);
		this.m.Sacrifice3 = brothers[r];
		brothers.remove(r);
		
		r = this.Math.rand(0, brothers.len() - 1);
		this.m.Sacrifice4 = brothers[r];
		brothers.remove(r);
		
		r = this.Math.rand(0, brothers.len() - 1);
		this.m.Sacrifice5 = brothers[r];
		
		this.m.Score = 250;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"sac1",
			this.m.Sacrifice1.getName()
		]);
		_vars.push([
			"sac2",
			this.m.Sacrifice2.getName()
		]);
		_vars.push([
			"sac3",
			this.m.Sacrifice3.getName()
		]);
		_vars.push([
			"sac4",
			this.m.Sacrifice4.getName()
		]);
		_vars.push([
			"sac5",
			this.m.Sacrifice5.getName()
		]);
		_vars.push([
			"sacrifice",
			this.m.Sacrifice != null ? this.m.Sacrifice.getName() : ""
		]);
	}

	function onClear()
	{
		this.m.Sacrifice1 = null;
		this.m.Sacrifice2 = null;
		this.m.Sacrifice3 = null;
		this.m.Sacrifice4 = null;
		this.m.Sacrifice5 = null;
		this.m.Sacrifice = null;
	}

});

