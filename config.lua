Config = {}

Config.Busfahrer = {
    SpawnPeds = true,

    PedsGiveMoney = true,
    PayPerPed = {
        Min = 10,
        Max = 25,
    },

    Coords = {
        Blip = vector3(431.3918, -643.7908, 28.5002),
        Marker = vector3(435.2006, -644.2198, 28.7344)
    },
    Marker = {
        Type = 2, 
        Scale = vector3(1.0, 1.0, 1.0), 
        Color = vector3(0, 0, 255),
        Alpha = 150
    },
    Blip = {
        Type = 513,
        Color = 29,
        Size = 0.6
    },
    VehicleSpawns = {
        vector4(457.4672, -654.6110, 27.8185, 214.4928),
        vector4(459.0104, -640.2364, 28.4642, 214.7592),
        vector4(460.3391, -625.7930, 28.4954, 215.0013),
        vector4(461.4668, -611.4659, 28.4876, 213.3857)
    },

    Routen = {
        [1] = {
            Name = "Stadt Route",
            Pay = 500,

            [1] = {
                Coords = vector3(422.3271, -674.1261, 29.2381),
                Radius = 5.0,
                Type = "Checkpoint"
            },
            [2] = {
                Coords = vector3(305.2440, -771.4125, 29.2250),
                Radius = 3.0,
                Type = "Haltestelle"
            },
            [3] = {
                Coords = vector3(109.2756, -782.3395, 31.3450),
                Radius = 3.0,
                Type = "Haltestelle"
            },
            [4] = {
                Coords = vector3(108.0006, -781.8994, 31.3539),
                Radius = 5.0,
                Type = "Checkpoint"
            },
            [5] = {
                Coords = vector3(-109.2763, -616.4202, 36.0529),
                Radius = 3.0,
                Type = "Haltestelle"
            },
            [6] = {
                Coords = vector3(-175.3657, -826.1363, 30.8153),
                Radius = 3.0,
                Type = "Haltestelle"
            },
            [7] = {
                Coords = vector3(-276.1375, -1406.9539, 31.3445),
                Radius = 5.0,
                Type = "Checkpoint"
            },
            [8] = {
                Coords = vector3(-51.5443, -1602.1592, 29.2265),
                Radius = 5.0,
                Type = "Checkpoint"
            },
            [9] = {
                Coords = vector3(54.3869, -1531.7507, 29.1941),
                Radius = 3.0,
                Type = "Haltestelle"
            },
            [10] = {
                Coords = vector3(310.5796, -1374.5839, 31.8521),
                Radius = 3.0,
                Type = "Haltestelle"
            },
            [11] = {
                Coords = vector3(275.3582, -1218.1057, 29.3754),
                Radius = 3.0,
                Type = "Haltestelle"
            },
            [12] = {
                Coords = vector3(361.4948, -1064.5724, 29.3627),
                Radius = 3.0,
                Type = "Haltestelle"
            },
            [13] = {
                Coords = vector3(408.4520, -873.4960, 29.3024),
                Radius = 5.0,
                Type = "Checkpoint"
            },
            [14] = {
                Coords = vector3(315.0073, -843.9675, 29.2518),
                Radius = 5.0,
                Type = "Checkpoint"
            },
            [15] = {
                Coords = vector3(359.3357, -685.6703, 29.247),
                Radius = 5.0,
                Type = "Checkpoint"
            },
            [16] = {
                Coords = vector3(474.4602, -582.0243, 28.4997),
                Radius = 5.0,
                Type = "Ziel"
            }
        },
    },

    MaxPeds = 14, --Max Peds per Station
    PedsNumber = 5,
    Peds = {
        "a_m_m_soucent_03",
        "a_m_m_prolhost_01",
        "a_f_y_eastsa_03",
        "a_m_o_genstreet_01",
        "a_m_y_beachvesp_01"
    },
}

Config.Elektriker = {
    PayPerRepair = {
        Min = 50,
        Max = 100,
    },

    Coords = {
        Blip = vector3(718.5139, 152.0119, 80.7546),
        Marker = vector3(718.5139, 152.0119, 80.7546),
    },

    Marker = {
        Type = 2, 
        Scale = vector3(1.0, 1.0, 1.0), 
        Color = vector3(255,255,0),
        Alpha = 150
    },

    Blip = {
        Type = 354,
        Color = 46,
        Size = 1.5
    },

    RepairBlip = {
        Type = 354,
        Color = 46,
        Size = 0.7
    },

    Locations = {
        vector3(692.2835, 160.8194, 80.9403),
        vector3(698.2261, 158.7961, 80.9403),
        vector3(685.4266, 168.5695, 80.9502),
        vector3(679.6742, 170.5942, 80.9505),
        vector3(679.7562, 153.0342, 80.9366),
        vector3(674.0703, 155.0875, 80.9366),
        vector3(686.9291, 145.1794, 80.9378),
        vector3(692.6709, 143.0107, 80.9378),
        vector3(670.1354, 128.0993, 80.9502),
        vector3(664.3822, 130.1548, 80.9502),
        vector3(676.9874, 119.9567, 80.9378),
        vector3(682.6419, 117.8563, 80.9373),
        vector3(664.5002, 111.9449, 80.9229),
        vector3(658.8751, 114.0830, 80.9225),
        vector3(697.6884, 104.4310, 80.7550),
        vector3(703.4293, 102.7369, 80.7545),
        vector3(703.3588, 120.0532, 80.9564),
        vector3(709.1817, 118.0469, 80.9563),
    }
}

Config.ContainerCarrier = {
    Coords = {
        Blip = vector3(-115.6929, -2516.6685, 6.0957),
        Marker = vector3(-115.6929, -2516.6685, 6.0957),
    },

    Marker = {
        Type = 2, 
        Scale = vector3(1.0, 1.0, 1.0), 
        Color = vector3(0, 0, 0),
        Alpha = 150,
    },

    Blip = {
        Type = 677,
        Color = 10,
        Size = 1.0,
    },

    BlipforContainer = {
        Type = 677,
        Color = 10,
        Size = 0.6,
    },

    VehicleSpawns = {
        vector4(-109.4819, -2547.1201, 5.9830, 320.3440),
        vector4(-117.0756, -2541.1526, 6.0000, 323.8974),
        vector4(-109.4167, -2530.1382, 6.0000, 326.4705),
        vector4(-100.8670, -2535.2615, 6.0023, 322.8306),
    },

    ContainerSpawns = {
        vector4(-93.8473, -2454.0220, 5.0178, 55.2467),
        vector4(-97.2453, -2458.2949, 5.0195, 56.5156),
        vector4(-100.1476, -2462.8662, 5.0204, 57.9615),
        vector4(-108.2526, -2420.9539, 5.0000, 89.8266),
        vector4(-108.4539, -2415.6975, 5.0000, 89.3393),
        vector4(-107.9184, -2410.1313, 5.0000, 86.3812),
        vector4(-53.1407, -2410.1201, 5.0001, 94.4158),
        vector4(-53.0559, -2415.5154, 5.0002, 89.6387),
        vector4(-52.8730, -2420.9128, 5.0002, 91.6215),
        vector4(17.8970, -2456.0793, 5.0068, 237.1206),
        vector4(44.9583, -2475.1416, 5.0068, 224.5685),
        vector4(41.7258, -2479.2451, 5.0068, 233.6299),
        vector4(38.2886, -2483.6443, 5.0068, 234.1193),
        vector4(49.6795, -2491.6677, 5.0068, 234.3097),
        vector4(36.2956, -2512.5984, 5.0046, 54.9168),
        vector4(-2.7105, -2485.4070, 5.0068, 234.9070),
        vector4(-13.0568, -2477.8647, 5.0068, 54.8048),
    },

    ContainerDeliverSpots = {
        vector4(-155.4900, -2472.6194, 6.2258, 224.8069),
        vector4(-169.6060, -2507.2539, 6.2039, 3.7318),
    },

    ContainerNames = {
        "China",
        "Deutschland",
        "England",
        "Bangladesch",
        "USA",
        "Japan",
        "Italien",
        "Griechenland",
        "Malta",
        "Schweiz",
        "Polen",
        "Österreich",
        "Russland",
    },

    ContainerWahre = {
        [1] = {
            Name = "Auto Teile",
            Pay = 500,
        },
        [2] = {
            Name = "Waffen",
            Pay = 1000,
        },
        [3] = {
            Name = "Drogen",
            Pay = 500,
        },
        [4] = {
            Name = "Fleisch",
            Pay = 400,
        },
        [5] = {
            Name = "Gemüse",
            Pay = 300,
        },
        [6] = {
            Name = "Wasser",
            Pay = 200,
        },
        [7] = {
            Name = "Süß Getränke",
            Pay = 250,
        },
        [8] = {
            Name = "PCs",
            Pay = 800,
        },
        [9] = {
            Name = "Consolen",
            Pay = 600,
        },
        [10] = {
            Name = "Pflanzen",
            Pay = 150,
        },
        [11] = {
            Name = "Düngher",
            Pay = 300,
        },
    },

    MaxJobOffers = 10,
}

