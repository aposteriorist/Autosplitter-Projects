state("Chroma_Zero-Win64-Shipping")
{
}

startup
{
    Assembly.Load(File.ReadAllBytes("Components/asl-help")).CreateInstance("Basic");
	vars.Helper.GameName = "Chroma Zero";
	vars.Helper.AlertLoadless();

    settings.Add("ChromaZero", true, "Chroma Zero Splits");
        settings.Add("lightGateSplit", true, "Split on getting Reminder 0 from the Light Gate", "ChromaZero");
        settings.Add("remindersSplit", true, "Split on Reminders", "ChromaZero");
            settings.Add("Reminder 1", false, "Split on Reminder 1", "remindersSplit");
            settings.Add("Reminder 6", false, "Split on Reminder 6", "remindersSplit");
            settings.Add("Reminder 7", false, "Split on Reminder 7", "remindersSplit");
            settings.Add("Reminder 10", false, "Split on Reminder 10", "remindersSplit");
            settings.Add("Reminder 18", false, "Split on Reminder 18", "remindersSplit");
            settings.Add("Reminder 19", false, "Split on Reminder 19", "remindersSplit");
            settings.Add("Reminder 26", false, "Split on Reminder 26", "remindersSplit");
        settings.Add("Reminder 22", true, "Split on obtaining the clues from the Magenta Tower", "ChromaZero");
        settings.Add("creditsSplit", true, "Split on reaching the credits", "ChromaZero");
}

init
{
    IntPtr gWorld = vars.Helper.ScanRel(3, "48 8B 1D ???????? 48 85 DB 74 ?? 41 B0 01");
    IntPtr gEngine = vars.Helper.ScanRel(3, "48 8B 0D ???????? 66 0F 5A C9 E8");
    IntPtr fNames = vars.Helper.ScanRel(7, "8B D9 74 ?? 48 8D 15 ???????? EB");

    vars.Helper["IGT"] = vars.Helper.Make<double>(gWorld, 0x160, 0x4D0, 0x2E0, 0x2D8);

    vars.Helper["DeleteSaveProgress"] = vars.Helper.Make<double>(gWorld, 0x160, 0x4E0, 0x490);
    vars.Helper["AnyPercentGoal"] = vars.Helper.Make<bool>(gWorld, 0x160, 0x5B8);
    vars.Helper["ObtainedReminder"] = vars.Helper.Make<int>(gWorld, 0x160, 0x540, 0x42C);
    vars.Helper["LightGateGoal"] = vars.Helper.Make<bool>(gWorld, 0x160, 0x590);

    vars.TotalTime = new TimeSpan();
    vars.Splits = new HashSet<string>();
}

start
{
    return current.IGT > 0.0f && old.IGT == 0.0f;
}

onStart
{
    vars.TotalTime = TimeSpan.Zero;
    vars.Splits.Clear();
}

update
{
    vars.Helper.Update();
	vars.Helper.MapPointers();

    if (current.DeleteSaveProgress > 0.0f)
    {
        vars.Log("Return to Title: " + current.DeleteSaveProgress);
    }

    if (current.ObtainedReminder != old.ObtainedReminder)
    {
        vars.Log("Current Reminders: " + current.ObtainedReminder);
    }
}

split
{
    if (current.LightGateGoal && !vars.Splits.Contains("Enter Dark Phase"))
    {
        return settings["lightGateSplit"] && vars.Splits.Add("Enter Dark Phase");
    }

    if (current.AnyPercentGoal && !vars.Splits.Contains("Credits"))
    {
        return settings["creditsSplit"] && vars.Splits.Add("Credits");
    }

    if (current.ObtainedReminder != old.ObtainedReminder && !vars.Splits.Contains("Obtained Reminder"+current.ObtainedReminder.ToString()))
    {
        return settings["Reminder "+current.ObtainedReminder] && vars.Splits.Add("Obtained Reminder"+current.ObtainedReminder.ToString());
    }
}

reset 
{    
    return current.DeleteSaveProgress > 0.90f;
}

isLoading
{
    return (old.IGT == current.IGT);
}

gameTime
{
    if (old.IGT > current.IGT && current.IGT == 0.0f)
    {
        vars.TotalTime += TimeSpan.FromSeconds(old.IGT);
    }

    return vars.TotalTime + TimeSpan.FromSeconds(current.IGT);
}
