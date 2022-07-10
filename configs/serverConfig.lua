Auth = exports.plouffe_lib:Get("Auth")
Utils = exports.plouffe_lib:Get("Utils")
Callback = exports.plouffe_lib:Get("Callback")

Server = {
	Init = false,
	PlayersPerGang = {}
}

Gangs = {}
GangsFnc = {} 

Gangs.Player = {}
Gangs.GangInfo = {}

Gangs.Menu = {
	bossMenu = {
        {
            id = 1,
            header = "Voir la liste des membres",
            txt = "Ouvrir la liste de tous les membres",
            params = {
                event = "",
                args = {
                    fnc = "EmployesMenu"
                }
            }
        },

        {
            id = 2,
            header = "Recruter un nouveau membre",
            txt = "Vous permert de recruter quelqun dans votre gang",
            params = {
                event = "",
                args = {
                    fnc = "RecruitNew"
                }
            }
        }
    },

    member = {
        {
            id = 2,
            header = "Changer le grade",
            txt = "Changer le grade...",
            params = {
                event = "",
                args = {
                    fnc = "ChangeMemberGrade"
                }
            }
        },

        {
            id = 3,
            header = "Retirer du gang",
            txt = "Cette personne ne fera plus partit du gang",
            params = {
                event = "",
                args = {
                    fnc = "KickOut"
                }
            }
        }
    }
}

Gangs.Utils = {
	ped = 0,
	pedCoords = vector3(0,0,0)
}

Gangs.Gangs = {
    lost = {
        name = "lost",
        bossAccess = {["4"] = true},
        coordsList = {
            lost_wardrobe = {
                name = "lost_wardrobe",
                groups = {"lost"},
                coords = vector3(972.39569091797, -97.96395111084, 74.870109558105),
                maxDst = 2.0,
                protectEvents = true,
                isKey = true,
                isZone = true,
                nuiLabel = "Garde-Robe",
                aditionalParams = {fnc = "OpenWardrobe", index = "lost_wardrobe", gang = "lost"},
                keyMap = {
                    checkCoordsBeforeTrigger = true,
                    onRelease = true,
                    releaseEvent = "on_gangs_from_zones",
                    key = "E"
                }
            },

            lost_inventory_1 = {
                name = "lost_inventory_1",
                groups = {"lost"},
                coords = vector3(977.08935546875, -104.2248916626, 74.845207214355),
                maxDst = 2.0,
                protectEvents = true,
                isKey = true,
                isZone = true,
                nuiLabel = "Inventaire",
                aditionalParams = {fnc = "OpenInventory", index = "lost_inventory_1", gang = "lost"},
                keyMap = {
                    checkCoordsBeforeTrigger = true,
                    onRelease = true,
                    releaseEvent = "on_gangs_from_zones",
                    key = "E"
                }
            },

            lost_inventory_2 = {
                name = "lost_inventory_2",
                groups = {lost = {["3"] = true, ["4"] = true, ["5"] = true}},
                coords = vector3(986.98992919922, -92.917633056641, 74.845840454102),
                maxDst = 2.0,
                protectEvents = true,
                isKey = true,
                isZone = true,
                nuiLabel = "Inventaire",
                aditionalParams = {fnc = "OpenInventory", index = "lost_inventory_2", gang = "lost"},
                keyMap = {
                    checkCoordsBeforeTrigger = true,
                    onRelease = true,
                    releaseEvent = "on_gangs_from_zones",
                    key = "E"
                }
            },

            lost_boss_menu = {
                name = "lost_boss_menu",
                groups = {lost = {["4"] = true}},
                coords = vector3(975.64666748047, -100.86375427246, 74.870079040527),
                maxDst = 2.0,
                protectEvents = true,
                isKey = true,
                isZone = true,
                nuiLabel = "Menu Patron",
                aditionalParams = {fnc = "OpenBossMenu", index = "lost_boss_menu", gang = "lost"},
                keyMap = {
                    checkCoordsBeforeTrigger = true,
                    onRelease = true,
                    releaseEvent = "on_gangs_from_zones",
                    key = "E"
                }
            }
        }
    },

    vagos = {
        name = "vagos",
        bossAccess = {["4"] = true},
        coordsList = {
            vagos_wardrobe = {
                name = "vagos_wardrobe",
                groups = {"vagos"},
                coords = vector3(341.60552978516,-2021.6314697266,25.594644546509),
                maxDst = 2.0,
                protectEvents = true,
                isKey = true,
                isZone = true,
                nuiLabel = "Garde-Robe",
                aditionalParams = {fnc = "OpenWardrobe", index = "vagos_wardrobe", gang = "vagos"},
                keyMap = {
                    checkCoordsBeforeTrigger = true,
                    onRelease = true,
                    releaseEvent = "on_gangs_from_zones",
                    key = "E"
                }
            },

            vagos_inventory_1 = {
                name = "vagos_inventory_1",
                groups = {"vagos"},
                coords = vector3(331.37698364258,-2014.7338867188,22.642778396606),
                maxDst = 2.0,
                protectEvents = true,
                isKey = true,
                isZone = true,
                nuiLabel = "Inventaire",
                aditionalParams = {fnc = "OpenInventory", index = "vagos_inventory_1", gang = "vagos"},
                keyMap = {
                    checkCoordsBeforeTrigger = true,
                    onRelease = true,
                    releaseEvent = "on_gangs_from_zones",
                    key = "E"
                }
            },

            vagos_inventory_2 = {
                name = "vagos_inventory_2",
                groups = {vagos = {["3"] = true, ["4"] = true, ["5"] = true}},
                coords = vector3(335.6770324707,-2018.3829345703,22.394958496094),
                maxDst = 2.0,
                protectEvents = true,
                isKey = true,
                isZone = true,
                nuiLabel = "Inventaire",
                aditionalParams = {fnc = "OpenInventory", index = "vagos_inventory_2", gang = "vagos"},
                keyMap = {
                    checkCoordsBeforeTrigger = true,
                    onRelease = true,
                    releaseEvent = "on_gangs_from_zones",
                    key = "E"
                }
            },

            vagos_boss_menu = {
                name = "vagos_boss_menu",
                groups = {vagos = {["4"] = true}},
                coords = vector3(333.36212158203,-2012.1737060547,22.394954681396),
                maxDst = 2.0,
                protectEvents = true,
                isKey = true,
                isZone = true,
                nuiLabel = "Menu Patron",
                aditionalParams = {fnc = "OpenBossMenu", index = "vagos_boss_menu", gang = "vagos"},
                keyMap = {
                    checkCoordsBeforeTrigger = true,
                    onRelease = true,
                    releaseEvent = "on_gangs_from_zones",
                    key = "E"
                }
            }
        }
    },

    families = {
        name = "families",
        bossAccess = {["4"] = true},
        coordsList = {
            families_wardrobe = {
                name = "families_wardrobe",
                groups = {"families"},
                coords = vector3(-141.73585510254,-1609.2901611328,35.03023147583),
                maxDst = 2.0,
                protectEvents = true,
                isKey = true,
                isZone = true,
                nuiLabel = "Garde-Robe",
                aditionalParams = {fnc = "OpenWardrobe", index = "families_wardrobe", gang = "families"},
                keyMap = {
                    checkCoordsBeforeTrigger = true,
                    onRelease = true,
                    releaseEvent = "on_gangs_from_zones",
                    key = "E"
                }
            },

            families_inventory_1 = {
                name = "families_inventory_1",
                groups = {"families"},
                coords = vector3(-136.81427001953,-1607.3153076172,35.030220031738),
                maxDst = 2.0,
                protectEvents = true,
                isKey = true,
                isZone = true,
                nuiLabel = "Inventaire",
                aditionalParams = {fnc = "OpenInventory", index = "families_inventory_1", gang = "families"},
                keyMap = {
                    checkCoordsBeforeTrigger = true,
                    onRelease = true,
                    releaseEvent = "on_gangs_from_zones",
                    key = "E"
                }
            },

            families_inventory_2 = {
                name = "families_inventory_2",
                groups = {families = {["3"] = true, ["4"] = true, ["5"] = true}},
                coords = vector3(-134.81564331055,-1611.4782714844,35.030078887939),
                maxDst = 2.0,
                protectEvents = true,
                isKey = true,
                isZone = true,
                nuiLabel = "Inventaire",
                aditionalParams = {fnc = "OpenInventory", index = "families_inventory_2", gang = "families"},
                keyMap = {
                    checkCoordsBeforeTrigger = true,
                    onRelease = true,
                    releaseEvent = "on_gangs_from_zones",
                    key = "E"
                }
            },

            families_boss_menu = {
                name = "families_boss_menu",
                groups = {families = {["4"] = true}},
                coords = vector3(-155.56954956055,-1604.2950439453,35.043880462646),
                maxDst = 2.0,
                protectEvents = true,
                isKey = true,
                isZone = true,
                nuiLabel = "Menu Patron",
                aditionalParams = {fnc = "OpenBossMenu", index = "families_boss_menu", gang = "families"},
                keyMap = {
                    checkCoordsBeforeTrigger = true,
                    onRelease = true,
                    releaseEvent = "on_gangs_from_zones",
                    key = "E"
                }
            }
        }
    },

    cartel = {
        name = "cartel",
        bossAccess = {["4"] = true},
        coordsList = {
            cartel_wardrobe = {
                name = "cartel_wardrobe",
                groups = {"cartel"},
                coords = vector3(-90.161651611328,993.33471679688,235.75355529785),
                maxDst = 2.0,
                protectEvents = true,
                isKey = true,
                isZone = true,
                nuiLabel = "Garde-Robe",
                aditionalParams = {fnc = "OpenWardrobe", index = "cartel_wardrobe", gang = "cartel"},
                keyMap = {
                    checkCoordsBeforeTrigger = true,
                    onRelease = true,
                    releaseEvent = "on_gangs_from_zones",
                    key = "E"
                }
            },

            cartel_inventory_1 = {
                name = "cartel_inventory_1",
                groups = {"cartel"},
                coords = vector3(-84.626014709473,1004.9510498047,234.39379882812),
                maxDst = 2.0,
                protectEvents = true,
                isKey = true,
                isZone = true,
                nuiLabel = "Inventaire",
                aditionalParams = {fnc = "OpenInventory", index = "cartel_inventory_1", gang = "cartel"},
                keyMap = {
                    checkCoordsBeforeTrigger = true,
                    onRelease = true,
                    releaseEvent = "on_gangs_from_zones",
                    key = "E"
                }
            },

            cartel_inventory_2 = {
                name = "cartel_inventory_2",
                groups = {cartel = {["3"] = true, ["4"] = true, ["5"] = true}},
                coords = vector3(-82.412170410156,999.91314697266,239.47724914551),
                maxDst = 2.0,
                protectEvents = true,
                isKey = true,
                isZone = true,
                nuiLabel = "Inventaire",
                aditionalParams = {fnc = "OpenInventory", index = "cartel_inventory_2", gang = "cartel"},
                keyMap = {
                    checkCoordsBeforeTrigger = true,
                    onRelease = true,
                    releaseEvent = "on_gangs_from_zones",
                    key = "E"
                }
            },

            cartel_boss_menu = {
                name = "cartel_boss_menu",
                groups = {cartel = {["4"] = true}},
                coords = vector3(-63.376789093018,990.96990966797,234.43194580078),
                maxDst = 2.0,
                protectEvents = true,
                isKey = true,
                isZone = true,
                nuiLabel = "Menu Patron",
                aditionalParams = {fnc = "OpenBossMenu", index = "cartel_boss_menu", gang = "cartel"},
                keyMap = {
                    checkCoordsBeforeTrigger = true,
                    onRelease = true,
                    releaseEvent = "on_gangs_from_zones",
                    key = "E"
                }
            }
        }
    },

    ballas = {
        name = "ballas",
        bossAccess = {["4"] = true},
        coordsList = {
            ballas_wardrobe = {
                name = "ballas_wardrobe",
                groups = {"ballas"},
                coords = vector3(117.75,-1963.25,21.33),
                maxDst = 2.0,
                protectEvents = true,
                isKey = true,
                isZone = true,
                nuiLabel = "Garde-Robe",
                aditionalParams = {fnc = "OpenWardrobe", index = "ballas_wardrobe", gang = "ballas"},
                keyMap = {
                    checkCoordsBeforeTrigger = true,
                    onRelease = true,
                    releaseEvent = "on_gangs_from_zones",
                    key = "E"
                }
            },

            ballas_inventory_1 = {
                name = "ballas_inventory_1",
                groups = {"ballas"},
                coords = vector3(112.33,-1968.66,21.33),
                maxDst = 2.0,
                protectEvents = true,
                isKey = true,
                isZone = true,
                nuiLabel = "Inventaire",
                aditionalParams = {fnc = "OpenInventory", index = "ballas_inventory_1", gang = "ballas"},
                keyMap = {
                    checkCoordsBeforeTrigger = true,
                    onRelease = true,
                    releaseEvent = "on_gangs_from_zones",
                    key = "E"
                }
            },

            ballas_inventory_2 = {
                name = "ballas_inventory_2",
                groups = {ballas = {["3"] = true, ["4"] = true, ["5"] = true}},
                coords = vector3(118.92,-1966.17,21.33),
                maxDst = 2.0,
                protectEvents = true,
                isKey = true,
                isZone = true,
                nuiLabel = "Inventaire",
                aditionalParams = {fnc = "OpenInventory", index = "ballas_inventory_2", gang = "ballas"},
                keyMap = {
                    checkCoordsBeforeTrigger = true,
                    onRelease = true,
                    releaseEvent = "on_gangs_from_zones",
                    key = "E"
                }
            },

            ballas_boss_menu = {
                name = "ballas_boss_menu",
                groups = {ballas = {["4"] = true}},
                coords = vector3(119.91,-1967.72,21.33),
                maxDst = 2.0,
                protectEvents = true,
                isKey = true,
                isZone = true,
                nuiLabel = "Menu Patron",
                aditionalParams = {fnc = "OpenBossMenu", index = "ballas_boss_menu", gang = "ballas"},
                keyMap = {
                    checkCoordsBeforeTrigger = true,
                    onRelease = true,
                    releaseEvent = "on_gangs_from_zones",
                    key = "E"
                }
            }
        }
    },

    mafia = {
        name = "mafia",
        bossAccess = {["4"] = true},
        coordsList = {
            mafia_wardrobe = {
                name = "mafia_wardrobe",
                groups = {"mafia"},
                coords = vector3(1402.9088134766,1154.4418945312,117.50297546387),
                maxDst = 2.0,
                protectEvents = true,
                isKey = true,
                isZone = true,
                nuiLabel = "Garde-Robe",
                aditionalParams = {fnc = "OpenWardrobe", index = "mafia_wardrobe", gang = "mafia"},
                keyMap = {
                    checkCoordsBeforeTrigger = true,
                    onRelease = true,
                    releaseEvent = "on_gangs_from_zones",
                    key = "E"
                }
            },

            mafia_wardrobe_2 = {
                name = "mafia_wardrobe_2",
                groups = {"mafia"},
                coords = vector3(1400.0139160156, 1139.6578369141, 114.33573913574),
                maxDst = 2.0,
                protectEvents = true,
                isKey = true,
                isZone = true,
                nuiLabel = "Garde-Robe",
                aditionalParams = {fnc = "OpenWardrobe", index = "mafia_wardrobe_2", gang = "mafia"},
                keyMap = {
                    checkCoordsBeforeTrigger = true,
                    onRelease = true,
                    releaseEvent = "on_gangs_from_zones",
                    key = "E"
                }
            },

            mafia_inventory_1 = {
                name = "mafia_inventory_1",
                groups = {"mafia"},
                coords = vector3(1394.9080810547, 1150.0725097656, 114.33564758301),
                maxDst = 2.0,
                protectEvents = true,
                isKey = true,
                isZone = true,
                nuiLabel = "Inventaire",
                aditionalParams = {fnc = "OpenInventory", index = "mafia_inventory_1", gang = "mafia"},
                keyMap = {
                    checkCoordsBeforeTrigger = true,
                    onRelease = true,
                    releaseEvent = "on_gangs_from_zones",
                    key = "E"
                }
            },

            mafia_inventory_2 = {
                name = "mafia_inventory_2",
                groups = {mafia = {["3"] = true, ["4"] = true, ["5"] = true}},
                coords = vector3(1391.4758300781, 1159.0731201172, 114.33564758301),
                maxDst = 2.0,
                protectEvents = true,
                isKey = true,
                isZone = true,
                nuiLabel = "Inventaire",
                aditionalParams = {fnc = "OpenInventory", index = "mafia_inventory_2", gang = "mafia"},
                keyMap = {
                    checkCoordsBeforeTrigger = true,
                    onRelease = true,
                    releaseEvent = "on_gangs_from_zones",
                    key = "E"
                }
            },

            mafia_boss_menu = {
                name = "mafia_boss_menu",
                groups = {mafia = {["4"] = true}},
                coords = vector3(1395.1378173828,1159.7796630859,114.33564758301),
                maxDst = 2.0,
                protectEvents = true,
                isKey = true,
                isZone = true,
                nuiLabel = "Menu Patron",
                aditionalParams = {fnc = "OpenBossMenu", index = "mafia_boss_menu", gang = "mafia"},
                keyMap = {
                    checkCoordsBeforeTrigger = true,
                    onRelease = true,
                    releaseEvent = "on_gangs_from_zones",
                    key = "E"
                }
            }
        }
    },

    bsg = {
        name = "bsg",
        bossAccess = {["4"] = true},
        coordsList = {
            bsg_wardrobe = {
                name = "bsg_wardrobe",
                groups = {"bsg"},
                coords = vector3(131.45846557617, -1710.0391845703, 33.248207092285),
                maxDst = 2.0,
                protectEvents = true,
                isKey = true,
                isZone = true,
                nuiLabel = "Garde-Robe",
                aditionalParams = {fnc = "OpenWardrobe", index = "bsg_wardrobe", gang = "bsg"},
                keyMap = {
                    checkCoordsBeforeTrigger = true,
                    onRelease = true,
                    releaseEvent = "on_gangs_from_zones",
                    key = "E"
                }
            },

            bsg_inventory_1 = {
                name = "bsg_inventory_1",
                groups = {"bsg"},
                coords = vector3(137.01637268066, -1710.1220703125, 33.248146057129),
                maxDst = 2.0,
                protectEvents = true,
                isKey = true,
                isZone = true,
                nuiLabel = "Inventaire",
                aditionalParams = {fnc = "OpenInventory", index = "bsg_inventory_1", gang = "bsg"},
                keyMap = {
                    checkCoordsBeforeTrigger = true,
                    onRelease = true,
                    releaseEvent = "on_gangs_from_zones",
                    key = "E"
                }
            },

            bsg_inventory_2 = {
                name = "bsg_inventory_2",
                groups = {bsg = {["3"] = true, ["4"] = true, ["5"] = true}},
                coords = vector3(148.07986450195, -1716.373046875, 34.731620788574),
                maxDst = 2.0,
                protectEvents = true,
                isKey = true,
                isZone = true,
                nuiLabel = "Inventaire",
                aditionalParams = {fnc = "OpenInventory", index = "bsg_inventory_2", gang = "bsg"},
                keyMap = {
                    checkCoordsBeforeTrigger = true,
                    onRelease = true,
                    releaseEvent = "on_gangs_from_zones",
                    key = "E"
                }
            },

            bsg_boss_menu = {
                name = "bsg_boss_menu",
                groups = {bsg = {["4"] = true}},
                coords = vector3(144.65342712402, -1719.6184082031, 34.731620788574),
                maxDst = 2.0,
                protectEvents = true,
                isKey = true,
                isZone = true,
                nuiLabel = "Menu Patron",
                aditionalParams = {fnc = "OpenBossMenu", index = "bsg_boss_menu", gang = "bsg"},
                keyMap = {
                    checkCoordsBeforeTrigger = true,
                    onRelease = true,
                    releaseEvent = "on_gangs_from_zones",
                    key = "E"
                }
            }
        }
    },

    cali = {
        name = "cali",
        bossAccess = {["4"] = true},
        coordsList = {
            cali_wardrobe = {
                name = "cali_wardrobe",
                groups = {"cali"},
                coords = vector3(-1790.4039306641, 437.92263793945, 128.3648223877),
                maxDst = 2.0,
                protectEvents = true,
                isKey = true,
                isZone = true,
                nuiLabel = "Garde-Robe",
                aditionalParams = {fnc = "OpenWardrobe", index = "cali_wardrobe", gang = "cali"},
                keyMap = {
                    checkCoordsBeforeTrigger = true,
                    onRelease = true,
                    releaseEvent = "on_gangs_from_zones",
                    key = "E"
                }
            },

            cali_inventory_1 = {
                name = "cali_inventory_1",
                groups = {"cali"},
                coords = vector3(-1795.3220214844, 425.5712890625, 128.25263977051),
                maxDst = 2.0,
                protectEvents = true,
                isKey = true,
                isZone = true,
                nuiLabel = "Inventaire",
                aditionalParams = {fnc = "OpenInventory", index = "cali_inventory_1", gang = "cali"},
                keyMap = {
                    checkCoordsBeforeTrigger = true,
                    onRelease = true,
                    releaseEvent = "on_gangs_from_zones",
                    key = "E"
                }
            },

            cali_inventory_2 = {
                name = "cali_inventory_2",
                groups = {cali = {["3"] = true, ["4"] = true, ["5"] = true}},
                coords = vector3(-1796.8802490234, 439.86730957031, 128.25247192383),
                maxDst = 1.0,
                protectEvents = true,
                isKey = true,
                isZone = true,
                nuiLabel = "Inventaire",
                aditionalParams = {fnc = "OpenInventory", index = "cali_inventory_2", gang = "cali"},
                keyMap = {
                    checkCoordsBeforeTrigger = true,
                    onRelease = true,
                    releaseEvent = "on_gangs_from_zones",
                    key = "L"
                }
            },

            cali_boss_menu = {
                name = "cali_boss_menu",
                groups = {cali = {["4"] = true}},
                coords = vector3(-1817.0202636719, 447.25357055664, 128.4072265625),
                maxDst = 2.0,
                protectEvents = true,
                isKey = true,
                isZone = true,
                nuiLabel = "Menu Patron",
                aditionalParams = {fnc = "OpenBossMenu", index = "cali_boss_menu", gang = "cali"},
                keyMap = {
                    checkCoordsBeforeTrigger = true,
                    onRelease = true,
                    releaseEvent = "on_gangs_from_zones",
                    key = "E"
                }
            }
        }
    },

    sinister = {
        name = "sinister",
        bossAccess = {["4"] = true},
        coordsList = {
            sinister_wardrobe = {
                name = "sinister_wardrobe",
                groups = {"sinister"},
                coords = vector3(945.13732910156, -1634.1055908203, 30.327184677124),
                maxDst = 2.0,
                protectEvents = true,
                isKey = true,
                isZone = true,
                nuiLabel = "Garde-Robe",
                aditionalParams = {fnc = "OpenWardrobe", index = "sinister_wardrobe", gang = "sinister"},
                keyMap = {
                    checkCoordsBeforeTrigger = true,
                    onRelease = true,
                    releaseEvent = "on_gangs_from_zones",
                    key = "E"
                }
            },

            sinister_inventory_1 = {
                name = "sinister_inventory_1",
                groups = {"sinister"},
                coords = vector3(958.63531494141, -1635.3009033203, 30.307271957397),
                maxDst = 2.0,
                protectEvents = true,
                isKey = true,
                isZone = true,
                nuiLabel = "Inventaire",
                aditionalParams = {fnc = "OpenInventory", index = "sinister_inventory_1", gang = "sinister"},
                keyMap = {
                    checkCoordsBeforeTrigger = true,
                    onRelease = true,
                    releaseEvent = "on_gangs_from_zones",
                    key = "E"
                }
            },

            sinister_inventory_2 = {
                name = "sinister_inventory_2",
                groups = {sinister = {["3"] = true, ["4"] = true, ["5"] = true}},
                coords = vector3(964.66851806641, -1641.8608398438, 30.887710571289),
                maxDst = 2.0,
                protectEvents = true,
                isKey = true,
                isZone = true,
                nuiLabel = "Inventaire",
                aditionalParams = {fnc = "OpenInventory", index = "sinister_inventory_2", gang = "sinister"},
                keyMap = {
                    checkCoordsBeforeTrigger = true,
                    onRelease = true,
                    releaseEvent = "on_gangs_from_zones",
                    key = "E"
                }
            },

            sinister_boss_menu = {
                name = "sinister_boss_menu",
                groups = {sinister = {["4"] = true}},
                coords = vector3(963.15423583984, -1645.2331542969, 30.917112350464),
                maxDst = 2.0,
                protectEvents = true,
                isKey = true,
                isZone = true,
                nuiLabel = "Menu Patron",
                aditionalParams = {fnc = "OpenBossMenu", index = "sinister_boss_menu", gang = "sinister"},
                keyMap = {
                    checkCoordsBeforeTrigger = true,
                    onRelease = true,
                    releaseEvent = "on_gangs_from_zones",
                    key = "E"
                }
            }
        }
    },
}