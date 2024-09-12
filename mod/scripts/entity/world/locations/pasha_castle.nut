this.pasha_castle <- this.inherit("scripts/entity/world/location", {
	m = {},
	function getDescription()
	{
		return "A majestic castle engulfed in flames.";
	}

	function create()
	{
		this.location.create();
		this.m.TypeID = "location.pasha_castle";
		this.m.LocationType = this.Const.World.LocationType.Unique;
		this.m.IsShowingBanner = false;
		this.m.VisibilityMult = 1.0;
        this.m.OnEnter = "event.location.pasha_castle_enter";
		this.m.Resources = 0;
	}
	
	function onSpawned()
	{
		this.m.Name = "Pavel's Castle";
		this.location.onSpawned();
	}

	function onInit()
	{
		this.location.onInit();
		local body = this.addSprite("body");
		body.setBrush("pasha_castle");
	}

});