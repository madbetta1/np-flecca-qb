Fleeca = {}
Fleeca.blackmoney = false -- enable this if you want blackmoney as a reward
Fleeca.maxcash = 7500 -- maximum amount of cash a pile can hold
Fleeca.mincash = 5000 -- minimum amount of cash a pile holds
Fleeca.cooldown = 600 -- amount of time to do the heist again in seconds (15min)
Fleeca.mincops = 0 -- minimum required cops to start mission
Fleeca.vaultdoor = "v_ilev_gb_vauldr"
Fleeca.Banks = {
    F1 = {
        doors = {
            startloc = {x = 310.93, y = -284.44, z = 54.16, h = -90.00, animcoords = {x = 311.05, y = -284.00, z = 53.16, h = 248.60}},
        },
        prop = {
            first = {coords = vector3(311.5481, -284.5114, 54.285), rot = vector3(90.0, 180.0, 21.0)},
        },
        trolley = {x = 313.45, y = -289.24, z = 53.14, h = -15},
        objects = {
            vector3(313.45, -289.24, 53.14),
        },
        loot = false,
        onaction = false,
        lastrobbed = 0
    },
    F2 = {
        doors = {
            startloc = {x = 146.61, y = -1046.02, z = 29.37, h = 244.20, animcoords = {x = 146.75, y = -1045.60, z = 28.37, h = 244.20}},
        },
        prop = {
            first = {coords = vector3(147.22, -1046.148, 29.487), rot = vector3(90.0, 180.0, 20.0)},
        },
        trolley = {x = 147.25, y = -1050.38, z = 28.35, h = -15},
        objects = {
            vector3(147.25, -1050.38, 28.35),
        },
        loot = false,
        onaction = false,
        lastrobbed = 0
    },
    F3 = {
        doors = {
            startloc = {x = -1211.07, y = -336.68, z = 37.78, h = 296.76, animcoords = {x = -1211.25, y = -336.37, z = 36.78, h = 296.76}}, 
        },
        prop = {
            first = {coords = vector3(-1210.50, -336.37, 37.901), rot = vector3(-90.0, 0.0, 25.0)},
        },
        trolley = {x = -1207.50, y = -339.20, z = 36.76, h = 30},
        objects = {
            vector3(-1207.50, -339.20, 36.76),
        },
        loot = false,
        onaction = false,
        lastrobbed = 0
    },
    F4 = {
        hash = 4231427725, -- exception
        doors = {
            startloc = {x = -2956.68, y = 481.34, z = 15.70, h = 353.97, animcoords = {x = -2956.68, y = 481.34, z = 14.70, h = 353.97}},
        },
        prop = {
            first = {coords = vector3(-2956.59, 482.05, 15.815), rot = vector3(90.0, 180.0, -88.0)},
        },
        trolley = {x = -2952.69, y = 483.34, z = 14.68, h = 85},
        objects = {
            vector3(-2952.69, 483.34, 14.68),
        },
        loot = false,
        onaction = false,
        lastrobbed = 0
    },
    F5 = {
        doors = {
            startloc = {x = -354.15, y = -55.11, z = 49.04, h = 251.05, animcoords = {x = -354.15, y = -55.11, z = 48.04, h = 251.05}},
        },
        prop = {
            first = {coords = vector3(-353.50, -55.37, 49.157), rot = vector3(90.0, 180.0, 20.0)},
        },
        trolley = {x = -353.34, y = -59.48, z = 48.01, h = -15},
        objects = {
            vector3(-353.34, -59.48, 48.01),
        },
        loot = false,
        onaction = false,
        lastrobbed = 0
    },
    F6 = {
        doors = {
            startloc = {x = 1176.40, y = 2712.75, z = 38.09, h = 84.83, animcoords = {x = 1176.40, y = 2712.75, z = 37.09, h = 84.83}},
        },
        prop = {
            first = {coords = vector3(1175.70, 2712.82, 38.207), rot = vector3(90.0, 180.0, 180.0)},
        },
        trolley = {x = 1174.24, y = 2716.69, z = 37.07, h = -180},
        objects = {
            vector3(1174.24, 2716.69, 37.07),
        },
        loot = false,
        onaction = false,
        lastrobbed = 0
    }
}