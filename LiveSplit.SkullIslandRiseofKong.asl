state("Monke-Win64-Shipping")
{
    int Loads: 0x6E6B478;
}

isLoading
{
    return current.Loads == 50;
}

start
{
    return old.Loads == 1 && current.Loads == 50;
}

reset
{
    return current.Loads == 1 && current.MainMenu == 2;
}

exit
{
    timer.IsGameTimePaused = true;
}
