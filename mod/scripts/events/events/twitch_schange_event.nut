this.twitch_schange_event <- this.inherit("scripts/events/event", {
	m = {
		Name = "test"
	},
	function create()
	{
		this.m.ID = "event.twitch_schange";
		this.m.Title = "At a rest stop";
		this.m.Cooldown = 1;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_05.png[/img]{At camp, %dude% comes up to you and tells you that he wants to become a woman.}"
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Help carry out the operation!",
					function getResult( _event )
					{
					
						local roster = this.World.getPlayerRoster();
						local bros = roster.getAll();
						foreach( bro in bros )
						{
							if (bro.getNameOnly() == _event.m.Name)
							{
								bro.m.Faces = [
									"woman_head1",
									"woman_head2"
									];
								bro.m.Hairs = [
									"woman_hair1",
									"woman_hair2",
									"woman_hair3",
									"woman_hair4",
									"woman_hair5"
									];
								bro.m.HairColors = null;
								bro.m.Beards = null;
								bro.m.BeardChance = 0;
								bro.m.Bodies = ["woman_body"];
								
								local sprite = bro.getSprite("head");
								sprite.setBrush(bro.m.Faces[this.Math.rand(0, bro.m.Faces.len() - 1)]);
								sprite.Color = this.createColor("#fbffff");
								sprite.varyColor(0.05, 0.05, 0.05);
								sprite.varySaturation(0.1);
								local body = bro.getSprite("body");
								body.Color = sprite.Color;
								body.Saturation = sprite.Saturation;

								local sprite = bro.getSprite("hair");
								sprite.setBrush(bro.m.Hairs[this.Math.rand(0, bro.m.Hairs.len() - 1)]);

								local beard = bro.getSprite("beard");
								beard.resetBrush();
								local sprite = bro.getSprite("beard_top");
								sprite.resetBrush();

								local body = bro.m.Bodies[this.Math.rand(0, bro.m.Bodies.len() - 1)];
								bro.getSprite("body").setBrush(body);
								bro.getSprite("injury_body").setBrush(body);
								
								bro.getSprite("tattoo_head").resetBrush();
								bro.getSprite("tattoo_body").resetBrush();
								
								bro.setDirty(true);
								bro.updateOverlay();
								bro.setDirty(false);
							}
						}
						return "B";
					}

				},
				{
					Text = "Oh well, whats started again, bruh",
					function getResult( _event )
					{
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
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_05.png[/img]{Meet %dude% in a new apperance!}"
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Wow, good",
					function getResult( _event )
					{
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