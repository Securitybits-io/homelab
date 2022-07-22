mounts:
  mounted:
    YoutubeDLMovies:
      name: /youtube-dl
      device: //10.0.11.241/PlexMedia/Youtube-DL
      fstype: cifs
      mkmnt: True
      config: /etc/fstab
      opts: rw,guest,vers=3.0,file_mode=0777,dir_mode=0777
      persist: True
      mount: True

cron:
  minute: 0
  hour: 1

youtubedl:
  folder: "TacTube"
  channels:
    GBRSGroup:
      channel: "GBRS-Group"
      url: "https://www.youtube.com/c/GBRSGroup/videos"
    TribeSk8tz:
      channel: "Tribe-Sk8tz"
      url: "https://www.youtube.com/c/TRIBESK8Z/videos" 
    SCIrregulars:
      channel: "SC-Irregulars Slade"
      url: "https://www.youtube.com/c/SladeIrregulars1984/videos"
    Jerelaja: 
      channel: "jerelaaja"
      url: "https://www.youtube.com/user/jerelaaja/videos"
    InvisioCommunication:
      channel: "InvisioCommunication"
      url: "https://www.youtube.com/user/INVISIOCOMMUNICATION"
    FerroConcepts:
      channel: "FerroConcepts"
      url: "https://www.youtube.com/channel/UCWcq7YsS5kFVU9uMcAc0fmA"
    ForwardObservationsGroup:
      channel: "Forward-Observations-Group"
      url: "https://www.youtube.com/channel/UCA2BX6VwUnaOhxzrxgwK0Ag"
    ForwardObservationsGroupArchive:
      channel: Forward-Observations-Group-archive
      url: "https://www.youtube.com/c/ForwardObservationsArchives/videos"
    SpiritusSystems:
      channel: "SpiritusSystems"
      url: "https://www.youtube.com/c/SpiritusSystems"
    ScimitarMilsim:
      channel: "Scimitar-Milsim"
      url: "https://www.youtube.com/channel/UCjCeT3Z2nv3VM0WzjhvsYXQ"
    Weapon Snatcher:
      channel: "Weapon Snatcher"
      url: "https://www.youtube.com/c/WeaponSnatcher/videos"
    CobaltMilsim:
      channel: "Cobalt-Milsim"
      url: "https://www.youtube.com/user/CobaltMilsim"
    HighReadyClips:
      channel: "HighReadyClips"
      url: "https://www.youtube.com/user/HighReadyClips/videos"
    MilsimMedia:
      channel: "Milsim-Media"
      url: "https://www.youtube.com/c/MilsimMedia"
    Stirling Airsoft:
      channel: "Stirling-Airsoft"
      url: "https://www.youtube.com/channel/UC-E4WxDCMhcgpres-pCcg6g"
    HumbleBoysAirsoft:
      channel: "Humble Boys Airsoft"
      url: "https://www.youtube.com/channel/UCRlu5wV-dxGTUa-aXZg0eKQ"
    Midwest Development Group:
      channel: "Midwest-Development-Group"
      url: "https://www.youtube.com/channel/UC6m6LZmjl8_75ZPwd0TzJHQ"
    Musat:
      channel: "Team-MUSAT"
      url: "https://www.youtube.com/c/MUSATInc"
    NSWGroup:
      channel: "NSWGroup"
      url: "https://www.youtube.com/user/dfmbatera/videos"
    POChannel:
      channel: "PO-Channel"
      url: "https://www.youtube.com/channel/UCAsh8YGJyhnRW4v629R-AeQ"
    USASOC:
      channel: "USASOC"
      url: "https://www.youtube.com/c/USASOAC/videos"
    TimesArchive:
      channel: "Times-Archive"
      url: "https://www.youtube.com/c/TimesArchives"    
    MilspecMojo:
      channel: "MilspecMojo"
      url: "https://www.youtube.com/channel/UC3b0hycqWaTpbonOk021Bow"
    SuperFlex:
      channel: "SuperFlex"
      url: "https://www.youtube.com/channel/UCcvhFFkUKfMAc7HBrCojIOA/videos"
    GarandThumb:
      channel: "Garand-Thumb"
      url: "https://www.youtube.com/c/GarandThumb/videos"
    Administrative Results:
      channel: "Administrative Results"
      url: "https://www.youtube.com/c/AdministrativeResults/videos"
    ProjectGecko:
      channel: "Project-Gecko"
      url: "https://www.youtube.com/c/ProjectGecko/videos"
    HighEndPew:
      channel: "High End Pew"
      url: "https://www.youtube.com/c/HighEndPew/videos"
    4thleafgroup:
      channel: "4th Leaf Group"
      url: "https://www.youtube.com/c/4thLeafGroup/videos"
    BESTAAirsoft:
      channel: "Besta Airsoft"
      url: "https://www.youtube.com/c/BESTAAirsoft/videos"
    Condition One Group:
      channel: "Condition One Group"
      url: "https://www.youtube.com/channel/UC-K-QXfuONACYb9C1iYMA4A/videos"
    Iron Infidel:
      channel: "Iron Infidel"
      url: "https://www.youtube.com/c/IronInfidel/videos"
    Wise Men Company:
      channel: "Wise Men Company"
      url: "https://www.youtube.com/c/Wisemencompany77/videos"
    Kit Badger:
      channel: "Kit Badger"
      url: "https://www.youtube.com/c/KitBadger/videos"
    Brent0331:
      channel: "Brent0331"
      url: "https://www.youtube.com/user/Brent0331/videos"
    theFieldCraftSurvivalChannel:
      channel: "The Field Craft Survival Channel"
      url: "https://www.youtube.com/c/TheFieldCraftSurvivalChannel/videos"
    Mike Glover Actual:
      channel: "Mike Glover Actual"
      url: "https://www.youtube.com/c/MikeGloverActual"
    S2 Underground:
      channel: "S2 Underground"
      url: "https://www.youtube.com/c/S2Underground/videos"
    Tactical Hyve:
      channel: "Tactical Hyve"
      url: "https://www.youtube.com/c/TacticalHyve/videos"
    UF Pro:
      channel: "UF Pro"
      url: "https://www.youtube.com/c/ufprogear/videos"
    Specter Airsoft Team:
      channel: "Specter-Airsoft-Team"
      url: "https://www.youtube.com/channel/UCjuoFlRx230vijwZ5mq29qQ"
    TREXARMS:
      channel: "TREXARMS"
      url: "https://www.youtube.com/c/TREXARMS"
    ITSTactical:
      channel: "ITS Tactical"
      url: "https://www.youtube.com/user/ITStactical"
    TNVCINC:
      channel: "TNVC INC"
      url: "https://www.youtube.com/user/TNVCINC/videos"
    KineticConsulting:
      channel: "Kinetic consulting"
      url: "https://www.youtube.com/c/KineticConsulting/videos"
    HaleyStrategicConsulting:
      channel: "Haley Strategic"
      url: "https://www.youtube.com/c/HaleyStrategicPartners/videos"
    BarrelAndHatchett:
      channel: "Barrel and Hatchett"
      url: "https://www.youtube.com/channel/UC_RWPmdAhluqCtc0BT4-uvg/"
    Tier1Tribe:
      channel: "Tier 1 Tribe"
      url: "https://www.youtube.com/channel/UChI2dxVFMXNU4rRrYtjO0Bg/"
    Task Force Spartan Milsim Media:
      channel: "Task Force Spartan Milsim"
      url: "https://www.youtube.com/channel/UCTubWp4vjzw47Dt02WllbPA/videos"
    The Tech Prepper:
      channel: "The Tech Prepper"
      url: "https://www.youtube.com/c/TheTechPrepper"
    Irish:
      channel: "Irish"
      url: "https://www.youtube.com/channel/UC-5bkh-OS6aKSyUIPmu5-DA"
    One 7 Six:
      channel: "One 7 Six"
      url: "https://www.youtube.com/channel/UCOXveiLfpYvjZ3V1zojaUbQ"
    Vernon Griffith II:
      channel: "Vernong Griffith II"
      url: "https://www.youtube.com/c/VernonGriffithII/videos"
    Orion Training Group:
      channel: "Orion Training Group"
      url: "https://www.youtube.com/channel/UCjdvhj_WZVDuX2qMy3HcmtA/videos"
    Marauder Collective:
      channel: "Marauder Collective"
      url: "https://www.youtube.com/channel/UCLXgViT_8wgTWCw7C_M9rZA/videos"
    sat952v:
      channel: "SAT952V"
      url: "https://www.youtube.com/c/sat952v"
    Death Grip:
      channel: "Death Grip"
      url: "https://www.youtube.com/channel/UC4f0KX3Qf9DHSLE8F13AgIw/videos"
    Blakewater0326:
      channel: "Blakewater0326"
      url: "https://www.youtube.com/c/Blakewater0326"