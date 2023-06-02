state("My Friend Peppa Pig")
{
    byte Start: "UnityPlayer.dll", 0x19A7630, 0xA8, 0xC8, 0x28, 0x30;
    bool MainMenu: "UnityPlayer.dll", 0x199ACE0, 0x1E0, 0x48, 0x118, 0x50, 0x20, 0x10, 0x28;
}

startup
{   
    vars.Log = (Action<object>)(output => print("[My Friend Peppa Pig] " + output));

    Assembly.Load(File.ReadAllBytes("Components/asl-help")).CreateInstance("Unity");
    vars.Helper.LoadSceneManager = true;
    
    if (timer.CurrentTimingMethod == TimingMethod.RealTime)
    {
        var timingMessage = MessageBox.Show (
            "This game uses Time without Loads (Game Time) as the main timing method.\n"+
            "LiveSplit is currently set to show Real Time (RTA).\n"+
            "Would you like to set the timing method to Game Time?",
            "LiveSplit | My Friend Peppa Pig",
            MessageBoxButtons.YesNo, MessageBoxIcon.Question
        );

        if (timingMessage == DialogResult.Yes)
            timer.CurrentTimingMethod = TimingMethod.GameTime;
    }
}

init
{
    vars.Helper.TryLoad = (Func<dynamic, bool>)(mono =>
    {
        vars.Helper["Transitions"] = mono.Make<bool>("LoadingSceneManager", 1, "_instance", 0x2C);
        vars.Helper["PauseMenu"] = mono.Make<bool>("PauseManager", 1, "_instance", 0x81);

        return true;
    });
}

isLoading
{
    return current.Transitions || current.PauseMenu || current.MainMenu;
}

start
{
    return current.Start == 1 && old.Start == 0;
}

exit
{
	vars.Helper.Dispose();
}

shutdown
{
	vars.Helper.Dispose();
}
