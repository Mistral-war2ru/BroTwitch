var PrepareCarefully = {};

PrepareCarefully.createDIV = TacticalScreenTopbarRoundInformationModule.prototype.createDIV;
TacticalScreenTopbarRoundInformationModule.prototype.createDIV = function(_parentDiv)
{
	PrepareCarefully.createDIV.call(this, _parentDiv);
	var self = this;
	this.mStartBattleContainer = $('<div class="prepare-for-battle-button-container"/>');
	this.mContainer.append(this.mStartBattleContainer);
	this.mStartBattleContainer.createTextButton("Начать битву", function ()
	{
	    self.onPrepareCarefullyButtonPressed();
	}, null, 4)
}

PrepareCarefully.update = TacticalScreenTopbarRoundInformationModule.prototype.update;
TacticalScreenTopbarRoundInformationModule.prototype.update = function (_data)
{
	PrepareCarefully.update.call(this, _data);
	if ("PrepareCarefullyMode" in _data && _data.PrepareCarefullyMode )
	{
		this.mStartBattleContainer.addClass("display-block").removeClass("display-none");
	}
	else
	{
		this.mStartBattleContainer.addClass("display-none").removeClass("display-block");
	}
}

TacticalScreenTopbarRoundInformationModule.prototype.onPrepareCarefullyButtonPressed = function()
{
	this.mStartBattleContainer.addClass("display-none").removeClass("display-block");
    SQ.call(Screens["TacticalScreen"].mSQHandle, 'onPrepareCarefullyButtonPressed');
}
