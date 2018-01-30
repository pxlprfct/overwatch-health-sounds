# Overwatch Health Sounds
[Blog post](http://ollie.work/2016/10/10/creating-a-world-of-warcraft-addon/)
A World of Warcraft addon that plays an Overwatch character's "I need healing" sound when low on health

### How to use /ohs
**List Current Settings**
```
/ohs
```
**Change Health Threshold**
```
/ohs threshold 30
```
> The sound will only play once the player falls below **30%** health

**Change Voice Line Frequency**
```
/ohs frequency 5
```
> The voice line will only play once every **5** seconds (to help prevent spam)

**Change Voice Line**
```
/ohs voice Torbjörn
```
> **Torbjörn's** voice will play when on low-health

Available voice lines - D.va, Genji, Junkrat, Lúcio, Mei, Mercy, Reaper, Roadhog, Solider: 76, Symmetra, Torbjörn, Tracer, Widowmaker, Winston, Zarya, Zenyatta

The following voice lines are missing - Bastion, Hanzo, McCree, Pharah, Reinhardt

Soundfiles found on [Sounds of Overwatch](http://rpboyer15.github.io/sounds-of-overwatch/)

Also on [Curse](http://mods.curse.com/addons/wow/overwatch-health-sounds)

---
**ToDo**
- Find missing voice lines (Bastion, Hanzo, McCree, Pharah, Reinhardt)
- Find low-health 'gasps' (all files are currently missing)
- General Code Cleanup
