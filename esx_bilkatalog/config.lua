Config                            = {}
Config.DrawDistance               = 100.0

Config.Zones = {

  ShopEntering = {
    Pos   = { x = -33.777, y = -1102.021, z = 25.422 },
    Size  = { x = 1.5, y = 1.5, z = 1.0 },
    Type  = 1,
  },

  ShopInside = {
    Pos     = { x = 228.092 , y = -992.096, z = -99.0 },
    Size    = { x = 1.5, y = 1.5, z = 1.0 },
    Heading = 178.67,
    Type    = -1,
  },

  ShopOutside = {
    Pos     = { x = -28.637, y = -1085.691, z = 25.565 },
    Size    = { x = 1.5, y = 1.5, z = 1.0 },
    Heading = 90.0,
    Type    = -1,
  },

  BossActions = {
    Pos   = { x = -32.065, y = -1114.277, z = 25.422 },
    Size  = { x = 1.5, y = 1.5, z = 1.0 },
    Type  = -1,
  },

  GiveBackVehicle = {
    Pos   = { x = -18.227, y = -1078.558, z = 25.675 },
    Size  = { x = 3.0, y = 3.0, z = 1.0 },
    Type  = (Config.EnablePlayerManagement and 1 or -1),
  },

  ResellVehicle = {
    Pos   = { x = -44.630, y = -1080.738, z = 25.683 },
    Size  = { x = 3.0, y = 3.0, z = 1.0 },
    Type  = 1,
  },

}