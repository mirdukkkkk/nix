{
  programs.plasma.powerdevil.AC = {
    autoSuspend.action = "nothing";

    powerButtonAction = "showLogoutScreen";
    whenSleepingEnter = "standby";

    dimDisplay.enable = false;

    turnOffDisplay = {
      idleTimeout = 900;
      idleTimeoutWhenLocked = "whenLockedAndUnlocked";
    };
  };
}
